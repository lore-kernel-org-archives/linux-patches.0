Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959182343C9;
	Mon, 10 Mar 2025 18:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630568; cv=none; b=BkaU/Tp9OF8xgEnabq68GcJGbne2SGH01ML8ZkOMPlH8voVuKlXsLZ9jjF0FH2xJsxhyA2iBxzcntDH4eTqN7YcoD3uXxB2ntq01y7xCLHxvYrJAtOablpZp1lsWwNv0pvXsPJtN1Im9UfyQA9ZBRF+VtEsIpiVlENaXTrHF8PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630568; c=relaxed/simple;
	bh=jmBeYx0R4qrM4W2uUo5qkSgJJHEyN12y91TOoxsOA5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m31Mg3G8s2v8SvTyzHYwLg6iiP3wo2H+Ck5VNv8F7iLCFC/BY7HA02+i5UMb5bin94hR0LoTz3EqpyEO5WoEMUvtgfdIDCUTLpjiu3VNQ6qIamKwKtjPAQLVV7gBJGFL4wwr/axiCie1dyybkKqn2WClKKuB8Gdf57Mn4kpEznA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ylIXiWto; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ylIXiWto"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236EAC4CEE5;
	Mon, 10 Mar 2025 18:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630568;
	bh=jmBeYx0R4qrM4W2uUo5qkSgJJHEyN12y91TOoxsOA5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ylIXiWtoLEgskxAkB3VQlLcQ1YaCCq5hu81fYhdE+ALhhzIiSWbUrevoMzwAtVvVY
	 hFNAfZoPcJAuzZ6ON5l50XoeozWuSZ1O0Rh9wNi4WKqoATmt4G6XMbe8173cltqYUn
	 SRYoqj4JEq8dztVxMBIasiXEONaFtliE0m0BS9jA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: [PATCH 5.15 418/620] nilfs2: protect access to buffers with no active references
Date: Mon, 10 Mar 2025 18:04:24 +0100
Message-ID: <20250310170602.088905285@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 367a9bffabe08c04f6d725032cce3d891b2b9e1a upstream.

nilfs_lookup_dirty_data_buffers(), which iterates through the buffers
attached to dirty data folios/pages, accesses the attached buffers without
locking the folios/pages.

For data cache, nilfs_clear_folio_dirty() may be called asynchronously
when the file system degenerates to read only, so
nilfs_lookup_dirty_data_buffers() still has the potential to cause use
after free issues when buffers lose the protection of their dirty state
midway due to this asynchronous clearing and are unintentionally freed by
try_to_free_buffers().

Eliminate this race issue by adjusting the lock section in this function.

[konishi.ryusuke@gmail.com: adjusted for page/folio conversion]
Link: https://lkml.kernel.org/r/20250107200202.6432-3-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Fixes: 8c26c4e2694a ("nilfs2: fix issue with flush kernel thread after remount in RO mode because of driver's internal error or metadata corruption")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/segment.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -732,7 +732,6 @@ static size_t nilfs_lookup_dirty_data_bu
 		}
 		if (!page_has_buffers(page))
 			create_empty_buffers(page, i_blocksize(inode), 0);
-		unlock_page(page);
 
 		bh = head = page_buffers(page);
 		do {
@@ -742,11 +741,14 @@ static size_t nilfs_lookup_dirty_data_bu
 			list_add_tail(&bh->b_assoc_buffers, listp);
 			ndirties++;
 			if (unlikely(ndirties >= nlimit)) {
+				unlock_page(page);
 				pagevec_release(&pvec);
 				cond_resched();
 				return ndirties;
 			}
 		} while (bh = bh->b_this_page, bh != head);
+
+		unlock_page(page);
 	}
 	pagevec_release(&pvec);
 	cond_resched();


