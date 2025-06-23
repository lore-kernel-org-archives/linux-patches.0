Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4209D1AD3FA;
	Mon, 23 Jun 2025 21:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715624; cv=none; b=dY14R1lV+k/ajL2OZwctr+dh8cSJWEYuzZusf0e23cjIzyor4UwtBVPAAF9FAnBjFQdZnU4ctHajQX4Qs2FVcb7nEfy0XP11pWfC9DZDGSrhaUQuWzdqbZtyy0jj9++UM3nJBo9z49qWQ1Te+KKsLEyIw9v2MajVMCfpZWPdFmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715624; c=relaxed/simple;
	bh=7gsZTG8ylbHOBgmqLWPtZ5YXt1ECJ2cs2jYCjoTWjxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TiVwDQVbuwWbUgogU+W9KHhbC6z0OPkv9jDYQ0sOZH3+3SST4dnFCRJAo64a7rfoKzmuFaXCWtexul8pYtj3Z4Ql7+fsPfknW09eWBTBWfo/A4PVW7hXgd5vUUQxCtL01+8R2mlKnfga3NtURoNGImpbaN6iECDOMHq+UD9WuIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZttIEyRf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZttIEyRf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714EFC4CEEA;
	Mon, 23 Jun 2025 21:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715623;
	bh=7gsZTG8ylbHOBgmqLWPtZ5YXt1ECJ2cs2jYCjoTWjxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZttIEyRfqoEw5/9Xy1QYvSco6gooZzNe3PFDCRx2KnS5Ro4/a+hkWUn6/dniSTQdM
	 sCHqvC1T7XmGtRvFoyvrCwLhaHYw+EBLoObck/oH4e3mNRJHceUo3Zv9vPPnfrMp+g
	 kmft3mNxFR4+emhJB2BCMoBHn7m05/UrELM0bPHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	syzbot+d16409ea9ecc16ed261a@syzkaller.appspotmail.com,
	Pedro Falcato <pfalcato@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Jann Horn <jannh@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 470/592] mm/vma: reset VMA iterator on commit_merge() OOM failure
Date: Mon, 23 Jun 2025 15:07:08 +0200
Message-ID: <20250623130711.612136032@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

commit 0cf4b1687a187ba9247c71721d8b064634eda1f7 upstream.

While an OOM failure in commit_merge() isn't really feasible due to the
allocation which might fail (a maple tree pre-allocation) being 'too small
to fail', we do need to handle this case correctly regardless.

In vma_merge_existing_range(), we can theoretically encounter failures
which result in an OOM error in two ways - firstly dup_anon_vma() might
fail with an OOM error, and secondly commit_merge() failing, ultimately,
to pre-allocate a maple tree node.

The abort logic for dup_anon_vma() resets the VMA iterator to the initial
range, ensuring that any logic looping on this iterator will correctly
proceed to the next VMA.

However the commit_merge() abort logic does not do the same thing.  This
resulted in a syzbot report occurring because mlockall() iterates through
VMAs, is tolerant of errors, but ended up with an incorrect previous VMA
being specified due to incorrect iterator state.

While making this change, it became apparent we are duplicating logic -
the logic introduced in commit 41e6ddcaa0f1 ("mm/vma: add give_up_on_oom
option on modify/merge, use in uffd release") duplicates the
vmg->give_up_on_oom check in both abort branches.

Additionally, we observe that we can perform the anon_dup check safely on
dup_anon_vma() failure, as this will not be modified should this call
fail.

Finally, we need to reset the iterator in both cases, so now we can simply
use the exact same code to abort for both.

We remove the VM_WARN_ON(err != -ENOMEM) as it would be silly for this to
be otherwise and it allows us to implement the abort check more neatly.

Link: https://lkml.kernel.org/r/20250606125032.164249-1-lorenzo.stoakes@oracle.com
Fixes: 47b16d0462a4 ("mm: abort vma_modify() on merge out of memory failure")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: syzbot+d16409ea9ecc16ed261a@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/6842cc67.a00a0220.29ac89.003b.GAE@google.com/
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vma.c |   22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

--- a/mm/vma.c
+++ b/mm/vma.c
@@ -927,26 +927,9 @@ static __must_check struct vm_area_struc
 		err = dup_anon_vma(next, middle, &anon_dup);
 	}
 
-	if (err)
+	if (err || commit_merge(vmg))
 		goto abort;
 
-	err = commit_merge(vmg);
-	if (err) {
-		VM_WARN_ON(err != -ENOMEM);
-
-		if (anon_dup)
-			unlink_anon_vmas(anon_dup);
-
-		/*
-		 * We've cleaned up any cloned anon_vma's, no VMAs have been
-		 * modified, no harm no foul if the user requests that we not
-		 * report this and just give up, leaving the VMAs unmerged.
-		 */
-		if (!vmg->give_up_on_oom)
-			vmg->state = VMA_MERGE_ERROR_NOMEM;
-		return NULL;
-	}
-
 	khugepaged_enter_vma(vmg->target, vmg->flags);
 	vmg->state = VMA_MERGE_SUCCESS;
 	return vmg->target;
@@ -955,6 +938,9 @@ abort:
 	vma_iter_set(vmg->vmi, start);
 	vma_iter_load(vmg->vmi);
 
+	if (anon_dup)
+		unlink_anon_vmas(anon_dup);
+
 	/*
 	 * This means we have failed to clone anon_vma's correctly, but no
 	 * actual changes to VMAs have occurred, so no harm no foul - if the


