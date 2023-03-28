Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3188BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5468C433D2;
	Tue, 28 Mar 2023 15:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015942;
	bh=2do8PrF2cN1I2smgIzvvf5xkFz8VjuNjvUXB3mZuE94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S6SKHZm5nbMiM5PSvnvmN2QA16haLHFqQwmXNGr/sZxTU7pMpAPzRAUIcVHoJVsr2
	 JAuUkPhh/mnPLayvBs68icJujWI3KyZmdZiweVgnYCHc9WlGOipsx+UwnmVBsFlF+J
	 YJHBnyyamvrue1KOzEi2QlYouBRwvAF5O5C2IU7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Pengfei Xu <pengfei.xu@intel.com>,
	syzbot+2ee18845e89ae76342c5@syzkaller.appspotmail.com,
	David Hildenbrand <david@redhat.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	heng.su@intel.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 213/224] mm/ksm: fix race with VMA iteration and mm_struct teardown
Date: Tue, 28 Mar 2023 16:43:29 +0200
Message-Id: <20230328142626.215642889@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liam R. Howlett <Liam.Howlett@oracle.com>

commit 6db504ce55bdbc575723938fc480713c9183f6a2 upstream.

exit_mmap() will tear down the VMAs and maple tree with the mmap_lock held
in write mode.  Ensure that the maple tree is still valid by checking
ksm_test_exit() after taking the mmap_lock in read mode, but before the
for_each_vma() iterator dereferences a destroyed maple tree.

Since the maple tree is destroyed, the flags telling lockdep to check an
external lock has been cleared.  Skip the for_each_vma() iterator to avoid
dereferencing a maple tree without the external lock flag, which would
create a lockdep warning.

Link: https://lkml.kernel.org/r/20230308220310.3119196-1-Liam.Howlett@oracle.com
Fixes: a5f18ba07276 ("mm/ksm: use vma iterators instead of vma linked list")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
  Link: https://lore.kernel.org/lkml/ZAdUUhSbaa6fHS36@xpf.sh.intel.com/
Reported-by: syzbot+2ee18845e89ae76342c5@syzkaller.appspotmail.com
  Link: https://syzkaller.appspot.com/bug?id=64a3e95957cd3deab99df7cd7b5a9475af92c93e
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <heng.su@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/ksm.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -960,9 +960,15 @@ static int unmerge_and_remove_all_rmap_i
 
 		mm = mm_slot->slot.mm;
 		mmap_read_lock(mm);
+
+		/*
+		 * Exit right away if mm is exiting to avoid lockdep issue in
+		 * the maple tree
+		 */
+		if (ksm_test_exit(mm))
+			goto mm_exiting;
+
 		for_each_vma(vmi, vma) {
-			if (ksm_test_exit(mm))
-				break;
 			if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
 				continue;
 			err = unmerge_ksm_pages(vma,
@@ -971,6 +977,7 @@ static int unmerge_and_remove_all_rmap_i
 				goto error;
 		}
 
+mm_exiting:
 		remove_trailing_rmap_items(&mm_slot->rmap_list);
 		mmap_read_unlock(mm);
 


