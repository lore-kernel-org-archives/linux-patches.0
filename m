Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027392;
	b=Q9J8pI+C1shothz6P5Ghiy6yiisIZlpuY84PAhPv7rf7Jh4NT7Si4njHV0WoQ+FKJ3co
	 DAvN2R7+MuL33jIKJXshEKa9Du2HCpTHUe22tdkq8SgDkbEpG36Y7K+f0TM42vef/ODSd
	 9GsZfamAmhP3XuMjhewgNbpcHjIfk6Xzut7PycHX+ddTfO45gXPQ6XlNea0iORiHff0Pi
	 3SRqhL+efg17pMjbpYQ9FDZmXFqhGREIttMl/fJ98bZTQY+CyRbguq6VyFj4NkyUqBT5q
	 6OLZ3SlNWh8Yrl+6YFnP2NK04izsVP1SXcWpDKfJaW6bGFfkU0pe32rWJbwd81MdXnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027392;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wd+mBB8I6Am2FQfrPMuDssVldQi49nOsk/75XgktnWk=;
	b=uz2C69EJhBD+AtAc5IMThj9XUc1gRGoUuRhuX1LExgnVw+Trn+hMdKybYBjyoqWNW3SN
	 rKxEh7058edh+OCMIjRbDAqG9+8XTK5UnZlrBXvdp2acEZzjWmQIAHYriNNuq3QrSymWj
	 liUQNO1TTpmj68sxwPe3joVG6IhXwojNw91GrgAJmNim3Te+7pajRZnieCosLvzCzh7ZP
	 RWV57kO6t9MTdQkltIi+3M8WdTk5mu9YlTzzpmTXcCmybZIzfaE2/AxlliB6sj2uJnp0L
	 oOsDUVpZ/tb69pyCg9qrXF1dzCiEcEalAnAzMm9RSBR3mGmLY+lNC/bvYn4X5lHTV8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U7QTp3qX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E743360A2626;
	Wed, 18 Nov 2026 18:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U7QTp3qX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1E51F000C6;
	Wed, 18 Nov 2026 18:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027391;
	bh=Wd+mBB8I6Am2FQfrPMuDssVldQi49nOsk/75XgktnWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U7QTp3qXHPCywn72ky8qe+tNo/BJMVVIQx9pudARjLhzcHLTvm2a4eCOQlVvT6Ey5
	 Y8OwUwTN3VJqgNbYGOS+0Zprx9Y4nlfudLzlsuCBcrp4Dz1lMWb9xJW7t08HjJWhVU
	 y30f6GPLcM7rY7J+PYIDnJ76GwsxOCeezaofbjCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1736/2151] bpf: Dont take a program with a target program for an iterator
Date: Wed, 18 Nov 2026 15:57:51 +0100
Message-ID: <20261118150225.103052269@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1bb5fe0783a97..dd6d90ee6151d 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -352,10 +352,10 @@ int bpf_iter_prog_supported(struct bpf_prog *prog)
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



