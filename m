Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE593A5433;
	Thu, 30 Jul 2026 14:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422990; cv=none; b=roFJaQpvRPYr58o+a12zbj/dg4ropx8FKcqslOrjFpmKHsYQw/yUawWXBBv+YepMCb3kyYqePMhIpbfGNcAyI8xtyIF3NDn4Jp0D7d+I7fatgWFN+jhAwqhu/1BYKwkaT7VuAiyvBu6l35ZmESWgWrehxxisjDGenagvRQurOqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422990; c=relaxed/simple;
	bh=zJU2LFuH2XlhcrHbFeS0OSYpDl/CRhEN1Pz8B6ug9co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BlXqjjR1unjPCsrGMGXltX6HIVf6UDxCwcVNQyFIn4lbKUBHhj4eK4cUzi9Q+efWYB8qVSTHQhdUUmhiAWNmNdjlta+WuGAoVCfBvsl/122PAbHrhiAPzsLulVPqNGT4CXdBo9/y/rre3w0ddC15cFhjglW+HeVY0o429HAUHHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=syk9isOS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="syk9isOS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 994C21F000E9;
	Thu, 30 Jul 2026 14:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422989;
	bh=A6QZGSKF4d0p7QY1jLAt+XmtsxMgPYGce/JKr163GFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=syk9isOScxQCB56C1qxhHjPMEO0cF8B9RnHdEABjcl6zgqlfGJvXuzGsAzc3NCsGy
	 GTgOx3vYD1ZLt/ig4YCxCq+akfyIQceWQ+mFWnxK8wCDMzP1HtTi56rpCvHW1sbjmp
	 yc8nED5gPCICF/Bmp1yiumMdkrhlYFoXCqW30vEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 7.1 627/744] ceph: fix refcount leak in ceph_readdir()
Date: Thu, 30 Jul 2026 16:15:00 +0200
Message-ID: <20260730141457.602650905@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WenTao Liang <vulab@iscas.ac.cn>

commit c3e64079d8b9663e3998d0caac9aba915b6b93ae upstream.

The ceph_readdir() function allocates a ceph_mds_request via
ceph_mdsc_create_request() and stores it in dfi->last_readdir. In
the directory entry processing loop, if the entry's offset is less
than ctx->pos or if the inode pointer is unexpectedly NULL, the
function returns -EIO without releasing the reference held by
dfi->last_readdir, causing a refcount leak.

Fix this by adding ceph_mdsc_put_request(dfi->last_readdir) before
returning on these error paths. Also set dfi->last_readdir to NULL
for safety, matching the cleanup done at the normal exit.

Cc: stable@vger.kernel.org
Fixes: af9ffa6df7e3 ("ceph: add support to readdir for encrypted names")
Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/dir.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -546,11 +546,16 @@ more:
 			pr_warn_client(cl,
 				"%p %llx.%llx rde->offset 0x%llx ctx->pos 0x%llx\n",
 				inode, ceph_vinop(inode), rde->offset, ctx->pos);
+			ceph_mdsc_put_request(dfi->last_readdir);
+			dfi->last_readdir = NULL;
 			return -EIO;
 		}
 
-		if (WARN_ON_ONCE(!rde->inode.in))
+		if (WARN_ON_ONCE(!rde->inode.in)) {
+			ceph_mdsc_put_request(dfi->last_readdir);
+			dfi->last_readdir = NULL;
 			return -EIO;
+		}
 
 		ctx->pos = rde->offset;
 		doutc(cl, "%p %llx.%llx (%d/%d) -> %llx '%.*s' %p\n", inode,


