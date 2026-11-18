Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021088;
	b=I4Io/+/bV2h+qM396WfIHsgyzxJzcWMWHGxT3JrKtDQpknmh17y2yKcViBdhWwrBH3WC
	 dusghqe4BFOSjDBIKz0oamJDVcVx99LvJuW+OsBxkUn4b5DAPOvQaw+9Ti5bH6hBw7bDv
	 s6+GTTYtQ+AXzzRrT2vD/H7DQEIUK7M8nHYpag+msGjFH10D12ns91O/wj9tdTvUosqQZ
	 yn1kOUV/iXnH8c0P9dqQCCv8RqjnS/eMnWYpMK+YEl02FCfD7pnX+WCtPzFbBqkJbscNW
	 7uaCyhPyBe2Zeu6uHSrDcw8z7VX3iK5PFSjwN+Wpu8UoR0WGdQ+iT1kk2D67YqSHmxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021088;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mE25ue1c3TcCdaPYeXQk1aXF/OQNGIEu2GOj4g4AGH8=;
	b=FJWudVTxyycBU9rlJ+gJbRJsGP7k62C/izA0pGAGv15OUsCfSNFAe4O9APn1IdF5NU+M
	 wsyzvYicE97HPzcuM291IpOhzPAWvc54wqfmMsocDEbgQ5MboJ4EUaQmX5CsJ71RU2nDh
	 nmMKaIf1gWiCeejjuZj71SHr8wYqn7fwFVe9zru3AoLOTO27lB8Cx765u130Dr7hnU+mG
	 k6oV60T1JdXoovCafZTOzOVisNhYJbpycO1Bkb4U5bpyRyP7FjH/p03QZ1T89xOdTovz1
	 X+/15WaG/A5+6JjC7CCr92xZ9cRA4fyiq29Ix5bFXL9PDq5ClESn+oJeDCp/xkqrojA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g9WcskXZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75D3606A325;
	Wed, 18 Nov 2026 16:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g9WcskXZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D7A1F000C4;
	Wed, 18 Nov 2026 16:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021088;
	bh=mE25ue1c3TcCdaPYeXQk1aXF/OQNGIEu2GOj4g4AGH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g9WcskXZxRIBpCPam0rR1XTJtBwMTKa/FkXoH1g8wX7SijMG/FgLKcXVKpirnFmc8
	 64PKaXNVPSrDwEesfRxMDoFvXVnzPu528R/Nzh2JIJNwMEikxjq9K2rI3tU7DYg/Td
	 +JAiGEzITSbpdXdrf5fhZFVMr7nsZ0Ts3rf7hg/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2181/2651] libbpf: Keep the fd_array fill index out of bpf_program__clone()
Date: Wed, 18 Nov 2026 15:57:01 +0100
Message-ID: <20261118150404.296659748@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit b1eaee8b9a95897a5df843c623aa55d9585cd9d8 ]

bpf_program__clone() hands the kernel the fd_array of the object along
with obj->fd_array_cnt when the caller supplies neither. That counter is
not a count the kernel can use: it is the index of the next free slot
of an array built for the sparse fd_array API, where module BTF fds
start at slot 1 and slot 0 stays empty, since a kfunc insn with offset
0 names vmlinux BTF rather than a slot. A non-zero fd_array_cnt turns
the array into a continuous one, which the kernel resolves slot by
slot, and slot 0 holds 0. Cloning a program from an object that calls a
module kfunc thus fails with "fd 0 is not pointing to valid bpf_map or
btf", for every program of the object, which is what veristat runs into
on such an object. bpf_object__load() passes the array without a count.

Do the same in bpf_program__clone(), leaving the count to callers who
pass an array of their own, and rename the counter to fd_array_used so
that it no longer reads like the uapi field.

Fixes: 970bd2dced35 ("libbpf: Introduce bpf_program__clone()")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Mykyta Yatsenko <yatsenko@meta.com>
Link: https://patch.msgid.link/20261019132203.3034698-4-memxor@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 03daf99224a3f..4c3b79239a270 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -759,7 +759,12 @@ struct bpf_object {
 
 	int *fd_array;
 	size_t fd_array_cap;
-	size_t fd_array_cnt;
+	/*
+	 * Slots handed out so far, slot 0 included. A kfunc insn names a module
+	 * BTF slot through its offset, slot 0 stands for vmlinux BTF and stays
+	 * empty, so the array goes to the kernel without a count.
+	 */
+	size_t fd_array_used;
 
 	struct usdt_manager *usdt_man;
 
@@ -8856,22 +8861,22 @@ static int bpf_object__resolve_ksym_func_btf_id(struct bpf_object *obj,
 	/* set index for module BTF fd in fd_array, if unset */
 	if (mod_btf && !mod_btf->fd_array_idx) {
 		/* insn->off is s16 */
-		if (obj->fd_array_cnt == INT16_MAX) {
+		if (obj->fd_array_used == INT16_MAX) {
 			pr_warn("extern (func ksym) '%s': module BTF fd index %d too big to fit in bpf_insn offset\n",
 				ext->name, mod_btf->fd_array_idx);
 			return -E2BIG;
 		}
 		/* Cannot use index 0 for module BTF fd */
-		if (!obj->fd_array_cnt)
-			obj->fd_array_cnt = 1;
+		if (!obj->fd_array_used)
+			obj->fd_array_used = 1;
 
 		ret = libbpf_ensure_mem((void **)&obj->fd_array, &obj->fd_array_cap, sizeof(int),
-					obj->fd_array_cnt + 1);
+					obj->fd_array_used + 1);
 		if (ret)
 			return ret;
-		mod_btf->fd_array_idx = obj->fd_array_cnt;
+		mod_btf->fd_array_idx = obj->fd_array_used;
 		/* we assume module BTF FD is always >0 */
-		obj->fd_array[obj->fd_array_cnt++] = mod_btf->fd;
+		obj->fd_array[obj->fd_array_used++] = mod_btf->fd;
 	}
 
 	ext->is_set = true;
@@ -10036,7 +10041,7 @@ int bpf_program__clone(struct bpf_program *prog, const struct bpf_prog_load_opts
 	attr.prog_ifindex = OPTS_GET(opts, prog_ifindex, 0) ?: prog->prog_ifindex;
 	attr.kern_version = OPTS_GET(opts, kern_version, 0) ?: obj->kern_version;
 	attr.fd_array = OPTS_GET(opts, fd_array, NULL) ?: obj->fd_array;
-	attr.fd_array_cnt = OPTS_GET(opts, fd_array_cnt, 0) ?: obj->fd_array_cnt;
+	attr.fd_array_cnt = OPTS_GET(opts, fd_array_cnt, 0);
 	attr.token_fd = OPTS_GET(opts, token_fd, 0) ?: obj->token_fd;
 	if (attr.token_fd)
 		attr.prog_flags |= BPF_F_TOKEN_FD;
-- 
2.53.0



