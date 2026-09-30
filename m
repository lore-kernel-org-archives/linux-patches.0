Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0397E4DDB2D;
	Wed, 30 Sep 2026 19:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797121; cv=none; b=MsSJGgQTQ9C00LDinIFFOL58IW64wiPTEo63pIQpir/7G21gbrC7TQYyurN55Jyc++HDcW07jbYkbB3Es0iJZ7rT2s7q4mqVUVgl7IqHKNTJaZApmRghBVZGu7il68JlHgXc5MWrwAdf5lzbaXR299Nr3RS61AbPWj9MBnhZw1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797121; c=relaxed/simple;
	bh=0FZGXjIYq3Zr8YIApH+dzN4oI8DclDLq5VJHqwUXOs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTvyAbbKWk9XND4fO4ZMVDFPOpG/tqtVy20ufh+P9nHkShceXUc8vDjM7XvLwmZBGEX2kjVgRUI0gJTJwXnqCRO5fDt8XlcA/nMFiSVaI6U+8LwrFSMmZKle/Bj6Wedk2RvKMw1vz+CES1FBimxG+CFCmNi78QdCO+lnfmIjtA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t3GMdGi1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t3GMdGi1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649F21F000FF;
	Wed, 30 Sep 2026 19:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797119;
	bh=+cgY4pdkLPlL2QmLjwPNpMI3RzxtQ3JAKJiSr3yfJgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t3GMdGi1Nam6LQkfy9sCuuLTcD9aIXEwNNHZKbCKUhVGluO4jZJIpvR2ptsdeCZle
	 aST4wsgJrFOYmHbn1fA1g9j9/nTN+Ik8mNpuwj3a8goH1naU5tsnHWjSQAcqav9pkt
	 tpEDSIoFde7AdpwHFZEovgzl1D6Z1tTqIbeeQe5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ad9ec60c8eaf69e6f99c@syzkaller.appspotmail.com,
	Eduard Zingerman <eddyz87@gmail.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1155/1193] bpf: Fail verification for sign-extension of packet data/data_end/data_meta
Date: Wed, 30 Sep 2026 17:30:39 +0200
Message-ID: <20260930152459.903056430@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonghong Song <yonghong.song@linux.dev>

[ Upstream commit 92de36080c93296ef9005690705cba260b9bd68a ]

syzbot reported a kernel crash due to
  commit 1f1e864b6555 ("bpf: Handle sign-extenstin ctx member accesses").
The reason is due to sign-extension of 32-bit load for
packet data/data_end/data_meta uapi field.

The original code looks like:
        r2 = *(s32 *)(r1 + 76) /* load __sk_buff->data */
        r3 = *(u32 *)(r1 + 80) /* load __sk_buff->data_end */
        r0 = r2
        r0 += 8
        if r3 > r0 goto +1
        ...
Note that __sk_buff->data load has 32-bit sign extension.

After verification and convert_ctx_accesses(), the final asm code looks like:
        r2 = *(u64 *)(r1 +208)
        r2 = (s32)r2
        r3 = *(u64 *)(r1 +80)
        r0 = r2
        r0 += 8
        if r3 > r0 goto pc+1
        ...
Note that 'r2 = (s32)r2' may make the kernel __sk_buff->data address invalid
which may cause runtime failure.

Currently, in C code, typically we have
        void *data = (void *)(long)skb->data;
        void *data_end = (void *)(long)skb->data_end;
        ...
and it will generate
        r2 = *(u64 *)(r1 +208)
        r3 = *(u64 *)(r1 +80)
        r0 = r2
        r0 += 8
        if r3 > r0 goto pc+1

If we allow sign-extension,
        void *data = (void *)(long)(int)skb->data;
        void *data_end = (void *)(long)skb->data_end;
        ...
the generated code looks like
        r2 = *(u64 *)(r1 +208)
        r2 <<= 32
        r2 s>>= 32
        r3 = *(u64 *)(r1 +80)
        r0 = r2
        r0 += 8
        if r3 > r0 goto pc+1
and this will cause verification failure since "r2 <<= 32" is not allowed
as "r2" is a packet pointer.

To fix this issue for case
  r2 = *(s32 *)(r1 + 76) /* load __sk_buff->data */
this patch added additional checking in is_valid_access() callback
function for packet data/data_end/data_meta access. If those accesses
are with sign-extenstion, the verification will fail.

  [1] https://lore.kernel.org/bpf/000000000000c90eee061d236d37@google.com/

