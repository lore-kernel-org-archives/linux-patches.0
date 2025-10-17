Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A50330B14;
	Fri, 17 Oct 2025 15:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715429; cv=none; b=en+8dCicuXBvdKP1L0DjIxp1Kza773ccMAIe3EYzVxXfT+w7ZlLcEh3sFOEp+io8VXNo9uB1Krcc/VPjZlidzQvEOtW2bLHkwvvnAKt2rgolbZ6SP0ZiIVYhBUfGcJuWSk6v5rsgr8MHTWyTX+FLJ1owwxWh4oki9hUJy8ARi9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715429; c=relaxed/simple;
	bh=1L0BwS4GE9ed+s6SKgkwUPiVlLVy8hNtzVFIomOCM5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWV+ctGsi5NPu10zZ7UYARKXubHEE+VGfJGAGdI3zP05SYNo4giblKftFRFSzpYl7UBX1uLqJK2MfoWR7Hk94AArdbFhvZbNwXdrJtLcTTau1NuO8C6OMS0s86ToGpCXj/JSHXnzxCTnG9oFMzNA1TqWal5rl080r72JE91tV6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZAf2xFoL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZAf2xFoL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21318C4CEE7;
	Fri, 17 Oct 2025 15:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715429;
	bh=1L0BwS4GE9ed+s6SKgkwUPiVlLVy8hNtzVFIomOCM5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZAf2xFoLd7juoJR6xwVlpG/URZoz7yedGpzZvH8f9ZqsqbUzabAD3Swu8b9SSiaYo
	 reN38qDooTMyozSuv44IdyeobAPRcSEKbGgfJfxBq204C3Q0+POjsSEqqDANJxsBCx
	 QmJilFnYbZLpnXuxJkPC3nHnQ4TUbg6xmhJz3FPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 214/371] fsnotify: pass correct offset to fsnotify_mmap_perm()
Date: Fri, 17 Oct 2025 16:53:09 +0200
Message-ID: <20251017145209.828417524@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Roberts <ryan.roberts@arm.com>

commit 28bba2c2935e219d6cb6946e16b9a0b7c47913be upstream.

fsnotify_mmap_perm() requires a byte offset for the file about to be
mmap'ed.  But it is called from vm_mmap_pgoff(), which has a page offset.
Previously the conversion was done incorrectly so let's fix it, being
careful not to overflow on 32-bit platforms.

Discovered during code review.

Link: https://lkml.kernel.org/r/20251003155238.2147410-1-ryan.roberts@arm.com
Fixes: 066e053fe208 ("fsnotify: add pre-content hooks on mmap()")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Kiryl Shutsemau <kas@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/util.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/util.c b/mm/util.c
index 6c1d64ed0221..8989d5767528 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -566,6 +566,7 @@ unsigned long vm_mmap_pgoff(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long prot,
 	unsigned long flag, unsigned long pgoff)
 {
+	loff_t off = (loff_t)pgoff << PAGE_SHIFT;
 	unsigned long ret;
 	struct mm_struct *mm = current->mm;
 	unsigned long populate;
@@ -573,7 +574,7 @@ unsigned long vm_mmap_pgoff(struct file *file, unsigned long addr,
 
 	ret = security_mmap_file(file, prot, flag);
 	if (!ret)
-		ret = fsnotify_mmap_perm(file, prot, pgoff >> PAGE_SHIFT, len);
+		ret = fsnotify_mmap_perm(file, prot, off, len);
 	if (!ret) {
 		if (mmap_write_lock_killable(mm))
 			return -EINTR;
-- 
2.51.0



