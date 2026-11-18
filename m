Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028818;
	b=461qY4felAecUVsOI/iJyWiNo30fPujgZQ5gfjgQspXzxXhWFF9GGwPcC75C8jaVmV23
	 8LZnjQAtY2HW7CR3q8k71Dqctrb6Z0IMDQXljy/Lp1XnePXK9hkm05eW4V/1AIcsnWFUs
	 +dTs5eyHbLCYxkPCKTaKZxK7AqXkFhUZaJHXzuKxqToQ3FFkyV5cKZ9jwRUTxyyrjfVlX
	 uI24fqH015/ms1cUniXmXiIvpchziWHMpuioUHSsw2E7waH+2iEOJxZpx22/WEgvXRS6M
	 oeOiBG0Gn0RNj4GuwjLJtOCegb8IGd0Z0VCDr+j6G88LFZFBbGQQTzy9O60SmRRj6PQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028818;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zi7Cfkc381DFpzcjSRzd1qk3kiUqck/P3BMx4fCECNs=;
	b=2iXag/2HZZHpoeonnADk/LhmhQVK/TRuDbi/3WxWCiXAAmszyCUzD+IpVIhwKgl85Nj3
	 8e59OUh7q2N6gt0/32mxPVZrpKlSSYIL9LPG5OwCVSSCq2vQQo+JaJmkZ+oiMpgh1UZZt
	 VGmV4WtF0WjIe+AQJcm6nMfdZMOilc9O5EI6knJYZlHyqhlsen9jXw35tVRCl7e/7xe/r
	 f1HPL/RMOP370dKv/ON+1XmynzLDdoFGlz8fRb3KgDKTPFLrcNU3BwAb+JAd6+AU9LM6q
	 dF1mmN3QStLs/3r+fMEWmcW5ypAiEqlTP0r2BZG7wmIWkkC5vAcNz6Z+a5jU59wOgbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zohWi2bZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6F0606A33F;
	Wed, 18 Nov 2026 19:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zohWi2bZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C821F000CA;
	Wed, 18 Nov 2026 19:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028818;
	bh=zi7Cfkc381DFpzcjSRzd1qk3kiUqck/P3BMx4fCECNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zohWi2bZSskkUk+LUmd2qUY61A0v9LGoz3yvGHzM8pPBwkGB6WiYV5P3Z4Z+KDoEb
	 6sMMIwQ9d/nVE/y8L4tWSqmnCTbVhE1pEjChVbpS+enqZdi5j2XY37CKh+F4plHph3
	 fKQXeIpEjPbl1z/xeFx/HyICSwamZ1V7iKDrr6N8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Christian Brauner <brauner@kernel.org>,
	Petr Vaganov <petrvaganoff@gmail.com>
Subject: [PATCH 6.12 0130/1756] fs/stat.c: avoid harmless garbage value problem in vfs_statx_path()
Date: Wed, 18 Nov 2026 15:37:37 +0100
Message-ID: <20261118150013.365797961@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

commit 0fac3ed473dd2955053be6671cdd747807f5e488 upstream.

Clang static checker(scan-build) warning:
fs/stat.c:287:21: warning: The left expression of the compound assignment is
an uninitialized value. The computed value will also be garbage.
  287 |                 stat->result_mask |= STATX_MNT_ID_UNIQUE;
      |                 ~~~~~~~~~~~~~~~~~ ^
fs/stat.c:290:21: warning: The left expression of the compound assignment is
an uninitialized value. The computed value will also be garbage.
  290 |                 stat->result_mask |= STATX_MNT_ID;

When vfs_getattr() failed because of security_inode_getattr(), 'stat' is
uninitialized. In this case, there is a harmless garbage problem in
vfs_statx_path(). It's better to return error directly when
vfs_getattr() failed, avoiding garbage value and more clearly.

Signed-off-by: Su Hui <suhui@nfschina.com>
Link: https://lore.kernel.org/r/20250119025946.1168957-1-suhui@nfschina.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Fixes: 98d2b4308197 ("add unique mount ID")
Signed-off-by: Petr Vaganov <petrvaganoff@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/stat.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/stat.c
+++ b/fs/stat.c
@@ -253,6 +253,8 @@ static int vfs_statx_path(struct path *p
 			  u32 request_mask)
 {
 	int error = vfs_getattr(path, stat, request_mask, flags);
+	if (error)
+		return error;
 
 	if (request_mask & STATX_MNT_ID_UNIQUE) {
 		stat->mnt_id = real_mount(path->mnt)->mnt_id_unique;
@@ -274,7 +276,7 @@ static int vfs_statx_path(struct path *p
 	if (S_ISBLK(stat->mode))
 		bdev_statx(path, stat, request_mask);
 
-	return error;
+	return 0;
 }
 
 static int vfs_statx_fd(int fd, int flags, struct kstat *stat,


