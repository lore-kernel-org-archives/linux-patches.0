Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5669529CE7;
	Wed,  2 Oct 2024 13:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876101; cv=none; b=NPbVF6V2eSWaCyGaUvmAVIttfzHXSQQHj866G2xlMrAWUfD87Qv/79XvlaqTFCAdmDpZUxd5nxTuTOfVkDvNeyQqe2dS2AiCGRslsgHUzukxOJDgtGic4xxvTcVFFuStIR+u1/t4co6YX4kHIbspTTh0cDel4KFh/uwubNpEFGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876101; c=relaxed/simple;
	bh=OJi9dahKttWvgKiB1soLnlJ062fOQq9qlmy3xkIuCV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHHsGl+TjF8m916E4RXchG7z0HJlUQkZDiTEKuci/0rYubLKYjV7/LiPY/yCsfnlGZNxKkBkMrLWOPRaso87VCSKVXyBpj24ovvB4TYuiIOrnIj4CEvbnKDYqmNfrN4ORSYNIe+BDV4BGkasaQc7D21k6jLi3FYZVvtITrNOA5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rm3IAbv/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rm3IAbv/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E671C4CEC5;
	Wed,  2 Oct 2024 13:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876100;
	bh=OJi9dahKttWvgKiB1soLnlJ062fOQq9qlmy3xkIuCV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rm3IAbv/gdT9/2ygbuXvTKo4Z11XJHP98AcGRbtt886HGSUMWJi4v/9RUznZTgDSC
	 1LhpXEfn4zdt0qgYjij579dpfVMjpX50HBJdhMEqZP5uF0zwLiZGHDl1z/pGfxUmMH
	 f6bKhc+/CSuEQ5RRWSt5ViFVSAr/N34PYTcnSkQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 321/695] bpf: Improve check_raw_mode_ok test for MEM_UNINIT-tagged types
Date: Wed,  2 Oct 2024 14:55:19 +0200
Message-ID: <20241002125835.263015844@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 18752d73c1898fd001569195ba4b0b8c43255f4a ]

When checking malformed helper function signatures, also take other argument
types into account aside from just ARG_PTR_TO_UNINIT_MEM.

This concerns (formerly) ARG_PTR_TO_{INT,LONG} given uninitialized memory can
be passed there, too.

The func proto sanity check goes back to commit 435faee1aae9 ("bpf, verifier:
add ARG_PTR_TO_RAW_STACK type"), and its purpose was to detect wrong func protos
which had more than just one MEM_UNINIT-tagged type as arguments.

The reason more than one is currently not supported is as we mark stack slots with
STACK_MISC in check_helper_call() in case of raw mode based on meta.access_size to
allow uninitialized stack memory to be passed to helpers when they just write into
the buffer.

Probing for base type as well as MEM_UNINIT tagging ensures that other types do not
get missed (as it used to be the case for ARG_PTR_TO_{INT,LONG}).

Fixes: 57c3bb725a3d ("bpf: Introduce ARG_PTR_TO_{INT,LONG} arg types")
Reported-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Link: https://lore.kernel.org/r/20240913191754.13290-4-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e3abf560e405f..8c07efa3905b9 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8170,6 +8170,12 @@ static bool arg_type_is_mem_size(enum bpf_arg_type type)
 	       type == ARG_CONST_SIZE_OR_ZERO;
 }
 
+static bool arg_type_is_raw_mem(enum bpf_arg_type type)
+{
+	return base_type(type) == ARG_PTR_TO_MEM &&
+	       type & MEM_UNINIT;
+}
+
 static bool arg_type_is_release(enum bpf_arg_type type)
 {
 	return type & OBJ_RELEASE;
@@ -9212,15 +9218,15 @@ static bool check_raw_mode_ok(const struct bpf_func_proto *fn)
 {
 	int count = 0;
 
-	if (fn->arg1_type == ARG_PTR_TO_UNINIT_MEM)
+	if (arg_type_is_raw_mem(fn->arg1_type))
 		count++;
-	if (fn->arg2_type == ARG_PTR_TO_UNINIT_MEM)
+	if (arg_type_is_raw_mem(fn->arg2_type))
 		count++;
-	if (fn->arg3_type == ARG_PTR_TO_UNINIT_MEM)
+	if (arg_type_is_raw_mem(fn->arg3_type))
 		count++;
-	if (fn->arg4_type == ARG_PTR_TO_UNINIT_MEM)
+	if (arg_type_is_raw_mem(fn->arg4_type))
 		count++;
-	if (fn->arg5_type == ARG_PTR_TO_UNINIT_MEM)
+	if (arg_type_is_raw_mem(fn->arg5_type))
 		count++;
 
 	/* We only support one arg being in raw mode at the moment,
-- 
2.43.0



