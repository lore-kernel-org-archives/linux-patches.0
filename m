Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533126CDC4;
	Tue, 14 May 2024 10:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682222; cv=none; b=X2KIRILiKsack3hmwKG/+LU2PmdVVqIKJx0rJQdPmZ59ZOui4AnRIuGw2IRAimCsWNESlvX2svai7Hypo+8pshfv1n4Mcr9nhaDtbafpwVd0w9Xr/xPnQcbCa3OZFDIcng41Gx6cvew4yAS+rZV7vOLulIpz7N+QDvFCac3VTPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682222; c=relaxed/simple;
	bh=pr1Gfw8zb9UzoXGlRAH+elH2aSsrAw754UQzP8sZLtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lrj+/923DzJDGm1ar5Ms8TKGQC+CN9kfNYaW1eqrZoMyr+FH1hR70EJqH3rONOqqYnkD36foykmteVJuPckyYtHuh0roBLzWfUsbPd2AE/2ife+xUB8JtZK6N4Sn7vBFC/Z1k3JfbRFuJ0JJG7kXR0auRVHKBBcPlePH7JMylpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LMa1cTIz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LMa1cTIz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4AFC2BD10;
	Tue, 14 May 2024 10:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682222;
	bh=pr1Gfw8zb9UzoXGlRAH+elH2aSsrAw754UQzP8sZLtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LMa1cTIzOK9wB4Wnfjf8N4gQhiwHmkNkm5AePretcstO1bxzd19j27zTeQXf9l0Yx
	 bBtV9MDJ1U8aZUGUP0BXcWllX5PJ+tCNr7shmj9PVmDyvCUzB3aa7pLj2Z39nugX2m
	 rB4zfFubDBF60VPWwbFlttbgPnELxOmCZqtCiU3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Protopopov <aspsk@isovalent.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 030/336] bpf: Fix a verifier verbose message
Date: Tue, 14 May 2024 12:13:54 +0200
Message-ID: <20240514101039.744078570@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Protopopov <aspsk@isovalent.com>

[ Upstream commit 37eacb9f6e89fb399a79e952bc9c78eb3e16290e ]

Long ago a map file descriptor in a pseudo ldimm64 instruction could
only be present as an immediate value insn[0].imm, and thus this value
was used in a verbose verifier message printed when the file descriptor
wasn't valid. Since addition of BPF_PSEUDO_MAP_IDX_VALUE/BPF_PSEUDO_MAP_IDX
the insn[0].imm field can also contain an index pointing to the file
descriptor in the attr.fd_array array. However, if the file descriptor
is invalid, the verifier still prints the verbose message containing
value of insn[0].imm. Patch the verifier message to always print the
actual file descriptor value.

Fixes: 387544bfa291 ("bpf: Introduce fd_idx")
Signed-off-by: Anton Protopopov <aspsk@isovalent.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20240412141100.3562942-1-aspsk@isovalent.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 19e575e6b7fe0..11bc3af33f34f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -18040,8 +18040,7 @@ static int resolve_pseudo_ldimm64(struct bpf_verifier_env *env)
 			f = fdget(fd);
 			map = __bpf_map_get(f);
 			if (IS_ERR(map)) {
-				verbose(env, "fd %d is not pointing to valid bpf_map\n",
-					insn[0].imm);
+				verbose(env, "fd %d is not pointing to valid bpf_map\n", fd);
 				return PTR_ERR(map);
 			}
 
-- 
2.43.0



