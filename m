Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB522566;
	Tue, 15 Jul 2025 13:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587926; cv=none; b=tskSfDfnXUVIBJRy29t+3GiYacMeIMuB8TG76ZfMVPL/ZpntbggXoHxW+nop1+3NZZ37ILG6y074L7eJqBjQdrrI093oipsHfntDC/EoTapLhGCfMubzSbXcNGjuSB0VE4vGO4y5Uen5L5PsGGjTqWzi9AL4Bj/Bmfsy4Ix1hOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587926; c=relaxed/simple;
	bh=12Zo1TfQ3NzkRad0uFRKxyV1p6sdnWsrz/1hN8MVaRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/P0w3TxNh3bGwCgXlsn/i6PpmV9zzgtkixeYaMtFaDHfAbNsqDSe9C7VqMewNz3qGEJ8zYJLHYlZXxw2zeBSpWlVP6jrGbeJGmEEmXRYjo/cKORYGmyQxtJIq3OXG9RUtGNhd07gT5Qstvn0AiN8awi2B6+ZMFfUos0GYsG+sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YBKpoRjv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YBKpoRjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E484BC4CEE3;
	Tue, 15 Jul 2025 13:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587926;
	bh=12Zo1TfQ3NzkRad0uFRKxyV1p6sdnWsrz/1hN8MVaRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YBKpoRjvT2ubqMUV67NcY+RFum0TovZYar3ytsW6Q82rS0PajBFcWwrzxDrxnXGhs
	 JGVdo0J8bYDD/BPSKb2cg2Kxp4HEhRAGSR0luUTCkGs2O13kOlqiPBN/vAs4qmIear
	 rx+1BDEXFChM/SSkEdELNUhy/gNPnY3ZGjCK5v4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Shravya KN <shravya.k-n@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 193/208] bnxt_en: Fix DCB ETS validation
Date: Tue, 15 Jul 2025 15:15:02 +0200
Message-ID: <20250715130818.676694189@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8e90224c43a21..6464de38c82e2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
@@ -447,7 +447,9 @@ static int bnxt_ets_validate(struct bnxt *bp, struct ieee_ets *ets, u8 *tc)
 
 		if ((ets->tc_tx_bw[i] || ets->tc_tsa[i]) && i > bp->max_tc)
 			return -EINVAL;
+	}
 
+	for (i = 0; i < max_tc; i++) {
 		switch (ets->tc_tsa[i]) {
 		case IEEE_8021QAZ_TSA_STRICT:
 			break;
-- 
2.39.5



