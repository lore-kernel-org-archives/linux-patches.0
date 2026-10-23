Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773787;
	b=QpAo8Txeg+3RrqpHjak5dU9kXdfKbtZAELND33tj6WkMpllyeYmY0gcHOdQM4ZyY8GAf
	 bzxv3ZbehlnMGsa2zXQla0divXm5AQTwmiedS9sxLCa2HBXOcgrlnf04dJ81CVWWsbJa+
	 XzTY2JKxGy9Y971toI6PM93AuGlCQJK48hpGNc03JcdSLaxLlK5NbPG3GIdK9v4I3C3vu
	 hgla6FCRfYTQMMVAdQm7HpuwUDD9gF3M6XsgID7AZnc+gWFSqeKm1ccMWUw9v9hzrqxG9
	 eSKWvI5B0FrFpZ/3OjW4tPiMle/WjkIMgEURr/OOsuH8A5dO64JyAzYc3WhGFCrRz8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773787;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KJbfy8TOLrO0OvX/C1vhQsuI9pgfrOHi4RqOSWgcGd0=;
	b=ZzJAyZUuua4EXvdCIOVjLAf/nmPWaZI4ETj/qTVrI94D8jL9gpIMoEMVmot/K73J4XsS
	 +t3EW1SxtNk3Hxzgpi75jDUMuW4yzBhITwHa2A6s2hqYpB7/gr7hqanFJAPJjZYyt4rEp
	 tXKSawyyandrhf1ESZXpZ8/UHSJ7nOekpwnn1siUqyJ65y1vzvYg8aYiChpiiR9/1mH6D
	 ZH7Fmi4vO5Z93TZ1DZHH94ouqUd+ILNRLor5/a/E+BjuNQtDJUmgECbL7K/rX15ygH8oA
	 5eYQK43jzvqPClx+CZKfZ8dHqAgn2cD6ZkpbyxMZBElwHe9TwIl7U0NPzKQpmFYFIOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zpjpO5qC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543EC606A31B;
	Fri, 23 Oct 2026 16:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zpjpO5qC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1FE1F01825;
	Fri, 23 Oct 2026 16:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773787;
	bh=KJbfy8TOLrO0OvX/C1vhQsuI9pgfrOHi4RqOSWgcGd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zpjpO5qCeuJB2OOTZXKdzGIa2DaImEy39HJwCCTa8N7XPHPZkl7fHN+hLfH4W5nre
	 fa4onuU1olQVwXm00STsd8ccNTi4AlgJizBFt85af3bCpYur2CJkBrwd2b2lv0d74U
	 5cpzX5+XEa8G8Jyro69i6BlCNwaMTMFAL62175gI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Parola <fparola@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 008/193] kho: free phys_bits bitmaps using free_page() in __kho_abort()
Date: Fri, 23 Oct 2026 18:34:45 +0200
Message-ID: <20261023163714.401900600@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Federico Parola <fparola@amazon.de>

Commit fa759cd75bce ("kho: allocate metadata directly from the buddy
allocator") switched the allocation of preserved memory bitmaps to
get_zeroed_page(), but __kho_abort() still releases them with kfree().
kfree() on a buddy page that is not a large kmalloc allocation hits the
WARN_ON_ONCE() in free_large_kmalloc() and returns without freeing it,
so every aborted finalization leaks all bitmap pages.

Free the bitmaps with free_page() instead.

This is a stable-only patch. Upstream fixed it as a side effect of
commit 99cd2ffac697 ("kho: don't unpreserve memory during abort"), which
removes the tracking teardown from __kho_abort() altogether. That change
builds on commit 36f8f7ef7fd2 ("kho: add interfaces to unpreserve
folios, page ranges, and vmalloc") and commit 70f9133096c8 ("kho: drop
notifiers"). In 6.18.y, KHO users still preserve memory from the
KEXEC_KHO_FINALIZE notifier and have no interface to unpreserve it, so
the teardown on abort is the only way their preservations get dropped.
Backporting that commit would make preservations outlive every abort,
so keep the teardown and fix only the mismatched free.

Fixes: fa759cd75bce ("kho: allocate metadata directly from the buddy allocator")
Signed-off-by: Federico Parola <fparola@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kexec_handover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 9fe5d14f1ec54..9691f6bc2fba7 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -1054,7 +1054,7 @@ static int __kho_abort(void)
 		unsigned long phys;
 
 		xa_for_each(&physxa->phys_bits, phys, bits)
-			kfree(bits);
+			free_page((unsigned long)bits);
 
 		xa_destroy(&physxa->phys_bits);
 		kfree(physxa);
-- 
2.53.0



