Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585706;
	b=rqRo01aNo4EVEnKJgrP87KiX+id6KVilWlBswdFrLeqTdqEfFkqIs8QHJgNrBuQ1vHJv
	 aIcwiGSvatbao0HeUtNX8+dFchWxdnBFAmZQ2IPw6GhiS9J1fF92pcecZ9DHZvoyFaosS
	 KOHLONHcQvgTNhIG41nLx7flS5+VdLVrXVDE8IxfdVUVGNdXBjhuzSoIXzA02BZnobhCD
	 YHoWzP1Z+Az8iJUyYFqDlvAINOfAYSNrtiqlehj1JOc8urDE033P+XSq4QSZg44pfWxLM
	 y7tVtlN/SMCSRKDxxnV88TU3rUtB6dwEXEARp7INK6Unlq1LS+uMM8u0+3/LZp2mEtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585706;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V/6lFsfkNS4u5/l4GEz0/y/pHVK8P8ygi6P8VYS+opo=;
	b=c6FMGsAEk/YMzNs0Swjd0c2IgQ+aenyFpIsgdWnHWrnw+GGjn/ZaiQlFXYSh94tVB7Il
	 +R4Rc3yQyFOlmOZXNkf0fUtg6jyEyqvGbJc9guurnZOduA2XjzhpJflY4nDwXF2yW5Tuv
	 3Kg/tMmjW5EfSfsEgZyWFxONBATmMqWY5npasgONyU/YwdnUuIAtharOXwAMezj/CVXso
	 GMzJ+lOwBxFcvr2mKTBLhcK0Gs8O1HGUXOOjwQIKDTHnUU9z2lo+RrdLOHqRADJBTWcCd
	 QndR83nyiinSzf+4prLI1mJcgfJWnskU1jIlthby+2MMX3ojw8AUh18ovccf2iQtKeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="K/kCaoFj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C331760A3839;
	Fri, 13 Nov 2026 16:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K/kCaoFj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728571F000C5;
	Fri, 13 Nov 2026 16:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585706;
	bh=V/6lFsfkNS4u5/l4GEz0/y/pHVK8P8ygi6P8VYS+opo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K/kCaoFj4SEKkPt7CoZDSz4kY0FUFkcHu9QflJUwmmDYqMwVndQ3d02LrAX7Y3Jnk
	 x7mrF/tlhWyoWAIwhNzjsx+99GEiAGTpcSODB7bIdf9uUPBXN13jtnMh7gyGIvD+GA
	 kHLsGBHEBKSAp27YHuVIBDPxNaZFCdar8IHrIIzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 311/507] mm/userfaultfd: write-lock the VMA before waking waiters when unregistering
Date: Fri, 13 Nov 2026 10:50:15 -0500
Message-ID: <20261113153805.914996786@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit 35f7ecd55ce7e51cb6d5ef49e6dd51f3c80f61e4 ]

userfaultfd_unregister() wakes pending missing faults before clearing the
VMA's userfaultfd registration. With per-VMA fault locking, holding
mmap_lock for write does not prevent another fault from queuing after
the wakeup but before userfaultfd_clear_vma() write-locks the VMA. That
waiter can then remain asleep indefinitely.

Call vma_start_write() before waking waiters. Existing fault handlers
queue themselves before dropping the VMA read lock, and new readers are
excluded until mmap_write_unlock().

Fixes: 29a22b9e08d7 ("mm: handle userfaults under VMA lock")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-23-d6437171ecc3@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/userfaultfd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 500962be11624..ddce409db0ad7 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -4035,6 +4035,9 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
 			start = vma->vm_start;
 		vma_end = min(end, vma->vm_end);
 
+		/* Prevent new userfaults from being queued after the wakeup. */
+		vma_start_write(vma);
+
 		if (userfaultfd_missing(vma)) {
 			/*
 			 * Wake any concurrent pending userfault while
-- 
2.53.0



