Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B0F1F95A
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF6FC433C8;
	Tue,  1 Aug 2023 09:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883430;
	bh=P0cv7mtuM/xucLEWDgmSXOUo/dHnKUBWmknw7veC/7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vcZlREsfgRqm3EcMds8Rgm8DzzHArjFdwXrP4m2AY5Hr8gh5AfdGcKXrtDsC1qcYk
	 bmDRiWyB0xyDjI9z1kT4boTqqZXo4a7Grf1K0cy571CX2APVWRDykIszZVyCHSaLCL
	 WZUITx6Ys3WK2ZfrU7J0sQySBtlX5zltV+CCh2Wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.4 234/239] mm: lock VMA in dup_anon_vma() before setting ->anon_vma
Date: Tue,  1 Aug 2023 11:21:38 +0200
Message-ID: <20230801091934.461315217@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jann Horn <jannh@google.com>

commit d8ab9f7b644a2c9b64de405c1953c905ff219dc9 upstream.

When VMAs are merged, dup_anon_vma() is called with `dst` pointing to the
VMA that is being expanded to cover the area previously occupied by
another VMA.  This currently happens while `dst` is not write-locked.

This means that, in the `src->anon_vma && !dst->anon_vma` case, as soon as
the assignment `dst->anon_vma = src->anon_vma` has happened, concurrent
page faults can happen on `dst` under the per-VMA lock.  This is already
icky in itself, since such page faults can now install pages into `dst`
that are attached to an `anon_vma` that is not yet tied back to the
`anon_vma` with an `anon_vma_chain`.  But if `anon_vma_clone()` fails due
to an out-of-memory error, things get much worse: `anon_vma_clone()` then
reverts `dst->anon_vma` back to NULL, and `dst` remains completely
unconnected to the `anon_vma`, even though we can have pages in the area
covered by `dst` that point to the `anon_vma`.

This means the `anon_vma` of such pages can be freed while the pages are
still mapped into userspace, which leads to UAF when a helper like
folio_lock_anon_vma_read() tries to look up the anon_vma of such a page.

This theoretically is a security bug, but I believe it is really hard to
actually trigger as an unprivileged user because it requires that you can
make an order-0 GFP_KERNEL allocation fail, and the page allocator tries
pretty hard to prevent that.

I think doing the vma_start_write() call inside dup_anon_vma() is the most
straightforward fix for now.

For a kernel-assisted reproducer, see the notes section of the patch mail.

Link: https://lkml.kernel.org/r/20230721034643.616851-1-jannh@google.com
Fixes: 5e31275cc997 ("mm: add per-VMA lock and helper functions to control it")
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -647,6 +647,7 @@ static inline int dup_anon_vma(struct vm
 	 * anon pages imported.
 	 */
 	if (src->anon_vma && !dst->anon_vma) {
+		vma_start_write(dst);
 		dst->anon_vma = src->anon_vma;
 		return anon_vma_clone(dst, src);
 	}


