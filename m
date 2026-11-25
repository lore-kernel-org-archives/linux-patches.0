Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622655;
	b=4kohCzOr3Ah/K0FusbUsEy5sMbIfBtm5Si1iroPjMwz35hR6hAViN1Gal8B+TUJGqjlC
	 qEAK0a9njxYCLBydC0SjE4RSKfKaKPgI99EVt9qrFpJmUobtw74VibIcVvX0x2tpwikUw
	 glbK7BkiuhGCefnr8Ns8QpngoSNGH36XzH3+W0QPmturMokS0jE2TaIQzDaYaJh+aAPyy
	 OKN11g4gvIOH8S9xBes7HfwdqsPwXIiWn+XTkqyq+9zPl8AQZJuixcV1MlwoqqEagvv9Q
	 tx104tHk/89e0d//G0wjZh1/D3u8au4kDDyo7/giE0rPoid9Y76K5zQ4WdgKnwISL7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622655;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yz2Q1KcDJbxUqvQK7Cc3MwJoopqkz/YuZ7JAh8z1du8=;
	b=Dof6KlKGlf6fRh1p5eEi9gla8bju5ByjdOn7SsUGDkv9yfjSl3z++DqZbbtttpvAVLCD
	 XeUz9V63VyRseOxM+SLlBBP8osaBskFLBrF/a91wqCv7JbhZgS/X+8WXi9SSMuC4eBDbb
	 9Qhi5IescBaq0zEmKbyV3epS+XXApRN2XsuBX957LCYGEkmoF6qq4Y3mORcacmwe2OTJy
	 RBfFKlKHB9b4fYayOXPfu+EJ/r98U8+q8stiaUvOlewbTJuqYRpquIyyolOtXpFtJqTj9
	 iVoBSlCrhFyyBp1cXItxkLDREe/wcgMl5MPOa3OyPb4UpGd8WF9J9I8TwfwlMP/mCCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="H60XN/u2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD16606A335;
	Wed, 25 Nov 2026 16:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H60XN/u2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC461F000C0;
	Wed, 25 Nov 2026 16:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622654;
	bh=yz2Q1KcDJbxUqvQK7Cc3MwJoopqkz/YuZ7JAh8z1du8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H60XN/u26/VC7EUWt6WOBGPZfKd6+1tcKxAH55cslG5XZECrIESm8umc4yxvc4UW2
	 VmZt8mVUBF0W+8NiqwspO4S4+1atd3uVga0ecNJC2Kekka4MWDAiAS5L6UdBqJE7Fw
	 gzwQQpU43aMtV1+KHE7BCLN1lXodgvVjw7nWxD2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 607/990] bpf: Let bpf_dynptr_write() mark a global function
Date: Wed, 25 Nov 2026 15:32:54 +0100
Message-ID: <20261125143836.311620486@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 589998616e0f9190ba6f6644a19532c5b2ba66d0 ]

The caller of a global function loses its packet pointers if the function
may change packet data. That is found out by a scan for calls of the
helpers which bpf_helper_changes_pkt_data() lists.

bpf_dynptr_write() is not on the list, because it depends on the type of
the dynptr: check_helper_call() looks at it. The scan cannot do that, and
so a global function which makes a dynptr from the skb, or gets one as an
argument, and writes through it counts as harmless. The write can
reallocate the head of the skb, and the caller goes on with pointers into
the old one, which has been freed.

Let every call of bpf_dynptr_write() mark the function, as a tail call
does. The same mark decides whether a program may replace a function.

Fixes: 51081a3f25c7 ("bpf: track changes_pkt_data property for global functions")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017230950.802052-10-alexei.starovoitov@gmail.com
[ sashal: Applied the same change in kernel/bpf/verifier.c instead of kernel/bpf/cfg.c, which doesn't exist here, with one differing context line (struct bpf_kfunc_call_arg_meta meta;). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index dc7b4d0280f65..1890c0ba642ab 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -18471,7 +18471,9 @@ static int visit_insn(int t, struct bpf_verifier_env *env)
 			 */
 			if (ret == 0 && fp->might_sleep)
 				mark_subprog_might_sleep(env, t);
-			if (bpf_helper_changes_pkt_data(insn->imm))
+			/* nobody knows yet whether the dynptr is that of an skb */
+			if (bpf_helper_changes_pkt_data(insn->imm) ||
+			    insn->imm == BPF_FUNC_dynptr_write)
 				mark_subprog_changes_pkt_data(env, t);
 		} else if (insn->src_reg == BPF_PSEUDO_KFUNC_CALL) {
 			struct bpf_kfunc_call_arg_meta meta;
-- 
2.53.0



