Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9538D1C86F6;
	Tue, 27 Aug 2024 15:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770919; cv=none; b=sP9FtK34KI5utss61gWDeasmJJBgs632S5R1TIa1VQrW2OMW16P4Fhnk1dXFNZJGR6BMll94FWwIS9o5hwHrh5CsWA4L05VsDIqKM5GE3K+F7lTJeF+hT3odnuz7mz1w30UEtSPp+OQs2nOp+GeSz1XBLijwGXG/wmDTANIpWFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770919; c=relaxed/simple;
	bh=3Z+pxQIc8l+WCEucUkd4Rukpr2VOTUn9gba6GtG+UCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TW1OPU9xTMRfHHqBLVImrVwkKlV6z2J155VxKvhd46quDtZdNVj382j+p9fY97EIg7ykjILtBTOQn9yR23muYvKiulpbnev/mtTc0bTLglL1/w0EubVs3voPcJqsE+5EyZ2JlNf/wvHSjvfsX5B0TweRwiWEQzACaURX7jGu99M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=knAU7BXe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="knAU7BXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD9EC4DDF4;
	Tue, 27 Aug 2024 15:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770919;
	bh=3Z+pxQIc8l+WCEucUkd4Rukpr2VOTUn9gba6GtG+UCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=knAU7BXebnLOjP98jUheDbYSkzU3dY3Fcm3rwhm0gVGyjuVs0euQzmJcmH61Vs74u
	 H1pNBdLpORXoWjsq9YDJT4wjOAmeEVpC3sda5GyEnzR53NytjKhHMniRlT/0DSSEHT
	 lOK4frP4rQaSbn88NAPI5MYA7O9jzoLljTcpuub4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Reisner <reisner.marc@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.10 008/273] selinux: revert our use of vma_is_initial_heap()
Date: Tue, 27 Aug 2024 16:35:32 +0200
Message-ID: <20240827143833.699427407@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Moore <paul@paul-moore.com>

commit 05a3d6e9307250a5911d75308e4363466794ab21 upstream.

Unfortunately it appears that vma_is_initial_heap() is currently broken
for applications that do not currently have any heap allocated, e.g.
brk == start_brk.  The breakage is such that it will cause SELinux to
check for the process/execheap permission on memory regions that cross
brk/start_brk even when there is no heap.

The proper fix would be to correct vma_is_initial_heap(), but as there
are multiple callers I am hesitant to unilaterally modify the helper
out of concern that I would end up breaking some other subsystem.  The
mm developers have been made aware of the situation and hopefully they
will have a fix at some point in the future, but we need a fix soon so
we are simply going to revert our use of vma_is_initial_heap() in favor
of our old logic/code which works as expected, even in the face of a
zero size heap.  We can return to using vma_is_initial_heap() at some
point in the future when it is fixed.

Cc: stable@vger.kernel.org
Reported-by: Marc Reisner <reisner.marc@gmail.com>
Closes: https://lore.kernel.org/all/ZrPmoLKJEf1wiFmM@marcreisner.com
Fixes: 68df1baf158f ("selinux: use vma_is_initial_stack() and vma_is_initial_heap()")
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/hooks.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3852,7 +3852,17 @@ static int selinux_file_mprotect(struct
 	if (default_noexec &&
 	    (prot & PROT_EXEC) && !(vma->vm_flags & VM_EXEC)) {
 		int rc = 0;
-		if (vma_is_initial_heap(vma)) {
+		/*
+		 * We don't use the vma_is_initial_heap() helper as it has
+		 * a history of problems and is currently broken on systems
+		 * where there is no heap, e.g. brk == start_brk.  Before
+		 * replacing the conditional below with vma_is_initial_heap(),
+		 * or something similar, please ensure that the logic is the
+		 * same as what we have below or you have tested every possible
+		 * corner case you can think to test.
+		 */
+		if (vma->vm_start >= vma->vm_mm->start_brk &&
+		    vma->vm_end <= vma->vm_mm->brk) {
 			rc = avc_has_perm(sid, sid, SECCLASS_PROCESS,
 					  PROCESS__EXECHEAP, NULL);
 		} else if (!vma->vm_file && (vma_is_initial_stack(vma) ||


