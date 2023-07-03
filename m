Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95FC8101C3
	for <patches@lists.linux.dev>; Mon,  3 Jul 2023 18:55:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F329C433C9;
	Mon,  3 Jul 2023 18:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688410557;
	bh=wYSjGEMIyPxXVmcKPuiGgH32hSsulLKvxpDYjjFy2fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RatOhX6eBz4mKauIoWAOm/rhD018j1ogEkxwdwXntLRHHlXpnMOr9giPOTT8Rvz87
	 ikS8ZUBeTd5/qhQpKlZRFMcnhRcN/OWb7bWGgCEvfgrZVpaeUSgb9Oe2b6FKMr271N
	 Pua8iykJbKZfaBS3PJeuCFzMKMSKU2Y3Hx1fGkmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Filippov <jcmvbkbc@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.3 01/13] xtensa: fix lock_mm_and_find_vma in case VMA not found
Date: Mon,  3 Jul 2023 20:54:11 +0200
Message-ID: <20230703184519.247164312@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230703184519.206275653@linuxfoundation.org>
References: <20230703184519.206275653@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Max Filippov <jcmvbkbc@gmail.com>

commit 03f889378f33aa9a9d8e5f49ba94134cf6158090 upstream.

MMU version of lock_mm_and_find_vma releases the mm lock before
returning when VMA is not found. Do the same in noMMU version.
This fixes hang on an attempt to handle protection fault.

Fixes: d85a143b69ab ("xtensa: fix NOMMU build with lock_mm_and_find_vma() conversion")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/nommu.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -637,8 +637,13 @@ EXPORT_SYMBOL(find_vma);
 struct vm_area_struct *lock_mm_and_find_vma(struct mm_struct *mm,
 			unsigned long addr, struct pt_regs *regs)
 {
+	struct vm_area_struct *vma;
+
 	mmap_read_lock(mm);
-	return vma_lookup(mm, addr);
+	vma = vma_lookup(mm, addr);
+	if (!vma)
+		mmap_read_unlock(mm);
+	return vma;
 }
 
 /*


