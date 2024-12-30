Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CD0156678;
	Mon, 30 Dec 2024 15:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574022; cv=none; b=m3XLIwctVSb+MoNhZscJvwzSgTbjTRT2mbzVKqCdTsRrWLBpW8otTL9ei1aEBSoRUCErWp/gygBCtyuPWkfgIZn9d6hb9ZdLICiOAD5lsoyLOyuAtvV7t2GHiX8hHXq+M+eDmoXzdoCekGzK1HRy01efsD9mzuc9bTTqVnZ1i9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574022; c=relaxed/simple;
	bh=HoPNRwTq+4lVGI+aD3ukWV982kFG+WegeZ+lGilZMEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=usWtNbBCm+9XpCDC/IuTxcXUqM9r0X7LWsJMRwWcc01mdA+qcrW5nSxEfPToHrxTBWCMgCcMZhuIBa8/TAKH1bBFhuHt4TRRKzthMduPA//GwghXS80sU/9Pbkursg9UUM/QTokEEo8yvC4qR5suoQcfrp7tLpW919jNRY8QbDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YCgmhHOh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YCgmhHOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5615C4CED0;
	Mon, 30 Dec 2024 15:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574022;
	bh=HoPNRwTq+4lVGI+aD3ukWV982kFG+WegeZ+lGilZMEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YCgmhHOh/NSo1/V7CKhJDEcA4SnjGwHj466S9BCE8SD6/cEQktikBBJHPKBT1PLJh
	 m4FnLf4PW4TwqpwMFH8uF83SObyXmmI92IIwNRnCh+QbxlfIk1sOQsw/o9X306IJL7
	 Y+hnzObFHgRTblBaiPJ+Wo/MVjE3vTyA7JdEoiok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 002/114] ceph: allocate sparse_ext map only for sparse reads
Date: Mon, 30 Dec 2024 16:41:59 +0100
Message-ID: <20241230154218.152259121@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

From: Ilya Dryomov <idryomov@gmail.com>

[ Upstream commit 18d44c5d062b97b97bb0162d9742440518958dc1 ]

If mounted with sparseread option, ceph_direct_read_write() ends up
making an unnecessarily allocation for O_DIRECT writes.

Fixes: 03bc06c7b0bd ("ceph: add new mount option to enable sparse reads")
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/file.c        | 2 +-
 net/ceph/osd_client.c | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 67468d88f139..851d70200c6b 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1552,7 +1552,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 		}
 
 		op = &req->r_ops[0];
-		if (sparse) {
+		if (!write && sparse) {
 			extent_cnt = __ceph_sparse_read_ext_count(inode, size);
 			ret = ceph_alloc_sparse_ext_map(op, extent_cnt);
 			if (ret) {
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 9d078b37fe0b..abac770bc0b4 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1173,6 +1173,8 @@ EXPORT_SYMBOL(ceph_osdc_new_request);
 
 int __ceph_alloc_sparse_ext_map(struct ceph_osd_req_op *op, int cnt)
 {
+	WARN_ON(op->op != CEPH_OSD_OP_SPARSE_READ);
+
 	op->extent.sparse_ext_cnt = cnt;
 	op->extent.sparse_ext = kmalloc_array(cnt,
 					      sizeof(*op->extent.sparse_ext),
-- 
2.39.5



