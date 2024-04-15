Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400ED757E1;
	Mon, 15 Apr 2024 14:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191244; cv=none; b=B3dBSJcHgGN8RVnAqjxj8pm1XZewUWMBoy8sldbFDwPI5vYR7+V+q1blc1Indf4Ml0NwrelU3/SsMAU22zYvNHLlnPmJM8AjcYIp+J7/Ko6AsXO9/S0MDgdu2Epk9vyszA4pNJUzLmYq1wF4yRScWyS2E3eSToWT7LeEdubYcjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191244; c=relaxed/simple;
	bh=MElXmEepG5obOE3cp8QqeSi87hbsFQsXolyWrZhT0lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fyegVCa7KL92fDYSB9UNkoxS1Yrxyfbw3qA/RXFNNN6gGkMhZCOQzvXa+kXd6Te4IYB7OkrktHLKv97S1LvIQ2iRS/iQr+2MlDR7/SRvGe51RD33+fpaV6Fj5eCO1OT6Yf1lPK2EQr9Lqvp2xQDJlEvBNhorFF32VPwAulbbJqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AnInY+uQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AnInY+uQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3888C113CC;
	Mon, 15 Apr 2024 14:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191243;
	bh=MElXmEepG5obOE3cp8QqeSi87hbsFQsXolyWrZhT0lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AnInY+uQiCCW+zfYeHAeP7vUV5crHZDWK4mgGEG3VlZ0G4B+bV4LsNN16ERLIzmi4
	 X1OwSMdGX5SR4Wz0XJ7vVGiOfD4uv9JWhCYevEvfufjCAnr05spVdOfWQ1UVhd229Y
	 2iwLzZtUmpj3fMI11ncepiA6ibeWCRnfVnx7gzOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Vikas Gupta <vikas.gupta@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 052/172] bnxt_en: Fix error recovery for RoCE ulp client
Date: Mon, 15 Apr 2024 16:19:11 +0200
Message-ID: <20240415142001.995771148@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vikas Gupta <vikas.gupta@broadcom.com>

[ Upstream commit b5ea7d33ba2a42b95b4298d08d2af9cdeeaf0090 ]

Since runtime MSIXs vector allocation/free has been removed,
the L2 driver needs to repopulate the MSIX entries for the
ulp client as the irq table may change during the recovery
process.

Fixes: 303432211324 ("bnxt_en: Remove runtime interrupt vector allocation")
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index a5f9c9090a6b0..195c02dc06830 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -210,6 +210,9 @@ void bnxt_ulp_start(struct bnxt *bp, int err)
 	if (err)
 		return;
 
+	if (edev->ulp_tbl->msix_requested)
+		bnxt_fill_msix_vecs(bp, edev->msix_entries);
+
 	if (aux_priv) {
 		struct auxiliary_device *adev;
 
-- 
2.43.0



