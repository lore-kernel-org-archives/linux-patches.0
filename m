Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BC21FC0F4;
	Wed,  5 Feb 2025 14:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766793; cv=none; b=VwFJohZvKGBDEvOHjavM53IkU2DA/0JWgE1WXOQdELaDDDTJa4szFQgdK4pF1+h5cDzp7o/gNQmTx0VDlXFLgF86VcTVretbR3sQ/mojHWe1KAbjb3Uv00foQEgVJWPPGPYNIZln8lP4BikznuOnytSyO1+aS5JiHK401KhHEa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766793; c=relaxed/simple;
	bh=w6ns1Sgc2tlHx4ibxPKxt+aw9KB5JmOGTQqNCVa6sZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YxS+xlRxSorLGr+Gufn++A++vDOOiGLbOszSMG4C5/+AFTIRxfihlok9mHyB3KP/gHQHeRygnTr7YE+XQ5aqkN0anWZb0gtXHA0bA3P+dgKAmGQ/YH5oSR1Zo+6B7uodRShQWZrrCFqAF+oKGhoFgsBTtaVUHgJoqb5oashlGnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZOaRvl0P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZOaRvl0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB806C4CED1;
	Wed,  5 Feb 2025 14:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766793;
	bh=w6ns1Sgc2tlHx4ibxPKxt+aw9KB5JmOGTQqNCVa6sZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZOaRvl0PHyLhNAaNlCJxNAuEarT1iC3y3MJwB7YvK3Z8VL7RH0whO/iS2HFh4m9R/
	 7GU/vFroNREu1AhSChSSeDNtRJNezqFp6FVCAniuz3AepnnLc0uSHSwk9QInqaGuav
	 eb6lwchJCjTju17h/3IbDVJ4nUvBI8JWcwVOlHmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Lehui <pulehui@huawei.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 309/623] selftests/bpf: Fix btf leak on new btf alloc failure in btf_distill test
Date: Wed,  5 Feb 2025 14:40:51 +0100
Message-ID: <20250205134508.048267264@linuxfoundation.org>
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

[ Upstream commit 4a04cb326a6c7f9a2c066f8c2ca78a5a9b87ddab ]

Fix btf leak on new btf alloc failure in btf_distill test.

Fixes: affdeb50616b ("selftests/bpf: Extend distilled BTF tests to cover BTF relocation")
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250115100241.4171581-1-pulehui@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/btf_distill.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf_distill.c b/tools/testing/selftests/bpf/prog_tests/btf_distill.c
index ca84726d5ac1b..b72b966df77b9 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_distill.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_distill.c
@@ -385,7 +385,7 @@ static void test_distilled_base_missing_err(void)
 		"[2] INT 'int' size=8 bits_offset=0 nr_bits=64 encoding=SIGNED");
 	btf5 = btf__new_empty();
 	if (!ASSERT_OK_PTR(btf5, "empty_reloc_btf"))
-		return;
+		goto cleanup;
 	btf__add_int(btf5, "int", 4, BTF_INT_SIGNED);   /* [1] int */
 	VALIDATE_RAW_BTF(
 		btf5,
@@ -478,7 +478,7 @@ static void test_distilled_base_multi_err2(void)
 		"[1] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED");
 	btf5 = btf__new_empty();
 	if (!ASSERT_OK_PTR(btf5, "empty_reloc_btf"))
-		return;
+		goto cleanup;
 	btf__add_int(btf5, "int", 4, BTF_INT_SIGNED);   /* [1] int */
 	btf__add_int(btf5, "int", 4, BTF_INT_SIGNED);   /* [2] int */
 	VALIDATE_RAW_BTF(
-- 
2.39.5



