Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2FA8248BA6;
	Wed, 15 Jan 2025 10:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938023; cv=none; b=JbKsNaaEBEkT2/vCPWHkHrQCJBWgC3VnD+sHO1LpZQmy8cIXVtlM8oETBdxWVlgNVJO+yBeGumHIjrfm/oy/suLQBCtL/UUbrxOwyTeVJlm0ZyTpMvpDfwU93QanPdaUtReyQM+IQ0p6iwxaXss8XR2kJsElbTP7bTFXeD6mdlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938023; c=relaxed/simple;
	bh=KBPS1WXdHrPDUCTcyEtGIGfwPSKCIRnjr5jpp6HN0d4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SndOPeutOHzwG0zFINAnIVcuW+6WtyZzqW1CmWCagOzb4nWzFOOXlGcICX5N6WB+0Lf9v1iun2pmviinxF+m1AZkUQWzGEPC7LRByU5E/I3Dicq4Fxb0u7w1rUlj7S+lBC7PFQ3y7jVImOMPyvVYMnwiw76kkt08iDkvXPidI5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N3zX+WMs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N3zX+WMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16EB4C4CEDF;
	Wed, 15 Jan 2025 10:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938023;
	bh=KBPS1WXdHrPDUCTcyEtGIGfwPSKCIRnjr5jpp6HN0d4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N3zX+WMsmUr2MDmpzj3s+mKU0CWRWkqqCVNBmk1+Jbrm2vhU66MFZca01qhdf4feZ
	 vphhb8ZH77jEIb/Z7gcH5tXgr/DHFMlUe7PXVlOKQv0sEqSv6udfjZT0F1qhvXiz6S
	 4dCkfDvEebQDrEO2RjG+TMx7xdTfDjyjpC+QnDio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/189] bnxt_en: Fix possible memory leak when hwrm_req_replace fails
Date: Wed, 15 Jan 2025 11:35:27 +0100
Message-ID: <20250115103607.600835815@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fdd6356f21ef..546d9a3d7efe 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -208,7 +208,7 @@ int bnxt_send_msg(struct bnxt_en_dev *edev,
 
 	rc = hwrm_req_replace(bp, req, fw_msg->msg, fw_msg->msg_len);
 	if (rc)
-		return rc;
+		goto drop_req;
 
 	hwrm_req_timeout(bp, req, fw_msg->timeout);
 	resp = hwrm_req_hold(bp, req);
@@ -220,6 +220,7 @@ int bnxt_send_msg(struct bnxt_en_dev *edev,
 
 		memcpy(fw_msg->resp, resp, resp_len);
 	}
+drop_req:
 	hwrm_req_drop(bp, req);
 	return rc;
 }
-- 
2.39.5



