Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065400;
	b=2sms2PK88if+gbRNSI860b3yTxWqc/UFcibi2YiKK9tvUVfdfVZBi4jPQTMCIz0iaEF0
	 LhSU8wJHJc99yvjXbM/GOMeluRDz0AbS5e01LK+5fnWqb40urGCpu88uFLQ8qXlXGeM5q
	 XQyh08lwgbAzpjpU7/fDjVAPXfXtlKecV8fSkZ4bXqGb1BFR7lJ5PUjoaoX5d3939cu2L
	 WbeuKnlCZGde7tk9HamcK+4Utmw1p6584+raAkGl7FxiveniIiGZYCGarlkpW0RF9LhxP
	 QTZEhB1fI9D0BkzVmNoLWkIkGCCBTxr0VgTF88itoFRBG8L0nLHV5tityPilHowymbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065400;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RWZ8iJQmIColP7JbLo1AyZJmbyVMpVlRZd5PyvBDOBQ=;
	b=Dckw9U6EIIs23c+gSzJpHALpF+VRkFJSzYTWdKdDa4Ehw8Ssxwx/SLyrrliFjy0msdvw
	 P/VS2tbo8W3yafUQV1a/ndjPv1RIxZokJOwPK6D+aGD9+FTui5EJ6sZjnU+GC0Xgl2r7R
	 x3b7vip4PAG/g8M3dUjX3X50ErCxiK5x2TLBX8TNQv9q4N4/9DQAilrL2NdKFW8K+/uOB
	 z+VanpVyS5lV1/CXa1RzC4wRAxxf+jc4BcTj2c9qSrdeU8h2OUFkuIKfvQlrcxcsagxYe
	 y3akCvVf26FczM6dCFwUuyWhiT1ndtTrAba8+3PBB9KNU77uoc8qd+VDKdHBzhOpQlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sspa02Lk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB59D606A330;
	Sat,  7 Nov 2026 15:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sspa02Lk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225C01F0089F;
	Sat,  7 Nov 2026 15:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065399;
	bh=RWZ8iJQmIColP7JbLo1AyZJmbyVMpVlRZd5PyvBDOBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sspa02Lk5oi2Qlpwx0ZOZpHK8/oFdPnYJ2Ib0WHhQrG+a85b/jkZR/z7WhMTJSjjH
	 hr58NGEK14m6p7YtEV0bqn17rwwExQs8meVZ6tJZakPXmp7cfduzF8n48uydCVNfGn
	 BzK3+xxwlnLaQTL/eWMmyPJjvvszkovL5NkJSRgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Cen Zhang (Microsoft)" <cenzhang@linux.microsoft.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	AutonomousCodeSecurity@microsoft.com,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	tgopinath@linux.microsoft.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1084/1257] userfaultfd: fix UFFDIO_MOVE livelock on large folio with extra references
Date: Sat,  7 Nov 2026 08:56:20 -0500
Message-ID: <20261107135009.198343225@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>

[ Upstream commit 454143aeb4c6c85ca7d50df36d1a66a64d88283e ]

To move one page out of a large folio, move_pages_ptes() first has to
split the folio.  __folio_split() refuses if the folio has any reference
beyond its page table mappings and the caller's own, and it reports the
refusal as -EAGAIN.  move_pages() treats returned -EAGAIN as a transient
race and keeps retrying the same address, holding the VMA read locks the
whole time.  This is incorrect since in some cases userspace can hold such
a reference indefinitely, such as by registering the page as an io_uring
buffer.

An unprivileged user can trigger this with three threads: first holds such
a reference on a page of a THP, second calls UFFDIO_MOVE on another page
of the same THP and spins in the kernel forever holding the VMA read
locks, and third calls fork() or mprotect(), which takes mmap_lock for
writing and then waits forever for those read locks.  From then on every
mmap_lock user of that mm hangs, including other processes inspecting it
through /proc/<pid>/, until the process is SIGKILLed.  The hung task
detector reports the blocked tasks (third one), and with
kernel.hung_task_panic=1 the machine panics:

  INFO: task wedge:95 blocked for more than 122 seconds.
  task:wedge  state:D stack:12528 pid:95 tgid:95 ppid:94
  Call Trace:
   __schedule+0x596/0x1110
   schedule+0x36/0xf0
   __vma_start_exclude_readers+0x100/0x170
   __vma_start_write+0x51/0xd0
   __split_vma+0x208/0x3d0
   vma_modify+0x6a8/0x840
   vma_modify_flags+0xce/0x110
   mprotect_fixup+0xbe/0x480
   do_mprotect_pkey+0x2d9/0x580
   __x64_sys_mprotect+0x1a/0x30

Fix by returning -EBUSY instead of -EAGAIN in move_pages_ptes(), the
caller of split_folio(), when the split fails.  Thus, move_pages() does
not retry -EBUSY and the ioctl drops its locks and returns to userspace
instead of spinning.

Link: https://lore.kernel.org/20261012201514.97015-1-cenzhang@linux.microsoft.com
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Signed-off-by: Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <AutonomousCodeSecurity@microsoft.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <tgopinath@linux.microsoft.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/userfaultfd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 74f04c323c50f..500962be11624 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1663,8 +1663,12 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
 			pte_unmap(dst_pte);
 			src_pte = dst_pte = NULL;
 			ret = split_folio(src_folio);
-			if (ret)
+			if (ret) {
+				/* do not retry, extra refs may be held forever */
+				if (ret == -EAGAIN)
+					ret = -EBUSY;
 				goto out;
+			}
 			/* have to reacquire the folio after it got split */
 			folio_unlock(src_folio);
 			folio_put(src_folio);
-- 
2.53.0



