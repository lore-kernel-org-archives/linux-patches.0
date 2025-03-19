Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3221D1FDE39;
	Wed, 19 Mar 2025 14:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395186; cv=none; b=J9W1tgJr2h1aA0A6K3cMH8Ci9xVGKcKgsb8R3eCsdXD6SLfVNIZEGKDrlmMaBjg5Qtx8THbblw6s9+E60yclwCtgTiFv589ED+52AORr/9n2bQs4AabP3ny9cb6/d+ownvGQP3LyDhgxJ0od1o6TnlIFAvTEqqFTKDIgOH5X4S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395186; c=relaxed/simple;
	bh=slCl2vYTn0Zy6K+DTEU0bIRVcCt//ngQUkmmpWfEPWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qo9mfZxKTwjHv98M5U5daLMz/0rQfbWWP3FamsOERQarHBMTL91xPlwcYOH3IEPndVqA2Iy5ZahrsT7fCVBGc9dp8Uc7OqW+6x/2cl0uI4cK4+eVG7OBbgyYcKFQxhrvDTs6sU2kgubkzW+ddabwBkAhvk9RhJrDk1FAc8NkGSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lHLOj53I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lHLOj53I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E62C4CEE4;
	Wed, 19 Mar 2025 14:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395186;
	bh=slCl2vYTn0Zy6K+DTEU0bIRVcCt//ngQUkmmpWfEPWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lHLOj53IUyzFK2NDn+fOmOe4fQW3HWrpEhhNhTfRVebFGy8urAmBvUmmrpFOOBZg2
	 vgelC09oJ+6kCs0xH0i777CNWBvoIyV+MPd9fgD6Ud3Jo1jVn4+ubn5m4rnjkOGo3c
	 jRXQke9Jpj3m1P5Ejza9h25IgpzZ+dED1kgrbvYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seunghui Lee <sh043.lee@samsung.com>,
	Bean Huo <beanhuo@micron.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/166] scsi: ufs: core: Fix error return with query response
Date: Wed, 19 Mar 2025 07:30:15 -0700
Message-ID: <20250319143021.185507910@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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
index 6d53dd7d411a8..cb5611cbf4547 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3027,8 +3027,13 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
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



