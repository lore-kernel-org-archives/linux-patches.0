Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028527;
	b=LjKI7dNoqQL+N+LEN+loRtJiOkPyzeCjtMCPOGPD8oiBylx67rNi/8HMSJS/ViJKZrqy
	 uBH/tvcTn/kZgOVQsCH1yDU3BZYZlJPE4rLVfBWv3NOq5maIInKlb5Joi9Xi3KyMNqoQK
	 DngG2WTAoUWZPZTgThQQmq4UzC5+H1zRof8M2MQ6wVsYElPpux+4Aovnd+jlTz0OC+oZX
	 ZlUghtI4lcgbibWuGqnQjnPBfFPTiOP6hwZNr+hunsFfjUWNEo/DSt7I2/KY4nZQvfiax
	 Co59/2tJ9ZBHxxK1zQWPkgqv0RMgfoS94YPfgvDLGRDQKETi04ntLc7r2UKlrImbTDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qYSqP5+QOHTAVBJ2Sjk6847AJN2kqdDX+LtYMtxD9ns=;
	b=ENo7I8WLoonKigjNuzSpDfcwc4Ur/DvgMc/nuKJ4k1Tjk7xItdkKiOqhT802Ys8GkOpi
	 13Dh/mlnbnc6nyHLM+wxDTZWotY8u0iXi2x1QGNsWfsf5NOOajSTH3C+o0RaxncqodFDl
	 YOnRXg8GIbC7yNOJ2p1i07VfhTufGDiCiEAUbgnlw2oos6GMSpzAykUSRbyaLNz1JFdMD
	 jb/h9dkpgd7g3j6ak6FgiKi1FDcq6BtlqvAEKEOqSPq2dExZSvMgtiNDVLpAtN7KjwJEB
	 tTJkgd/2yPfFXBepALoy3sUb7Lyz2fmhrXjHDy6pBNCe14yFL3BMvR+5lgpmlHiwADQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kk4lmLEB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2B3606A31C;
	Wed, 18 Nov 2026 19:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kk4lmLEB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FFBA1F000C4;
	Wed, 18 Nov 2026 19:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028527;
	bh=qYSqP5+QOHTAVBJ2Sjk6847AJN2kqdDX+LtYMtxD9ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kk4lmLEBygrZ0J6pqKKjpPg+UC3KxCB82z9Yzc+LVh5Gb3Q9LlVT8icbnf8YJ8k9Q
	 CzMGPRWIfgk4Ptfa2dN+FUjQy1VDCu0me9xeIZoXv0LFGfrdTy+d5TD+ErhgaZuAmz
	 Xe0+fYmR3C2r/M2bVrH4f3ufwKdh2aHlFdmmSdZk=
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
Subject: [PATCH 6.12 0020/1756] mm/userfaultfd: write-lock the VMA before waking waiters when unregistering
Date: Wed, 18 Nov 2026 15:35:47 +0100
Message-ID: <20261118150008.721687162@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
[ sashal: adjusted the patch target to the older file location of userfaultfd_unregister() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/userfaultfd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index cbd9d610c54bf..59f01cc7c5ace 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1513,6 +1513,9 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
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



