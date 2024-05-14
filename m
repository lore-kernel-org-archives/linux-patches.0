Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C00E4205D;
	Tue, 14 May 2024 11:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686168; cv=none; b=Zx2orh1vZkHMkTVyws7OB0d9UgAuGu9STpC8Nd5B8iGQ+7xybyCGpO4ZgEnL3vc09ScUpRkBymx9ShjFI50Ggczmr+iw3XfVl8rL+ubEz8KG4MmBMOyJArw+pvhEvSeuai+mYfsQ7/bO4ISRM81aCpvO5hrs4jioHLTYyI8nDHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686168; c=relaxed/simple;
	bh=UOQuMqCupA3uysqOe3Fvat9gGkVWW7xsjSZyrJp7aPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9Cx4zjsl3uWsbu+itVrxECBXO37BpCPdH47mbKX6vLujGBZxSO2Or2JwVw26dUcRW/aCeAzglYpPTnF1cYnGuKpMkDxaSUMpInhAzhCBaN6fHdJBBSmGEnq5zehVjLFe8H+o9Ex7e+x+fCl1GoCF7MCT87YEiMAwzKVJCrKoHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D5xoP6Mo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D5xoP6Mo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FDDC2BD10;
	Tue, 14 May 2024 11:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686168;
	bh=UOQuMqCupA3uysqOe3Fvat9gGkVWW7xsjSZyrJp7aPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D5xoP6MoMXdf1EzjAVrbeg5+BslwvkxXZeMd86RhzB5COpALDHD0rKrnINVnRwnfO
	 /Y5Z/4RW8LFk1ZcQZGl327PhHGPyiexWjaWw+Df9Ka4/9oVcSrtcIpyqsD+1pR/zpY
	 WF8qNcu2HfILw4cisL3XOUHbZ4DyyLGL30eSedOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Protopopov <aspsk@isovalent.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/236] bpf: Fix a verifier verbose message
Date: Tue, 14 May 2024 12:16:45 +0200
Message-ID: <20240514101021.978573208@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 27cc6e3db5a86..18b3f429abe17 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13177,8 +13177,7 @@ static int resolve_pseudo_ldimm64(struct bpf_verifier_env *env)
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



