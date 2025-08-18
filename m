Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B496727F727;
	Mon, 18 Aug 2025 13:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525316; cv=none; b=EhPD5oa3gV7dkmhooNuNNe88f/x4UjvXiLKSnF+YPYw9lFJ+Ta3KhgOaeX1ivNNpuZ9irldXf2SeXXQximJSBVg1SlsnCBFL4etXshTLM4stGONHLCSqfm0CjT4F2a5XNPQ1sAABcjyWNIX0gqtj1MdEwqyCfK8AawNiSH/l16c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525316; c=relaxed/simple;
	bh=6A8lJ9otMe9GnI6ASETq5o3nD7adgYjZsRQjG3mVgGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQ1e1lwAtEs8y+7gWu0+/bgwMue4vIos4CiLUo+4JHHhI547hWU28+j7cEYvW90M0eyVUypKtkluAcJRc9nfvkzWGZlmaQjEFRbNRpPDIeX+wSdeELfFk0uAvAB03aFViR+XfL3cG9ehi8gzVs0Jn9rM86YNvG37c00laiXqlMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yz+VdEVu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yz+VdEVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF4CC4CEF1;
	Mon, 18 Aug 2025 13:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525316;
	bh=6A8lJ9otMe9GnI6ASETq5o3nD7adgYjZsRQjG3mVgGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yz+VdEVukpFAWp+7ebZHUkm9s+6NWCVp+147F0oBG5zlfB9fKz5T5HvsqpmU3Xbr8
	 jB6OrqeO01sHTeRMyQuy9IhbIWXV++RsuQDUOhi5SD2HTO13Ijy+RxK9/Bnh9by774
	 zYY5Nxdh2VLqPUyn6viyqag9j0vKtOG3kXFP3/Ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 225/570] libbpf: Verify that arena map exists when adding arena relocations
Date: Mon, 18 Aug 2025 14:43:32 +0200
Message-ID: <20250818124514.485041890@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit 42be23e8f2dcb100cb9944b2b54b6bf41aff943d ]

Fuzzer reported a memory access error in bpf_program__record_reloc()
that happens when:
- ".addr_space.1" section exists
- there is a relocation referencing this section
- there are no arena maps defined in BTF.

Sanity checks for maps existence are already present in
bpf_program__record_reloc(), hence this commit adds another one.

[1] https://github.com/libbpf/libbpf/actions/runs/16375110681/job/46272998064

Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250718222059.281526-1-eddyz87@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index d41ee26b9443..6401dd3bd35f 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4582,6 +4582,11 @@ static int bpf_program__record_reloc(struct bpf_program *prog,
 
 	/* arena data relocation */
 	if (shdr_idx == obj->efile.arena_data_shndx) {
+		if (obj->arena_map_idx < 0) {
+			pr_warn("prog '%s': bad arena data relocation at insn %u, no arena maps defined\n",
+				prog->name, insn_idx);
+			return -LIBBPF_ERRNO__RELOC;
+		}
 		reloc_desc->type = RELO_DATA;
 		reloc_desc->insn_idx = insn_idx;
 		reloc_desc->map_idx = obj->arena_map_idx;
-- 
2.39.5



