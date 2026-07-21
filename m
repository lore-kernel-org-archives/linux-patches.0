Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E199646D0AD;
	Tue, 21 Jul 2026 17:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656227; cv=none; b=JtzKAMeAcR4oXh1xU7UeqEJBjjrbzktNfKH4rneuk0bXlhEnDO6H2peaB+c5+4cDrRzoeGekheIjIl8ckH8nMbyCqeKKrw1pNIJR5kx5NNKey/pAg8MibGW8nW12q8jwEfv+3kh/wZGCJV6KRGXh5vhSsYqin0JmcVcoWFsPxks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656227; c=relaxed/simple;
	bh=1NcKqT7cNtKWpA6WPueD4ryL/Sp0xNqLv+rkuXYIo8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvMsVbneklFvFWScZ3VBX5x4WUJQZI4TdgG+2JBXF/S7s451ENhAfMQRhrdSKF+5rbTGR7JQt3msLAqZIhRTYZRz0Za7gulquJjsK9e4oaHylKa9IEY0z2mF10LqjGcCsgZRby5FDpna6jXDRkLcPmlsQ70CH12RzYQxmIWGInw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ocx+ErkF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ocx+ErkF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541361F000E9;
	Tue, 21 Jul 2026 17:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656225;
	bh=zWQpNwC6GX887j+zlrWK5uWft03LAKuLqVH2626bK08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ocx+ErkFhYtdAsdBX0xv494wZeOjEv6EFHKENtAD4FgC1ZUHjVo4bCbDzZ3JibAyP
	 l0Tckfz/QpGGTmU1UwEJ19A+jLabUfN5K5PIU92C3L6Qw36zD33dJC6sRr+kdNrMJx
	 ZGKczqDsorcX7sbjgPWbtZRFR6bET1x8CPCQjvq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chanwoo Lee <cw9316.lee@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0307/1611] scsi: ufs: Fix wrong value printed in unexpected UPIU response case
Date: Tue, 21 Jul 2026 17:07:03 +0200
Message-ID: <20260721152521.981174991@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5371f173e28b9e..8de3d0886a121b 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5494,7 +5494,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
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



