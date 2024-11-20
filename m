Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AD91DFEF;
	Wed, 20 Nov 2024 12:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107393; cv=none; b=ukDEuc3Fftcvo2kMlY6LcQYlPC1fdvL7rPzKMpDVN+uf/PpuCpP5AeHRhkJRc6rxhl+TiPj7ppoy0f4rDP5a0y88Bdd6zQbupBNxwUFuqtkP21AIW7+lLj2xzuwgG40NtTAJ+thZvRdm/xkHUwLx2Id/vtnlVYQOhPn+S75Yq18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107393; c=relaxed/simple;
	bh=m6IC4S/OFmIC7Rv0cRxnR0hkSm7Pr15Ari4zJK3DIA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H267RYVTde9Nlk8sLgubh815E7+1IyraTI0529umlGzExzjlpsTmEfGmY+SCgv2JxY2aroFpp61yxPffNOLJMz5IHJr0ICH51xuo05IAJSSy70vDfWOyOo5MXeSdlGcfuHpDpnlmq9nfxgmOn4C0lwf2jBLbSfivnRzwDin9+yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r5WMpUJ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r5WMpUJ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF90C4CECD;
	Wed, 20 Nov 2024 12:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107393;
	bh=m6IC4S/OFmIC7Rv0cRxnR0hkSm7Pr15Ari4zJK3DIA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r5WMpUJ9T7Kv4KiiW81783A4AAzoYNo1013JOqBox8YhFFDOo6eZl0BZV5NkWOhtx
	 EGHGv/1c1/QlmJFxZyNaRTyN0Gz6x9n8H6yydJ4exuzadhXdKUd6Sshay2Hr5DmNH7
	 jpdkKtwKkAOrBxizyqr8S4PFAe4i4suV7N+cr+6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bc6bfc25a68b7a020ee1@syzkaller.appspotmail.com,
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 6.12 3/3] mm/mmap: fix __mmap_region() error handling in rare merge failure case
Date: Wed, 20 Nov 2024 13:55:57 +0100
Message-ID: <20241120124100.526989773@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120124100.444648273@linuxfoundation.org>
References: <20241120124100.444648273@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

The mmap_region() function tries to install a new vma, which requires a
pre-allocation for the maple tree write due to the complex locking
scenarios involved.

Recent efforts to simplify the error recovery required the relocation of
the preallocation of the maple tree nodes (via vma_iter_prealloc()
calling mas_preallocate()) higher in the function.

The relocation of the preallocation meant that, if there was a file
associated with the vma and the driver call (mmap_file()) modified the
vma flags, then a new merge of the new vma with existing vmas is
attempted.

During the attempt to merge the existing vma with the new vma, the vma
iterator is used - the same iterator that would be used for the next
write attempt to the tree.  In the event of needing a further allocation
and if the new allocations fails, the vma iterator (and contained maple
state) will cleaned up, including freeing all previous allocations and
will be reset internally.

Upon returning to the __mmap_region() function, the error is available
in the vma_merge_struct and can be used to detect the -ENOMEM status.

Hitting an -ENOMEM scenario after the driver callback leaves the system
in a state that undoing the mapping is worse than continuing by dipping
into the reserve.

A preallocation should be performed in the case of an -ENOMEM and the
allocations were lost during the failure scenario.  The __GFP_NOFAIL
flag is used in the allocation to ensure the allocation succeeds after
implicitly telling the driver that the mapping was happening.

The range is already set in the vma_iter_store() call below, so it is
not necessary and is dropped.

Reported-by: syzbot+bc6bfc25a68b7a020ee1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/x/log.txt?x=17b0ace8580000
Fixes: 5de195060b2e2 ("mm: resolve faulty mmap_region() error path behaviour")
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mmap.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1491,7 +1491,18 @@ static unsigned long __mmap_region(struc
 				vm_flags = vma->vm_flags;
 				goto file_expanded;
 			}
-			vma_iter_config(&vmi, addr, end);
+
+			/*
+			 * In the unlikely even that more memory was needed, but
+			 * not available for the vma merge, the vma iterator
+			 * will have no memory reserved for the write we told
+			 * the driver was happening.  To keep up the ruse,
+			 * ensure the allocation for the store succeeds.
+			 */
+			if (vmg_nomem(&vmg)) {
+				mas_preallocate(&vmi.mas, vma,
+						GFP_KERNEL|__GFP_NOFAIL);
+			}
 		}
 
 		vm_flags = vma->vm_flags;


