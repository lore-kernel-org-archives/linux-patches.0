Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA1D7DA6A;
	Wed,  5 Feb 2025 14:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766113; cv=none; b=E+NcCGtsCvV2lz2KhhK5AZHCKvRWiWa5QWil2RFqG3l4SNJWFUmgck/xnf7V4QeFbJ8tgaPBoofGLdyJFdrSPM5sexlTadwY0bEnuhjmKA/zECj6W8Vy0/9/YDB1R9orYFRRdbucED4OM2FAciNlnzlYiEgMIsgdQ1U4L9Y09DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766113; c=relaxed/simple;
	bh=LS4NY1S2N1BFK7Lwn0kRRiMgoiuiZ6jcvTgIMaILVvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CXYvvSdrrJn0BBjJ0pnBSSBMk1m22nRbVBxfyF6qiD+LlcTS2NSQOrpsaiY0L9M65zHu7aoQVENQQ2z0W7RciiBnYlfyT8X26eoW0MFW6V+j0gY29bk7XEHoZNFSZycWahGgN79QNoKiaJ5cbiYutJj59LA+kYgOuqXt38a95g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C/lD+1Dm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C/lD+1Dm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC14C4CED1;
	Wed,  5 Feb 2025 14:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766113;
	bh=LS4NY1S2N1BFK7Lwn0kRRiMgoiuiZ6jcvTgIMaILVvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C/lD+1Dmxp5POHA14marnF9xt0xM+5pIFeqNZJoxd+20OqdT40UfwF8mVAuvIrjch
	 7FbZI9ZoCHmbaeluLxzJr1YgGJkv1cUCryR0G/clwxZGl8Hd7H7lLlIfbzI4pfHlO9
	 o+njKnytu7fm2DoqDNF3NGuXJq36ZfW+RUmbSQaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Lehui <pulehui@huawei.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 288/590] libbpf: Fix incorrect traversal end type ID when marking BTF_IS_EMBEDDED
Date: Wed,  5 Feb 2025 14:40:43 +0100
Message-ID: <20250205134506.295161580@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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
index 4f7399d85eab3..8ef8003480dac 100644
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



