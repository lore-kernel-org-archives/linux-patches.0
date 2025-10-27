Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A30219F48D;
	Mon, 27 Oct 2025 18:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590991; cv=none; b=nbnpe26kvZmefVNQVIc/NPe69EL4+i+zkq1t/OQRuLn3FYN+LAH7M8Fem55MwqEWfdXVoANlO6I1EvNofru18/KPVdK37i4R47z+KidlQMljksCs8+cU4U00P2ZdyOB9ciDhEfnKlBNTUI7H8d/Jr7KxH1QABBei8eLlehenN0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590991; c=relaxed/simple;
	bh=AeQaph7P9o29sBwaHrJJZpp3YDHCPS42MO38139VTag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGCzkI4OK87BWBjdFlDPQ4OSVspxr1CMevBADqmvh5OVla/gbFNseDof3LXTyiJhIVUFw3IScX87qsbUS63mgaf9+YsxFlHv9D2xfKG6DdpFK4eJJq/moI/YdO16qH9nrE7fkQSmydH9frwm8nGXvx2zCOmVO0b9ob0ueAF7uHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N5gPRZYJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N5gPRZYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230BCC4CEF1;
	Mon, 27 Oct 2025 18:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590990;
	bh=AeQaph7P9o29sBwaHrJJZpp3YDHCPS42MO38139VTag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N5gPRZYJsaNu1W5lpP0dMsViIjFo2a2ixK0M/Q/u2VY3jtdAIw/AOaqA87hQUO4T2
	 8oVmtQbQmlH2DaXg9W4Hv4Ubp+6eFIsNOZ1EZVQttfz/cf4uCAToFSUmyGTtOMrE2h
	 C7+okncdLy1Roj32f8SSXH16FkFs5vpir+oZCW5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yureka Lilian <yuka@yuka.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 025/332] libbpf: Fix reuse of DEVMAP
Date: Mon, 27 Oct 2025 19:31:18 +0100
Message-ID: <20251027183525.285977528@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f65e03e7cf944..4c6902c7bdff7 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4091,6 +4091,16 @@ static bool map_is_reuse_compat(const struct bpf_map *map, int map_fd)
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



