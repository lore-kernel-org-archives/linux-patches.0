Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA74C1FC110;
	Sat, 12 Sep 2026 07:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199160; cv=none; b=m7L+C1Be/OayRozXm+3nxzDAZH+kVLssx4MPzGkG9S2hFnQCMrybIVzFg3zL9vFigBO8HfcbsUm4NhBU5TWfsyFwlPQNZcYE8QXrk7R3FWiz5QnNK7X6NUWeiXn/pvyY/ksaGM1+Mg47Q/uZ75SRjelNqL4b/W5UYcbQ+BwZh+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199160; c=relaxed/simple;
	bh=wz5GkSfO6kL3T8LiFC8G5lZ9cDJAI7rqAd2UWaRVdlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GSRdg012KRSGgNYwySDXPTOExigmeEvqFE05t6ExcgvpPxDLE+mydcb5Hl+bmvY905Bhajl73MR9TcZ15MQ7MqYISVYuHnmRdwKruruWkApPN8Ahnxig24vyo7f6Q8hCCu72MNxLPn3O8y4lqdUVbLHmbagZeQ7cBMLEN9mAsJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i97XXMbg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i97XXMbg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4281F000FF;
	Sat, 12 Sep 2026 07:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199158;
	bh=JI6IzlDZfgJLygJlkDrB60ufauugUn3/sxB3RAJTGek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i97XXMbg72SiJGJA9aYbAqYl1WMpGCNUdphtnlza02AVTjgamPIhMO8Ucqd3esYv6
	 WOvnHpKK1ecCp5O1STBlSAhmiaGW3DjEdRqCtM+aPP9Do6YV1LdTfD5gHbyds+8Glk
	 Ecap401XSjfl5YFgUu80uVBbNH/JcWBnNfn/Rdvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.hwang@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0528/1815] bpf: Disallow interpreter fallback for gotox insn
Date: Sat, 12 Sep 2026 08:37:58 +0200
Message-ID: <20260912065701.281318081@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Hwang <leon.hwang@linux.dev>

[ Upstream commit 905f716362e1186c1a23447ca279e6d21f795cdb ]

The interpreter does not recognize the BPF_JMP|BPF_JA|BPF_X insn, which
is used for insn_array map. Thereafter, it would hit the BUG_ON() in
___bpf_prog_run() at run time.

[    2.563726] BPF interpreter: unknown opcode 0d (imm: 0x0)
[    2.564557] ------------[ cut here ]------------
[    2.565206] kernel BUG at kernel/bpf/core.c:2349!
[    2.565882] Oops: invalid opcode: 0000 [#1] SMP PTI

Set jit_required as true when insn_array map is used in the prog in
order to disallow interpreter fallback for gotox insn in
core.c::__bpf_prog_select_runtime().

Fixes: 493d9e0d6083 ("bpf, x86: add support for indirect jumps")
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Link: https://lore.kernel.org/bpf/20260715141122.15783-3-leon.hwang@linux.dev
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2c4b52ba52413..22a122403a2e3 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -17899,6 +17899,7 @@ static int __add_used_map(struct bpf_verifier_env *env, struct bpf_map *map)
 			return err;
 		}
 		env->insn_array_maps[env->insn_array_map_cnt++] = map;
+		env->prog->jit_required = true;
 	}
 
 	return env->used_map_cnt - 1;
-- 
2.53.0



