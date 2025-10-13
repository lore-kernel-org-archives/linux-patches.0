Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C5C221F20;
	Mon, 13 Oct 2025 14:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367098; cv=none; b=Y8xgotn+UdniT4HsJzV6qUY/AK/3fx7oEOsMcmrT7soCrtO9nk1OEsd/8/GqWUpKjtZ+k6RcXiGOkv8PziOC/YFNQX0kkBAJ8G+UjMzvANXH7kHW/hFLd7PTln9ZMARimob1tRdQaeAIe2BCT6eREUea4p0LcLKLX/vY7KEqyT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367098; c=relaxed/simple;
	bh=IOB+Pg9JvLP4cbaQMHWxmpnGea1ABXkdmELg5fUtciE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I46U54ZIoOpjgs0lendjX4WKBlIt0nC7LLTumsvjJxdy4ntgLgUWRgtkApKex5HjafX6fxnlXzc6GvfcepAwDxhO/B42u7XGRyrX56dHttB3SsuE5/ryfKs13nUAf7otxU7XYEphl7N6+bmUDKVY5oQyQcRLsOAAvpiEKlCyAxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=puefVrhm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="puefVrhm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151B7C4CEE7;
	Mon, 13 Oct 2025 14:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367098;
	bh=IOB+Pg9JvLP4cbaQMHWxmpnGea1ABXkdmELg5fUtciE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=puefVrhmzKVBrQf8FSzC/dpQTziCqq8BMwWxvWtk6w8ZxnWM9QOqVBWjS8qIAabv5
	 jH3DquSB1iUMgZ5SImGFx5Z3w0gcAcOFN80KeOcBvyVmSAfq6Sujagu2jh6PqXbGHq
	 bhq0ejp2kp6KMYzJ/flVOTKMJd1MEKupKwd64rrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yureka Lilian <yuka@yuka.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 058/196] libbpf: Fix reuse of DEVMAP
Date: Mon, 13 Oct 2025 16:43:51 +0200
Message-ID: <20251013144316.681922120@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2fb66ca0f50a5..7bd6aff6e260e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4882,6 +4882,16 @@ static bool map_is_reuse_compat(const struct bpf_map *map, int map_fd)
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



