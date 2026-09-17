Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF194E3236;
	Thu, 17 Sep 2026 15:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659363; cv=none; b=aAKrBrIam2ipOsCotwBu/yIbaZWm3x00iuCLCHghUWXyFx6OYAgAYbV2nXU+GBty/4lEOn/MIft+yAR0VxniCYy83tT9FBcIiR+6DylGJDN177F/4/SBXBY5gqucW3b5zkjZkj2lQMVigQYepE6gKyyKk3SebnFgOxMs9bQzxJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659363; c=relaxed/simple;
	bh=RfEBsOIu/hPkMpMSJnWpMp4Qm9NcF/hIYQdqPh4unxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GAV5UYFua2W1Ke0MVOCAAXZuVw6wl6xDeDktnrYCTp4WHIu8O5P9Ej9VG+Pnpi2snAayzvPn8o6bGud8Fcs+AMJxQ5BBqutilNIw3RI6M9XTHMI7YzGYe9PGiXn+aKCw9TzOr3RFoS1z4fFDB+0fmGxz5tUzEErsKQJZZAXyElg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=npXOa/ux; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="npXOa/ux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F081F000FF;
	Thu, 17 Sep 2026 15:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659356;
	bh=bIZ6pkmNEV2Pxx32cM762F5CpAxraQY5xYwO+wVkKeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=npXOa/uxsoz3A9tLihNmaBh+axdbq0lG/UzDQkJltHrEVGQAA3iyn4V2YZYv3+LAI
	 EzmWUfh76Aa0InEv9vr6LheudIuuW3H9ZMu80ChBvdiQ4Jq6BePjA4V9zKpOB2kFER
	 kfsHQKn4z8YaB24MzYPzJiR2nPBHUjzXJMcTl/64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 229/733] bpf: Mark signal tracepoint siginfo arguments as scalar
Date: Thu, 17 Sep 2026 16:08:57 +0100
Message-ID: <20260917151356.932227061@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 77515ab12e4983e6416f8c35039a3f0c0822ac70 ]

The signal_generate and signal_deliver tracepoints declare their info
argument as a struct kernel_siginfo pointer. btf_ctx_access() therefore
treats it as a trusted pointer for tp_btf programs.

Signal delivery also uses SEND_SIG_NOINFO and SEND_SIG_PRIV as special
values for this argument. Those values are zero and one respectively,
and are not pointers. A tp_btf program can currently dereference either
value and fault the kernel. In particular, signal_generate can run from
timer interrupt context, turning the fault into a kernel panic.

Record both tracepoints in raw_tp_null_args[] and mark argument one as
a non-pointer. This preserves scalar access to the cookie while rejecting
direct and helper-mediated pointer use. Merely marking it nullable would
not suffice because SEND_SIG_PRIV is nonzero.

Fixes: 838a10bd2ebf ("bpf: Augment raw_tp arguments with PTR_MAYBE_NULL")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20260903144433.1716731-2-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 8b88771571b42..0f7b4006a08f4 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6740,6 +6740,9 @@ static const struct bpf_raw_tp_null_args raw_tp_null_args[] = {
 	{ "rxrpc_resend", 0x10 },
 	{ "rxrpc_tq", 0x10 },
 	{ "rxrpc_client", 0x1 },
+	/* signal */
+	{ "signal_generate", 0x20 },
+	{ "signal_deliver", 0x20 },
 	/* skb */
 	{"kfree_skb", 0x1000},
 	/* sunrpc */
-- 
2.53.0



