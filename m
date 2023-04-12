Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD882F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:35:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C9DC433D2;
	Wed, 12 Apr 2023 08:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288527;
	bh=4kaf7GLPDlglGCv04Df4RlzZ0dJngCbekqMf67l9O98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tKML+NPfWk9fY3dfa9Z8pV4r2TH1664apSHze5hFJL9zLWwUe35/EomYNURcAm3nc
	 T6f016vDiv/VYNja7DRmpyEoM+5d5iJJ7EgF7hqbx/yOOF5Qqou4XeesuUZAi7DiH5
	 9Z5hqZmI7e6tMju3NjT3RZ7Q0v7ZxhK+J/wqTUFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Foster <bfoster@redhat.com>,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 12/93] NFSD: pass range end to vfs_fsync_range() instead of count
Date: Wed, 12 Apr 2023 10:33:13 +0200
Message-Id: <20230412082823.554775130@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit 79a1d88a36f77374c77fd41a4386d8c2736b8704 ]

_nfsd_copy_file_range() calls vfs_fsync_range() with an offset and
count (bytes written), but the former wants the start and end bytes
of the range to sync. Fix it up.

Fixes: eac0b17a77fb ("NFSD add vfs_fsync after async copy is done")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Tested-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index c91da7bce17ea..3eb500adcda2e 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1514,6 +1514,7 @@ static ssize_t _nfsd_copy_file_range(struct nfsd4_copy *copy)
 	u64 src_pos = copy->cp_src_pos;
 	u64 dst_pos = copy->cp_dst_pos;
 	int status;
+	loff_t end;
 
 	/* See RFC 7862 p.67: */
 	if (bytes_total == 0)
@@ -1533,8 +1534,8 @@ static ssize_t _nfsd_copy_file_range(struct nfsd4_copy *copy)
 	/* for a non-zero asynchronous copy do a commit of data */
 	if (!copy->cp_synchronous && copy->cp_res.wr_bytes_written > 0) {
 		since = READ_ONCE(dst->f_wb_err);
-		status = vfs_fsync_range(dst, copy->cp_dst_pos,
-					 copy->cp_res.wr_bytes_written, 0);
+		end = copy->cp_dst_pos + copy->cp_res.wr_bytes_written - 1;
+		status = vfs_fsync_range(dst, copy->cp_dst_pos, end, 0);
 		if (!status)
 			status = filemap_check_wb_err(dst->f_mapping, since);
 		if (!status)
-- 
2.39.2



