Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591134;
	b=XPcEknPVqCPTTA6w0P/p3xq3JFDgsFOaEURbSh/tBo89GL3L1jn8efEtSJ8Nsxi/CaP4
	 O+Jwp3oHm82D/EmR0mpU5Eba+ldhPCVn1mGJk9A7S9xsyWJRZoEbTQhtEdG38PmTOBZGL
	 NGUm7ceqfrk5PdVhnAeKmzFQt4yR94pOC+f6up1o9x1fSScMg8L3yEBaevBDzDk22EKJR
	 U4e54OnxMBlCxY4bGMhDxIS/mDSaYHv+jjprZR85kvIVZ/QNwGEViY0stytjxOKt3gKmw
	 vtIMP/99fI9rXPDhCc4cvmZDN+k81Fdeo7a59tsWn7uOdwJ0TJQ8Kaljf5tcWY1rSAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591134;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mTgzxIPj/646kGw43pR3szHSxhN7AndqWCR5SD5Q+Ao=;
	b=aJNfjEhd8S9BlzeDrhOHnyuW4L8PNDV4WEmLRUqJF46qsrsUlRh+SPcnBHc9DHpY1IdO
	 +8yxTXr374HcFcIFReQbY7MpMnePMsW3x8s4wHc1c/GZqrAShTlIZ9vzesARDe+YwxLwj
	 Z71p9Haf5DSyFipWFk0/vnn4VOUnWBoqwuDR/oObVtRqs2hijfP6Jjv2UPsBfYwTXhDpr
	 hThPlGXshnLToDPHc+ziUDOE0zw9Og8A2+kjMmBx2NfPex/faO4i9p+wxumDU/nejb4JY
	 1pzKacrOPNLtI2jiL/yRXHkLqaZQuhM+QWaj8An8B6NtqcKHfe1BOop7NDiuj6k2dfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OPNmz4Kj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF85606A88C;
	Fri, 13 Nov 2026 17:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OPNmz4Kj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0431F000C6;
	Fri, 13 Nov 2026 17:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591134;
	bh=mTgzxIPj/646kGw43pR3szHSxhN7AndqWCR5SD5Q+Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OPNmz4KjpQE+q8QRn6tNXE+5vHJiuzA3icaI0/3KM8UCIE+6wZJBg2zV45Z+7VRPq
	 BkHi2K/bx3cDUreZVpECT8olSjC85ioUKx9YfKFih+3yVKk4vVRuhe/SwgHs/hyCmE
	 DCAZfLzWELto6zgcU/PV/GvIET9Q75CX4eq3qPH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Down <chris@chrisdown.name>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Kairui Song <kasong@tencent.com>,
	Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Ying Huang <huang.ying.caritas@gmail.com>,
	Kelley Nielsen <kelleynnn@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 280/670] mm: make swapoff interruptible when unusing mms/shmem
Date: Fri, 13 Nov 2026 10:47:24 -0500
Message-ID: <20261113153821.373580863@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Down <chris@chrisdown.name>

[ Upstream commit 740128dd1a3f2bd81a80314d079b6b03c39ba3af ]

try_to_unuse() only checks for a pending signal between mms, and
shmem_unuse() doesn't check at all.  That means that once swapoff gets to
a process or a shmem file with a lot swapped out, nothing can interrupt it
until every last page of it has been read back in.

Just as one example of where this can concretely show up, freezing tasks
for suspend or hibernation has to wait for swapoff to notice the freezer's
fake signal, and gives up after freeze_timeout_msecs (20 seconds by
default).

Here's a facetious example where one swaps out 2GiB of one process to a
swap file on ext4, starts swapoff, and half a second later tries to freeze
with pm_test=freezer.  Writing to /sys/power/state then fails with EBUSY
and this in dmesg:

    Freezing user space processes failed after 20.003 seconds (1 tasks refusing to freeze, wq_busy=0):
    task:swapoff         state:D stack:0     pid:3175  tgid:3175  ppid:2955   task_flags:0x400100 flags:0x00000419
    Call trace:
     [...]
     io_schedule+0x44/0x70
     folio_wait_bit_common+0x1ec/0x3d0
     __folio_lock+0x24/0x40
     unuse_pte_range+0x2d0/0x348
     unuse_vma+0x158/0x248
     unuse_mm+0xfc/0x150
     try_to_unuse+0x104/0x3f8
     __do_sys_swapoff+0x220/0x5d8
     [...]

The same goes for anything else that wants swapoff to stop, like an admin
hitting ^C in a panic, of course.

Prior to commit b56a2d8af914 ("mm: rid swapoff of quadratic complexity")
try_to_unuse() was driven by find_next_to_unuse() which checks for a
signal before every entry, so let's restore that behaviour.

Just as an example of the improvements, here's how long freezing takes
in the same test while swapoff is happening on my computer:

                      before                  after
    400MiB anon       8.925s                  0.028s
    400MiB shmem      1.639s                  0.003s
    2GiB anon         failed after 20.003s    0.011s

Link: https://lore.kernel.org/at9kJwdGkHPsWwgG@chrisdown.name
Fixes: b56a2d8af914 ("mm: rid swapoff of quadratic complexity")
Signed-off-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Ying Huang <huang.ying.caritas@gmail.com>
Cc: Kelley Nielsen <kelleynnn@gmail.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c    | 4 ++++
 mm/swapfile.c | 4 +++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 986d667a3bb92..881cbeaf3f747 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1455,6 +1455,10 @@ static int shmem_unuse_inode(struct inode *inode, unsigned int type)
 		if (ret < 0)
 			break;
 
+		if (signal_pending(current)) {
+			ret = -ERESTARTSYS;
+			break;
+		}
 		start = indices[folio_batch_count(&fbatch) - 1];
 	} while (true);
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4ea0ebefe92d9..99eb5878f5acf 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2262,6 +2262,8 @@ static inline int unuse_pmd_range(struct vm_area_struct *vma, pud_t *pud,
 	pmd = pmd_offset(pud, addr);
 	do {
 		cond_resched();
+		if (signal_pending(current))
+			return -ERESTARTSYS;
 		next = pmd_addr_end(addr, end);
 		ret = unuse_pte_range(vma, pmd, addr, next, type);
 		if (ret)
@@ -2475,7 +2477,7 @@ static int try_to_unuse(unsigned int type)
 	if (READ_ONCE(si->inuse_pages)) {
 		if (!signal_pending(current))
 			goto retry;
-		return -EINTR;
+		return -ERESTARTSYS;
 	}
 
 success:
-- 
2.53.0



