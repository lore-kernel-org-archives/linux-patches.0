Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625238;
	b=ifslSOW0FLbdRWOj6oMQ0TWAAMfxVUMXOs5aMimNbqyn6qD5eXWaluvPJuXA7nOOmkSU
	 fDf7zLfsnZJpybGd5YFuv55OB07Yw7cNdRkI4Mpfbc1ay1g+auI5OT1MVXsNXVP3azLAd
	 VrGJX0o5/llS67f48/PFwrvzDoK13pZHeFNDSxTwGUqKtXmov0Cuw0EX/C9gzNO77H15T
	 hOut0LtKPCIwErEiV0tvfVrmoCKLsO7EOgWHyvYvZPitnM3CXdhvt9DGTQfNkg8mNpE0v
	 53RJAXGKCXrA+E58zC032RwmeAv9z5NRJeUeCVJHXO8DZt4aQXEkt1sgpciGQuNMZXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KTqXiBRN0kxLCQ6SaguriGuf2pDWA3XV0FTwCqOxKgs=;
	b=10YWHwieNNTP/u01KiFGuxHVEa+3v89zogz/VPWhkSWv76pLY3bzYKh+NgNm034hX2k1
	 XtgXWJN5t04eHAAGMs1kxN4O55OxxhAM/Zey/A0yuZIvjRvPInylG0AiyvfPbbWUPmlwE
	 +mZnbDynFFhtcRSJ044gw0BilXN5gTDHoC7VnOB/tTeqA0P0u8k/Zo4jnttXYJMUhMgmj
	 6S49W+stCQACy9AE4XA2Se2nq1K27Ai3oXF6Bl+HfAT14faPnXZX0uB+u8eO5EaFQMmjO
	 G10MW2XjdRXzXZ3YolMOrC+qqapGaShmkYsMyf5W4WqOE6ZRvBz61m3zQMpbjM9fE/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yfye26YZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25440606A31E;
	Wed, 25 Nov 2026 16:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yfye26YZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35861F000C4;
	Wed, 25 Nov 2026 16:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625237;
	bh=KTqXiBRN0kxLCQ6SaguriGuf2pDWA3XV0FTwCqOxKgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yfye26YZQ0mFLprbfQjz+D45Lbn1BtWtfIvbY/BY+TvJqsOmiAxzFUW4Yf7mlWfRB
	 R0XlIyMgDu363ZNUSeI6eNS/9uVEfnE/NRYKy9tslZZxo2whPs9LRK5KNfmAV8e8bz
	 6FCaEUxoeGJzlgQ/mJRSMpKAqd6b+4aoSXHHa5Dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.hwang@linux.dev>,
	Yuan Chen <chenyuan@kylinos.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 450/816] bpf: Roll back freplace link state when bpf_arch_text_poke() fails
Date: Wed, 25 Nov 2026 15:33:18 +0100
Message-ID: <20261125143859.606195974@linuxfoundation.org>
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

From: Yuan Chen <chenyuan@kylinos.cn>

[ Upstream commit 5ec398d9ec8fe13f8058af9a2e5f5e8f46e0a35a ]

A freplace attach claims the target prog by bumping
tgt_prog->aux->freplace_link_cnt and setting tr->extension_prog.
bpf_arch_text_poke() then makes the extension take effect.  If the
poke fails, the claims are never released: the attach unwinds
through bpf_link_cleanup(), which clears link->prog, so
bpf_trampoline_unlink_prog() never runs.

Drop the link count under ext_mutex on the error path, and set
tr->extension_prog only after the poke succeeded.  The count is
still bumped before the poke: it blocks prog_array updates while
the entry is patched.

Fixes: d6083f040d5d ("bpf: Prevent tailcall infinite loop caused by freplace")
Fixes: be8704ff07d2 ("bpf: Introduce dynamic program extensions")
Suggested-by: Leon Hwang <leon.hwang@linux.dev>
Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Leon Hwang <leon.hwang@linux.dev>
Link: https://patch.msgid.link/20260928091121.219333-1-chenyuan_fl@163.com
[ sashal: adapted to the older tramp_link naming (link->link.prog) and the four-argument bpf_arch_text_poke() signature, without the extra BPF_MOD_NOP argument. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/trampoline.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index a85e6491fbd1b..ffd150e5027b3 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -576,9 +576,16 @@ static int __bpf_trampoline_link_prog(struct bpf_tramp_link *link,
 		err = bpf_freplace_link_tgt_prog(tgt_prog);
 		if (err)
 			return err;
+		err = bpf_arch_text_poke(tr->func.addr, BPF_MOD_JUMP, NULL,
+					 link->link.prog->bpf_func);
+		if (err) {
+			/* Undo the claim from bpf_freplace_link_tgt_prog(). */
+			guard(mutex)(&tgt_prog->aux->ext_mutex);
+			tgt_prog->aux->freplace_link_cnt--;
+			return err;
+		}
 		tr->extension_prog = link->link.prog;
-		return bpf_arch_text_poke(tr->func.addr, BPF_MOD_JUMP, NULL,
-					  link->link.prog->bpf_func);
+		return 0;
 	}
 	if (cnt >= BPF_MAX_TRAMP_LINKS)
 		return -E2BIG;
-- 
2.53.0



