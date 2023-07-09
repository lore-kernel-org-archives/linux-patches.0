Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB18522D
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:14:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7722EC433C7;
	Sun,  9 Jul 2023 11:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901272;
	bh=ANrfaKyJP2FUXOaM31vYzQIlBUTQnUVpURxMjTlfYhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2TmXLKxMcupYV3st+JR8Q3VPaGif2WpTk23nqO7CSlR0L6p6nHtk3k2nhPJyBM9x
	 J4PH9KAXO4tz3ZxATlniessi/uDG1m9Kqa+P6T82T/CdGGkC5DRc2uuxljuWoS2kRD
	 jN+PeYQeIpH1j2pCxEK/ANV4U6XqdKQqSVgPonMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suren Baghdasaryan <surenb@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.4 3/8] mm: lock newly mapped VMA which can be modified after it becomes visible
Date: Sun,  9 Jul 2023 13:14:09 +0200
Message-ID: <20230709111345.397858220@linuxfoundation.org>
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

From: Suren Baghdasaryan <surenb@google.com>

commit 33313a747e81af9f31d0d45de78c9397fa3655eb upstream.

mmap_region adds a newly created VMA into VMA tree and might modify it
afterwards before dropping the mmap_lock.  This poses a problem for page
faults handled under per-VMA locks because they don't take the mmap_lock
and can stumble on this VMA while it's still being modified.  Currently
this does not pose a problem since post-addition modifications are done
only for file-backed VMAs, which are not handled under per-VMA lock.
However, once support for handling file-backed page faults with per-VMA
locks is added, this will become a race.

Fix this by write-locking the VMA before inserting it into the VMA tree.
Other places where a new VMA is added into VMA tree do not modify it
after the insertion, so do not need the same locking.

Cc: stable@vger.kernel.org
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mmap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2804,6 +2804,8 @@ cannot_expand:
 	if (vma->vm_file)
 		i_mmap_lock_write(vma->vm_file->f_mapping);
 
+	/* Lock the VMA since it is modified after insertion into VMA tree */
+	vma_start_write(vma);
 	vma_iter_store(&vmi, vma);
 	mm->map_count++;
 	if (vma->vm_file) {


