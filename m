Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E9B151988;
	Wed,  5 Feb 2025 14:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766090; cv=none; b=engEzCmtrHWBAVKyeEcAG2TN6rEzrW4N3DUcR+z4Ao28dLwolkdu5c1sQ2ZwERZcehrMGCf9mqVsz6VY8Vl33C4tsT/Mk6gdHD68Mbq1f/hQ+knZJKsFVuHpQxrXDdomYCpZMv4qg68wdECE315AnOVKx3uICZKRCQD6KbBwKbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766090; c=relaxed/simple;
	bh=830QYp6QG8iaEP49dmJw/yCe622e3A38TC/GsbE75dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9V8jjsYavHQBp7L64f/pzHgOZdlJ5ryHVGuGch1+rxlj5etQM9NraxR8hH7axG9Sko+p6vSGw3CCBe+ID/jK4/mVh+7/gCBcHb1yBGnaAFtGARa9gEBTqPtXjWD5+foyDKlHojf7bODD15IOsip1kj4UQ51eMcezYG+RoAzARQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tplm+GzY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tplm+GzY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B608C4CED1;
	Wed,  5 Feb 2025 14:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766089;
	bh=830QYp6QG8iaEP49dmJw/yCe622e3A38TC/GsbE75dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tplm+GzYbU/enIJBEoYakgIktAtdzQyKGu4NlSQouted3cSV4bFVgF31bTSVPPWpi
	 nQvsJXAAGcPLVl/BTRtxmogjL4Yl6qna+g6eUfPQycLesb3Ntcfu43dbHhKwsEA8yr
	 vQF8fHkLKi7wt2W8hnhC8GBKR6GaAe/fp8Y8Fb2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Lehui <pulehui@huawei.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 286/590] selftests/bpf: Fix btf leak on new btf alloc failure in btf_distill test
Date: Wed,  5 Feb 2025 14:40:41 +0100
Message-ID: <20250205134506.219600587@linuxfoundation.org>
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



