Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032461;
	b=5N//eD8OI06vpVvIidAVa613fC0XEtmQ/La77gfpLjQfoNEgEjz5xL7EK8KVxnNpN17w
	 Nafv/xwrphisnd8ARO6Mr32RUeRp/tt3tPiGDjLX/Jp82O04Pnz2499hQafB0evOx3VPP
	 rkKR7laYtA6TSX9SGgTWL2uAB3pnwt4q0eEDp3hpZ5uyMRvmHQWHylbe+AH9R1JySD/M1
	 a2vU76lk17mHH1Fz2tEvqsH4nYtzcdEmZOMouvrs9Q9nyu22M3SMzBVLQDM1e612fJqIh
	 /wbDPa/znJ40v+5n+KaWSzdhtKaHk1zkT5R62C9I6Dz7TXYypmRSyk9lDFDQCe7yJ5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032461;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uZKJ6JAqCTE13Rbffob8sEsUhUPI/0YLOekDNoqxn+M=;
	b=Q+xd3djcFNqNXHFDLb11e7RVYkWSCKn/Q2NlG9ZFM9DTSV7AS1E/rW+1aE/F193TSGCm
	 mnzuG8OAqUeCdPJGkEhwqH9DtvESRWqzVajGmZL0PWRwaeEnFLmAwGtNGtroUrUYh0OtJ
	 7vod8QwP5mZqBXb69cfEzIN4ANtrSq8o9zzUOk4Ic4XwwZ4fjyipE++vo04TXzyp4gAEu
	 4FqbblMZHSYCWOy6bEMZq/qHpQy0K8e7w1OzFARG0gogrRxBlMbPqOel3x6iyeBTkyT2F
	 kdfeQFkAU14pDj0mS3VCrpnVxdcmbup0Psomr8atjeIr399/uk0vIemi2qtFduETkOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0r/AdCEj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95FD606CB2C;
	Wed, 18 Nov 2026 20:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0r/AdCEj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE181F000C5;
	Wed, 18 Nov 2026 20:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032461;
	bh=uZKJ6JAqCTE13Rbffob8sEsUhUPI/0YLOekDNoqxn+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0r/AdCEjOy7uqgs7auj94Bp9IglTbgyk0DMJ0IljNuUXHvZJz34TEF0CKhJwiL1QP
	 NC6fG6Qa2mn4w9Jz42AAvvShxCJ571ZlmHARtwTpSFtqyuPood2cXysJj8HXFpuyF6
	 VwTaXzCx3jvv1kGvEs7kEQuYZOg2jvESgl1NtFDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1378/1756] bpf: Dont take a program with a target program for an iterator
Date: Wed, 18 Nov 2026 15:58:25 +0100
Message-ID: <20261118150104.059708213@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 96c0b3fb0926c..d8ff9ba04f7a4 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -353,10 +353,10 @@ bool bpf_iter_prog_supported(struct bpf_prog *prog)
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



