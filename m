Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A13B13C660;
	Thu, 13 Jun 2024 12:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280285; cv=none; b=G+HNHr6K77+DugTUP/tbCj9/qIS0cLMj76dTZaQ4W0VBozaWI0KSEGlJjA6pDF6VlXB8hBLoedX7DGO1HaEfkz9aZjltYeUZ/9DhmuOltBV7iblVcrA0Hyyt67Gcnlb3X5P7Q+7l5MMIK0AzqSSPXOkg7h9GYuCoOVKPZMZqpbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280285; c=relaxed/simple;
	bh=Db/CbTG4uvisEV1tR2H+TcxGs+JDzEZtBS6ZhSiZ6bY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UtcRQzo3bkx6OfJ6JrrXH5pyJDnTfsw1E3BrqkFSlmzw53QdGL+TsSYdBuDRExtK1nXqZh1s8bEmYeu4GYZzXRk1yI00Z4iyMprjlUnwh4aboBvhD0pCAsNMvjAPTo54bWL5UjVORBP98gmxDcQIFkr3Sf2SdyhsBzJgSI3bu5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oe3BkYNI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oe3BkYNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874D3C2BBFC;
	Thu, 13 Jun 2024 12:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280284;
	bh=Db/CbTG4uvisEV1tR2H+TcxGs+JDzEZtBS6ZhSiZ6bY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oe3BkYNIusBo31HSA4nESxpau+w826gGsj6wPYzh5G7IDktn4ZX0pt9W2eb3zAKC/
	 8Ldry0hzfl6WoCj5lhbbNaPOK5+wLrWLkOoWOL85ouJvXK6NvmyEhp/yf/Cj9Ox6Gh
	 qrxohvc9IGcuy+WWxROdh2EIDb0Ru48uvZ9e5yYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	syzbot+ff14db38f56329ef68df@syzkaller.appspotmail.com
Subject: [PATCH 5.4 189/202] net/9p: fix uninit-value in p9_client_rpc()
Date: Thu, 13 Jun 2024 13:34:47 +0200
Message-ID: <20240613113235.034416277@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

commit 25460d6f39024cc3b8241b14c7ccf0d6f11a736a upstream.

Syzbot with the help of KMSAN reported the following error:

BUG: KMSAN: uninit-value in trace_9p_client_res include/trace/events/9p.h:146 [inline]
BUG: KMSAN: uninit-value in p9_client_rpc+0x1314/0x1340 net/9p/client.c:754
 trace_9p_client_res include/trace/events/9p.h:146 [inline]
 p9_client_rpc+0x1314/0x1340 net/9p/client.c:754
 p9_client_create+0x1551/0x1ff0 net/9p/client.c:1031
 v9fs_session_init+0x1b9/0x28e0 fs/9p/v9fs.c:410
 v9fs_mount+0xe2/0x12b0 fs/9p/vfs_super.c:122
 legacy_get_tree+0x114/0x290 fs/fs_context.c:662
 vfs_get_tree+0xa7/0x570 fs/super.c:1797
 do_new_mount+0x71f/0x15e0 fs/namespace.c:3352
 path_mount+0x742/0x1f20 fs/namespace.c:3679
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount+0x725/0x810 fs/namespace.c:3875
 __x64_sys_mount+0xe4/0x150 fs/namespace.c:3875
 do_syscall_64+0xd5/0x1f0
 entry_SYSCALL_64_after_hwframe+0x6d/0x75

Uninit was created at:
 __alloc_pages+0x9d6/0xe70 mm/page_alloc.c:4598
 __alloc_pages_node include/linux/gfp.h:238 [inline]
 alloc_pages_node include/linux/gfp.h:261 [inline]
 alloc_slab_page mm/slub.c:2175 [inline]
 allocate_slab mm/slub.c:2338 [inline]
 new_slab+0x2de/0x1400 mm/slub.c:2391
 ___slab_alloc+0x1184/0x33d0 mm/slub.c:3525
 __slab_alloc mm/slub.c:3610 [inline]
 __slab_alloc_node mm/slub.c:3663 [inline]
 slab_alloc_node mm/slub.c:3835 [inline]
 kmem_cache_alloc+0x6d3/0xbe0 mm/slub.c:3852
 p9_tag_alloc net/9p/client.c:278 [inline]
 p9_client_prepare_req+0x20a/0x1770 net/9p/client.c:641
 p9_client_rpc+0x27e/0x1340 net/9p/client.c:688
 p9_client_create+0x1551/0x1ff0 net/9p/client.c:1031
 v9fs_session_init+0x1b9/0x28e0 fs/9p/v9fs.c:410
 v9fs_mount+0xe2/0x12b0 fs/9p/vfs_super.c:122
 legacy_get_tree+0x114/0x290 fs/fs_context.c:662
 vfs_get_tree+0xa7/0x570 fs/super.c:1797
 do_new_mount+0x71f/0x15e0 fs/namespace.c:3352
 path_mount+0x742/0x1f20 fs/namespace.c:3679
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount+0x725/0x810 fs/namespace.c:3875
 __x64_sys_mount+0xe4/0x150 fs/namespace.c:3875
 do_syscall_64+0xd5/0x1f0
 entry_SYSCALL_64_after_hwframe+0x6d/0x75

If p9_check_errors() fails early in p9_client_rpc(), req->rc.tag
will not be properly initialized. However, trace_9p_client_res()
ends up trying to print it out anyway before p9_client_rpc()
finishes.

Fix this issue by assigning default values to p9_fcall fields
such as 'tag' and (just in case KMSAN unearths something new) 'id'
during the tag allocation stage.

Reported-and-tested-by: syzbot+ff14db38f56329ef68df@syzkaller.appspotmail.com
Fixes: 348b59012e5c ("net/9p: Convert net/9p protocol dumps to tracepoints")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Cc: stable@vger.kernel.org
Message-ID: <20240408141039.30428-1-n.zhandarovich@fintech.ru>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/9p/client.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -235,6 +235,8 @@ static int p9_fcall_init(struct p9_clien
 	if (!fc->sdata)
 		return -ENOMEM;
 	fc->capacity = alloc_msize;
+	fc->id = 0;
+	fc->tag = P9_NOTAG;
 	return 0;
 }
 


