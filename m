Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A65F13665A;
	Tue, 14 May 2024 10:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684385; cv=none; b=SuEfuMjmYV1AdaAAL+yxPz4TTnjOtx1m19dp2QdiuPG9M3Jmi+G18BEwoRccRPIH5ZW6DmJRsvaTXmjGbFpwdtmSxoKRUHeKED3PwO6yi77E0hQmJaZC82K6Pb8z0/zg0p7rNLAgsOLz6dBtFF+iHTKuUtdmhxp++JQgDb0D6Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684385; c=relaxed/simple;
	bh=VHdkj2j8TzNLuOI9zIjfMPAjNwYqImiLygDZVqiMuP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YL0seE6IC5RroAWpcL8H1OWKb5QcunCGU5FaHHXpxHLLwPVUVWU72mfNyRJIsRq/PczXyVgyg6BDrJxvu/6imlHGbZcm0BkdhNDtoiWnCxmWEL0/xbXFeqpRf7wKiJ+WAKeZcTLX8qPZYtYZ34bmWnjW6H62vrSaLEebm/xAJKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XgAEgP6K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XgAEgP6K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E80C2BD10;
	Tue, 14 May 2024 10:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684384;
	bh=VHdkj2j8TzNLuOI9zIjfMPAjNwYqImiLygDZVqiMuP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XgAEgP6Kx00hQGErhmad6SYaqQC69au6OL4x8bJX5QctYEd+afN29q6I/lNGHFpA+
	 A8aCiCE3tBJJleqbUS/gFeH26xgl/zAWTRlF1g3Vn0R0vXYdZ6e13IKhkAKt9mboc9
	 F+a+pJq9FwfCzi0q8ZPxetdDVP2UP33eaftgDJE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Protopopov <aspsk@isovalent.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/301] bpf: Fix a verifier verbose message
Date: Tue, 14 May 2024 12:15:05 +0200
Message-ID: <20240514101033.534911272@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c9fc734989c68..818bac019d0d3 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -17655,8 +17655,7 @@ static int resolve_pseudo_ldimm64(struct bpf_verifier_env *env)
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



