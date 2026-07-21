Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EECF46A5E7;
	Tue, 21 Jul 2026 15:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649048; cv=none; b=Y2wqUojLKzEznBgxuI61ovhgx7PiCY4Ij4VwYPftiEBKG5K8FUjnTdcm6k+lz8fFfEm/mK77qESVOBTww2n4kmJWnIGz4C5ULZ3P49Qlzmdjmje/I5zOO7Cs+epk4viahIj/Ipok8FhYV3JW6swdEzUyGBUSyqhP+EigpP5hC3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649048; c=relaxed/simple;
	bh=MTYmdZJn/nncqu5kJ+VcHnIQQW01h6nBr2H9mr740tE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lm2rD6OAlwpBq4oHDiQNP+TcwnFfDuCcHxZt77UwmTstWymOI1RREVx2/ch9uOReoFc7FUwvlscdd3KC2W1aXcXUzQX1F0Q/7SMM3XDrRAvTXiXyXt9pM6ofSVxUjCLEOuw6XSKHTL94fbH+82/vtM2hagf2Bn1X+O3EjAcx5aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PspHzpj5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PspHzpj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857331F000E9;
	Tue, 21 Jul 2026 15:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649047;
	bh=CyxAgYcqo1imL+WmLUn7z6N6Dm4CuJC8y3sx0gjZ6sE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PspHzpj50dERZtRgRN94WhADI0eBNR8ydQWdjyf5fXuvWJvgm0xMxhKpmKD0MwkD3
	 uYJ9UhvrEsvLNVu8MUbbO345Er7DPtzsuG6qCxl4D1sgyQ5U97Gg9U4mpoQVS8maJ6
	 Lgkt5supnCd89/yQVqZJ2TNmw1jiIzzeiTXJ0MqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	KP Singh <kpsingh@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0430/2077] libbpf: Reject non-exclusive metadata maps in the signed loader
Date: Tue, 21 Jul 2026 17:01:43 +0200
Message-ID: <20260721152602.890110701@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: KP Singh <kpsingh@kernel.org>

[ Upstream commit 0fb6c9ed6493b4af01be8bb0a384574eba7df636 ]

The loader verifies map->sha against the metadata hash in its
instructions. map->sha is calculated when BPF_OBJ_GET_INFO_BY_FD is
called on the frozen map.

While the map is frozen, the /signed loader/ must also ensure the map
is exclusive, as, without exclusivity (which a hostile host could just
omit when loading the loader), another BPF program with map access can
mutate the contents afterwards, so the check passes on stale data.

With the extra check as part of the signed loader, it now refuses to
move on with map->sha validation if the host set it up wrongly.

Fixes: fb2b0e290147 ("libbpf: Update light skeleton for signing")
Signed-off-by: KP Singh <kpsingh@kernel.org>
Co-developed-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20260601150248.394863-4-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h        |  1 +
 kernel/bpf/syscall.c       |  7 +++++++
 tools/lib/bpf/gen_loader.c | 17 +++++++++++++++++
 3 files changed, 25 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index cd191c5fdb0a5e..487f4653d8a669 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -295,6 +295,7 @@ struct bpf_map_owner {
 
 struct bpf_map {
 	u8 sha[SHA256_DIGEST_SIZE];
+	u32 excl;
 	const struct bpf_map_ops *ops;
 	struct bpf_map *inner_map_meta;
 #ifdef CONFIG_SECURITY
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index d1274486a564ee..2edda1844ec7fd 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1572,6 +1572,13 @@ static int map_create(union bpf_attr *attr, bpfptr_t uattr)
 			err = -EFAULT;
 			goto free_map;
 		}
+
+		/* See libbpf: emit_signature_match() */
+		BUILD_BUG_ON(offsetof(struct bpf_map, excl) != SHA256_DIGEST_SIZE);
+		BUILD_BUG_ON(!__same_type(map->excl, u32));
+		BUILD_BUG_ON(offsetof(struct bpf_map, sha)  != 0);
+		BUILD_BUG_ON(!__same_type(map->sha, u8[SHA256_DIGEST_SIZE]));
+		map->excl = 1;
 	} else if (attr->excl_prog_hash_size) {
 		err = -EINVAL;
 		goto free_map;
diff --git a/tools/lib/bpf/gen_loader.c b/tools/lib/bpf/gen_loader.c
index e63a01101e2d85..91790dc82eb6c8 100644
--- a/tools/lib/bpf/gen_loader.c
+++ b/tools/lib/bpf/gen_loader.c
@@ -585,6 +585,23 @@ static void emit_signature_match(struct bpf_gen *gen)
 	__s64 off;
 	int i;
 
+	/*
+	 * Reject if the metadata map is not exclusive. Without exclusivity
+	 * the cached map->sha[] verified above can be stale: another BPF
+	 * program with map access could have mutated the contents between
+	 * BPF_OBJ_GET_INFO_BY_FD and loader execution.
+	 */
+	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_1, BPF_PSEUDO_MAP_IDX,
+					 0, 0, 0, 0));
+	emit(gen, BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, SHA256_DIGEST_LENGTH));
+	off = -(gen->insn_cur - gen->insn_start - gen->cleanup_label) / 8 - 2;
+	if (is_simm16(off)) {
+		emit(gen, BPF_MOV64_IMM(BPF_REG_7, -EINVAL));
+		emit(gen, BPF_JMP_IMM(BPF_JNE, BPF_REG_2, 1, off));
+	} else {
+		gen->error = -ERANGE;
+	}
+
 	for (i = 0; i < SHA256_DWORD_SIZE; i++) {
 		emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_1, BPF_PSEUDO_MAP_IDX,
 						 0, 0, 0, 0));
-- 
2.53.0



