Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9841D0F7D;
	Wed,  2 Oct 2024 14:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877989; cv=none; b=UNQcIiuDHFJKqJWnFk1dOUk/rZ5kqqeK4G2L4E5v2BUZubu78vLKjfSTQT06CtdzqtTeJ7b1UT7mzeB4vxAKGz23cdPqVpHU3x4eVst11soVdSv2q0didRCKB2Ko3CLEFN7O+RDPfgeBcNit+iykRix/FAqKNKUrZOGz7warzwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877989; c=relaxed/simple;
	bh=QDftEfFzLeUxTOpZIHmoPAlHRMDqs/Vm+Ndtmcwp1YQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hNbZxFHr2U2vySG+zRyABlQ6SiWvrtXi/F2/X0qBuVIZZCfSOYcYQV8rX6P6JshhJyq032KUelKfGQs6oDW0QaH2o+sDZtRxUk0qTMIq1CkEV5hIeDMHMY7eiNhWOVtqIUGvC/JDvwXml1TTAd2JaOqkEsRZL67WaXna0e8+lXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n7cOw9+s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n7cOw9+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B334AC4CEC2;
	Wed,  2 Oct 2024 14:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877989;
	bh=QDftEfFzLeUxTOpZIHmoPAlHRMDqs/Vm+Ndtmcwp1YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n7cOw9+sOqbOmcT++XnLln20CgXIiHgxoMcAGo+92EWE/HCgs7AwRtw7p1pdaFU9p
	 SbmEuQddeHNfr1KMx/QELGuH3f4C4LuwnXRfUXZuf5iGvY8BoyEAb5urhYDA8qx17F
	 07GQqc8xDaQdsfflksNTASDmggCbZ059kvzymRdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ad9ec60c8eaf69e6f99c@syzkaller.appspotmail.com,
	Eduard Zingerman <eddyz87@gmail.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 236/634] bpf: Fail verification for sign-extension of packet data/data_end/data_meta
Date: Wed,  2 Oct 2024 14:55:36 +0200
Message-ID: <20241002125820.413451072@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

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

Reported-by: syzbot+ad9ec60c8eaf69e6f99c@syzkaller.appspotmail.com
Fixes: 1f1e864b6555 ("bpf: Handle sign-extenstin ctx member accesses")
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20240723153439.2429035-1-yonghong.song@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h   |  1 +
 kernel/bpf/verifier.c |  5 +++--
 net/core/filter.c     | 21 ++++++++++++++++-----
 3 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 42b998518038a..b13af44f20ada 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -919,6 +919,7 @@ static_assert(__BPF_REG_TYPE_MAX <= BPF_BASE_TYPE_LIMIT);
  */
 struct bpf_insn_access_aux {
 	enum bpf_reg_type reg_type;
+	bool is_ldsx;
 	union {
 		int ctx_field_size;
 		struct {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 203ce12e687d2..ed612052fc7ac 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5594,12 +5594,13 @@ static int check_packet_access(struct bpf_verifier_env *env, u32 regno, int off,
 /* check access to 'struct bpf_context' fields.  Supports fixed offsets only */
 static int check_ctx_access(struct bpf_verifier_env *env, int insn_idx, int off, int size,
 			    enum bpf_access_type t, enum bpf_reg_type *reg_type,
-			    struct btf **btf, u32 *btf_id, bool *is_retval)
+			    struct btf **btf, u32 *btf_id, bool *is_retval, bool is_ldsx)
 {
 	struct bpf_insn_access_aux info = {
 		.reg_type = *reg_type,
 		.log = &env->log,
 		.is_retval = false,
+		.is_ldsx = is_ldsx,
 	};
 
 	if (env->ops->is_valid_access &&
@@ -6913,7 +6914,7 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 			return err;
 
 		err = check_ctx_access(env, insn_idx, off, size, t, &reg_type, &btf,
-				       &btf_id, &is_retval);
+				       &btf_id, &is_retval, is_ldsx);
 		if (err)
 			verbose_linfo(env, insn_idx, "; ");
 		if (!err && t == BPF_READ && value_regno >= 0) {
diff --git a/net/core/filter.c b/net/core/filter.c
index 55b1d9de2334d..bbcce4ddfb7bf 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8568,13 +8568,16 @@ static bool bpf_skb_is_valid_access(int off, int size, enum bpf_access_type type
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
@@ -9018,6 +9021,14 @@ static bool xdp_is_valid_access(int off, int size,
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
@@ -9343,12 +9354,12 @@ static bool flow_dissector_is_valid_access(int off, int size,
 
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
2.43.0



