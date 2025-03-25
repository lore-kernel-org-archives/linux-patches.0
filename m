Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A58C41C85;
	Tue, 25 Mar 2025 12:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905710; cv=none; b=Gudif8RUJ+ddWAsx8+SXcXB6CdPehUPvK9JfVcMwxGTBYqXCjkIxXEf4cQtcqKdse3vNQGA3zMjU3PsOzoKkxEfJAGFmYPUSR/5YFZQVLtc8F5CdmwXk+d5OShnBi810oD8RcCxHT0jnLWT7TgqH/tYTFW+izpxEa77kJmgg8Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905710; c=relaxed/simple;
	bh=Jqc6opI6LDiyLBO4h9k1FZaGpgaHidFUPFkBP7zNJrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQzSxArvwrf6VnZGAgOR3ZTLtJlLXCQhlc8d5/FQ+Ht9c9bhcZpxta+LCT9uqOZKv1FhykdgJMdxAzbJXPD+j2KNE09vX62LXKYip4cKSZlQbvDUyN5QhglITklk5aC8iE5jkEDj5x6S7TZJ21hrwb6fi889DmqY+dGXPTmtkU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ny0L7bFl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ny0L7bFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB23C4CEE4;
	Tue, 25 Mar 2025 12:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905710;
	bh=Jqc6opI6LDiyLBO4h9k1FZaGpgaHidFUPFkBP7zNJrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ny0L7bFl4APmcjfn7uBzCNxUyuf5krTV/k2qBXnBk7mKXWLq5VkNufHyYac7XGaF7
	 vHTz7hJaaIJH775EhnLPUTf7GRqS8yuUQ/S67zX2afmOUmgzNX9hXPdgJllyvkrkJz
	 AzbJfxSLFQ0f9kGs1TpJZFO1TuBcjHQGRdBxil7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Lai <yi1.lai@intel.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Chen Linxuan <chenlinxuan@deepin.org>
Subject: [PATCH 6.1 122/198] lib/buildid: Handle memfd_secret() files in build_id_parse()
Date: Tue, 25 Mar 2025 08:21:24 -0400
Message-ID: <20250325122159.854576486@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

commit 5ac9b4e935dfc6af41eee2ddc21deb5c36507a9f upstream.

>From memfd_secret(2) manpage:

  The memory areas backing the file created with memfd_secret(2) are
  visible only to the processes that have access to the file descriptor.
  The memory region is removed from the kernel page tables and only the
  page tables of the processes holding the file descriptor map the
  corresponding physical memory. (Thus, the pages in the region can't be
  accessed by the kernel itself, so that, for example, pointers to the
  region can't be passed to system calls.)

We need to handle this special case gracefully in build ID fetching
code. Return -EFAULT whenever secretmem file is passed to build_id_parse()
family of APIs. Original report and repro can be found in [0].

  [0] https://lore.kernel.org/bpf/ZwyG8Uro%2FSyTXAni@ly-workstation/

Fixes: de3ec364c3c3 ("lib/buildid: add single folio-based file reader abstraction")
Reported-by: Yi Lai <yi1.lai@intel.com>
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Link: https://lore.kernel.org/bpf/20241017175431.6183-A-hca@linux.ibm.com
Link: https://lore.kernel.org/bpf/20241017174713.2157873-1-andrii@kernel.org
[ Chen Linxuan: backport same logic without folio-based changes ]
Fixes: 88a16a130933 ("perf: Add build id data in mmap2 event")
Signed-off-by: Chen Linxuan <chenlinxuan@deepin.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/buildid.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/lib/buildid.c
+++ b/lib/buildid.c
@@ -5,6 +5,7 @@
 #include <linux/elf.h>
 #include <linux/kernel.h>
 #include <linux/pagemap.h>
+#include <linux/secretmem.h>
 
 #define BUILD_ID 3
 
@@ -157,6 +158,10 @@ int build_id_parse(struct vm_area_struct
 	if (!vma->vm_file)
 		return -EINVAL;
 
+	/* reject secretmem folios created with memfd_secret() */
+	if (vma_is_secretmem(vma))
+		return -EFAULT;
+
 	page = find_get_page(vma->vm_file->f_mapping, 0);
 	if (!page)
 		return -EFAULT;	/* page not mapped */


