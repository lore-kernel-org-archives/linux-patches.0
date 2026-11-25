Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622521;
	b=GTmJhRiNGFRlcuaYiUJOtU/XBPhAc94cg1dTDoBI1Y8WdfSQDwBsTE0nLS8ihgWMT42H
	 qyGqIoKgRlGuFovrHYdrcXXqH9y2gu24bUW/RUp9EScCC11TUB7wgTS+7wcETl5QZtfcx
	 cR470j8iaLHzwMKHpGNIp25QXrcLAUrc/4tPvQeX+IeBT243DlJ33WQFhtF6cWr7AwEbP
	 AijnJbfDEaXCw59otIUktwANWwcJ4p/kIB6ict2hCvcMXV7O8M3cMqkCzzOz8G1Zp0U3i
	 YDr0klSyBJI0AoV8+OD/FGCHUZ6EL9oNU7457sbvxq3zsJiBiuft8/edi9Owagr50xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622521;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BapOA45WCzkdTjlvetZYxnRyfvME6CVQwX7b8KQHrio=;
	b=xIyAOlmZx7LdfXOwkh/cmZL2PiumW1Mp1NP+ugt60THoe0MH5bz3SU0Qi2Wr5NCZOf6L
	 B6kQ+tUApP0AgykcI5fyPsd57qJbTG2Ahv0itMidejqQfo7++UxvFYAi3JfIert4wm3I5
	 hYw5ATFWop6n29Y4iGgCBpvgVZ+s5d9z77RxaFvTrqbY3++LoLTiVFVCEfDJf7WIUDyjm
	 Al5gIMer2w71BVlygZUTn/uJozHKzgT8eARd8p4bqb212D7qzkP7niGHOWc2hEngwUJv2
	 Cbr/2UXW3SJisUt6hAteJW916yfjS3ooBJDhWYu80kcBbQb7SrDWZ3EJK0dPkFJPYCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MtPHTSiv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E1E606A323;
	Wed, 25 Nov 2026 16:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MtPHTSiv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1B81F000C4;
	Wed, 25 Nov 2026 16:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622521;
	bh=BapOA45WCzkdTjlvetZYxnRyfvME6CVQwX7b8KQHrio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MtPHTSivMTjJDi3PuV3Wxon5PsfuvElqOKtvC5vOKrMeW/UMlDCtUe+oeoqDu0W7f
	 vi/fcGQMfutsfhwSe/Aa97H6H2kQ1QO4Ktgzdn2YPowIVr7q/GJRp5rL+90agQIO+E
	 K5pW5jEwG3uMHFEUD/VfbYRMa9uvlO28nrbqraac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.hwang@linux.dev>,
	Yuan Chen <chenyuan@kylinos.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 564/990] bpf: Roll back freplace link state when bpf_arch_text_poke() fails
Date: Wed, 25 Nov 2026 15:32:11 +0100
Message-ID: <20261125143835.308509114@linuxfoundation.org>
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
[ sashal: Adapted the freplace fix to the older bpf_arch_text_poke() four-argument form and link->link.prog, instead of the newer BPF_MOD_NOP call and node->link->prog. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/trampoline.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 478ea4ec3a801..98704c030a20b 100644
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



