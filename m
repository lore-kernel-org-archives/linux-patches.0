Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50EC313E13;
	Tue, 16 Dec 2025 11:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884312; cv=none; b=KBUxoDzLGZ/Sz7PxFNo6QFayiPm4GCddMB1pWiqGeIWsP6JmvigfZFjqSP4KwCAlq4CF06ooUQz+fYNOBntGIn5LfhQ3iWImkH4pUVOhUbbNsJdciTDZQkvIDNsvCOYvRDPPzR5/ybpYuqMK0AAVVUdjSiuPxV6KXo/wGqAqTMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884312; c=relaxed/simple;
	bh=F5qI3hBsAH1fsmTg9isPD+Y9U+Ku46gSuSJ49oxeUHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPP22akwhgPau3bM6+PKcjnmsLukqIoFvo35uyb53Gh51nTtgYxxQYMPT+pvk3lVQ4BoVuG1gYAJTK23gK4luh2vm7VsxOeXWiPqmLpcUx6MLHVm8lRem6olyygp7+i2i5MVBPMPRoTj3Q4J/szg1pzvAtlJSbKu5IAgG6CELuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P/pCYt2o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P/pCYt2o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E85C4CEF1;
	Tue, 16 Dec 2025 11:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884312;
	bh=F5qI3hBsAH1fsmTg9isPD+Y9U+Ku46gSuSJ49oxeUHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P/pCYt2oXn92Nzbfxf0hrZdx2z3zvZuu1KoLG8YIfH+y5to01VA12t3rIg3olA6CG
	 v2dyCmve9qiblm1P/hv7Kl7eTMigasq1hxxY7SaEctSKvQ2zyDjwGUMrzZGHfJ5Bj3
	 YQDsOzuuQfSXhJDATMW5mJRbagF4vMoSjYYxjdM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.hwang@linux.dev>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 155/354] bpf: Free special fields when update [lru_,]percpu_hash maps
Date: Tue, 16 Dec 2025 12:12:02 +0100
Message-ID: <20251216111326.531120025@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Hwang <leon.hwang@linux.dev>

[ Upstream commit 6af6e49a76c9af7d42eb923703e7648cb2bf401a ]

As [lru_,]percpu_hash maps support BPF_KPTR_{REF,PERCPU}, missing
calls to 'bpf_obj_free_fields()' in 'pcpu_copy_value()' could cause the
memory referenced by BPF_KPTR_{REF,PERCPU} fields to be held until the
map gets freed.

Fix this by calling 'bpf_obj_free_fields()' after
'copy_map_value[,_long]()' in 'pcpu_copy_value()'.

Fixes: 65334e64a493 ("bpf: Support kptrs in percpu hashmap and percpu LRU hashmap")
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20251105151407.12723-2-leon.hwang@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/hashtab.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 570e2f7231443..26883a997e717 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -961,15 +961,21 @@ static void free_htab_elem(struct bpf_htab *htab, struct htab_elem *l)
 static void pcpu_copy_value(struct bpf_htab *htab, void __percpu *pptr,
 			    void *value, bool onallcpus)
 {
+	void *ptr;
+
 	if (!onallcpus) {
 		/* copy true value_size bytes */
-		copy_map_value(&htab->map, this_cpu_ptr(pptr), value);
+		ptr = this_cpu_ptr(pptr);
+		copy_map_value(&htab->map, ptr, value);
+		bpf_obj_free_fields(htab->map.record, ptr);
 	} else {
 		u32 size = round_up(htab->map.value_size, 8);
 		int off = 0, cpu;
 
 		for_each_possible_cpu(cpu) {
-			copy_map_value_long(&htab->map, per_cpu_ptr(pptr, cpu), value + off);
+			ptr = per_cpu_ptr(pptr, cpu);
+			copy_map_value_long(&htab->map, ptr, value + off);
+			bpf_obj_free_fields(htab->map.record, ptr);
 			off += size;
 		}
 	}
-- 
2.51.0



