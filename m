Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617873;
	b=IcsqAY24sA2zE2D5fbl9Ij5DgpGOTbnfEtrRR7SlughlWqgzBkcbx2R3nv0YZw45hUjQ
	 p8NHPKBk/D5T8LQgCIJ9a8tAYG3ATcaY8FlKR9yp1JimP3sCRCxjQ2jNF9HJRGWBRSAOk
	 pE+gS9c391jJj+Py+5cF9UGoXiz8LA6w06TpT0AJfkp9sykaCEf4czz4dJEQpj04eqRXt
	 aSq0oTbqRryMa/MihB247Qodv1vqfpu1DWrqRgw0lb5RSPhJiCjh6tAOuip4hHZvj7etA
	 jLvnHKUum7cfF7KpOXz4+CcSeXhvEr8dcojUwiaLukdWW5+O8y8kIwQTAQ7QTfqR3bQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617873;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vjcv8mIjjO3HqhxZeiW9Q7eUKdsler0SF1MT8Hsl5QE=;
	b=C1MOjCcLilWCyws10dFq5oPlQigSpixfVRtRr/dnBLi/C1zv0EzA3uF/uu687VOIerS2
	 rCD+79qfcZphr02iu2hazKJMQm0Y8gGTsBZFnzby2S3VHXdzbddR0mGAiii0Myed9cC6H
	 ijyUtQTNx/HQZIvTCFXb/vAav4uGA6droQ4Sv7yBAlLxpKgiNAsO5y2m3TOnNO9KQdKn6
	 Lxfjn5iZm/6YOTZODBTfAY4rnwp8tq4bsE+RQE84l1XewdmNd2FspdFdCMzH3Wo8WkxUV
	 /YukphjgiCt/XoJbnD0s3nnUTCkI0bJbaDk2QfT+AmSQ15Nj0CixFicMPSwuGbrU+jQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HhwEoTlI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F153606A31E;
	Wed, 25 Nov 2026 14:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HhwEoTlI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FDC81F000C0;
	Wed, 25 Nov 2026 14:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617873;
	bh=Vjcv8mIjjO3HqhxZeiW9Q7eUKdsler0SF1MT8Hsl5QE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HhwEoTlIQvsmQzxtpdssnhtohRYpAHb1Hz0A/AxNwph0RPE03YPVDOciYISqM/RxY
	 +QIpo2og+w4ExTBh0Kg5qO0GVap01H7tB2E3mxqQaaXUjTZIEni5uX4EM/9H+ejLmH
	 YEqH4+eYE2WGOJrVRUo2GYRKLsakeySRyBO0E46E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0101/1005] bpf: Dont let bpf_arena_free_pages() see a half-set user range
Date: Wed, 25 Nov 2026 15:23:59 +0100
Message-ID: <20261125143824.111950833@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 52498f14c2d26d67a9bf06998b797900827a06ad ]

If map_extra is 0, the first arena_map_mmap() sets user_vm_start and
user_vm_end. It holds arena->lock, but bpf_arena_free_pages() reads both
fields without this mutex. The kfunc relies on the verifier, which rejects
a prog if user_vm_start of its arena is 0. But this check covers only the
maps in used_maps. The kfunc accepts any trusted pointer to struct bpf_map.

Thus the kfunc can run during arena_map_mmap() and read user_vm_start as 0
and user_vm_end as vma->vm_end. Then min() does not limit page_cnt to the
arena. arena_free_range() unmaps and frees pages of other vmalloc areas.

Read user_vm_start one time and return if it is 0. This value means that no
range is set, because arena_get_unmapped_area() rejects address 0. If only
user_vm_end is still 0, uaddr_end is 0 and the kfunc returns, as today.

Fixes: 317460317a02 ("bpf: Introduce bpf_arena.")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-5-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/arena.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index a10981be21fe6..607768ef4bb5f 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -990,6 +990,8 @@ static int arena_free_range(struct bpf_arena *arena, long uaddr, long page_cnt)
 
 static void arena_free_pages(struct bpf_arena *arena, long uaddr, long page_cnt, bool sleepable)
 {
+	/* The first mmap() may be setting the user range right now */
+	u64 user_vm_start = READ_ONCE(arena->user_vm_start);
 	struct mem_cgroup *new_memcg, *old_memcg;
 	u64 full_uaddr, uaddr_end;
 	struct arena_free_span *s;
@@ -997,8 +999,8 @@ static void arena_free_pages(struct bpf_arena *arena, long uaddr, long page_cnt,
 	/* only aligned lower 32-bit are relevant */
 	uaddr = (u32)uaddr;
 	uaddr &= PAGE_MASK;
-	full_uaddr = clear_lo32(arena->user_vm_start) + uaddr;
-	if (full_uaddr < arena->user_vm_start)
+	full_uaddr = clear_lo32(user_vm_start) + uaddr;
+	if (!user_vm_start || full_uaddr < user_vm_start)
 		return;
 	uaddr_end = min(arena->user_vm_end, full_uaddr + (page_cnt << PAGE_SHIFT));
 	if (full_uaddr >= uaddr_end)
-- 
2.53.0



