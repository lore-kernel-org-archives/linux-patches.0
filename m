Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DC61F0E36;
	Tue, 21 Jan 2025 18:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482803; cv=none; b=py7m03nFAc1mDjR/3CPubTteo4VKHcAd7RgM2gZ8jrfaV4m4WTf3DroCfBe1knl2w44OZV8n+fAV3cKonncCHnBXxDcPyDn4t6lePejifuSTTWFdYQFHMUQ/N4WocIDmcHK9Vnh/kkN6LnXbA0otAjwqctM8aKIf7yiPf/nvZUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482803; c=relaxed/simple;
	bh=NLAr6WJczvWl2oUtwQk7cTjbUtwY9Q/P8GRFCdpt6/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=im5n2Xk3qyLqE9vVkiiwBNoP92JyxzjI8hrctAG6Shvswe+UyZ4Vq+vTmHjOZtjVWYN8hPwIkwaRc+LL8/NcTeT6kQmyiIRu3TE/K8cUCWZoxoQzL1jREkWwZLz0rynJwbJxqWUoKbgjl5bX5Zy4aVWU8TGDDVxzCG1TdSrWL6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QqrP5cZE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QqrP5cZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9FC7C4CEDF;
	Tue, 21 Jan 2025 18:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482803;
	bh=NLAr6WJczvWl2oUtwQk7cTjbUtwY9Q/P8GRFCdpt6/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QqrP5cZER5vQcrOLcUVhWD6m9BM02huLOTNZ2ClEfRo6nStSqdeA0sjzWDJDvKoF6
	 wiK8L7s/mcIwZWUQ4o99qvjsl4qaSIPvJDnFlPmtySrslE9XczB+U/hE/DvnfIs+xu
	 CcVlCH0obqz4U07zNplF0vEBCYvB0GG9D1197HVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 014/127] bnxt_en: Fix possible memory leak when hwrm_req_replace fails
Date: Tue, 21 Jan 2025 18:51:26 +0100
Message-ID: <20250121174530.221806911@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fde0c3e8ac57..871f695e7076 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -252,7 +252,7 @@ static int bnxt_send_msg(struct bnxt_en_dev *edev, int ulp_id,
 
 	rc = hwrm_req_replace(bp, req, fw_msg->msg, fw_msg->msg_len);
 	if (rc)
-		return rc;
+		goto drop_req;
 
 	hwrm_req_timeout(bp, req, fw_msg->timeout);
 	resp = hwrm_req_hold(bp, req);
@@ -264,6 +264,7 @@ static int bnxt_send_msg(struct bnxt_en_dev *edev, int ulp_id,
 
 		memcpy(fw_msg->resp, resp, resp_len);
 	}
+drop_req:
 	hwrm_req_drop(bp, req);
 	return rc;
 }
-- 
2.39.5



