Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6785043E066;
	Tue, 21 Jul 2026 20:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667448; cv=none; b=oG5i1m9b1041NcBtlgHeQthOC50uMlbxKC2xk2ruXh2fRwSa0xsykBMo4lubOmSnQ9jvQX02/p+ElHO5yUe0LTZtMqIRvtQ/JNcTdKhShSODnHK4iZ8m3UGYVnURJGv/vNING3V5P97Y+wJ/5j0YOrSoZ9rq2zLIu9tfXzbfU2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667448; c=relaxed/simple;
	bh=m7DfH8+2j8plkeq5O0Y2YVwSxXqwI9XNDwo95u/6g7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjasDTXhxweikeC8cFZxuCKMDNlH1Gt3/cwsyz3eLK6GqlQnRS9+raKbdy3xjfpCAj3DKI3gZnqKJU8/YUn7HQvWM4KZ3IsPEV8z/2ltlR3KNZ+lpZBfbLHT2c9+Rg8FOxvla4v/xFM7ZTCo/7ru3sas3fLiHN/emA5Qf/WVS+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y1K0DIkD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y1K0DIkD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DAEF1F00A3D;
	Tue, 21 Jul 2026 20:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667445;
	bh=BwEwTm/1a6JzPl5/9aOEKUHrvzlajd760biCAiaOhDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y1K0DIkDzOYeXl7FJaDBeOaFQLtmJPe79XRDDFnmG55m6iLfqjgSRpINIrGheQAYQ
	 Hpu2KHSPeSIP1qz8rTpTAypBvALIbPTzXObHRsvaztRGmdWsT5nXbEvTGn3Wv5RPKa
	 q9Le8YQ1fv9o2Ed+8kyvgBrC4Y2alutlL8rAAnfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fredric Cover <fredric.cover.lkernel@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 1021/1266] smb: client: use kvzalloc() for megabyte buffer in simple fallocate
Date: Tue, 21 Jul 2026 17:24:18 +0200
Message-ID: <20260721152504.674793761@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3431,7 +3431,7 @@ static int smb3_simple_fallocate_range(u
 	if (rc)
 		goto out;
 
-	buf = kzalloc(1024 * 1024, GFP_KERNEL);
+	buf = kvzalloc(1024 * 1024, GFP_KERNEL);
 	if (buf == NULL) {
 		rc = -ENOMEM;
 		goto out;
@@ -3488,7 +3488,7 @@ static int smb3_simple_fallocate_range(u
 
  out:
 	kfree(out_data);
-	kfree(buf);
+	kvfree(buf);
 	return rc;
 }
 


