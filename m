Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E6A1D0940;
	Wed,  2 Oct 2024 14:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879068; cv=none; b=juS6ofM8ASczNeMj44Anb7gUa+J+XwVcGeV9glV52rfaEYsbZsX0KY/q32gwkqQPb+FXnZ1P7OwvurAkQtgWra47Gj5liXTP8p8/Q9/ByoEHkbU1QeXfAPFidZXsWJKSRNXhzGOjY5kk9bJICFyMSiEF+c3XXJbnvZvHT71N4PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879068; c=relaxed/simple;
	bh=OpEB67nDhZ7xcj07RuuuNUjHhI0lcwIp9ETcYfmUuAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwSA/a2A0A3V63Bv6Me64rlt/1e5iU2P9eKycCTKcIhebGwM9YzcfuZ1dMSJ9MT3qK4yRjDe/IG8FlVT+wXlSvDvZFgKyLuQz8GQ0byCweKObbiOebr2DldIB0IwSV76SFjCXwaZAPjTz5Le6JESPQXig4LT9NasgMkIr4oSPCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNTiHnQS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNTiHnQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3B3C4CEC2;
	Wed,  2 Oct 2024 14:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879068;
	bh=OpEB67nDhZ7xcj07RuuuNUjHhI0lcwIp9ETcYfmUuAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aNTiHnQSyo9FZLSjn7a3yBXcVQ86aWxa+Lvuq/SlBLNlyMQtUl5qyl62JpJHkaI8+
	 CJB1KSJJ4rYPMl5eYwzOA8eYkkEQ3CFTuMpndTlXzf4Q+rmTlMroNqaCFThhLu2Azh
	 GRDY5mGxMsdWyLBRgT+seFOXk4jy+G2dakSuNd4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2dab93857ee95f2eeb08@syzkaller.appspotmail.com,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.10 627/634] mm/hugetlb.c: fix UAF of vma in hugetlb fault pathway
Date: Wed,  2 Oct 2024 15:02:07 +0200
Message-ID: <20241002125835.874491007@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vishal Moola (Oracle) <vishal.moola@gmail.com>

commit 98b74bb4d7e96b4da5ef3126511febe55b76b807 upstream.

Syzbot reports a UAF in hugetlb_fault().  This happens because
vmf_anon_prepare() could drop the per-VMA lock and allow the current VMA
to be freed before hugetlb_vma_unlock_read() is called.

We can fix this by using a modified version of vmf_anon_prepare() that
doesn't release the VMA lock on failure, and then release it ourselves
after hugetlb_vma_unlock_read().

Link: https://lkml.kernel.org/r/20240914194243.245-2-vishal.moola@gmail.com
Fixes: 9acad7ba3e25 ("hugetlb: use vmf_anon_prepare() instead of anon_vma_prepare()")
Reported-by: syzbot+2dab93857ee95f2eeb08@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/00000000000067c20b06219fbc26@google.com/
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6075,7 +6075,7 @@ retry_avoidcopy:
 	 * When the original hugepage is shared one, it does not have
 	 * anon_vma prepared.
 	 */
-	ret = vmf_anon_prepare(vmf);
+	ret = __vmf_anon_prepare(vmf);
 	if (unlikely(ret))
 		goto out_release_all;
 
@@ -6274,7 +6274,7 @@ static vm_fault_t hugetlb_no_page(struct
 		}
 
 		if (!(vma->vm_flags & VM_MAYSHARE)) {
-			ret = vmf_anon_prepare(vmf);
+			ret = __vmf_anon_prepare(vmf);
 			if (unlikely(ret))
 				goto out;
 		}
@@ -6406,6 +6406,14 @@ static vm_fault_t hugetlb_no_page(struct
 	folio_unlock(folio);
 out:
 	hugetlb_vma_unlock_read(vma);
+
+	/*
+	 * We must check to release the per-VMA lock. __vmf_anon_prepare() is
+	 * the only way ret can be set to VM_FAULT_RETRY.
+	 */
+	if (unlikely(ret & VM_FAULT_RETRY))
+		vma_end_read(vma);
+
 	mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 	return ret;
 
@@ -6627,6 +6635,14 @@ out_ptl:
 	}
 out_mutex:
 	hugetlb_vma_unlock_read(vma);
+
+	/*
+	 * We must check to release the per-VMA lock. __vmf_anon_prepare() in
+	 * hugetlb_wp() is the only way ret can be set to VM_FAULT_RETRY.
+	 */
+	if (unlikely(ret & VM_FAULT_RETRY))
+		vma_end_read(vma);
+
 	mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 	/*
 	 * Generally it's safe to hold refcount during waiting page lock. But


