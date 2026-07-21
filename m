Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0161A3B2FE4;
	Tue, 21 Jul 2026 20:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665900; cv=none; b=LHOmqH+KOfiRiDlFZbPraV1ZEGh13btLS6pmzpDyUAraenq6Pl7r7PneT1llq+iDzeMWP5iD9mJjkOF46dpTstAmVCd7p8sateJ0SeUXRwyWfRpqFDSxxfIT9Hxi+6z5IOCfehimgKuqIzITy75YJ0i+cmbAdP1j2l+ZOCZXGEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665900; c=relaxed/simple;
	bh=MApJ4R0tlFFuwiozX592Yk0JLtOQzPGX2gveSiYQwbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MxWTD/udhfqdABNOZcTT7YxNdtBF/TdsSlEI+1Wg+IAyQIKsLuW32B8s6eRsVlLM8PVOjScQrk0UMRFZF1hPNXUjOB0EpJwvPGr3Xf8kqD7tR2h+BZJyoCVfsuuF1T905vKhiUhK6Q1adRgZKx43Z/pRwi5S+/uNmd//h0glphk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vUodoi7b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vUodoi7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06AA61F000E9;
	Tue, 21 Jul 2026 20:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665898;
	bh=GzgYTxIGayJMhCjGeE69KfH5QMV3OqEqpzYhdbumT0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vUodoi7bCs0/NfvMhz9zWiG8/e1QeQo6kkPdqYHwHHdbc3kwLbmGwz9i1vsp5FE7o
	 T0LZbvo1Y7Hu3g4vatdMPQRer/rRoED6uADDBpMKXwZRDSu1/JgEqp6FNR/DpbLi2Z
	 KgqP2uXl3s08ss9d84tmGS++LbW8ldWaBoTvcVCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chanwoo Lee <cw9316.lee@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0478/1266] scsi: ufs: Fix wrong value printed in unexpected UPIU response case
Date: Tue, 21 Jul 2026 17:15:15 +0200
Message-ID: <20260721152452.532489324@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Chanwoo Lee <cw9316.lee@samsung.com>

[ Upstream commit 2483ae0a56231a915c706411421c6c002a2bf83e ]

In ufshcd_transfer_rsp_status(), the default case of the inner switch
statement prints the UPIU response code when an unexpected response is
received. However, the code was printing 'result' variable which is
always 0 at that point, making the error message useless for debugging.

Fix this by printing the actual UPIU response code returned by
ufshcd_get_req_rsp().

Fixes: 08108d31129a ("scsi: ufs: Improve type safety")
Signed-off-by: Chanwoo Lee <cw9316.lee@samsung.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260527092134.275887-1-cw9316.lee@samsung.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index f6aada5150f9cd..142abff3012207 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5407,7 +5407,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
 		default:
 			dev_err(hba->dev,
 				"Unexpected request response code = %x\n",
-				result);
+				ufshcd_get_req_rsp(lrbp->ucd_rsp_ptr));
 			result = DID_ERROR << 16;
 			break;
 		}
-- 
2.53.0



