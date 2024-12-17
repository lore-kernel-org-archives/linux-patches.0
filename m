Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24171F757B;
	Tue, 17 Dec 2024 17:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456495; cv=none; b=hUVQL5xN8K+w5QuiBxFgv8V6EL2yt49zj92FJnay+0sO6qdgO7lXnJoDnDNXK9gVskIT3V9P8JA93oudSDv7gIz05h3rLMWvLh3cHN1stsK9rsQrxleBUCPzCB2xNqyE/kreYFN333fJrfl0xlLkWOovn+/yOli+wlZNeMMXzXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456495; c=relaxed/simple;
	bh=v8fooYekdOnDpuktoxxQ15CZTXeCoMeTiAvp+HP/ghE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0fSkU0aTKezC1Ud0c3nvnoD2wcmXXAkD1+OaHmd00oDF+WfDY83B+UMC0Gxm543EiWua57k8SIOIcguOhrHx2xDFSKaQ9NnfsGk4xeWz+MLrF8vHzDhRaz7oA0l4L/qMvlteyxaeq+dDLNd2fGWzf+yeNQOnr3PvUQs6HPmfPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FGze18Qi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FGze18Qi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BEACC4CED3;
	Tue, 17 Dec 2024 17:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456495;
	bh=v8fooYekdOnDpuktoxxQ15CZTXeCoMeTiAvp+HP/ghE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FGze18Qi9kCQKvmJKlB/ImcWEuWeAWTOLoWyGfOJ8ZMHeUnXzpaAZX9lV8eAANgVP
	 kk0Xd772A90JT94hgJVvZjNLt5GqwDA9slQr/B9PrEwOHKkBhdKEESAeC/pq5G9txh
	 oAg+ftA7oXWh07Q+tVY5wQWO5SxXu0oLvBA7Iot0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Morris <rtm@mit.edu>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.12 076/172] bpf: Check size for BTF-based ctx access of pointer members
Date: Tue, 17 Dec 2024 18:07:12 +0100
Message-ID: <20241217170549.439469551@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

commit 659b9ba7cb2d7adb64618b87ddfaa528a143766e upstream.

Robert Morris reported the following program type which passes the
verifier in [0]:

SEC("struct_ops/bpf_cubic_init")
void BPF_PROG(bpf_cubic_init, struct sock *sk)
{
	asm volatile("r2 = *(u16*)(r1 + 0)");     // verifier should demand u64
	asm volatile("*(u32 *)(r2 +1504) = 0");   // 1280 in some configs
}

The second line may or may not work, but the first instruction shouldn't
pass, as it's a narrow load into the context structure of the struct ops
callback. The code falls back to btf_ctx_access to ensure correctness
and obtaining the types of pointers. Ensure that the size of the access
is correctly checked to be 8 bytes, otherwise the verifier thinks the
narrow load obtained a trusted BTF pointer and will permit loads/stores
as it sees fit.

Perform the check on size after we've verified that the load is for a
pointer field, as for scalar values narrow loads are fine. Access to
structs passed as arguments to a BPF program are also treated as
scalars, therefore no adjustment is needed in their case.

Existing verifier selftests are broken by this change, but because they
were incorrect. Verifier tests for d_path were performing narrow load
into context to obtain path pointer, had this program actually run it
would cause a crash. The same holds for verifier_btf_ctx_access tests.

  [0]: https://lore.kernel.org/bpf/51338.1732985814@localhost

Fixes: 9e15db66136a ("bpf: Implement accurate raw_tp context access via BTF")
Reported-by: Robert Morris <rtm@mit.edu>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20241212092050.3204165-2-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/btf.c                                            |    6 ++++++
 tools/testing/selftests/bpf/progs/verifier_btf_ctx_access.c |    4 ++--
 tools/testing/selftests/bpf/progs/verifier_d_path.c         |    4 ++--
 3 files changed, 10 insertions(+), 4 deletions(-)

--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6519,6 +6519,12 @@ bool btf_ctx_access(int off, int size, e
 		return false;
 	}
 
+	if (size != sizeof(u64)) {
+		bpf_log(log, "func '%s' size %d must be 8\n",
+			tname, size);
+		return false;
+	}
+
 	/* check for PTR_TO_RDONLY_BUF_OR_NULL or PTR_TO_RDWR_BUF_OR_NULL */
 	for (i = 0; i < prog->aux->ctx_arg_info_size; i++) {
 		const struct bpf_ctx_arg_aux *ctx_arg_info = &prog->aux->ctx_arg_info[i];
--- a/tools/testing/selftests/bpf/progs/verifier_btf_ctx_access.c
+++ b/tools/testing/selftests/bpf/progs/verifier_btf_ctx_access.c
@@ -11,7 +11,7 @@ __success __retval(0)
 __naked void btf_ctx_access_accept(void)
 {
 	asm volatile ("					\
-	r2 = *(u32*)(r1 + 8);		/* load 2nd argument value (int pointer) */\
+	r2 = *(u64 *)(r1 + 8);		/* load 2nd argument value (int pointer) */\
 	r0 = 0;						\
 	exit;						\
 "	::: __clobber_all);
@@ -23,7 +23,7 @@ __success __retval(0)
 __naked void ctx_access_u32_pointer_accept(void)
 {
 	asm volatile ("					\
-	r2 = *(u32*)(r1 + 0);		/* load 1nd argument value (u32 pointer) */\
+	r2 = *(u64 *)(r1 + 0);		/* load 1nd argument value (u32 pointer) */\
 	r0 = 0;						\
 	exit;						\
 "	::: __clobber_all);
--- a/tools/testing/selftests/bpf/progs/verifier_d_path.c
+++ b/tools/testing/selftests/bpf/progs/verifier_d_path.c
@@ -11,7 +11,7 @@ __success __retval(0)
 __naked void d_path_accept(void)
 {
 	asm volatile ("					\
-	r1 = *(u32*)(r1 + 0);				\
+	r1 = *(u64 *)(r1 + 0);				\
 	r2 = r10;					\
 	r2 += -8;					\
 	r6 = 0;						\
@@ -31,7 +31,7 @@ __failure __msg("helper call is not allo
 __naked void d_path_reject(void)
 {
 	asm volatile ("					\
-	r1 = *(u32*)(r1 + 0);				\
+	r1 = *(u64 *)(r1 + 0);				\
 	r2 = r10;					\
 	r2 += -8;					\
 	r6 = 0;						\


