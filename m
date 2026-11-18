Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022472;
	b=Cuc4aysrZ/xWwA5DtIZIdfy0ZKxKNpJ2aBcjJJ0IYM3ykArO6MmbssIi9YGrGmvhpVE2
	 SyE89waLRWBbHh8TL9Yh09RHQSMciFFXNPQcL/DxQMBAJyl3OCbRFnwObfsu6Zw7DkKCz
	 o1RsSayKQRXl5NHxBppXp2kjig/m91jbs8E5MlZEfBAAR8oc0mIKT/0Fjw/s5ZdAYhaIu
	 l5vKvG0mLA0QmntqPy3wUzUB1nFxwmvQ053lInQfj38ldTk0O15M/UJIczZlbvxJeM1V9
	 kQYxccaVrBJiiMzQCs0PKmcvVU2IJk2utI1i29cp3y2fRx7WkfLWIb2/V8eo9kB8hKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022472;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kjI94vDMKUM1UABAirrBAE/kjGpzM/9lBBsLbHIzLo4=;
	b=cZoWpYzhBrkn8oGzCJAr+Wfnhw2902HKsvkh1EnN9sDRBbYYKrvTZGs5jozsLK2THKWP
	 nzp2mVM9zb9nAzevD67RgMa/ODqLPtEV3St7RxuxPXWFgXdQaiIXkxpD6XdO4DjKc1n5H
	 7W7JDRN2wbpVnEIUjFZWxfkJIDry0ES13+lceiQZAvh3Oc7dPI0ScsEs1UDdIi4VONT/A
	 h1CFDbtmExxZ/4QpCGsJy4xcTPccsmxJG80FsUtoKd3T6RvIQJ6hky7d/504rbc+veuJI
	 o0Slutvt3stJOEXXItbWKH/V/l0LFs9CsW2b4x5cnAUW0+pS4GVgTw+oTIc/3OAx1/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PKYPbhMH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2523606A31C;
	Wed, 18 Nov 2026 17:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PKYPbhMH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009161F000C6;
	Wed, 18 Nov 2026 17:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022472;
	bh=kjI94vDMKUM1UABAirrBAE/kjGpzM/9lBBsLbHIzLo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PKYPbhMHj75N29huoqvIDZd4Ips1Gn/LDSYrQ+9P9+u8vYJrwE6KYOA3kn47Lbk30
	 GPZ1FhFX0M4BGjNtJ6Jo4SMHO8Ny11PBcBKmLSX7AfGIWptHzVM5taT5xCsAu3pRyy
	 Dy6qcszAhamCn6Pv5CmkC4VQLgys2W2IhBMIw5GU=
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
Subject: [PATCH 6.18 0025/2151] mm/userfaultfd: write-lock the VMA before waking waiters when unregistering
Date: Wed, 18 Nov 2026 15:29:20 +0100
Message-ID: <20261118150122.569493064@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted the patch location because userfaultfd_unregister() remains in its original file before the upstream consolidation. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/userfaultfd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 7e40eb9131bd7..2b4e83cc0cb9e 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1524,6 +1524,9 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
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



