Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC96E522D
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D889C433C8;
	Sun,  9 Jul 2023 11:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901275;
	bh=UjjBGhzKOxEVuuaGuLBSd+9oLMENGkyHQzkPSfEKTso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VkudsO6YSH5oY98Y5ggs2OpxIdxc4Bb3/1Nkw4Cp0u2Mb6oyUWkATIRlBXAgaFcBu
	 l5lbQ4qrfALbsjFZt/xjMd26BLPVwEfSo/7yfgPQv5DyEe1CbXtA/m52iXBGxOcnQe
	 ssGjfwefgT94LaifPKHgYnEGUjESarBfR+Q9QxZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugh Dickins <hughd@google.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.4 4/8] mm: lock newly mapped VMA with corrected ordering
Date: Sun,  9 Jul 2023 13:14:10 +0200
Message-ID: <20230709111345.430583721@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111345.297026264@linuxfoundation.org>
References: <20230709111345.297026264@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hugh Dickins <hughd@google.com>

commit 1c7873e3364570ec89343ff4877e0f27a7b21a61 upstream.

Lockdep is certainly right to complain about

  (&vma->vm_lock->lock){++++}-{3:3}, at: vma_start_write+0x2d/0x3f
                 but task is already holding lock:
  (&mapping->i_mmap_rwsem){+.+.}-{3:3}, at: mmap_region+0x4dc/0x6db

Invert those to the usual ordering.

Fixes: 33313a747e81 ("mm: lock newly mapped VMA which can be modified after it becomes visible")
Cc: stable@vger.kernel.org
Signed-off-by: Hugh Dickins <hughd@google.com>
Tested-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2801,11 +2801,11 @@ cannot_expand:
 	if (vma_iter_prealloc(&vmi))
 		goto close_and_free_vma;
 
+	/* Lock the VMA since it is modified after insertion into VMA tree */
+	vma_start_write(vma);
 	if (vma->vm_file)
 		i_mmap_lock_write(vma->vm_file->f_mapping);
 
-	/* Lock the VMA since it is modified after insertion into VMA tree */
-	vma_start_write(vma);
 	vma_iter_store(&vmi, vma);
 	mm->map_count++;
 	if (vma->vm_file) {


