Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216612;
	b=nmG7GrwkK8gOVFnyBA5xvg9emgbcziB5RJQh/GiiHVRY7gzjUtAXTfdEPjQrO5huFHsj
	 afnCkaQWk1WqJ1W279AEGByHAv1F6vvPvWNR13K2vPS2a2TmrZYnX/bxQba7i5x71wBPu
	 8csczkh8x925oKiKd1QdH1XiU9rwGGFqMr7Rwp8DdvPjYej/dog8jKiR38Tm/NY2zwdyj
	 EVrGPorPX/p8syN1p0n1FztqgO5XCfoteVfPCWbFSSnG9bLtTlV7tAA3XDxYq4xJWMX5G
	 zTzlaRS/Fl2u00Egg4iR3TcIv/4cJ0GgHq11jvtaJVzR/THN8EefbxF1HeNk1++UWgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216612;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pAZRHh/e59UjGlqQFIzHahRuD5m6Y9u3bAASncod4Lo=;
	b=AqpbiYOjeJX6FlSGNlgQOmy4i0YhJsbgxPn02BrJ1QzUkDvOjzFHdilqTMrYVgXepjQS
	 IIvFDOFjKmHr4em200lu1VqoLttrm2B7BqI7ixQFoVBfJnwdnXIBiMmcIUpgq89wHkDlW
	 eYwxsLlot4i6CGpBxVgvxCisfzOCF9wAJQ4wA3ejU7fffvYzaeiOwASHredI59Rlwqevs
	 fuAMaQe7xrfCGeomkb+cCKrDdjnfNqX8VgsDJ6V+ueC0riawzAKbIQv994ZEY57ua+b9R
	 jSi60n0j43zJzgMjR34oEia2SYv6bHuVeRhqEdqnPjDivKkRbKbsbGyqbJa+2Q+3GFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Njk04i9q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B055606A322;
	Wed, 28 Oct 2026 19:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Njk04i9q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326C31F01825;
	Wed, 28 Oct 2026 19:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216611;
	bh=pAZRHh/e59UjGlqQFIzHahRuD5m6Y9u3bAASncod4Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Njk04i9qeAKftIFNEMmNvK3zYW9EnCn6ky7MmYmZ4vkWYXRjise/LAe6cWboLZeL/
	 ou1pd1bq+5ziQ+3CYWg1Bysn3Xn7Dyg/NtLiu2+U9wIRzEraL1qHk3UQD2mT9YvNsp
	 EGNMkayHj7SG7dq1qoh5E5esi8X0vIPS6icrp6P0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1617/1887] bpf: Zero queue and stack outputs on lock failure
Date: Wed, 28 Oct 2026 18:01:53 +0100
Message-ID: <20261028170536.265559574@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 7ac6e1ae41a09f1dd4baeeff1d028ae49ee01232 ]

Queue and stack pop/peek helpers accept an uninitialized output buffer
because the verifier expects the helper to initialize it. The empty-map
error path clears the buffer, but a failed lock acquisition returns
-EBUSY without writing it.

Clear the output before returning -EBUSY so BPF programs cannot observe
uninitialized stack contents after a failed helper call.

Fixes: a34a9f1a19af ("bpf: Avoid deadlock when using queue and stack maps from NMI")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://lore.kernel.org/bpf/20260719125419.1782196-1-memxor@gmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/queue_stack_maps.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/queue_stack_maps.c b/kernel/bpf/queue_stack_maps.c
index a8fe640318c6c..a088132163b1e 100644
--- a/kernel/bpf/queue_stack_maps.c
+++ b/kernel/bpf/queue_stack_maps.c
@@ -103,8 +103,10 @@ static int __queue_map_get(struct bpf_map *map, void *value, bool delete)
 	void *ptr;
 
 	if (in_nmi()) {
-		if (!raw_spin_trylock_irqsave(&qs->lock, flags))
+		if (!raw_spin_trylock_irqsave(&qs->lock, flags)) {
+			memset(value, 0, qs->map.value_size);
 			return -EBUSY;
+		}
 	} else {
 		raw_spin_lock_irqsave(&qs->lock, flags);
 	}
@@ -138,8 +140,10 @@ static int __stack_map_get(struct bpf_map *map, void *value, bool delete)
 	u32 index;
 
 	if (in_nmi()) {
-		if (!raw_spin_trylock_irqsave(&qs->lock, flags))
+		if (!raw_spin_trylock_irqsave(&qs->lock, flags)) {
+			memset(value, 0, qs->map.value_size);
 			return -EBUSY;
+		}
 	} else {
 		raw_spin_lock_irqsave(&qs->lock, flags);
 	}
-- 
2.53.0



