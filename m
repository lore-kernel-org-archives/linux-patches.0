Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D3830F814;
	Mon, 13 Oct 2025 15:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368879; cv=none; b=a6hPAvf83mfZIXIIN7vVvami0LDx/ZER84KDdLOqPEN3SBctWrVSt5TF4zToF8VHYsAfaHE5E9QsjkOTPQMO3AqnJdS5Xi+P8nMo2RVIKptgtWLOgiZlWPYQE8dRxE9iVJfyadIaX+gtfGOkQ+8hbg7KIi24Av0s2+1S52LJEnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368879; c=relaxed/simple;
	bh=BHtwnrP4GXEJbgsRepWwY0n2Z0P0DqGml6RaDxf1HVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vu2Aby2kszD/PFUv5gdo6S/Gd8JISihfZ0ki6++QkMds7Q3MJhPoaiEci8gdp1NeRGxYeu5SRoCAXsGco5+ceSoC0hlrSJTZ/Fuvb25bDbtG2CVJyaktqsFBmundk2TRF1+6ORdFiOl5/+wDxW+313YJ/AKTYV+ZlvgDocY2yKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJOKketb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJOKketb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F489C116B1;
	Mon, 13 Oct 2025 15:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368878;
	bh=BHtwnrP4GXEJbgsRepWwY0n2Z0P0DqGml6RaDxf1HVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJOKketbDlDsV76zzgyxAC8khonFe7opcvg81E04FtsU9bjQfnAGsr5msg/8+iM2H
	 7AAixwj4EXEVFT2CQOFpwANqiUw8myl4T0TTYmZaTbV+dW9rnI4FmrKC2yyuUPYex0
	 fOoQ+w+aor1302xXSmpG5Ydl51gM5iKWhqhEFgQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yureka Lilian <yuka@yuka.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 049/563] libbpf: Fix reuse of DEVMAP
Date: Mon, 13 Oct 2025 16:38:30 +0200
Message-ID: <20251013144413.070335437@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 8f5a81b672e1b..fe4fc5438678c 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5093,6 +5093,16 @@ static bool map_is_reuse_compat(const struct bpf_map *map, int map_fd)
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



