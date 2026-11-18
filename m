Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038927;
	b=C/2h3MrRwEM1LbRyGJncuK3WjyhrdFd0lpFsNjrMOSHPnamDDrcq2DEoFdaMF0DGrPEv
	 GUrvsWNDM3qcFFB2xHyiJ5zsb4XgMP8LOp2afCPk5XIbot4bCSIpnxdz8NQAaM5IJElz0
	 Tim2O4ImSaoKlMPkp4Co3kYZsHIHoy/RWQFr+TO1zAnP/EgjOs4b2UM00BKVH0UGqCYiM
	 MMSaM+cM5ppyOqmkRIRYW3GShTf24n6moH2Qi2hOlQw+tUYfmhPDID9ckDbLgb3VBWnm+
	 323ge+MJspvMK5trflK6BzGMXC+TSLauY4dMBSCKEKk6B8ZAvnezlGMI7YZmFNWwpTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038927;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gvvSS1qekZp2BQU2Ev7ZtxqU8in4LreTE5Jp4GKqc24=;
	b=FfARQKAOvO+UtvNHPn14BidE//XjveSxlxlnzcRTZOcs1l/KnkmruZPStKXrhxbggO9r
	 4bS+gb+zzRuTA5NJedAoYpfU+GPDcrZxDmUh0w9xg1fRyRMclp2dA/iq8gwWNab+qfsRQ
	 GqGj+oXGC5PJieP8lrosgK9qd2ny15s3GqaxthM4I8B+XDj/FDIgoVZuNOxSbf4CtNQBw
	 2pbJvNuv/DXVfX3GRY2qvM3fdFX2JB0nOJz/RSiKGchgN7tMHJqqDa2q3OVkTItolAeRA
	 VOXSAGQ5t5hJW7YsVX9eoRUd9TRHhVbt3eCaxlTaMrTwKpvLR/0ttfOKqGmRrjP54ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dg8Fb36L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FBE606A325;
	Wed, 18 Nov 2026 21:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dg8Fb36L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1941F000C4;
	Wed, 18 Nov 2026 21:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038926;
	bh=gvvSS1qekZp2BQU2Ev7ZtxqU8in4LreTE5Jp4GKqc24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dg8Fb36LnYEyjQXNi4ADM4dLDZGrbaHX3dOt1VoPJEiu7DogtSML9WXTgQI5jlalW
	 1mMiUgbHnAzC14S9x9+568gPrRPsJG9S0NV66WjG5aNQFDSEgmREkHYJR0q926p4TI
	 jWVEdRsk28kUhx1XjQOP/aC/fndZEK71+ab9Xm7E=
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
Subject: [PATCH 6.6 1876/3318] mm/userfaultfd: write-lock the VMA before waking waiters when unregistering
Date: Wed, 18 Nov 2026 15:41:38 +0100
Message-ID: <20261118150418.259308299@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted the patch location because userfaultfd still resides in the filesystem subsystem ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/userfaultfd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index bd64d6b9cf899..11b4ed7efa5f8 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1664,6 +1664,9 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
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



