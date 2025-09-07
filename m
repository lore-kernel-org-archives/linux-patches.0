Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620AC189BB0;
	Sun,  7 Sep 2025 20:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276924; cv=none; b=cjvmAMfk80576INFs8O3/wGapNCpjfWuQ3yJLdJulrezLtNP/9fkfsho6MpreIDVrv6U7Eewhip5hnhovqkm+sinqGioOfgP72lICe8t50OKLhPCw13nkEZpG0OWSGngvWZN1po6DpCg10r8KHDXKZj5lzy7W53qQ0lLvGHRr+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276924; c=relaxed/simple;
	bh=ax1eyZY/qyVhBgIgKpJka917ftvcETQxR5R+4pmf65Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W62jp8osWzDfwNrvrPd/Mav13Q9evV1S9gKNfAlNwlI84VRlFbzyP+w1j8kR2TogO10NPzXQ7XcwupUJyYxaZRxOt3+0ayg3ROP4pqltdP5rr7yYwmVdJr5UU4H28nnb+OVVIOCRmDB0AtMbvaEb7yZzLV2MtbH6f9l9QvkmZ4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pjQVgJLp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pjQVgJLp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBCEBC4CEF0;
	Sun,  7 Sep 2025 20:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276924;
	bh=ax1eyZY/qyVhBgIgKpJka917ftvcETQxR5R+4pmf65Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pjQVgJLp/zdYyPqV9fJZRXt05UFQFKMG27mI+q0mZY73TjnAeSAxEcdenw5b0ut4Q
	 I9kjVzqJdD8qpWqNWVaE5lEAIxt17A6okykiPE9078VeWfGrrwWs/KRA9b+y/PVpE2
	 pN+gTsj7He/qgd3tnv+GCqtuDDcxWVvHZFTopKUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lonial Con <kongln9170@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/175] bpf: Fix oob access in cgroup local storage
Date: Sun,  7 Sep 2025 21:56:39 +0200
Message-ID: <20250907195614.994100396@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fa79393e41f82..6db72c66de91d 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -279,6 +279,7 @@ struct bpf_map_owner {
 	enum bpf_prog_type type;
 	bool jited;
 	bool xdp_has_frags;
+	u64 storage_cookie[MAX_BPF_CGROUP_STORAGE_TYPE];
 	const struct btf_type *attach_func_proto;
 };
 
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 0e2daea7e1efc..6f91e3a123e55 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2311,7 +2311,9 @@ static bool __bpf_prog_map_compatible(struct bpf_map *map,
 {
 	enum bpf_prog_type prog_type = resolve_prog_type(fp);
 	struct bpf_prog_aux *aux = fp->aux;
+	enum bpf_cgroup_storage_type i;
 	bool ret = false;
+	u64 cookie;
 
 	if (fp->kprobe_override)
 		return ret;
@@ -2326,11 +2328,24 @@ static bool __bpf_prog_map_compatible(struct bpf_map *map,
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



