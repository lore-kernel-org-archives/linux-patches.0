Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2395C1AF0CE;
	Mon, 23 Dec 2024 16:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970129; cv=none; b=Xqi7Xt7guDxuSwO5uVd0/qEZqex1/jysFtFCFb+xlWnfMlA1dtBVyZ2CduOpTCgmw8C6PVuxEsZUy6FL9aVozlpyjBkXqCM9zIMtzx6xAc3Dw1617QVMlzS3rHNqSKwrvPrkGaxzANYvZzGCkf1fZS7gxQfxvtwIhCKbLWkuZCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970129; c=relaxed/simple;
	bh=q2NlPwRtCd0JlN8SCTEN9b/NXDGi0DCarj/tpXNr2lY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVVgzdLtAVCOISQILy/jzGD/6ujTq3vHhrt4nsq0u8OBrvkjNUNrYKy55FZyiOd4kzk8tM9RGRaupa3KcMH/yrtVQ86eu/IcdElE6DKNFXp14RipfkPOo4lflaoYwAMcxxmiFQd5uc7/QCuGKDULt++U2MnEy/TQtxJbffU4c+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i3eWH2EG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i3eWH2EG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43038C4CED3;
	Mon, 23 Dec 2024 16:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970128;
	bh=q2NlPwRtCd0JlN8SCTEN9b/NXDGi0DCarj/tpXNr2lY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i3eWH2EGbKjEAywHjr9VWZMqIm9wuqLp/Xw1aGb60ExwFtEkOS1jCUg2104sYbj4t
	 Ch2FGCshl5g7VhyhNkTPtXALaC9SpeYXzKWJMdubuDfquMOFxmwQPftGbH+AZMOO41
	 hXW1Up0ltQydNnnH5m+brafWRM01tojwkbjs54gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.12 154/160] ceph: fix memory leaks in __ceph_sync_read()
Date: Mon, 23 Dec 2024 16:59:25 +0100
Message-ID: <20241223155414.764578425@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

commit d6fd6f8280f0257ba93f16900a0d3d3912f32c79 upstream.

In two `break` statements, the call to ceph_release_page_vector() was
missing, leaking the allocation from ceph_alloc_page_vector().

Instead of adding the missing ceph_release_page_vector() calls, the
Ceph maintainers preferred to transfer page ownership to the
`ceph_osd_request` by passing `own_pages=true` to
osd_req_op_extent_osd_data_pages().  This requires postponing the
ceph_osdc_put_request() call until after the block that accesses the
`pages`.

Cc: stable@vger.kernel.org
Fixes: 03bc06c7b0bd ("ceph: add new mount option to enable sparse reads")
Fixes: f0fe1e54cfcf ("ceph: plumb in decryption during reads")
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/file.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1127,7 +1127,7 @@ ssize_t __ceph_sync_read(struct inode *i
 
 		osd_req_op_extent_osd_data_pages(req, 0, pages, read_len,
 						 offset_in_page(read_off),
-						 false, false);
+						 false, true);
 
 		op = &req->r_ops[0];
 		if (sparse) {
@@ -1193,8 +1193,6 @@ ssize_t __ceph_sync_read(struct inode *i
 			ret = min_t(ssize_t, fret, len);
 		}
 
-		ceph_osdc_put_request(req);
-
 		/* Short read but not EOF? Zero out the remainder. */
 		if (ret < len && (off + ret < i_size)) {
 			int zlen = min(len - ret, i_size - off - ret);
@@ -1226,7 +1224,8 @@ ssize_t __ceph_sync_read(struct inode *i
 				break;
 			}
 		}
-		ceph_release_page_vector(pages, num_pages);
+
+		ceph_osdc_put_request(req);
 
 		if (off >= i_size || !more)
 			break;


