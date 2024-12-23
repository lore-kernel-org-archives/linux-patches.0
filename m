Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24948827;
	Mon, 23 Dec 2024 16:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970525; cv=none; b=nwPNGZ6A5XlbOfWlN3UTdRB9+FWF7/OfSrsgnO1D3kD7UdwHUJmQerZ9UOqsS7mm2evNntaGbXGJ1APdYwXTizK1pX0Z18bJD+pCHnRpuhUvK4z/c7lgwijkxYV0j4+H+f8WepZ2LjkyIjKYJOwuX+WUbErU6EqAXxlBxa0ujUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970525; c=relaxed/simple;
	bh=dFW/ICnDSSUOqPzpYoMYpuFSw2P0H2QABca84I36p8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YI5zTWceh30edm+Km9xiYEKyMiek7LLnM/TdxBvt/wRSlqBiPScw3THIReNYb92DSonQtq1jMzqkKc1U0V2/ZHSN7qW1nr5n8sWhtnPYEktBDDQHVmCHg6VPbqLwW9OxdN3hWWsTpcpg/Isjww8vMYmu9qU5W4R/ob3uQugjqp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Dq0B++r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Dq0B++r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E476C4CED3;
	Mon, 23 Dec 2024 16:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970524;
	bh=dFW/ICnDSSUOqPzpYoMYpuFSw2P0H2QABca84I36p8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Dq0B++rzprtBmgZ+ymiNx5EJN0GHImj77JmqfbQVGKqztD3wfvwWB2HSzTI2MzY2
	 cyEGsHvMcOBVeOPM5VLzOZ7haRKUfeGks5Vl5CgHEE95rQfDituWb+2VhHdklRlX+/
	 kcQYqyypqUJm9qs7QP0E5/sKKltoV/Z+E/aiVIMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.6 109/116] ceph: fix memory leaks in __ceph_sync_read()
Date: Mon, 23 Dec 2024 16:59:39 +0100
Message-ID: <20241223155403.785748543@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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
@@ -1036,7 +1036,7 @@ ssize_t __ceph_sync_read(struct inode *i
 
 		osd_req_op_extent_osd_data_pages(req, 0, pages, read_len,
 						 offset_in_page(read_off),
-						 false, false);
+						 false, true);
 
 		op = &req->r_ops[0];
 		if (sparse) {
@@ -1101,8 +1101,6 @@ ssize_t __ceph_sync_read(struct inode *i
 			ret = min_t(ssize_t, fret, len);
 		}
 
-		ceph_osdc_put_request(req);
-
 		/* Short read but not EOF? Zero out the remainder. */
 		if (ret < len && (off + ret < i_size)) {
 			int zlen = min(len - ret, i_size - off - ret);
@@ -1134,7 +1132,8 @@ ssize_t __ceph_sync_read(struct inode *i
 				break;
 			}
 		}
-		ceph_release_page_vector(pages, num_pages);
+
+		ceph_osdc_put_request(req);
 
 		if (off >= i_size || !more)
 			break;