[ Backport to 6.6.y: implemented the packet-field check without the newer
  is_retval verifier API. ]

Reported-by: syzbot+ad9ec60c8eaf69e6f99c@syzkaller.appspotmail.com
Fixes: 1f1e864b6555 ("bpf: Handle sign-extenstin ctx member accesses")
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20240723153439.2429035-1-yonghong.song@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h   |  1 +
 kernel/bpf/verifier.c |  5 +++--
 net/core/filter.c     | 21 ++++++++++++++++-----
 3 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 5b58c95dbf192..19aa8a5257884 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -930,6 +930,7 @@ static_assert(__BPF_REG_TYPE_MAX <= BPF_BASE_TYPE_LIMIT);
  */
 struct bpf_insn_access_aux {
 	enum bpf_reg_type reg_type;
+	bool is_ldsx;
 	union {
 		int ctx_field_size;
 		struct {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 13d66523f8428..778a68bfb91dd 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5664,11 +5664,12 @@ static int check_packet_access(struct bpf_verifier_env *env, u32 regno, int off,
 /* check access to 'struct bpf_context' fields.  Supports fixed offsets only */
 static int check_ctx_access(struct bpf_verifier_env *env, int insn_idx, int off, int size,
 			    enum bpf_access_type t, enum bpf_reg_type *reg_type,
-			    struct btf **btf, u32 *btf_id)
+			    struct btf **btf, u32 *btf_id, bool is_ldsx)
 {
 	struct bpf_insn_access_aux info = {
 		.reg_type = *reg_type,
 		.log = &env->log,
+		.is_ldsx = is_ldsx,
 	};
 
 	if (env->ops->is_valid_access &&
@@ -6917,7 +6918,7 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 			return err;
 
 		err = check_ctx_access(env, insn_idx, off, size, t, &reg_type, &btf,
-				       &btf_id);
+				       &btf_id, is_ldsx);
 		if (err)
 			verbose_linfo(env, insn_idx, "; ");
 		if (!err && t == BPF_READ && value_regno >= 0) {
diff --git a/net/core/filter.c b/net/core/filter.c
index 7fa77ae230edc..3f5c21f783773 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8632,13 +8632,16 @@ static bool bpf_skb_is_valid_access(int off, int size, enum bpf_access_type type
 		if (off + size > offsetofend(struct __sk_buff, cb[4]))
 			return false;
 		break;
+	case bpf_ctx_range(struct __sk_buff, data):
+	case bpf_ctx_range(struct __sk_buff, data_meta):
+	case bpf_ctx_range(struct __sk_buff, data_end):
+		if (info->is_ldsx || size != size_default)
+			return false;
+		break;
 	case bpf_ctx_range_till(struct __sk_buff, remote_ip6[0], remote_ip6[3]):
 	case bpf_ctx_range_till(struct __sk_buff, local_ip6[0], local_ip6[3]):
 	case bpf_ctx_range_till(struct __sk_buff, remote_ip4, remote_ip4):
 	case bpf_ctx_range_till(struct __sk_buff, local_ip4, local_ip4):
-	case bpf_ctx_range(struct __sk_buff, data):
-	case bpf_ctx_range(struct __sk_buff, data_meta):
-	case bpf_ctx_range(struct __sk_buff, data_end):
 		if (size != size_default)
 			return false;
 		break;
@@ -9082,6 +9085,14 @@ static bool xdp_is_valid_access(int off, int size,
 			}
 		}
 		return false;
+	} else {
+		switch (off) {
+		case offsetof(struct xdp_md, data_meta):
+		case offsetof(struct xdp_md, data):
+		case offsetof(struct xdp_md, data_end):
+			if (info->is_ldsx)
+				return false;
+		}
 	}
 
 	switch (off) {
@@ -9414,12 +9425,12 @@ static bool flow_dissector_is_valid_access(int off, int size,
 
 	switch (off) {
 	case bpf_ctx_range(struct __sk_buff, data):
-		if (size != size_default)
+		if (info->is_ldsx || size != size_default)
 			return false;
 		info->reg_type = PTR_TO_PACKET;
 		return true;
 	case bpf_ctx_range(struct __sk_buff, data_end):
-		if (size != size_default)
+		if (info->is_ldsx || size != size_default)
 			return false;
 		info->reg_type = PTR_TO_PACKET_END;
 		return true;
-- 
2.53.0



