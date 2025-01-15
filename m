Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D073248BD1;
	Wed, 15 Jan 2025 10:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938553; cv=none; b=j5E++DP14jQC8nqhTpnWl1pIaRI6X2mqPInmYeOqLKFTvrS4uxj9JU07rm/X/oKwkms0wSpPTBqRCTB0Rb56KaKJDHo5HosQiUn0s8nmB3BY5Tfx2L9C/kdZwvYCtCYItV+rLKCgmCnvZusCl7VgOpoEwPGufjDWdBcYVMO6mkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938553; c=relaxed/simple;
	bh=IZOKIgxJmvq0lHJcQy+Ee9Gg9Y06UtWYeIDVE9ydJ6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+nHpyRHtTib4IESuigsyLc6sU/o31W94dXsBU0vkP09nOJUEbhJCpudOiSIuMDFCp+wyzDB/H2IOv8S0RfTsAbRfFA70cErYs977+7z9dxTU4fztZoqnkeND32znmjAjbMRyaraZsASstXNeQga1wnPJFrW3qUTkkuXN4E0zSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TWpHHS+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TWpHHS+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7ABC4CEDF;
	Wed, 15 Jan 2025 10:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938553;
	bh=IZOKIgxJmvq0lHJcQy+Ee9Gg9Y06UtWYeIDVE9ydJ6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TWpHHS+NnCJ88alyiOD8BAlNiqa4NOSZnX/ybPu7yhzcyWQ9DIi8lP96EgMTXaLwi
	 1zveh6X0YMkniCO5uxyguSDPsB8ZITPj5Fki+sc6MyNWrloa7t0SUpy3M2qXjyzGaP
	 B5vND8ljl8ltuAuvbk3tD0fSvbF8/CZ3tMZcBorY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/129] bnxt_en: Fix possible memory leak when hwrm_req_replace fails
Date: Wed, 15 Jan 2025 11:36:41 +0100
Message-ID: <20250115103555.409228933@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit c8dafb0e4398dacc362832098a04b97da3b0395b ]

When hwrm_req_replace() fails, the driver is not invoking bnxt_req_drop()
which could cause a memory leak.

Fixes: bbf33d1d9805 ("bnxt_en: update all firmware calls to use the new APIs")
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20250104043849.3482067-2-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index 7689086371e0..2980963208cb 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -159,7 +159,7 @@ int bnxt_send_msg(struct bnxt_en_dev *edev,
 
 	rc = hwrm_req_replace(bp, req, fw_msg->msg, fw_msg->msg_len);
 	if (rc)
-		return rc;
+		goto drop_req;
 
 	hwrm_req_timeout(bp, req, fw_msg->timeout);
 	resp = hwrm_req_hold(bp, req);
@@ -171,6 +171,7 @@ int bnxt_send_msg(struct bnxt_en_dev *edev,
 
 		memcpy(fw_msg->resp, resp, resp_len);
 	}
+drop_req:
 	hwrm_req_drop(bp, req);
 	return rc;
 }
-- 
2.39.5



