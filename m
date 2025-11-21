Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AEC2FC01B;
	Fri, 21 Nov 2025 13:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733583; cv=none; b=C2n0UrQEFFMBK4tkQjtph5D/CF8BnT8aTJ0XZ2Ogk9jgUE2xyI6CeYFZvlIp7zQHQESPSAbyp7GgpxoCUFFt/8GKcPS3ztfxdg5168R3tyZnWz0Xcd68mPPnEtoyAcHiqNtDmaZBiR9nxrw+DI73R63OSfcPAjL6tDRvXx868Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733583; c=relaxed/simple;
	bh=ApZmMtLUeJAaPaX0ywX+8PGJeEfkkEwlmrB0wskXWJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZaSf1wfORR/63dDqhQdahME+Xhw6/Qyne1qh8Pj9CQQQIKnjNSupxYEAjd/y60n4DuIzp/eb1vJLzR67yaGabZh7+UtUhwzX+jQ7Atvs+a3K0PdbFqkhbG8Wk+4l/mdfgXAwcwYSYyqBOqdqs+BX40SjusfVMMcIVdwg3pCrfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qPa2h1nv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qPa2h1nv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33DA4C4CEF1;
	Fri, 21 Nov 2025 13:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733583;
	bh=ApZmMtLUeJAaPaX0ywX+8PGJeEfkkEwlmrB0wskXWJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qPa2h1nvHsCV+cBXsDKUgPd6lyWDFCFXa5TP2dB8YilcQh/6oAE3NYxATnq7shg1V
	 szcV04+2nEIu7Y7g1q4ZAS9EG9afMtZNXcrqM6y/9piFsTTn/mUh38LXcWAtSqFnr4
	 1CTpF5yrRAkpmr4qNtGwtErWCnC/s+fb8+xURw14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Pankaj Raghav <p.raghav@samsung.com>,
	David Howells <dhowells@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Daniel Gomez <da.gomez@samsung.com>,
	Dave Chinner <dchinner@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCH 6.6 518/529] filemap: cap PTE range to be created to allowed zero fill in folio_map_range()
Date: Fri, 21 Nov 2025 14:13:37 +0100
Message-ID: <20251121130249.475995161@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Pankaj Raghav <p.raghav@samsung.com>

commit 743a2753a02e805347969f6f89f38b736850d808 upstream.

Usually the page cache does not extend beyond the size of the inode,
therefore, no PTEs are created for folios that extend beyond the size.

But with LBS support, we might extend page cache beyond the size of the
inode as we need to guarantee folios of minimum order. While doing a
read, do_fault_around() can create PTEs for pages that lie beyond the
EOF leading to incorrect error return when accessing a page beyond the
mapped file.

Cap the PTE range to be created for the page cache up to the end of
file(EOF) in filemap_map_pages() so that return error codes are consistent
with POSIX[1] for LBS configurations.

generic/749 has been created to trigger this edge case. This also fixes
generic/749 for tmpfs with huge=always on systems with 4k base page size.

[1](from mmap(2))  SIGBUS
    Attempted access to a page of the buffer that lies beyond the end
    of the mapped file.  For an explanation of the treatment  of  the
    bytes  in  the  page that corresponds to the end of a mapped file
    that is not a multiple of the page size, see NOTES.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Link: https://lore.kernel.org/r/20240822135018.1931258-6-kernel@pankajraghav.com
Tested-by: David Howells <dhowells@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Daniel Gomez <da.gomez@samsung.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3608,7 +3608,7 @@ vm_fault_t filemap_map_pages(struct vm_f
 	struct vm_area_struct *vma = vmf->vma;
 	struct file *file = vma->vm_file;
 	struct address_space *mapping = file->f_mapping;
-	pgoff_t last_pgoff = start_pgoff;
+	pgoff_t file_end, last_pgoff = start_pgoff;
 	unsigned long addr;
 	XA_STATE(xas, &mapping->i_pages, start_pgoff);
 	struct folio *folio;
@@ -3632,6 +3632,11 @@ vm_fault_t filemap_map_pages(struct vm_f
 		folio_put(folio);
 		goto out;
 	}
+
+	file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE) - 1;
+	if (end_pgoff > file_end)
+		end_pgoff = file_end;
+
 	do {
 		unsigned long end;
 


