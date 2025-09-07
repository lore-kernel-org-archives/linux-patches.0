Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A31F1CDFAC;
	Sun,  7 Sep 2025 20:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275991; cv=none; b=D7TjBmHInTtBWl5fhgDUuh4BvXHncdb1i9znb82K7ACSlrxNTIvGkyUF5pfo40giNvwYlCV3PBmtMUvbvUvXmhzgyI54VRiEFYmscGJ28c28dOi6rMhqldXqjE4DRt5NogE9Na8/sOiy/a7jkiqv9VyoI6JEldxCxNSWLk09bJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275991; c=relaxed/simple;
	bh=brAl6CDQW3vAzOmU76K1DoevL2m3PJIL4pX25Fdh/gU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DvPXcWI93xFNQ8OtsZdKt5WckKpNzO0Y8vo2lRBk6AZynAMO/f+aWgQYy+fRsm5QM9YCjZY2H2ZgEuZWfeiL7wfQxuYQCFIktMC86zMBGHSWQf3QuBIQiBtrXwYnTd+fI6cWlMtKzvcfLZeq6VdB7TODy7ePAhdTQPWi8Ty7riE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JDSGRYjM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JDSGRYjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C8DC4CEF0;
	Sun,  7 Sep 2025 20:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275990;
	bh=brAl6CDQW3vAzOmU76K1DoevL2m3PJIL4pX25Fdh/gU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JDSGRYjMA3lO9dBH4NcwxQ4i3U9UrPnb4VH2bsYC2y9yt8YCEi0dnDYUTKdOU0ZSb
	 RyPpSRj8LhCjmUwXMWZuTDklUF+AbhfcnOhhBBQ7nvluSPc77lfXS28wf0Tjn18Tuv
	 JdZvz+zmJ0Lfx1pzUhaLu0coj1lenLKpNa1EX4hA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lonial Con <kongln9170@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 04/64] bpf: Fix oob access in cgroup local storage
Date: Sun,  7 Sep 2025 21:57:46 +0200
Message-ID: <20250907195603.518574121@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195603.394640159@linuxfoundation.org>
References: <20250907195603.394640159@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ea6728c304fe0..1046f290b4b2b 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -256,6 +256,7 @@ struct bpf_map_owner {
 	enum bpf_prog_type type;
 	bool jited;
 	bool xdp_has_frags;
+	u64 storage_cookie[MAX_BPF_CGROUP_STORAGE_TYPE];
 	const struct btf_type *attach_func_proto;
 };
 
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index aa3487e244549..73a1c66e54175 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1837,7 +1837,9 @@ static bool __bpf_prog_map_compatible(struct bpf_map *map,
 {
 	enum bpf_prog_type prog_type = fp->aux->dst_prog ? fp->aux->dst_prog->type : fp->type;
 	struct bpf_prog_aux *aux = fp->aux;
+	enum bpf_cgroup_storage_type i;
 	bool ret = false;
+	u64 cookie;
 
 	if (fp->kprobe_override)
 		return ret;
@@ -1853,12 +1855,25 @@ static bool __bpf_prog_map_compatible(struct bpf_map *map,
 		/* Note: xdp_has_frags doesn't exist in aux yet in our branch */
 		/* map->owner->xdp_has_frags = aux->xdp_has_frags; */
 		map->owner->attach_func_proto = aux->attach_func_proto;
+		for_each_cgroup_storage_type(i) {
+			map->owner->storage_cookie[i] =
+				aux->cgroup_storage[i] ?
+				aux->cgroup_storage[i]->cookie : 0;
+		}
 		ret = true;
 	} else {
 		ret = map->owner->type  == prog_type &&
 		      map->owner->jited == fp->jited;
 		/* Note: xdp_has_frags check would go here when available */
 		/* && map->owner->xdp_has_frags == aux->xdp_has_frags; */
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



