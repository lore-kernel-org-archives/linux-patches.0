Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F6A46E00C;
	Tue, 21 Jul 2026 19:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662105; cv=none; b=FSxEqQbTviDVL7kPatoKdn5yOfXKAy9/1WDPErCxjJhGiRHrcWDiaPpJbtGjfIWxBgOEVZqJx2BMHPzSCL1o3Ka+w+pq5EpXg8Ro43QV+oNYgAO1QzQKVb08sFxe/eVLfOfmP373o7ousDxPVcumDWaCy1LNMPyx1yYHipfB7Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662105; c=relaxed/simple;
	bh=PboyLa8tfi7UCOOiMBUEYc5Jqg4U1fvTmWaFd49/PtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p0sjV/SStxwUIndPaQVLCEPcEcifvzULwwTQghrap+xgJiy7eNRjce2ceomF6eU+Usqoa1rlrLDy++FdtTNBRmNK6/LlVp9GxpQV8DX6RIZRpLFysekGPjU5aKpCPkPmLOPChwwFLb/oWTJQefFis3TZcQoUtl5s1ZccKNH49H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mqv/BXE2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mqv/BXE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E6B1F00A3D;
	Tue, 21 Jul 2026 19:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662100;
	bh=DoaXmVgbzxDQ2o5rTA5jRc1GVBdPi9N7VUt0OQu5IbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mqv/BXE2TuzLcOgTG5OkpLtdQxDorw+XTTbuW44qiL26fop1v7bbLTQ5idfsm1TQr
	 VfHWM5YALMgwWXHaxiOZOxYXaARFLB8MOObeIqUe73DPZAPAjenFGSyciH3xc7EQBu
	 nQY56fMk2hAZfrEzOQK4FLPpnGRabRwg8/gC+jNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <malin89@huawei.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0315/1276] bpf: Tighten cgroup storage cookie checks for prog arrays
Date: Tue, 21 Jul 2026 17:12:38 +0200
Message-ID: <20260721152453.149167966@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 10627ddc0167aab5c1c390a10ef461e9937aba08 ]

The fix in commit abad3d0bad72 ("bpf: Fix oob access in cgroup local
storage") is still incomplete. The prog-array compatibility check
treats a program with no cgroup storage as compatible with any stored
storage cookie. This allows a storage-less program to bridge a tail
call chain between an entry program and a storage-using callee even
though cgroup local storage at runtime still follows the caller's
context, that is, A -> B(no storage) -> C(storage) path.

Requiring exact cookie equality would break the legitimate case of a
storage-less leaf program being tail called from a storage-using one.
Instead, only accept a zero storage cookie if the program cannot
perform tail calls itself. This keeps A -> B(no storage) working
while rejecting the A -> B(no storage) -> C(storage) bridge.

Fixes: abad3d0bad72 ("bpf: Fix oob access in cgroup local storage")
Reported-by: Lin Ma <malin89@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20260610105539.705887-1-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index d9131b235f7974..5cf8cdea0743b5 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2433,7 +2433,7 @@ static bool __bpf_prog_map_compatible(struct bpf_map *map,
 			cookie = aux->cgroup_storage[i] ?
 				 aux->cgroup_storage[i]->cookie : 0;
 			ret = map->owner->storage_cookie[i] == cookie ||
-			      !cookie;
+			      (!cookie && !aux->tail_call_reachable);
 		}
 		if (ret &&
 		    map->owner->attach_func_proto != aux->attach_func_proto) {
-- 
2.53.0



