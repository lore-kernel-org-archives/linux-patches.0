Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E090B524AF;
	Mon,  8 Apr 2024 13:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584384; cv=none; b=aP5bO5zmmIKnYH96+XMw9Rnyn4vn74S+eMtECmpSu5mU0N2z2VDJy6+GiCoZYQnBS/HcePfIOH6Mj68zBB2jSgykhM7U8SHuPG1U8NKlUrJikQfospLEhxtHZe/UhIZoCvs84akI5YmQogcYQmmN58wR5DwAsBU2TZIe+geozcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584384; c=relaxed/simple;
	bh=kKx6AAikZjNH+zTvXT1+A/fdXuN7VNJk9K2K3CQuWy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ghLuexWVDc5MpfX7qe9odRB1wO4M/UqADTR6D1DnR406b5PA5AgPvvxKtVwI0T6KdPo7xmLVFEjwnvuqcWcrGLVmbgpeoDoS5LOWcIekFNB9YysYw0Tuxjwk/LZXTXWGKPd5EMGN+JQR4YO0BNg1K+2SibeKxtG2KRdfpPvWWUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LWo4rG90; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWo4rG90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A39C433F1;
	Mon,  8 Apr 2024 13:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584383;
	bh=kKx6AAikZjNH+zTvXT1+A/fdXuN7VNJk9K2K3CQuWy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWo4rG90xhkB5Ix8p0kJkGcJvkhmaZ26CQ3VdcLCL+642LItgKY8OjROK9Ga03jC3
	 jaPvhVAGqN3ygS5O3GoEb95B7VWcJac6Eab7OVK/zL3DFrpN72z3c++8hfziK1nEQT
	 taYo90DLkfdnlWwzDCVtekg2SMbOdj18Ls6Hdydk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 388/690] NFSD: Fix strncpy() fortify warning
Date: Mon,  8 Apr 2024 14:54:14 +0200
Message-ID: <20240408125413.597667801@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 5304877936c0a67e1a01464d113bae4c81eacdb6 ]

In function ‘strncpy’,
    inlined from ‘nfsd4_ssc_setup_dul’ at /home/cel/src/linux/manet/fs/nfsd/nfs4proc.c:1392:3,
    inlined from ‘nfsd4_interssc_connect’ at /home/cel/src/linux/manet/fs/nfsd/nfs4proc.c:1489:11:
/home/cel/src/linux/manet/include/linux/fortify-string.h:52:33: warning: ‘__builtin_strncpy’ specified bound 63 equals destination size [-Wstringop-truncation]
   52 | #define __underlying_strncpy    __builtin_strncpy
      |                                 ^
/home/cel/src/linux/manet/include/linux/fortify-string.h:89:16: note: in expansion of macro ‘__underlying_strncpy’
   89 |         return __underlying_strncpy(p, q, size);
      |                ^~~~~~~~~~~~~~~~~~~~

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4proc.c      | 2 +-
 include/linux/nfs_ssc.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 15991eb9b8d8c..5dce18fe99085 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1392,7 +1392,7 @@ static __be32 nfsd4_ssc_setup_dul(struct nfsd_net *nn, char *ipaddr,
 		return 0;
 	}
 	if (work) {
-		strncpy(work->nsui_ipaddr, ipaddr, sizeof(work->nsui_ipaddr));
+		strlcpy(work->nsui_ipaddr, ipaddr, sizeof(work->nsui_ipaddr) - 1);
 		refcount_set(&work->nsui_refcnt, 2);
 		work->nsui_busy = true;
 		list_add_tail(&work->nsui_list, &nn->nfsd_ssc_mount_list);
diff --git a/include/linux/nfs_ssc.h b/include/linux/nfs_ssc.h
index 222ae8883e854..75843c00f326a 100644
--- a/include/linux/nfs_ssc.h
+++ b/include/linux/nfs_ssc.h
@@ -64,7 +64,7 @@ struct nfsd4_ssc_umount_item {
 	refcount_t nsui_refcnt;
 	unsigned long nsui_expire;
 	struct vfsmount *nsui_vfsmount;
-	char nsui_ipaddr[RPC_MAX_ADDRBUFLEN];
+	char nsui_ipaddr[RPC_MAX_ADDRBUFLEN + 1];
 };
 #endif
 
-- 
2.43.0



