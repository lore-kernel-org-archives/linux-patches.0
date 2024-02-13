Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDD55F56B;
	Tue, 13 Feb 2024 17:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845257; cv=none; b=E2MBQNw/XFc5LYVWTF+wFsfJCXJotg5KwXf3a4MoCnKYmZFC77Gn99RuUthsvm+9NOwI40kQFQytIuLhIl2vFYqUdj2gs6IfheFkh0B9rupg0J06tU+eqZfQ8hiJuJx5p0jnSBBYKliw3RY29o3F6WrA8PqyZ34+4qmzON6E4T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845257; c=relaxed/simple;
	bh=c42/HRPYBUT6qBWkrH9h1ax1oiYUDrz76AdpwtVD8ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUYhAG9j5BhyQDRlHPEDC8jMCjyi80oYiNV3xYdCnqGWY1dlDCvQZoj2f0qX91KzOk+W5eCp93CWfJkwaVw6kkfOx4vZvi6Pr0OumU8MOCZQZB0S3M5OQtQcLwnKpe4Ze39NGrRvR+knUdrQDq9Luc3SxKTqDR8bWpB0L+gXNso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SNAwSgFc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SNAwSgFc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0A7C433C7;
	Tue, 13 Feb 2024 17:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845257;
	bh=c42/HRPYBUT6qBWkrH9h1ax1oiYUDrz76AdpwtVD8ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SNAwSgFcRM0KD/LkQ2bP2F5FO1xeI9+WdMfBcP8HaigEcfiGIYoBho20IJcsvIh0s
	 ie5Ejeyjf6Z4cHL9DWnDw09U67z8c4/F0yF3sZPVMJhaPf8JWa1F4jrbVxbDr9OiLp
	 9tWGy4iFCfSecYRyXl2Oco2AiwCK/t9i71DGfnNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/121] xfs: only remap the written blocks in xfs_reflink_end_cow_extent
Date: Tue, 13 Feb 2024 18:20:38 +0100
Message-ID: <20240213171853.827470362@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Christoph Hellwig <hch@lst.de>

commit 55f669f34184ecb25b8353f29c7f6f1ae5b313d1 upstream.

xfs_reflink_end_cow_extent looks up the COW extent and the data fork
extent at offset_fsb, and then proceeds to remap the common subset
between the two.

It does however not limit the remapped extent to the passed in
[*offset_fsbm end_fsb] range and thus potentially remaps more blocks than
the one handled by the current I/O completion.  This means that with
sufficiently large data and COW extents we could be remapping COW fork
mappings that have not been written to, leading to a stale data exposure
on a powerfail event.

We use to have a xfs_trim_range to make the remap fit the I/O completion
range, but that got (apparently accidentally) removed in commit
df2fd88f8ac7 ("xfs: rewrite xfs_reflink_end_cow to use intents").

Note that I've only found this by code inspection, and a test case would
probably require very specific delay and error injection.

Fixes: df2fd88f8ac7 ("xfs: rewrite xfs_reflink_end_cow to use intents")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_reflink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 658edee8381d..e5b62dc28466 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -784,6 +784,7 @@ xfs_reflink_end_cow_extent(
 		}
 	}
 	del = got;
+	xfs_trim_extent(&del, *offset_fsb, end_fsb - *offset_fsb);
 
 	/* Grab the corresponding mapping in the data fork. */
 	nmaps = 1;
-- 
2.43.0



