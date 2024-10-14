Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DF31A76C4;
	Mon, 14 Oct 2024 14:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728915848; cv=none; b=eJij4rT2881/aLMCRTnGJzqYme7Ym91bWw6EQN43usk2P/otchCAZsGGJwJut0FeZcfA+LVW27iTYPTZhP09D+qXHOsbqLUyasvVtkOwaMuNvK22iCze/+FkTwUvvquWAVVUgp5H9zuZf/lz5Z59k0QffuUMOQrNOVFrUdtNOLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728915848; c=relaxed/simple;
	bh=C9W9Wf4g6gu+NDD3/O+TH0eWXIbs5+vXdJq9phta8uA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+PnERDSZiekH+1Y5oDjUvycLikIZowE7HWsBPilIR8e2gyWfgalWHAnnT0BFgUZraG9yx3ggyC2f5oWMXxDfqcKJyklm3OT6vgg+OIiMXcrb4D/Kx7N/w+oZRmH4XzwQrtwzlpRcg87uRGINebPfR3nKqx5w2i/R4vdZU/KNcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1soCQR1z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1soCQR1z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D101AC4CEC3;
	Mon, 14 Oct 2024 14:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728915848;
	bh=C9W9Wf4g6gu+NDD3/O+TH0eWXIbs5+vXdJq9phta8uA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1soCQR1zyE+d850FnXDulG6633PNp8y4DEMH0+ceFEUn833HUrGa/W5TgSET80P7F
	 HUfNhcbTZs2p558eY9ej63ZEm5s2hTT0oYSX/mPYJUPJlz+FfPwHq9ETtUruXwnyLG
	 p/5mdy6eFtyBTt1Ycz8vFlzwEZaN27VcuUPx1n2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 017/214] selftests/bpf: Fix ARG_PTR_TO_LONG {half-,}uninitialized test
Date: Mon, 14 Oct 2024 16:18:00 +0200
Message-ID: <20241014141045.665368827@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

[ Upstream commit b8e188f023e07a733b47d5865311ade51878fe40 ]

The assumption of 'in privileged mode reads from uninitialized stack locations
are permitted' is not quite correct since the verifier was probing for read
access rather than write access. Both tests need to be annotated as __success
for privileged and unprivileged.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20240913191754.13290-6-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/verifier_int_ptr.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/verifier_int_ptr.c b/tools/testing/selftests/bpf/progs/verifier_int_ptr.c
index 9fc3fae5cd833..87206803c0255 100644
--- a/tools/testing/selftests/bpf/progs/verifier_int_ptr.c
+++ b/tools/testing/selftests/bpf/progs/verifier_int_ptr.c
@@ -8,7 +8,6 @@
 SEC("socket")
 __description("ARG_PTR_TO_LONG uninitialized")
 __success
-__failure_unpriv __msg_unpriv("invalid indirect read from stack R4 off -16+0 size 8")
 __naked void arg_ptr_to_long_uninitialized(void)
 {
 	asm volatile ("					\
@@ -36,9 +35,7 @@ __naked void arg_ptr_to_long_uninitialized(void)
 
 SEC("socket")
 __description("ARG_PTR_TO_LONG half-uninitialized")
-/* in privileged mode reads from uninitialized stack locations are permitted */
-__success __failure_unpriv
-__msg_unpriv("invalid indirect read from stack R4 off -16+4 size 8")
+__success
 __retval(0)
 __naked void ptr_to_long_half_uninitialized(void)
 {
-- 
2.43.0



