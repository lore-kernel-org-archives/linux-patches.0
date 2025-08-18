Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950D632A3DE;
	Mon, 18 Aug 2025 13:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523563; cv=none; b=Rv14mlBobQ7q1SA0FPQ75OzuppBdbDP9XF5cVBFjBsrvfcAZwkHtX9lpVjkfbcx429FQwcjp7McO0kgbYZ8lvr/Yf8CuvX8wxQ+BqmiblNL/XJWjojugf87EiZTED95ZvjPCIQmjlMUbLY+B8aIVOC2hNeHBgn4P8bj02pWYSoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523563; c=relaxed/simple;
	bh=5tn6Nz32sdzvforRQioPnrnw4dbkaQuq4O9NwUPYyUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IRYNU49I3a6zItE/IanMOkgjgIdKQuJDgJmSHvxlQSBz3LWr2mU4V/7wh+Oze932552H9CUjf8c8Xr0KTGyAoX+9dNf/ibq57M2B3lgwJm43FPc7TQR04kpbGgfs4q1dqBME9a3lYAggY6qayzUL4DqL0VW96SLtV9Hj2UNKBWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/8LljyB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/8LljyB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A450C4CEEB;
	Mon, 18 Aug 2025 13:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523563;
	bh=5tn6Nz32sdzvforRQioPnrnw4dbkaQuq4O9NwUPYyUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0/8LljyBREx5UZ6YLOAFIeG8wbSgzcvf+uSCZhbELh6n3Z0Yfa10+WONvqn30nfZH
	 z3xF/iM8vcfJIxsXzC0nYfyLEi7v60Td/l3owLotrvgH6t8PWvVKYkrxr6wTMc55tv
	 faTXkMRjj38AwT8NJT9DZi5TUo5FFB2VxJZ5CkwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 209/515] libbpf: Verify that arena map exists when adding arena relocations
Date: Mon, 18 Aug 2025 14:43:15 +0200
Message-ID: <20250818124506.421426356@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index c8e29c52d28c..7e532fbfd684 100644
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



