Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481776311D;
	Tue, 14 May 2024 11:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685951; cv=none; b=slVNzosQYTDTios8v7D3iBjIue6exEVlx9C1QUr73mllSGyFTXRNsN9+2UbkCmDXooudcKTxxZ21oQNWvslyDpURT39WlyyKzh5f+AiVETaaHrLQO5tpDX+c+GdL5trxymOIcAq8TYhz5lxxivA1djoeYP4Yu5wtYMBS7+YD1b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685951; c=relaxed/simple;
	bh=zS2meG26Tali+2y9sH/REtdzN1lAD2TQvofMmdV/BaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/EyvglebPn86aR8GymjM3QivRHt7+DiHuiXn6fNlsV1UubcSu17yV5trUWJaA6m4hq1jhj2UE9+aq2tefzxVTNk7pXY+bqpW0ggd0S7HYnXURhwQUtuteoLeSffTbleHKykLpmRH7XDFwQQSt8xyFtWK3Wt+dd99jwnuZ0nckQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1bEAiZYf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1bEAiZYf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C15C2BD10;
	Tue, 14 May 2024 11:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685951;
	bh=zS2meG26Tali+2y9sH/REtdzN1lAD2TQvofMmdV/BaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1bEAiZYfvj8yVLxH5PYaWRbXKgjQgXZSZwWNyd1k8dBML1B8JbqOhvPus+24UMjtk
	 u5VtfkL1CJFy+MGNPRKu56G5g/68wLUGsuO2qdXnVIqA5BCwpFVf4zPloV4kPqmHX9
	 Bus/N9Yuq1G8K9UxtXPlgmPRUnc1Pc3FYV9lPsWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d8426b591c36b21c750e@syzkaller.appspotmail.com,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Nadav Amit <nadav.amit@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 283/301] mm/userfaultfd: reset ptes when close() for wr-protected ones
Date: Tue, 14 May 2024 12:19:14 +0200
Message-ID: <20240514101042.949731308@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Xu <peterx@redhat.com>

commit c88033efe9a391e72ba6b5df4b01d6e628f4e734 upstream.

Userfaultfd unregister includes a step to remove wr-protect bits from all
the relevant pgtable entries, but that only covered an explicit
UFFDIO_UNREGISTER ioctl, not a close() on the userfaultfd itself.  Cover
that too.  This fixes a WARN trace.

The only user visible side effect is the user can observe leftover
wr-protect bits even if the user close()ed on an userfaultfd when
releasing the last reference of it.  However hopefully that should be
harmless, and nothing bad should happen even if so.

This change is now more important after the recent page-table-check
patch we merged in mm-unstable (446dd9ad37d0 ("mm/page_table_check:
support userfault wr-protect entries")), as we'll do sanity check on
uffd-wp bits without vma context.  So it's better if we can 100%
guarantee no uffd-wp bit leftovers, to make sure each report will be
valid.

Link: https://lore.kernel.org/all/000000000000ca4df20616a0fe16@google.com/
Fixes: f369b07c8614 ("mm/uffd: reset write protection when unregister with wp-mode")
Analyzed-by: David Hildenbrand <david@redhat.com>
Link: https://lkml.kernel.org/r/20240422133311.2987675-1-peterx@redhat.com
Reported-by: syzbot+d8426b591c36b21c750e@syzkaller.appspotmail.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/userfaultfd.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -921,6 +921,10 @@ static int userfaultfd_release(struct in
 			prev = vma;
 			continue;
 		}
+		/* Reset ptes for the whole vma range if wr-protected */
+		if (userfaultfd_wp(vma))
+			uffd_wp_range(vma, vma->vm_start,
+				      vma->vm_end - vma->vm_start, false);
 		new_flags = vma->vm_flags & ~__VM_UFFD_FLAGS;
 		prev = vma_merge(&vmi, mm, prev, vma->vm_start, vma->vm_end,
 				 new_flags, vma->anon_vma,


