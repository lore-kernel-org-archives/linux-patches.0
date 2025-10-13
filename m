Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A225B3081AA;
	Mon, 13 Oct 2025 14:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367445; cv=none; b=dUJzc3LNeomXU0ew4sGhFvomfeB239PUE/YJhwTGtnqvyQgMcks07R9QcvFmsFWM2GfaexuYIYyIgo03pKz3PFF5ByIiNBaM06GyfzhkU5eJiUi3ncA8gRPpPn4QOz4wxCZBeXf/eA7zE8TOyuIy6JX/8AhpOyWZ+ApplWghEmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367445; c=relaxed/simple;
	bh=pIdHAC2T6E5pCn+CFIxlcndPeLQvhEM9G6Ny+PZfvBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2tsfZh2vf6lz5pPTHrlg036o/Wk2/3+CEtA9dlhjFevrIg1zUYjBqeyNdWWhBN5cnVezyNI4/Ivc66rGrS+3BSJ4nvkFJtvZIQPuSXQZfgBfGKGZrZXUNlkTELNs170YbrHUjPd1G+EK4bWyeGKjYwK5gHI3JVFxKEHIMpCInY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZ6zmeaW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZ6zmeaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D6D6C4CEE7;
	Mon, 13 Oct 2025 14:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367445;
	bh=pIdHAC2T6E5pCn+CFIxlcndPeLQvhEM9G6Ny+PZfvBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DZ6zmeaWem3KSz7gjBAaYZu8LC1hMFJ+7hpyv6hG4poBe9tE56SjzOLQFhosp/Y/I
	 6JUYgYP2ViG1QST4BaycRmfxKw81Dmtb4nWTtF598uZOS+jfKon2oWptJzQ+WqJzAV
	 aMB+KZLlv9S0fBOV1to0sGFgGrbUNlMmcSapx/Tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yureka Lilian <yuka@yuka.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/196] libbpf: Fix reuse of DEVMAP
Date: Mon, 13 Oct 2025 16:43:26 +0200
Message-ID: <20251013144315.748225451@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

From: Yureka Lilian <yuka@yuka.dev>

[ Upstream commit 6c6b4146deb12d20f42490d5013f2043df942161 ]

Previously, re-using pinned DEVMAP maps would always fail, because
get_map_info on a DEVMAP always returns flags with BPF_F_RDONLY_PROG set,
but BPF_F_RDONLY_PROG being set on a map during creation is invalid.

Thus, ignore the BPF_F_RDONLY_PROG flag in the flags returned from
get_map_info when checking for compatibility with an existing DEVMAP.

The same problem is handled in a third-party ebpf library:
- https://github.com/cilium/ebpf/issues/925
- https://github.com/cilium/ebpf/pull/930

Fixes: 0cdbb4b09a06 ("devmap: Allow map lookups from eBPF")
Signed-off-by: Yureka Lilian <yuka@yuka.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250814180113.1245565-3-yuka@yuka.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index aefbfa2df6207..95f2ffefff3ff 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5013,6 +5013,16 @@ static bool map_is_reuse_compat(const struct bpf_map *map, int map_fd)
 		return false;
 	}
 
+	/*
+	 * bpf_get_map_info_by_fd() for DEVMAP will always return flags with
+	 * BPF_F_RDONLY_PROG set, but it generally is not set at map creation time.
+	 * Thus, ignore the BPF_F_RDONLY_PROG flag in the flags returned from
+	 * bpf_get_map_info_by_fd() when checking for compatibility with an
+	 * existing DEVMAP.
+	 */
+	if (map->def.type == BPF_MAP_TYPE_DEVMAP || map->def.type == BPF_MAP_TYPE_DEVMAP_HASH)
+		map_info.map_flags &= ~BPF_F_RDONLY_PROG;
+
 	return (map_info.type == map->def.type &&
 		map_info.key_size == map->def.key_size &&
 		map_info.value_size == map->def.value_size &&
-- 
2.51.0



