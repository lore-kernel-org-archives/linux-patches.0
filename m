Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968482E54BB;
	Tue, 15 Jul 2025 13:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587379; cv=none; b=C2m6ZL0Qf9TFj1iVPXRUsv/cFxsDTO82wJ5jY64cry79crA228Sie159BayPneMGWzvvp5b96nk3R3cgcOj1DUGDsvyWftwHZZXVHGqs5iDgkg3b6RHPpBHn5NXqrxc61wq1KkD16i41lEoT6rftLLzvfbD7x4AznEBtBZjzC7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587379; c=relaxed/simple;
	bh=2tEsJFgojdPM9h8cW+B9fVWaRklhJjuKrQ4AxG8dhas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BLNLvQVrNKi/ZtC8ZvfrjWEtAUibRJMsceaJTMWUScN0CP58R1A46T0il8pRS/cDR1k2uS2TVtwutGJ3q7N9aG6mJ15E5AL9KmnxWkL/clkscxeYwrafk4f8QxvgdezkB4KEpDyxH3horflAuWHMmf9s4rpWx1qyCiS+Buu9iSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oBQmFm2v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oBQmFm2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FF4C4CEE3;
	Tue, 15 Jul 2025 13:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587379;
	bh=2tEsJFgojdPM9h8cW+B9fVWaRklhJjuKrQ4AxG8dhas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oBQmFm2vmsZkINVtY0w5uuLjt3a7PDiF98Bwpyu7px43mEB0IVQWg2j1vFkvPyvcU
	 58tukzW0KF8zD/GgzP9+TJ/UQQ1QPU7gtIP5CUKIY4P6Ok523D4ikGh2JaXoZ+2dNK
	 LZddqSkm7RRvB0MUfwV8NBohfVSrlPOJRy3Mk4ME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Shravya KN <shravya.k-n@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 71/88] bnxt_en: Fix DCB ETS validation
Date: Tue, 15 Jul 2025 15:14:47 +0200
Message-ID: <20250715130757.421546568@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
References: <20250715130754.497128560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shravya KN <shravya.k-n@broadcom.com>

[ Upstream commit b74c2a2e9cc471e847abd87e50a2354c07e02040 ]

In bnxt_ets_validate(), the code incorrectly loops over all possible
traffic classes to check and add the ETS settings.  Fix it to loop
over the configured traffic classes only.

The unconfigured traffic classes will default to TSA_ETS with 0
bandwidth.  Looping over these unconfigured traffic classes may
cause the validation to fail and trigger this error message:

"rejecting ETS config starving a TC\n"

The .ieee_setets() will then fail.

Fixes: 7df4ae9fe855 ("bnxt_en: Implement DCBNL to support host-based DCBX.")
Reviewed-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Shravya KN <shravya.k-n@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20250710213938.1959625-2-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
index 63e0670383852..1727e9bb1479d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
@@ -487,7 +487,9 @@ static int bnxt_ets_validate(struct bnxt *bp, struct ieee_ets *ets, u8 *tc)
 
 		if ((ets->tc_tx_bw[i] || ets->tc_tsa[i]) && i > bp->max_tc)
 			return -EINVAL;
+	}
 
+	for (i = 0; i < max_tc; i++) {
 		switch (ets->tc_tsa[i]) {
 		case IEEE_8021QAZ_TSA_STRICT:
 			break;
-- 
2.39.5



