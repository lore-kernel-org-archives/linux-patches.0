Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9937A18A6D7;
	Wed,  5 Feb 2025 14:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766806; cv=none; b=RsDglj7Ure9gBzxQViBe/s+kLoNGjgg7V6u7uThT7gIo/kJ2bwchyUNYefIfmhSRmalqCz+VP13Ko7/Zvs3DFz6PE2dy78kMnBZs9Q4i89ySzuD1wVGD1OHVU55JRTdmUM0Bf8AhAizSYu0IgwZJgDIH1VVvdvgD6ZtXNz3W7UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766806; c=relaxed/simple;
	bh=GvGa/EJlMzkyl9nx/dm7C4LbchS5p5l4QDnkgyOTl1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ksMrCW0yXQgGvTg4lkDL8Yx6e7pA6bdBvp77Po++Aq4pkHnefkmGWkzQ5Pzc4HpnXP3cOI75OOp7lC5chFRYWZUyOx42yYO18o60xfuxhpuGoHbQTNAClrQ9EH1t+X4fDgiDzQJH3a43aJBBZAhhWNGVTftWtrDGY5rxmBbffR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Je1PSrN9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Je1PSrN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB51C4CED1;
	Wed,  5 Feb 2025 14:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766806;
	bh=GvGa/EJlMzkyl9nx/dm7C4LbchS5p5l4QDnkgyOTl1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Je1PSrN9T2EKibhVem6GeMcsql1UeGJsQagnPYIKplcel68rCJlBBwqvBH6EUxKOT
	 N9riAs+gO4Vi5OD3ENkqg8mrOcBofjlrNfbev4hsKmelQuFfLns4W/W41Hm6HGFwLT
	 Oex3sP4Uh2D3zHUhHJaKNSsHFt3y/FcebXcTA32g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Lehui <pulehui@huawei.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 311/623] libbpf: Fix incorrect traversal end type ID when marking BTF_IS_EMBEDDED
Date: Wed,  5 Feb 2025 14:40:53 +0100
Message-ID: <20250205134508.122946582@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit 5ca681a86ef93369685cb63f71994f4cf7303e7c ]

When redirecting the split BTF to the vmlinux base BTF, we need to mark
the distilled base struct/union members of split BTF structs/unions in
id_map with BTF_IS_EMBEDDED. This indicates that these types must match
both name and size later. Therefore, we need to traverse the entire
split BTF, which involves traversing type IDs from nr_dist_base_types to
nr_types. However, the current implementation uses an incorrect
traversal end type ID, so let's correct it.

Fixes: 19e00c897d50 ("libbpf: Split BTF relocation")
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250115100241.4171581-3-pulehui@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf_relocate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/btf_relocate.c b/tools/lib/bpf/btf_relocate.c
index b72f83e15156a..53d1f3541bce6 100644
--- a/tools/lib/bpf/btf_relocate.c
+++ b/tools/lib/bpf/btf_relocate.c
@@ -212,7 +212,7 @@ static int btf_relocate_map_distilled_base(struct btf_relocate *r)
 	 * need to match both name and size, otherwise embedding the base
 	 * struct/union in the split type is invalid.
 	 */
-	for (id = r->nr_dist_base_types; id < r->nr_split_types; id++) {
+	for (id = r->nr_dist_base_types; id < r->nr_dist_base_types + r->nr_split_types; id++) {
 		err = btf_mark_embedded_composite_type_ids(r, id);
 		if (err)
 			goto done;
-- 
2.39.5



