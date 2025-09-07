Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561C614BFA2;
	Sun,  7 Sep 2025 20:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276147; cv=none; b=XMGwwvB2szLPSh1OhAW1hQVM4JvkYwadcRk+vybhqB3JVDqr5kFY/Y6W/CLQbzAXCoE5MN5L2rU7tSsNWEb3lht/FFTXt7W7OVkeyU/h3ODWPNPwR1+dSm9yIt1P4vcF+W0DP+eGO8SkZ+ZFSc18m3dJ5+LU+jr7ez4XIZ6/OjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276147; c=relaxed/simple;
	bh=ccQsytNI8b4yWNO5J+GOvI9dzpBwoagwE7CI7JUvC9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvE/UNU87Xsp8mKagGa1OXj6PEkus6gM22/K0EtzJ9IzESzjxzhMm4m60t63IaCCzLFd3WXsy7CVDqOBm7Q1lWaEBZNV9UqF0h32qJyFEeL3jgQWRN89nMluce6IlYYRn9rU6j1++xe/xrAzp3XBM/SHshBl18zfulNfD6UPzDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQ6l4FJw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQ6l4FJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6A4C4CEF0;
	Sun,  7 Sep 2025 20:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276147;
	bh=ccQsytNI8b4yWNO5J+GOvI9dzpBwoagwE7CI7JUvC9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQ6l4FJwJc5/9WGFgyTeT4HNDrqXyyvTXYbSOzE2ELayWMAjq3uPen+pw2H/QPfi8
	 s6J2D9KzaOBaRl/Rq+loB1JUMIahLjMbmrkpw/yqA9pwQEEEYgqEuk8AHIogroSjMi
	 Aoh58B/xwPZYanT6zVVmSvPxtxrIm4knyrBtbJ5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lonial Con <kongln9170@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/104] bpf: Fix oob access in cgroup local storage
Date: Sun,  7 Sep 2025 21:57:21 +0200
Message-ID: <20250907195607.783002773@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit abad3d0bad72a52137e0c350c59542d75ae4f513 ]

Lonial reported that an out-of-bounds access in cgroup local storage
can be crafted via tail calls. Given two programs each utilizing a
cgroup local storage with a different value size, and one program
doing a tail call into the other. The verifier will validate each of
the indivial programs just fine. However, in the runtime context
the bpf_cg_run_ctx holds an bpf_prog_array_item which contains the
BPF program as well as any cgroup local storage flavor the program
uses. Helpers such as bpf_get_local_storage() pick this up from the
runtime context:

  ctx = container_of(current->bpf_ctx, struct bpf_cg_run_ctx, run_ctx);
  storage = ctx->prog_item->cgroup_storage[stype];

  if (stype == BPF_CGROUP_STORAGE_SHARED)
    ptr = &READ_ONCE(storage->buf)->data[0];
  else
    ptr = this_cpu_ptr(storage->percpu_buf);

For the second program which was called from the originally attached
one, this means bpf_get_local_storage() will pick up the former
program's map, not its own. With mismatching sizes, this can result
in an unintended out-of-bounds access.

To fix this issue, we need to extend bpf_map_owner with an array of
storage_cookie[] to match on i) the exact maps from the original
program if the second program was using bpf_get_local_storage(), or
ii) allow the tail call combination if the second program was not
using any of the cgroup local storage maps.

Fixes: 7d9c3427894f ("bpf: Make cgroup storages shared between programs on the same cgroup")
Reported-by: Lonial Con <kongln9170@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20250730234733.530041-4-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h |  1 +
 kernel/bpf/core.c   | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 8f11c61606839..5f01845627d49 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -226,6 +226,7 @@ struct bpf_map_owner {
 	enum bpf_prog_type type;
 	bool jited;
 	bool xdp_has_frags;
+	u64 storage_cookie[MAX_BPF_CGROUP_STORAGE_TYPE];
 	const struct btf_type *attach_func_proto;
 };
 
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index d4eb6d9f276a5..3136af6559a82 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2121,7 +2121,9 @@ bool bpf_prog_map_compatible(struct bpf_map *map,
 {
 	enum bpf_prog_type prog_type = resolve_prog_type(fp);
 	struct bpf_prog_aux *aux = fp->aux;
+	enum bpf_cgroup_storage_type i;
 	bool ret = false;
+	u64 cookie;
 
 	if (fp->kprobe_override)
 		return ret;
@@ -2136,11 +2138,24 @@ bool bpf_prog_map_compatible(struct bpf_map *map,
 		map->owner->jited = fp->jited;
 		map->owner->xdp_has_frags = aux->xdp_has_frags;
 		map->owner->attach_func_proto = aux->attach_func_proto;
+		for_each_cgroup_storage_type(i) {
+			map->owner->storage_cookie[i] =
+				aux->cgroup_storage[i] ?
+				aux->cgroup_storage[i]->cookie : 0;
+		}
 		ret = true;
 	} else {
 		ret = map->owner->type  == prog_type &&
 		      map->owner->jited == fp->jited &&
 		      map->owner->xdp_has_frags == aux->xdp_has_frags;
+		for_each_cgroup_storage_type(i) {
+			if (!ret)
+				break;
+			cookie = aux->cgroup_storage[i] ?
+				 aux->cgroup_storage[i]->cookie : 0;
+			ret = map->owner->storage_cookie[i] == cookie ||
+			      !cookie;
+		}
 		if (ret &&
 		    map->owner->attach_func_proto != aux->attach_func_proto) {
 			switch (prog_type) {
-- 
2.50.1



