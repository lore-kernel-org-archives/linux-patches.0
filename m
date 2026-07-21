Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A678C3370EA;
	Tue, 21 Jul 2026 19:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663951; cv=none; b=ok53hChuM4smZ+64eIeC3yhLTiIx/73+PzR7Rgo6E5C0JcDnhVhJriJ88V1FDsYQPI6v9M0Feic8xCAIvgRtqJwlETlqSEZv0FafjwpD++cxm6hZCRy2SCKpDT+LuqYR61J2cb9x9g+98XnYjW0yASh19nxgoM31mf91d+8gk38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663951; c=relaxed/simple;
	bh=4hdWslS2CELtgWcTm8I2OM83JJVLk3wZ50P0SrPYIKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hp0SDgbFDg55VLeB9wHWz9Y03FRffEAsd+atlU9C2fb/vAfO54Xlw177M+93OCwosbj443QoCdeU8KLiKNE1/v/QASHai5aikmzvyKm31HWz81R8S+VM6UIOoIzo1FNeTQd9plfTnzALgDsMnu8bPb7oevEF3Klj4fwbNhfBdNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kp0b8xTM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kp0b8xTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1202B1F000E9;
	Tue, 21 Jul 2026 19:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663948;
	bh=jHvyLeKzXVZjc0qaf7mSm3JoS4W6UoYoAk91usa99x0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kp0b8xTMHnSRHR9X+fyE0y1a/SbagGFRc+EakJU9CDfxjATx8d8Qok3BzGoB/EdkJ
	 svE56bUJWmfdcjsGzNbu3TdfaSz4nnJlFhlXA/u2mqstySq/1P/5Z6MOl6S8XtUVvd
	 65D9jABw/CuQKu0b/8mP1+quu5Mi/X5RU1w43q6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fredric Cover <fredric.cover.lkernel@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 0973/1276] smb: client: use kvzalloc() for megabyte buffer in simple fallocate
Date: Tue, 21 Jul 2026 17:23:36 +0200
Message-ID: <20260721152507.792649555@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fredric Cover <fredric.cover.lkernel@gmail.com>

commit 806c00c23e3ce8eae397a40ced536ef88ae4e012 upstream.

Currently in smb3_simple_fallocate_range(), a 1 MB buffer is allocated
using kzalloc(). Under heavy memory fragmentation, a contiguous 1 MB block
of physical memory (an order-8 allocation) may not be available,
causing the allocation to fail.

This failure was observed during xfstests generic/013 on a 4GB RAM
test machine running fsstress:

fsstress: page allocation failure: order:8,
mode:0x40dc0(GFP_KERNEL|__GFP_ZERO|__GFP_COMP),
nodemask=(null),cpuset=/,mems_allowed=0

Call Trace:
 <TASK>
 dump_stack_lvl+0x5d/0x80
 warn_alloc+0x163/0x190
 __alloc_pages_slowpath.constprop.0+0x71b/0x12f0
 __alloc_frozen_pages_noprof+0x2f6/0x340
 alloc_pages_mpol+0xb6/0x170
 ___kmalloc_large_node+0xb3/0xd0
 __kmalloc_large_noprof+0x1e/0xc0
 smb3_simple_falloc.isra.0+0x62b/0x960
 cifs_fallocate+0xed/0x180
 vfs_fallocate+0x165/0x3c0
 __x64_sys_fallocate+0x48/0xa0
 do_syscall_64+0xe1/0x640
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
 </TASK>

Node 0 Normal: 3375*4kB ... 7*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB

Since this scratch buffer does not require physically contiguous memory,
switch the allocation to kvzalloc(). This retains the performance
benefits of kmalloc() under normal conditions, while gracefully falling
back to virtually contiguous memory when physical allocation fails.

Fixes: 966a3cb7c7db ("cifs: improve fallocate emulation")
Cc: stable@vger.kernel.org
Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
Tested-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3496,7 +3496,7 @@ static int smb3_simple_fallocate_range(u
 	if (rc)
 		goto out;
 
-	buf = kzalloc(1024 * 1024, GFP_KERNEL);
+	buf = kvzalloc(1024 * 1024, GFP_KERNEL);
 	if (buf == NULL) {
 		rc = -ENOMEM;
 		goto out;
@@ -3553,7 +3553,7 @@ static int smb3_simple_fallocate_range(u
 
  out:
 	kfree(out_data);
-	kfree(buf);
+	kvfree(buf);
 	return rc;
 }
 


