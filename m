Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DF51119C;
	Sat,  3 Feb 2024 04:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933843; cv=none; b=a1rGR50FwwiBgsk7cs/H4DLA06J5cfPU27zGCmUi1wF7dEod871ae+gFDAl0xeoSFYviM0l1SZfuM3uppCSGRLpVPKJlp3NxzS6SrrzVnUnayF8a1TsKuqQ4dMxuWtiIwouTJ9ed62MQNvFxsXU2Ew8KmDNpGP97p6ft6QhUyLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933843; c=relaxed/simple;
	bh=P4vIdtXUBiIgpxVSoPuSNFVGXmY037nWxgEifGKVoNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KAHlJhPGh3+FS42BygnLX1MNsz8NT3GhCF3pwts3iw45hWomh98fy7P9uQRf2HYE9G6zRIhuFZjFxV+f61PyCyJWpvcKEhKKyZRTVcFRTpcntnqfYKGIFrVS3FRkwQp2W4e+ItmUQjyd92nszOaIv7Uh73e9CTn6AbnHRKLLDVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qIsuPBO/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qIsuPBO/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B645C433C7;
	Sat,  3 Feb 2024 04:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933843;
	bh=P4vIdtXUBiIgpxVSoPuSNFVGXmY037nWxgEifGKVoNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qIsuPBO/aEAZplVkmN3K7RVyK45rtCR+c9GsCFSoNbUqBWRfdAML9PzTmO6rgwHiS
	 5BhPlfunokBRPX4gjjyHmxQ77OELRGyjW4ycbqvq+9zL5Pwe/VRu9XOi/2YJLgn6ws
	 pa5Va40dBAqzMRf1kVbtN7dkJTZ9LIfCli7BDtYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingyi Zhang <zhangmingyi5@huawei.com>,
	Xin Liu <liuxin350@huawei.com>,
	Changye Wu <wuchangye@huawei.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 145/353] libbpf: Fix NULL pointer dereference in bpf_object__collect_prog_relos
Date: Fri,  2 Feb 2024 20:04:23 -0800
Message-ID: <20240203035408.269270964@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingyi Zhang <zhangmingyi5@huawei.com>

[ Upstream commit fc3a5534e2a8855427403113cbeb54af5837bbe0 ]

An issue occurred while reading an ELF file in libbpf.c during fuzzing:

	Program received signal SIGSEGV, Segmentation fault.
	0x0000000000958e97 in bpf_object.collect_prog_relos () at libbpf.c:4206
	4206 in libbpf.c
	(gdb) bt
	#0 0x0000000000958e97 in bpf_object.collect_prog_relos () at libbpf.c:4206
	#1 0x000000000094f9d6 in bpf_object.collect_relos () at libbpf.c:6706
	#2 0x000000000092bef3 in bpf_object_open () at libbpf.c:7437
	#3 0x000000000092c046 in bpf_object.open_mem () at libbpf.c:7497
	#4 0x0000000000924afa in LLVMFuzzerTestOneInput () at fuzz/bpf-object-fuzzer.c:16
	#5 0x000000000060be11 in testblitz_engine::fuzzer::Fuzzer::run_one ()
	#6 0x000000000087ad92 in tracing::span::Span::in_scope ()
	#7 0x00000000006078aa in testblitz_engine::fuzzer::util::walkdir ()
	#8 0x00000000005f3217 in testblitz_engine::entrypoint::main::{{closure}} ()
	#9 0x00000000005f2601 in main ()
	(gdb)

scn_data was null at this code(tools/lib/bpf/src/libbpf.c):

	if (rel->r_offset % BPF_INSN_SZ || rel->r_offset >= scn_data->d_size) {

The scn_data is derived from the code above:

	scn = elf_sec_by_idx(obj, sec_idx);
	scn_data = elf_sec_data(obj, scn);

	relo_sec_name = elf_sec_str(obj, shdr->sh_name);
	sec_name = elf_sec_name(obj, scn);
	if (!relo_sec_name || !sec_name)// don't check whether scn_data is NULL
		return -EINVAL;

In certain special scenarios, such as reading a malformed ELF file,
it is possible that scn_data may be a null pointer

Signed-off-by: Mingyi Zhang <zhangmingyi5@huawei.com>
Signed-off-by: Xin Liu <liuxin350@huawei.com>
Signed-off-by: Changye Wu <wuchangye@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20231221033947.154564-1-liuxin350@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index e067be95da3c..df1b550f7460 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4344,6 +4344,8 @@ bpf_object__collect_prog_relos(struct bpf_object *obj, Elf64_Shdr *shdr, Elf_Dat
 
 	scn = elf_sec_by_idx(obj, sec_idx);
 	scn_data = elf_sec_data(obj, scn);
+	if (!scn_data)
+		return -LIBBPF_ERRNO__FORMAT;
 
 	relo_sec_name = elf_sec_str(obj, shdr->sh_name);
 	sec_name = elf_sec_name(obj, scn);
-- 
2.43.0



