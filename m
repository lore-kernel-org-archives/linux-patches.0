Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3593B7F48C;
	Tue, 14 May 2024 10:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684190; cv=none; b=iczuGUbxWEMCYZuHUlAW2SO/KiTzs94iWR1bonbesRKhyrr1/ToBH9l+YrtARM0ZB67PnJ7kaD8463zAAkohMb3/qlS+I44Eq7F70/Qjw17gRZTHkKmQjHGrOfFhYC1boWdO6o1yEfyzjqDeo1JyPQSLt9b2HOMUSGBhOaW6rJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684190; c=relaxed/simple;
	bh=2pakhCK3e0ePbOYdUJ5EEsrgZJez2uBasQ7jj/QfwAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a0W7LGHZoCmAsW7wvpLLuCCxGRsacTtWoUuIzJg/2F5Y9GNSHagxGiKMJJ8Vts6LP+SVWYPaG5DmnuRXfNuNbQc+tEXxpy3CYZeaoma3upb5EyRsCNv8v9NhKwAx1i93yWoKdjtSwcnmezOIn53xNt6+Lxg6qkuqlQwXWmi3JZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WtFV/b8i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WtFV/b8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD4FC2BD10;
	Tue, 14 May 2024 10:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684190;
	bh=2pakhCK3e0ePbOYdUJ5EEsrgZJez2uBasQ7jj/QfwAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WtFV/b8inE2n8LiONO040L1g3etAa6hTrlJw8WzVz7n1MPibYOSzFHNgBkeDU+K5j
	 dK7CG1+0YqiOAd3YDOqT6NJyoeWEWmOcRynIMzey8mjRndR4WHurSgIdG0Sr68PBRX
	 VU+DtHk/uQF6TAW+RzNILYmV+L/za9YcOlhWDjCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d8426b591c36b21c750e@syzkaller.appspotmail.com,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Nadav Amit <nadav.amit@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.8 315/336] mm/userfaultfd: reset ptes when close() for wr-protected ones
Date: Tue, 14 May 2024 12:18:39 +0200
Message-ID: <20240514101050.511648846@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -925,6 +925,10 @@ static int userfaultfd_release(struct in
 			prev = vma;
 			continue;
 		}
+		/* Reset ptes for the whole vma range if wr-protected */
+		if (userfaultfd_wp(vma))
+			uffd_wp_range(vma, vma->vm_start,
+				      vma->vm_end - vma->vm_start, false);
 		new_flags = vma->vm_flags & ~__VM_UFFD_FLAGS;
 		vma = vma_modify_flags_uffd(&vmi, prev, vma, vma->vm_start,
 					    vma->vm_end, new_flags,


