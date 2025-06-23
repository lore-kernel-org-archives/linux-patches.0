Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F2621FF2B;
	Mon, 23 Jun 2025 21:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715824; cv=none; b=EQ+sPaKhma3qRUeQAVszVuxyiiha1Rcwl6BQf+FGlsO/OB2NsiaYDhanfp51SDF5+GYihRoTso1G6kgbyADOhwJNlUawvJcDshCICOq5hMtHEW4c5rPu8XMZZi+XhMUgturjbaZiNSJiKr+bc+QUipss3RamusA7lYB2Dg0AARY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715824; c=relaxed/simple;
	bh=e9/ZiQBbvZ9yeQPMeh3+F0f2ksoI3IimYlMr98W8pqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlD2GP7sOn9OM/Fdrs4NDfflr0qp+AGoh94NwQGMypn3Y31Feuh5tu0UnCrzsQ5sKBAC++ZbvRg1tk54uSt6Wu2Le/w2VNiRaVHolmvJDqyj8hN1ur3byITocDT9taf5N+qUBlKSK3Z8iEhAUjWZ0SOD5unoXjkUaWNdoBarUzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jCqbwKGd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jCqbwKGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37CC0C4CEEA;
	Mon, 23 Jun 2025 21:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715824;
	bh=e9/ZiQBbvZ9yeQPMeh3+F0f2ksoI3IimYlMr98W8pqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jCqbwKGdcKsj4eany9betNgRNB6X92cgbrrrHWXEDhMNR5k2nI+6TywDfXdIkyiZ1
	 H3hr2pQQMksSx3hl/nCy76FMdqGgJvP1y19SLJzFVg3VL+UEl5JVPHd3WmAYkS+SCH
	 SEiQk8mxtx7vKiQ19esdOwMoeV6S7F7Y2bSdYdHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 231/414] libbpf: Check bpf_map_skeleton link for NULL
Date: Mon, 23 Jun 2025 15:06:08 +0200
Message-ID: <20250623130647.812645893@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: Mykyta Yatsenko <yatsenko@meta.com>

[ Upstream commit d0445d7dd3fd9b15af7564c38d7aa3cbc29778ee ]

Avoid dereferencing bpf_map_skeleton's link field if it's NULL.
If BPF map skeleton is created with the size, that indicates containing
link field, but the field was not actually initialized with valid
bpf_link pointer, libbpf crashes. This may happen when using libbpf-rs
skeleton.
Skeleton loading may still progress, but user needs to attach struct_ops
map separately.

Signed-off-by: Mykyta Yatsenko <yatsenko@meta.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250514113220.219095-1-mykyta.yatsenko5@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index bb24f6bac2073..1290314da6761 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -13971,6 +13971,12 @@ int bpf_object__attach_skeleton(struct bpf_object_skeleton *s)
 		}
 
 		link = map_skel->link;
+		if (!link) {
+			pr_warn("map '%s': BPF map skeleton link is uninitialized\n",
+				bpf_map__name(map));
+			continue;
+		}
+
 		if (*link)
 			continue;
 
-- 
2.39.5



