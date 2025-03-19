Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52EAF1B2194;
	Wed, 19 Mar 2025 14:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394898; cv=none; b=E/kH+2b+6yDhbQJ/SKtIp1hR8SZqlC5nLhjmi+jW0xsyLA4WSI9Hg/4YQ82MpalOpgmK8ByeH4l8J2gtIuL9/RM3RXbmu1XFTvpqWJSRWOMmckpLfgTez6OQGNR07V35UObwOa6vRyqWjc0/nERzaQbXS/lATc6+1KR/1tXq/JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394898; c=relaxed/simple;
	bh=EqnbpRAt8sVe2qqlJLAVmUGuMUh+KZe+4vZKNiSyU4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p5vzBqbMJJnej+yLPDvvYWkBshwek9gx00OfNqPGlBWKe03Xbm1DM452oiWmdtBTosnBUJkDReRQIXHMuV8GKbHZOp+ksbu+t0qU3He9WetP2NZvU2x4XoRR/I0JLgiMjfdDGkwOyBbEztourM6Aq1PV0mydnkPqyx/wNyJvjoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kGvQeXDI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kGvQeXDI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297BCC4CEE4;
	Wed, 19 Mar 2025 14:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394898;
	bh=EqnbpRAt8sVe2qqlJLAVmUGuMUh+KZe+4vZKNiSyU4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kGvQeXDIDy2pAZz46xKg6zH5wSedDbfYjCydQcqqHx+d2/DfTARykwjRERSrfuPfL
	 q1pBkvnVZj2Rl+pYblbSua4JIzHtZrMuxi/vO5EXQgZC/qO92qpcWpefJ3qD/N7a6Q
	 AT0UoldRjUx+khuaGD7RYk5cqoMLO+gbVx7PNHpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seunghui Lee <sh043.lee@samsung.com>,
	Bean Huo <beanhuo@micron.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 068/241] scsi: ufs: core: Fix error return with query response
Date: Wed, 19 Mar 2025 07:28:58 -0700
Message-ID: <20250319143029.404473766@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index a5bb6ea96460c..96cb294e2ec30 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3119,8 +3119,13 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
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



