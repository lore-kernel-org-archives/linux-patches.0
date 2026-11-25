Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625422;
	b=Iz+uo0trLtLNCpvUNxS93yr0TcUD5HMUpe9fJxF8RrL2UAsbc7LOwKtnHksc9i6WqsF3
	 tksVQjEegbSTtC2S/CuUcBpg/OQebMjFux16kswx6epApf+fu34bCbsr52oH7dai3mdOV
	 v9v5aE3/yyUlMWxgDjUFGJwm5kql3e8P6Y0/uYTmeeDNM6pg07xczyZ+aSUSGnggZ+Wbt
	 tvRHdGUzvjqWFJgJMispBlZMo3rIBAINhvFKrN/VKaxy5tM/crqmk5mCenfwYMD5hJQ2B
	 h8dtAsWtOms0epYI4Zt3IC4qI1c81RwPz7eWQ1FThWoEbTcY7tumArfXhG2D3k5v0eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625422;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZgFyLnGSDT7v7awC1QbnJ5LuWr4u4HUfob1VA7SPzJo=;
	b=iZ094x8UcLyoVlyAZcZEPIsE/Jr52J3ZZ58+ipROWCTsMJXBTwnfbr6DxoBfi0ZAzQU9
	 cjcXS02i3nwpC78mC0ZcGf2RtquKaOJlZ42GxJ4w52lRzEmDJjjtta0qJLRqprr4f5Djz
	 YIRYgxBkJNQ6NTQHMdYA9lf6myMqFgGnGX8YeOPXOyxCTJ1Oh1vWxbtF33kpvj1hPcRp6
	 NRGlEXVWp88BD5dgM8ED06qN1rWM9G9k2T/VNOw9KBL9dOXMZJOoVi3ymSFuUHPFuqc61
	 AfELbna4yidbb4pHujKZXqUEJsAtQerOLkpEb+ulihulDOboRNKSM62rJwpD4ruGKLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qMO5hlbT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78033606A31E;
	Wed, 25 Nov 2026 16:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qMO5hlbT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E5C1F000C0;
	Wed, 25 Nov 2026 16:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625422;
	bh=ZgFyLnGSDT7v7awC1QbnJ5LuWr4u4HUfob1VA7SPzJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qMO5hlbTD5kUj6QuNGGuhwEMX6MBQ7ZcoBVAqtYDhfVXCUInR6bp2Yxzj0d2MEaeU
	 7QhYy/zh2R9MndeokPQ9r125x2aHD1QcQZOEArual9l7JDU5fN7XRIe5WEo9VjfmVe
	 96n3kTWBgIdnKM2RNBke0h2Cjj3FaUllkK4ZMgBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 509/816] bpf: Assume no bounds for buffers behind a tail call
Date: Wed, 25 Nov 2026 15:34:17 +0100
Message-ID: <20261125143900.967394538@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 7fa323d77688e8b62b2f0bf6c3208a2c96d4a5e7 ]

The bpf_map_elem, bpf_sk_storage_map and sockmap iterators hand the key
and the value of an element to the program as buffers.  The verifier notes
how far a program reaches into them, and the iterator compares that with
the map when the program is attached.  A program that does not touch the
buffers passes.  It can tail-call another program of the same target,
which gets the same context, and whose reach nobody compares with the
map:

  BUG: KASAN: slab-out-of-bounds in ___bpf_prog_run+0xa46a/0xae80

The program array can be filled at any time, so there is nothing to look
at when the link is made.  For the same reason a program with a tail call
is taken to use the whole stack and the whole packet.  Take it to reach
as far as can be into the buffers as well, so that these iterators refuse
it with -EACCES.

Fixes: d6c4503cc296 ("bpf: Implement bpf iterator for hash maps")
Fixes: 5ce6e77c7edf ("bpf: Implement bpf iterator for sock local storage map")
Fixes: 0365351524d7 ("net: Allow iterating sockmap and sockhash")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-26-alexei.starovoitov@gmail.com
[ sashal: Adapted the hunk to the older code layout, where the tail-call fixup lives in do_misc_fixups() in the verifier source, with the same two added lines. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1404e842580ba..15a02a4c08d22 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -21566,6 +21566,8 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			if (!allow_tail_call_in_subprogs(env))
 				prog->aux->stack_depth = MAX_BPF_STACK;
 			prog->aux->max_pkt_offset = MAX_PACKET_OFF;
+			prog->aux->max_rdonly_access = U32_MAX;
+			prog->aux->max_rdwr_access = U32_MAX;
 
 			/* mark bpf_tail_call as different opcode to avoid
 			 * conditional branch in the interpreter for every normal
-- 
2.53.0



