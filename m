Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063292;
	b=ISFEzhOEx76J6V07Hx2d3VHkuqK1gxZbCn+fz6XA0OPvYpXGobMs94Un5xEqfzVnwPza
	 XgGOHu9bxdpSSKJIAOBHBjP8pDHztOIc/w2zEtvRqm3bsvtie7mfu7f7r/JedNovQPmW2
	 S4kAT84IqIDCrdqUFzY1yWTOdS00oUuDQftpjAv7Hc/DBH5jyMO//0VD4JAPlKJhMoSVS
	 srtKoFYLRi7lkCccd6UY18dtDESniXJixIysXMllVW7UcNMGAcDmPRA1gt8CW5rWAJged
	 PxrFI1KyTFbDjb8/k9m15WWwdLZTdg6k0LI9uLrAnwJGk5OLv8lZsDFUMObE/EmmQQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063292;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kavz4i8aceo78Di8VXnD32F13uinU8yLdqj0HbjxhJI=;
	b=USdoTUVGmJdP+fPV88r0Ainv0L/AB7Y2uuIg0Huv9DIjCQH3rPXg4ntdQJOew3j5e7ME
	 DBoLC2R0I13aZuXl9TdU7QxP0v8WK15Ll6TzQ8qfYzCzDn+Gy8LiDhcwd976AU9FmHSzY
	 3cKMy8k7pUC4THNPhn/AVPo/ovLuhHBChbCXjIbIyQIUA5iEbkr9R4Qv7d4h683cw/ES+
	 whIdGhRxZCD6uUyxydutq94gKY3b5DRjU482CCcbm21FFDstyhIE8tm3q8Iasyj2p6zqv
	 mgUaCgGTaVKPiCBeJz0cyD/zLD0WI0fQQmJQ+VC/hk7jftGzv/Bfw1eO5eRzWyy5BHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cZ9mIa1o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34175606D80C;
	Sat,  7 Nov 2026 14:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cZ9mIa1o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52F11F008A2;
	Sat,  7 Nov 2026 14:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063292;
	bh=kavz4i8aceo78Di8VXnD32F13uinU8yLdqj0HbjxhJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cZ9mIa1o+OJzOt44hhRf0ATS8qJIiEbD2PiG8ObxKP0IvSAiyOcU0I+AWf26PtASX
	 ueI0FChAFmDyPIzlAHT5ykg4JPh3tqQeUQscJKB9vpV80D0zI+gi1d8hRGjXnqEtEM
	 dfRlpn3DOLquCuzZ0EvRbI6lFl0fV4nXsEWAFVd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Ge <hao.ge@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 485/869] mm/alloc_tag: account for reserved tag ids in the kernel tag check
Date: Sat,  7 Nov 2026 08:52:47 -0500
Message-ID: <20261107134910.021149940@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Hao Ge <hao.ge@linux.dev>

[ Upstream commit c6e5c0b9a493891634d0a413c3485930a28a8903 ]

The tag ids stored in the page flags include two reserved markers.
Id 0 means the page has no tag and id 1 means the tag was cleared,
so real tags start at CODETAG_ID_FIRST. The kernel-side check in
alloc_tag_sec_init() compared kernel_tags.count alone against the
addressable limit, so with the count at or just under the limit
the last tag ids wrapped into those markers. Pages allocated
through them then look the same as untagged pages on free, nothing
is ever subtracted from the real tag and /proc/allocinfo shows
that memory as still allocated.

Add the missing CODETAG_ID_FIRST, same as tags_addressable().

Link: https://lore.kernel.org/20260916075557.121316-1-hao.ge@linux.dev
Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/alloc_tag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index 7c6d3a086fdc4..fbe9e6c995210 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -276,7 +276,7 @@ void __init alloc_tag_sec_init(void)
 	kernel_tags.count = last_codetag - kernel_tags.first_tag;
 
 	/* Check if kernel tags fit into page flags */
-	if (kernel_tags.count > (1UL << NR_UNUSED_PAGEFLAG_BITS)) {
+	if (CODETAG_ID_FIRST + kernel_tags.count > (1UL << NR_UNUSED_PAGEFLAG_BITS)) {
 		shutdown_mem_profiling(false); /* allocinfo file does not exist yet */
 		pr_err("%lu allocation tags cannot be references using %d available page flag bits. Memory allocation profiling is disabled!\n",
 			kernel_tags.count, NR_UNUSED_PAGEFLAG_BITS);
-- 
2.53.0



