Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C001E330B1B;
	Fri, 17 Oct 2025 15:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715973; cv=none; b=GKYPudhjMrHg8LMSK8tNKFf8VZhqWEcZakw48kL/ItwWfbNhC6e+pLZKrD3UgWz2ij8yGSTGI7jxdAR8Ui5PpRMNKjmVb5cP4CKGIZu6X9ErfOfE1pp6/z1FirYAxGxY5C8jOyjeXnhojPngj6vMWNIOxYF5uUqGU49xU8AcxpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715973; c=relaxed/simple;
	bh=rntNi5MerU1VNUz5Dp54ibXFiZQTt1r54WxOG/WgcnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYFyrjb948Fw/IWe+04r6bVohzinbwPBbaofJhdSjxWNgE1SJSEmk3LCFYRS56mfKsvWKZajGlHidJ78uBr70NDi3QKiQ/tklLYA8H5rLS9OBjqUXueDxH/7acwGAqSBeFbutDj28CfkO5ETXa760/J90oXeyDDLAtdJxrQf1kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XqkA3dcS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XqkA3dcS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A26EC4CEE7;
	Fri, 17 Oct 2025 15:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715973;
	bh=rntNi5MerU1VNUz5Dp54ibXFiZQTt1r54WxOG/WgcnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XqkA3dcSiMasqgkWWrWaKFd1SXyMkYPqBc+ZT8/C+PQhZDwFISexEjmclWRmVAXu9
	 FShBTJaquhAskCKw0UFdsrc0HcPJ6r0j2WCu4GhRa+hQg1GQgZ6VJKNCz+DWWM/j5h
	 opco6xq3HeMh6OXlzZ+mAyXot5KxuhyIrsfpgedQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yureka Lilian <yuka@yuka.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 029/276] libbpf: Fix reuse of DEVMAP
Date: Fri, 17 Oct 2025 16:52:02 +0200
Message-ID: <20251017145143.467458345@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 13dea519e59f2..d9589c92e05d2 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4485,6 +4485,16 @@ static bool map_is_reuse_compat(const struct bpf_map *map, int map_fd)
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



