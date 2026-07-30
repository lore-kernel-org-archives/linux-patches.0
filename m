Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB0237C92C;
	Thu, 30 Jul 2026 15:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424773; cv=none; b=dCh4Xo34MaKWnvg/FFxaeGsZiO2y12DfUdJNv+vT3qllCmUEiAvz4nK0XW/m+FRpC/esIhU2Dr7u4/vr++tDaJZpTY9MfXIaPqUcNbUk4IUBxfQmWAIz27bGILzMm5WSecOuVEuTj4TzJCke1RDPI1psdk/TP/J31oyAylMamNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424773; c=relaxed/simple;
	bh=+fImuYekiQTeChchoJgCLFkTfOsdjDKrlwEA6E2SoFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=buEMAs7CUPvl8cOEnpVAPOLQjgucEa4Wwjo2E0c47KLnqO96Wu/5wuJnQTkGRZ4en+tuFJcS/x7pfk8TR/3TvTNd+B684lqnBV2Pl2fX0qKJx6mDit/Cihu6DR+/g9jWqqd3WMBUU6qbEU34nxcdwHkWlRGNtfjzLO/6RwcyQvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RYlw6/xt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RYlw6/xt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675C41F000E9;
	Thu, 30 Jul 2026 15:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424772;
	bh=crBlkWF3Yv+WAbNMMI2rJGXy3q2kf0zEkATRBKkqNyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RYlw6/xtrjPMGpR9mqLtYHQqaN0catp8jXQOhPBqd9L3LYccBr4qU9WyxpQN3FGkd
	 aAb0MOJje/KWNnL1dxkqg8tz+QGJ2XoriAQ8ToeJvMBpd1hoWapKXYFxPFYyRKAgrq
	 svs9SHLPANohYeB34mQtcze9chb17jfWhopenics=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.18 512/675] ceph: fix refcount leak in ceph_readdir()
Date: Thu, 30 Jul 2026 16:14:02 +0200
Message-ID: <20260730141456.011862152@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


