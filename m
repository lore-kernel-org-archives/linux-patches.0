Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623934;
	b=4cPWOaFvW9a5tAZsu5MeNtOB8bsB83UrnFaQdTrNaO1tW/36+BZ7BVa83J53zwr1Ys5a
	 jpeyNPOr78fywV8M78XVLInus1GYkTVKMnZectezEcumNkmnYpRtmu1+ZIVELvjqA7TU7
	 NeK5y5jXZLi6vqjmJvpgz3T9J5whTN35SR0X4b8IW19eR2vKSVyyV1E6JkdLmlJnVdN+q
	 zX05N1TwEvoooNs5keN3OoMfpJzCoFVmr+nzWk91NyhDFMYkoSr1lQ9FKE/ATqxIEZ+ox
	 AZ3v+4JSwi6rKLNMW9Otx880lDfLnnWuIpFlpQ1qRkIYMaLtt8opf64UOMXgpqc8j+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623934;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ePUCYYctiKbKwzkPsW7DOnlLqiw65LeJeEzO4XtvpEo=;
	b=hsTGAKOOmn9KEqtFirLSZ/PcNTaeudC31M6glfdfVUkqlVPQubuYMiPMT+J8mvk1wz7u
	 1L0v/jofqF3d73h8lim53+2EaCw++YtzLOp+4Iqc4oQJcTwL0WmZ1/dtvqojQVv3YMbMB
	 MldIsy7q8ij+cnO/8FL6drwQq2zi8V5G7YhwgKCnVywu8nv/9N+Iki6JXRmp3DYexfJOj
	 AKSBy4EbC9urdpH+/jkoZPuKayRWrOlA1m6hprWCfav5Jm4mGwLw97nuGIERONuI3clBQ
	 9RKpIKHPFwKzFs/qMpxgzQXemRLIlicoRiek48JEiM0QnFA3MtxoeiqwcxogLWvOQ5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cju4LuOh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C26B606A321;
	Wed, 25 Nov 2026 16:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cju4LuOh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60461F000D8;
	Wed, 25 Nov 2026 16:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623934;
	bh=ePUCYYctiKbKwzkPsW7DOnlLqiw65LeJeEzO4XtvpEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cju4LuOh9yklkTCQvRz3Xxp/U7bd0TmFOgOIFMrasOnnxRna+aEwL3AY8e0GgjW68
	 E2vY4U5VpArYJC/A5cCWmq23P68IwPNijcI4OsCKmw0Id+UU/KGd1PfAmE6tZiVbg9
	 BBsa3eUH7J7cG21DmywX/PwMMwWcX/fOFEo+RyF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zesen Liu <ftyg@live.com>,
	Peili Gao <gplhust955@gmail.com>,
	Haoran Ni <haoran.ni.cs@gmail.com>,
	Shuran Liu <electronlsr@gmail.com>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 008/816] bpf: Fix verifier assumptions of bpf_d_paths output buffer
Date: Wed, 25 Nov 2026 15:25:56 +0100
Message-ID: <20261125143849.408810056@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuran Liu <electronlsr@gmail.com>

[ Upstream commit ac44dcc788b950606793e8f9690c30925f59df02 ]

Commit 37cce22dbd51 ("bpf: verifier: Refactor helper access type
tracking") started distinguishing read vs write accesses performed by
helpers.

The second argument of bpf_d_path() is a pointer to a buffer that the
helper fills with the resulting path. However, its prototype currently
uses ARG_PTR_TO_MEM without MEM_WRITE.

Before 37cce22dbd51, helper accesses were conservatively treated as
potential writes, so this mismatch did not cause issues. Since that
commit, the verifier may incorrectly assume that the buffer contents
are unchanged across the helper call and base its optimizations on this
wrong assumption. This can lead to misbehaviour in BPF programs that
read back the buffer, such as prefix comparisons on the returned path.

Fix this by marking the second argument of bpf_d_path() as
ARG_PTR_TO_MEM | MEM_WRITE so that the verifier correctly models the
write to the caller-provided buffer.

Fixes: 37cce22dbd51 ("bpf: verifier: Refactor helper access type tracking")
Co-developed-by: Zesen Liu <ftyg@live.com>
Signed-off-by: Zesen Liu <ftyg@live.com>
Co-developed-by: Peili Gao <gplhust955@gmail.com>
Signed-off-by: Peili Gao <gplhust955@gmail.com>
Co-developed-by: Haoran Ni <haoran.ni.cs@gmail.com>
Signed-off-by: Haoran Ni <haoran.ni.cs@gmail.com>
Signed-off-by: Shuran Liu <electronlsr@gmail.com>
Reviewed-by: Matt Bobrowski <mattbobrowski@google.com>
Link: https://lore.kernel.org/r/20251206141210.3148-2-electronlsr@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 2fe05b3d84000..1d6709e261b8c 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -973,7 +973,7 @@ static const struct bpf_func_proto bpf_d_path_proto = {
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_BTF_ID,
 	.arg1_btf_id	= &bpf_d_path_btf_ids[0],
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_WRITE,
 	.arg3_type	= ARG_CONST_SIZE_OR_ZERO,
 	.allowed	= bpf_d_path_allowed,
 };
-- 
2.53.0



