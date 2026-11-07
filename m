Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062748;
	b=h51mJaQ4j2CGhwzmH3yEFWTmiqvk0c212s9+ChRCwTpEOO2IubyKM/7Mkx1EXbLeKHE4
	 Q788MSYnZ9cloO+tf1e9gsSdx5p2oGdZenKKvDXsipRh4dNrFnwzaSisyqOwvJkRngxAi
	 niLKQ5U0WDiYRJbX6k2CwT4E9s8I+ZcjL3rYrSYUDcPgSRV9YYKUQVSkfoROeSR5K2X+/
	 HtZe2fa1gfVg7PJ+MlLf6lCUVwNRJN/I9BHsaBxs2+z0qkso3cWgBB/3ewIR76Qxqg+Vk
	 DYmYYRuq4758mbVlBsJe0sXHyZRtbG+JUWYCxxvQPiw5uiRrSae2MjjVtvEy0wS+7sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062748;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uJt0BWV0xMmP2iRi8nymPQBBRcYwM0x9jwAbMNotYgg=;
	b=OrqobSynFsoZEJ2vn2Y8dzFBukoSuyZhg/xaAtpTrg0ULUp14hO8sDM7zI6tjLdstpSY
	 Exe35GL8ZAN2wH+yV1q/8neQrzYBCmipQjnpQNoCBzPK98Ib0KmBuqHj2v9IMa/8A0YaE
	 EaxigJFfjy7/tWcKHDMpMNfDlCW5WAK/chVbcRb3LohaZJj41dvCY6+dULuq+dTFBzWSo
	 0k1px0Be9H6nYiJc+ytqorjiPNfusHHGNbRFYgm+NkbblqWKN5oLrxFw8gHwe64h2Waav
	 v1jdTP91+edd+BDhrxM+1qQuv8Pww3q5ib7JiFHVnlfMy9DS66hXhsOv/kUUHNcYV6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k1FPjU7f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74450606A32C;
	Sat,  7 Nov 2026 14:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k1FPjU7f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FBE11F0089F;
	Sat,  7 Nov 2026 14:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062748;
	bh=uJt0BWV0xMmP2iRi8nymPQBBRcYwM0x9jwAbMNotYgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k1FPjU7fznXTi2njgbuRBb0phcrCuGKuuzB7/kGcwc9aEyqqihxtXcTQwLU2FEAFG
	 mb3oNKUbfi4Sppt4g288KtxKkkulJ5BsSkrvlFFhd52txeU0dCg5e2sC/yG881AaaW
	 TGy5UR90cdycafgG5EeAjy3jut8y6AIJezX/bSY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 062/869] bpf: Fix queue/stack map u32 index overflow
Date: Sat,  7 Nov 2026 08:45:44 -0500
Message-ID: <20261107134854.390135853@linuxfoundation.org>
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

From: Yuan Chen <chenyuan@kylinos.cn>

[ Upstream commit 802a30c5db726639df7f93b3a1982ecc64202abe ]

The queue/stack map addresses elements[] with the product of a u32
head/tail index and value_size, but the storage itself is allocated in
64-bit arithmetic.  When max_entries * value_size reaches or exceeds
U32_MAX, the product wraps and push/peek/pop operate on the wrong
element, corrupting map data and leaking stale values to user space.
max_entries == U32_MAX would also make the u32 capacity counter
qs->size (max_entries + 1) wrap to 0 and permanently break the map.

The original bound check was removed by commit a37fb7ef24a4 ("bpf:
Eliminate rlimit-based memory accounting for queue_stack_maps maps"),
which deleted the bpf_map_charge_init() call and with it the
U32_MAX - PAGE_SIZE check that had earlier been moved into
bpf_map_charge_init() by c85d69135a91.  Oversized queue/stack maps can
therefore be created again.

Restore the bound in queue_stack_map_alloc_check() with a single
comparison that rejects any max_entries/value_size combination whose
element storage would reach or exceed U32_MAX bytes, keeping the u32
index multiplication overflow-free and the capacity counter valid.

Fixes: a37fb7ef24a4 ("bpf: Eliminate rlimit-based memory accounting for queue_stack_maps maps")
Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/bpf/20260831063226.621309-2-chenyuan_fl@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/queue_stack_maps.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/queue_stack_maps.c b/kernel/bpf/queue_stack_maps.c
index c1c9dee4dcdd0..b5628e4149817 100644
--- a/kernel/bpf/queue_stack_maps.c
+++ b/kernel/bpf/queue_stack_maps.c
@@ -59,6 +59,9 @@ static int queue_stack_map_alloc_check(union bpf_attr *attr)
 		 */
 		return -E2BIG;
 
+	if (attr->max_entries >= U32_MAX / attr->value_size)
+		return -E2BIG;
+
 	return 0;
 }
 
-- 
2.53.0



