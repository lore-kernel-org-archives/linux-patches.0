Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70F71D5CEA;
	Wed, 19 Mar 2025 14:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395042; cv=none; b=re11EIiyuG30Hq7UnC5e9z7sX+aP1qBm8SewhCX7UqYn0WlgZpTvmexWuGuUeBrSs3B8vnk1CLPQgWp1Mpa1Fn2BiVGShunnabFW1M/1bhrqPLGN8JyOB+eHXlXB9SL6aPHqrvmPj8y1TOcDh7EGChdJ3YewlDt4o/neMGmngFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395042; c=relaxed/simple;
	bh=YOXSmszJRCIIyb/Q0WH8huxy6g5ff+/jPKNVqSLXV/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D00xd06B7yo9ruSvWhZDjc7czzLTUsczpBAKifOPGByg9BHi4OgSEqEfYn4XyhitRSScFh8zvcUi5mgILZsPVhMWe/szOV8kdk9YKfMj4eIGXV4M+g/DDVvhfcF4fTYVmGYQwkwGk5vecgLnATSdnC66HloLi9E5/6bW+7zPO5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fqywDsWh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fqywDsWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93F7C4CEE4;
	Wed, 19 Mar 2025 14:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395042;
	bh=YOXSmszJRCIIyb/Q0WH8huxy6g5ff+/jPKNVqSLXV/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fqywDsWh4Jb3XPM+N6vtE2gd25LHOO6M1rMfA4F4rDCXC9uWZkLDSVTzYgZE/WN59
	 MBVhWg8SV3ks+Y3cPhAZrBqoAEepC2bC1Y7Wh3zJtEGimL+9YJ/uZwPWIE/tKQePMZ
	 4mGfFYMtb6VgWkChfk9+MeFqxw7tRLt0nUjok0LA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seunghui Lee <sh043.lee@samsung.com>,
	Bean Huo <beanhuo@micron.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 067/231] scsi: ufs: core: Fix error return with query response
Date: Wed, 19 Mar 2025 07:29:20 -0700
Message-ID: <20250319143028.485891270@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

From: Seunghui Lee <sh043.lee@samsung.com>

[ Upstream commit 1a78a56ea65252bb089e0daace989167227f2d31 ]

There is currently no mechanism to return error from query responses.
Return the error and print the corresponding error message with it.

Signed-off-by: Seunghui Lee <sh043.lee@samsung.com>
Link: https://lore.kernel.org/r/20250118023808.24726-1-sh043.lee@samsung.com
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index a3e95ef5eda82..89fc0b5662919 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3138,8 +3138,13 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	case UPIU_TRANSACTION_QUERY_RSP: {
 		u8 response = lrbp->ucd_rsp_ptr->header.response;
 
-		if (response == 0)
+		if (response == 0) {
 			err = ufshcd_copy_query_response(hba, lrbp);
+		} else {
+			err = -EINVAL;
+			dev_err(hba->dev, "%s: unexpected response in Query RSP: %x\n",
+					__func__, response);
+		}
 		break;
 	}
 	case UPIU_TRANSACTION_REJECT_UPIU:
-- 
2.39.5



