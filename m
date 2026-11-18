Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042000;
	b=RgWRXl/AqlbgNezlb9klQi9QysCW5CX0Gl2EDSQX2eX1DD3LH0WaPyUnC2RdxCTASOW+
	 HRwubsbmCzSS2caky0ZMQSlZA/+RipMKsCU4lseN01Pa7qAuwtvyBbMRgFqvv00qRjebn
	 XJqr2ZnDZIkYq1jOiXPjBxRIVqSo60bk7zchFQpnyQw03Kabewx5p8Zj80DDEyoYftF8q
	 WwcOb+CEkaantMheSKrF6avzOtfnq38rTSXbEYRFfJ+o8VwAQrzDwnWGwIpVfqVO6CI+N
	 8BntPirmgi3dAyCTzwo8dStfhybArM1ZlXaBWrYI3/mrgnwdqpnYLt+xzdas+Hqi/lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042000;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8ahljwyK7vYJ0kK9XPWolQSqNarLnhg3zo9PAmpCluU=;
	b=I25MUafcLSc8G/eLNLwy8l71LVeOqHbNaYPhlxSGfSuRzYIOF+r2/Ni09SojNXFXIIMO
	 kXif4/HreN+FXtm3qGq7Pb4dvqjWMXcydHv9PjFF2CVzjBfJ5qEd1Soz/IXYQCNlIu4Fm
	 NuDpQsr73thpg8bsTwuATpS8rA4VnahfEdC7nDJ8y2whc7o3XiFQG7YNUxCFdAEaG6iA3
	 JhUCk+aY3+/8/4CTjO8qbvxEE0QdOaLgLo8yYzch4O0TVOigihBHL0s4jgQWgiXH+mKOv
	 stTzftqjqX4wf5uk+ILKcDzdpeppMN6iqR9rznIc+NznrYMe+n1rNuqMnIS443i7YPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u8S+Fj2k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC001606A31C;
	Wed, 18 Nov 2026 22:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u8S+Fj2k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AA71F000C4;
	Wed, 18 Nov 2026 22:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041999;
	bh=8ahljwyK7vYJ0kK9XPWolQSqNarLnhg3zo9PAmpCluU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u8S+Fj2k0sX+07MoO0KG5dpGnOk/YxaJOHkgR1EzeF2FZ6mRSuwUzJcghVXoMh3i1
	 b0VHSuU5xI2n93Lya3TefIAcZ96ePVEi9ERTNIHDBIe1fTMf1ofnZVflPWuOSfXTQF
	 TXXgwwU1c33gQ4nLmQ/bCrr6IA0+0GUe5HX/Ik68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3013/3318] bpf: Dont take a program with a target program for an iterator
Date: Wed, 18 Nov 2026 16:00:35 +0100
Message-ID: <20261118150450.617616186@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit b83bacf2161d0f8583e3f1e9c90402638992ad82 ]

bpf_iter_prog_supported() goes by the name of the attach function.  Commit
7cc639dc45c5 ("bpf: Don't take an extension for an iterator program")
keeps out extensions, for which that is the name of a function of another
program.  A tracing program with BPF_TRACE_ITER that is loaded with
attach_prog_fd gets there as well: unlike for BPF_TRACE_RAW_TP,
bpf_check_attach_target() does not mind the target program.

If the function is called like that of an iterator target, bpf_iter_bpf_map
for example, its id in the BTF of the program is cached as the id of the
target, even if the load fails later.  Programs of that target which are
loaded already cannot be attached any more.  And the program itself can be
attached as an iterator of that target, with a context that the verifier
has taken from the prototype of that function:

  BUG: KASAN: stack-out-of-bounds in bpf_prog_66d4234e2e50f5b6_ts26_forged+0x12a/0x20b
  Read of size 8 at addr ffffc90000d9fc48 by task ts26/104

Refuse every program that has a target program.  That covers extensions.

Fixes: 15d83c4d7cef ("bpf: Allow loading of a bpf_iter program")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017230950.802052-2-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_iter.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index ec5ef3467652e..e5d15133f1269 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -345,10 +345,10 @@ bool bpf_iter_prog_supported(struct bpf_prog *prog)
 	int prefix_len = strlen(prefix);
 
 	/*
-	 * The attach function of an extension is a subprogram of the iterator
-	 * program that it extends, whatever its name is.
+	 * The attach function of a program that has a target program is a
+	 * function of that program, whatever its name is.
 	 */
-	if (prog->type == BPF_PROG_TYPE_EXT)
+	if (prog->aux->dst_prog)
 		return -EINVAL;
 
 	if (strncmp(attach_fname, prefix, prefix_len))
-- 
2.53.0



