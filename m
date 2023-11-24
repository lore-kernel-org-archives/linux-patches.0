Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D39133CC2;
	Fri, 24 Nov 2023 19:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pkS1gONk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3C2C433C8;
	Fri, 24 Nov 2023 19:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853338;
	bh=uKcCFESS9yliO8Uy7d2rByD14o4lY7MkqoG7wwfQi4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pkS1gONkV9eIbTPJfwTg2OCcQ4C1gzcTKmC/O2QL2ix7b6ZoRlz5GXjiJXqmXDTM0
	 dXnoVieyPPMF2IzPL91mEGG4ZHIIukggnELTmGhxPUtO7Ym5TMJJ44NjVMhhfTtDkF
	 +3zYjeFdsKWYQ3UujAk80RYJmlUHKbgOt31nFq9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 148/297] xfs: add missing cmap->br_state = XFS_EXT_NORM update
Date: Fri, 24 Nov 2023 17:53:10 +0000
Message-ID: <20231124172005.434532907@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 1a39ae415c1be1e46f5b3f97d438c7c4adc22b63 ]

COW extents are already converted into written real extents after
xfs_reflink_convert_cow_locked(), therefore cmap->br_state should
reflect it.

Otherwise, there is another necessary unwritten convertion
triggered in xfs_dio_write_end_io() for direct I/O cases.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_reflink.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 36832e4bc803c..628ce65d02bb5 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -425,7 +425,10 @@ xfs_reflink_allocate_cow(
 	if (!convert_now || cmap->br_state == XFS_EXT_NORM)
 		return 0;
 	trace_xfs_reflink_convert_cow(ip, cmap);
-	return xfs_reflink_convert_cow_locked(ip, offset_fsb, count_fsb);
+	error = xfs_reflink_convert_cow_locked(ip, offset_fsb, count_fsb);
+	if (!error)
+		cmap->br_state = XFS_EXT_NORM;
+	return error;
 
 out_trans_cancel:
 	xfs_trans_cancel(tp);
-- 
2.42.0



