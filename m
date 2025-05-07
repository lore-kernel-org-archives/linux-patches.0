Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84AD929A0;
	Wed,  7 May 2025 19:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644602; cv=none; b=jm/Mp+qSqWuIwUdP6u5XyUFQWIQaU8NOd+FRgCNRcOTAOT5fuCQsAqIhnxJQ+Zs5nclrSj/okPW6xAk+WU0dpKvedkWT9oy2I0bx68YG6GxDK4tU1LHZTbOHnD8BKuOBmlsCAdVyZf1vpRJDqsf40X0MqOe0nEIKhWt9RP4DxsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644602; c=relaxed/simple;
	bh=XKM8gnlNLi+tW84AjYzgGo0Du6iECWV/SxhBX08JCks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMuyNfloG3ZaKUcgNHwI+kwAhWWafQq0JkPv11bz3rY3tfPPL6h3IUKST+myuGqlJebRVnxikTA+7ESXzeOs4ixJZ4t1S6OVrQ+km/c35LFY2zyHJR8UZ0dYSlJ2FBf0/P743cGNYT6eekj8FRHMY4q6bLSX1joVwBcvn+iWJGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B25qZcYz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B25qZcYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7EFEC4CEE2;
	Wed,  7 May 2025 19:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644602;
	bh=XKM8gnlNLi+tW84AjYzgGo0Du6iECWV/SxhBX08JCks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B25qZcYz4gkPnowFBf45bXcawDt3NKeDSaqPkvrZyB0Hm7LwbES39iPiLCJzmYqCE
	 ALJ/Xo4CkdXzrJUFOZn5RdtAk4AinZgK4+gaWKVRqFTMGCZMHbCT8+D4O7vwLt8I3u
	 fQiGqBhfO8NEV0T8l2MvtEt4HTJ0OOl5Zk9nMOV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keoseong Park <keosung.park@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 097/164] scsi: ufs: core: Remove redundant query_complete trace
Date: Wed,  7 May 2025 20:39:42 +0200
Message-ID: <20250507183824.903248528@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

From: Keoseong Park <keosung.park@samsung.com>

[ Upstream commit 0e9693b97a0eee1df7bae33aec207c975fbcbdb8 ]

The query_complete trace was not removed after ufshcd_issue_dev_cmd() was
called from the bsg path, resulting in duplicate output.

Below is an example of the trace:

 ufs-utils-773     [000] .....   218.176933: ufshcd_upiu: query_send: 0000:00:04.0: HDR:16 00 00 1f 00 01 00 00 00 00 00 00, OSF:03 07 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ufs-utils-773     [000] .....   218.177145: ufshcd_upiu: query_complete: 0000:00:04.0: HDR:36 00 00 1f 00 01 00 00 00 00 00 00, OSF:03 07 00 00 00 00 00 00 00 00 00 08 00 00 00 00
 ufs-utils-773     [000] .....   218.177146: ufshcd_upiu: query_complete: 0000:00:04.0: HDR:36 00 00 1f 00 01 00 00 00 00 00 00, OSF:03 07 00 00 00 00 00 00 00 00 00 08 00 00 00 00

Remove the redundant trace call in the bsg path, preventing duplication.

Signed-off-by: Keoseong Park <keosung.park@samsung.com>
Link: https://lore.kernel.org/r/20250425010605epcms2p67e89b351398832fe0fd547404d3afc65@epcms2p6
Fixes: 71aabb747d5f ("scsi: ufs: core: Reuse exec_dev_cmd")
Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8d4a5b8371b63..a9b032d2f4a8d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7256,8 +7256,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 			err = -EINVAL;
 		}
 	}
-	ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR : UFS_QUERY_COMP,
-				    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
 
 	return err;
 }
-- 
2.39.5



