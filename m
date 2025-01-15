Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F66824168E;
	Wed, 15 Jan 2025 10:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937567; cv=none; b=nMzD/nvXniuKnDeXizKZg8DSu30IL2166MO7ZJHi69qn3nXph8jd9Ups43uyjQmB6yDCC1mIqjYW9znFiEWPlptIEn1Jl8oYENxZfm0BPySxoRj2XJ3bKS3DDMEtoB2/5Fqco5HuG6Vv+jpxv66DJwOyZ+TzCrVyChw/nri/Tnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937567; c=relaxed/simple;
	bh=x/DQetbhBGjOa6YDxyAux/yDGzXmKbuW+6Tqcw0LQ3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aj8pmu3ryCxBy9e2aas/8mfRH3S9N8IRTHy5TNqU3nuUwNVN6c4OBCrEFS+mkkecWNTXVHqrUmwv2mK5xntmCLEKowsMeOxC8Zu/I0Q8kDMxHFOGJWNbabb4VCyxL6hcX+eNHPOna9qorZbOk57UWjFksNow2NXQjHcGR1iE2XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLonUwL+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLonUwL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD79C4CEE4;
	Wed, 15 Jan 2025 10:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937566;
	bh=x/DQetbhBGjOa6YDxyAux/yDGzXmKbuW+6Tqcw0LQ3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kLonUwL+8UPS4Z0YfOHg2Nvxr4SG5yZCN0yXu/xHD/1Tcy0YStlCO9aSe5I8O7t3i
	 LYIllLlf0GQFBIIwqcHIZXDIGoA6RLQu39a4GuL3njJQUAuXukFw4Ni2D7nZQG4WcJ
	 BV6Z7KJ4Wnp9/bcVt1PkVXkHRf+RUC1l5Q1eeTF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 18/92] bnxt_en: Fix possible memory leak when hwrm_req_replace fails
Date: Wed, 15 Jan 2025 11:36:36 +0100
Message-ID: <20250115103548.263365363@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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
index 2e54bf4fc7a7..c0f67db641c3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -252,7 +252,7 @@ static int bnxt_send_msg(struct bnxt_en_dev *edev, unsigned int ulp_id,
 
 	rc = hwrm_req_replace(bp, req, fw_msg->msg, fw_msg->msg_len);
 	if (rc)
-		return rc;
+		goto drop_req;
 
 	hwrm_req_timeout(bp, req, fw_msg->timeout);
 	resp = hwrm_req_hold(bp, req);
@@ -264,6 +264,7 @@ static int bnxt_send_msg(struct bnxt_en_dev *edev, unsigned int ulp_id,
 
 		memcpy(fw_msg->resp, resp, resp_len);
 	}
+drop_req:
 	hwrm_req_drop(bp, req);
 	return rc;
 }
-- 
2.39.5



