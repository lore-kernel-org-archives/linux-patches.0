Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15341CFB2;
	Tue, 14 May 2024 11:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687560; cv=none; b=sdKw9kJWC+3BuPoCivGVjNlPyu/TQS/QCGbeiN7YCPLMJU9GYkoDCUfbZRW6Jw2K+T6qHJcoiNsUGBLMFl8ORH25k8adRESfCXaEz7lgr+iXII0tne5OH/o9cNkYJg+pqwztqV9GJV5O4kUMZkAYhTiSxF/QsRJW2yu83pfTxQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687560; c=relaxed/simple;
	bh=V7F7y6HzYK3fE4KLSX7vTyGFPl+m5iUQNtIS2rpfN+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iDhASnOnD71PcoB9phPEVy/yB/X7v+L2nCu7a1qrAJ52+JwB3Kuo7W2E2QU4eqbqBnoAgcpXs+xFLrvO/caWH6rEubak9nBbQbggNaBV5qkjQVSb/WuvcB+ny+QnBc/nVGohxQfSVg0P6SKH9QRYlb9kiMuvVeKGyqOGPg4Q1zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oV2vBI4o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oV2vBI4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58686C2BD10;
	Tue, 14 May 2024 11:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687560;
	bh=V7F7y6HzYK3fE4KLSX7vTyGFPl+m5iUQNtIS2rpfN+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oV2vBI4oIWGGLDsHWkA2GYyk3xLl/rEiZeaa3iJjNS3BL1zXpv8STHgAfOex+wCbx
	 5tiUUfyuhSKixo+raLUtmcFrOL4Te7IqrlllRc3J4p6AMnHTmK3er0262dGC4awLQK
	 PuRgSh2TYI1nyOK6E6/b5Pk0HZVl9IaUBqK06gwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Protopopov <aspsk@isovalent.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/168] bpf: Fix a verifier verbose message
Date: Tue, 14 May 2024 12:18:44 +0200
Message-ID: <20240514101007.678578093@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 67b3254270221..94d952967fbf9 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11875,8 +11875,7 @@ static int resolve_pseudo_ldimm64(struct bpf_verifier_env *env)
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



