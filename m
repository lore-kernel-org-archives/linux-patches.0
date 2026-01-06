Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D47936CDFA;
	Tue,  6 Jan 2026 17:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722315; cv=none; b=V66fFG27GXejw7fksGfmsz2GUNZieptsDbNdUieARFqQfhnq/gQ+qIziD8a3dAJG6GB/TuiqEI2WEm9jCmaBDYryTEduKd9CXfDgSw08zTWQvjbwX1BuLbYZ+X4x67BTYHsOFAlJlOBoh+5BRSz41cYBPx56ByqxHvwzZOalGgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722315; c=relaxed/simple;
	bh=6LR1GE3IvUz4iB1EwrPzXDrRi1/sH4HN8ygkr/tmYYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYmE3DKdwgbPQ3PROQjrQNDJPoubw7AQIx2YOZDN/uRnXDrc7tEltxQC25DdrskVW0B1KuGMZcc1YWCz04vGTijtZrRnSGxRJV4+V1kkOp7TVstLJnsfHtMLELQRDDRLmvgPCw79YNrsX4HzEANxRM/FhAU+A7OtQ4eprRl+Y3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AI+m/kfG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AI+m/kfG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85AB1C16AAE;
	Tue,  6 Jan 2026 17:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722315;
	bh=6LR1GE3IvUz4iB1EwrPzXDrRi1/sH4HN8ygkr/tmYYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AI+m/kfGy1pHyc0NWsmGr967kouMb1ncYcdT1n6tJB9sbbDxl/WUKEnMl2qVCwt0p
	 147oOrBpwyqR0jLG6y6NizAL7oAvZKoZcaW80iykHV5A/Qsn3DIMBJQ5nPzgYCfVdK
	 KbsyKm59cz3DYTPnnJr8nF3rAoLDEXIDRlpB6Azk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pingfan Liu <piliu@redhat.com>,
	Baoquan He <bhe@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Steven Chen <chenste@linux.microsoft.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 226/312] kernel/kexec: fix IMA when allocation happens in CMA area
Date: Tue,  6 Jan 2026 18:05:00 +0100
Message-ID: <20260106170556.029162043@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Pingfan Liu <piliu@redhat.com>

commit a3785ae5d334bb71d47a593d54c686a03fb9d136 upstream.

*** Bug description ***

When I tested kexec with the latest kernel, I ran into the following warning:

[   40.712410] ------------[ cut here ]------------
[   40.712576] WARNING: CPU: 2 PID: 1562 at kernel/kexec_core.c:1001 kimage_map_segment+0x144/0x198
[...]
[   40.816047] Call trace:
[   40.818498]  kimage_map_segment+0x144/0x198 (P)
[   40.823221]  ima_kexec_post_load+0x58/0xc0
[   40.827246]  __do_sys_kexec_file_load+0x29c/0x368
[...]
[   40.855423] ---[ end trace 0000000000000000 ]---

*** How to reproduce ***

This bug is only triggered when the kexec target address is allocated in
the CMA area. If no CMA area is reserved in the kernel, use the "cma="
option in the kernel command line to reserve one.

*** Root cause ***
The commit 07d24902977e ("kexec: enable CMA based contiguous
allocation") allocates the kexec target address directly on the CMA area
to avoid copying during the jump. In this case, there is no IND_SOURCE
for the kexec segment.  But the current implementation of
kimage_map_segment() assumes that IND_SOURCE pages exist and map them
into a contiguous virtual address by vmap().

*** Solution ***
If IMA segment is allocated in the CMA area, use its page_address()
directly.

Link: https://lkml.kernel.org/r/20251216014852.8737-2-piliu@redhat.com
Fixes: 07d24902977e ("kexec: enable CMA based contiguous allocation")
Signed-off-by: Pingfan Liu <piliu@redhat.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Steven Chen <chenste@linux.microsoft.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: Roberto Sassu <roberto.sassu@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kexec_core.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -967,13 +967,17 @@ void *kimage_map_segment(struct kimage *
 	kimage_entry_t *ptr, entry;
 	struct page **src_pages;
 	unsigned int npages;
+	struct page *cma;
 	void *vaddr = NULL;
 	int i;
 
+	cma = image->segment_cma[idx];
+	if (cma)
+		return page_address(cma);
+
 	addr = image->segment[idx].mem;
 	size = image->segment[idx].memsz;
 	eaddr = addr + size;
-
 	/*
 	 * Collect the source pages and map them in a contiguous VA range.
 	 */
@@ -1014,7 +1018,8 @@ void *kimage_map_segment(struct kimage *
 
 void kimage_unmap_segment(void *segment_buffer)
 {
-	vunmap(segment_buffer);
+	if (is_vmalloc_addr(segment_buffer))
+		vunmap(segment_buffer);
 }
 
 struct kexec_load_limit {


