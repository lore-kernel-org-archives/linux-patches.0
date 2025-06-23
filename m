Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1AD3FB1B;
	Mon, 23 Jun 2025 21:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715770; cv=none; b=aam+D5rMGSDoO/iilj/LCENfGv4vMg9b3diwLDSPZz9D7u/ch3m1+fVD6Phl+XNcR03TDuyZBi3AXceUw1ROekpA+SxLU8sp/T3ik3HVl+32KH4+9pKo81I/1dxnBwr52K0j6103AW/kVIE6Cp2/djK12Jz1BS7XUARO/Zsz8dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715770; c=relaxed/simple;
	bh=A76SDhBIuRD9zUB1SmLF16+dtD1k+dNu1luUcyS17O0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJHPi7ejND3lhnRU5shhndYb0PoU7C7ck6DL9YScbH2ahIIkQ+wN6Qwyw0kkNnmilqLt7w9O94M1oo92g9Cp/SCUJG4oKOfu0qz+FSdxc8RwMT339DeKf8oV6HZCwl4MTvEWSo0mzMycCZd8X0acCoJZTggojFj+Iipgj8vuEJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X2q9Ohp6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X2q9Ohp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61AC2C4CEEA;
	Mon, 23 Jun 2025 21:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715770;
	bh=A76SDhBIuRD9zUB1SmLF16+dtD1k+dNu1luUcyS17O0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X2q9Ohp6pltGtjlo+PJ3kO0W3oKYOR8QssQFP6bx4JXYlALR754dATeKirWjd9lJv
	 cE/ndoHp32wj3WDafT6axEZJUZGpgg9ghlprHEX1ccZX5YeDF1ZIv/hsXwfLylarDo
	 L8G3c//aGzcDbVSiq1Uwf6ippZgHsF3mC9eIqx2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Maguire <alan.maguire@oracle.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 206/414] libbpf/btf: Fix string handling to support multi-split BTF
Date: Mon, 23 Jun 2025 15:05:43 +0200
Message-ID: <20250623130647.155869117@linuxfoundation.org>
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

From: Alan Maguire <alan.maguire@oracle.com>

[ Upstream commit 4e29128a9acec2a622734844bedee013e2901bdf ]

libbpf handling of split BTF has been written largely with the
assumption that multiple splits are possible, i.e. split BTF on top of
split BTF on top of base BTF.  One area where this does not quite work
is string handling in split BTF; the start string offset should be the
base BTF string section length + the base BTF string offset.  This
worked in the past because for a single split BTF with base the start
string offset was always 0.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250519165935.261614-2-alan.maguire@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 27e7bfae953bd..4a486798fe4c0 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -995,7 +995,7 @@ static struct btf *btf_new_empty(struct btf *base_btf)
 	if (base_btf) {
 		btf->base_btf = base_btf;
 		btf->start_id = btf__type_cnt(base_btf);
-		btf->start_str_off = base_btf->hdr->str_len;
+		btf->start_str_off = base_btf->hdr->str_len + base_btf->start_str_off;
 		btf->swapped_endian = base_btf->swapped_endian;
 	}
 
-- 
2.39.5



