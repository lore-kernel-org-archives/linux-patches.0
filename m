Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D9A4F799E;
	Tue, 13 Oct 2026 12:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894318; cv=none; b=j/AGThe7nFGIIAo5ECESmsRtxOCUHmX9EFWbQ5xipbA5GjhUB+42NFlgq7s1RAC5+o3p9Lc+lEFdoWBVLxcZfjtvvAP4nB14oV8pnv98TN2fEE2/f3lSbiV7nPjgODYMqcUN2/k3EF2TpRC+pdKVkruO8FhMc+1I/FTkM70sVtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894318; c=relaxed/simple;
	bh=dw2rnn/OM37ImVxf4BZXiS6Txki8LE/StahYvw/oo38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhYglgPautBElQcf2leUWG2jGxAdpMn5qLzmIn2gLdqfAmZmiJKfqg8o5iKjY86Wg5YioI38wC2A/obAi52V4VkwVrPMpOm6UcP6Gp5zwuxmbs5G7UWCZgWoPaeFSzkSuUPkCvWcahtTcOhLNRndxdhPVIlMdzU8llzIDBaAeEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sCgOaUSp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sCgOaUSp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8CE1F00898;
	Tue, 13 Oct 2026 12:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894317;
	bh=dUA7bDiEpMswTq/A5F0JfD+BbjmIpfaIIs8q5SE5d60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sCgOaUSpzisez05XvgA6WW+5j09j9/lQzzRjK8cqobhzsZxl1JXms8juD9tIluaIl
	 7AOmp1r7OtKWt3FOKUStpI6WVOGen3K3+3/Hkv3Zc5Gz1Vf0u5O5zwI0ZLQk6clJtZ
	 1PcY8B2mx79S+I4mcYzgeH5e2CiHsZOphKywavCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 519/621] bpf: Mark syscall helpers as sleepable
Date: Tue, 13 Oct 2026 13:38:34 +0200
Message-ID: <20261013112933.139555002@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit d05524794240b52fdc3b6c1220dd05505715824d ]

bpf_sys_bpf() executes the bpf(2) syscall body, which can take mutexes,
allocate with GFP_KERNEL, and wait for an RCU grace period.
bpf_sys_close() reaches close_fd() and filp_close(), which can sleep as
well.

Both helpers are limited to BPF_PROG_TYPE_SYSCALL, whose main program is
sleepable. That does not make every callback sleepable: a syscall program
can register a bpf_timer callback, and the verifier checks that callback
in a non-sleepable context while retaining the syscall helper set.

Without .might_sleep on the prototypes, such a callback can invoke
bpf_sys_bpf() from hrtimer softirq context and trigger a
scheduling-while-atomic failure. bpf_sys_close() is exposed through the
same missing context check.

Set .might_sleep on both prototypes so the existing helper-context check
rejects them from timer callbacks and other atomic regions. Calls from the
sleepable main body remain valid.

Fixes: 79a7f8bdb159 ("bpf: Introduce bpf_sys_bpf() helper and program type.")
Fixes: 3abea089246f ("bpf: Add bpf_sys_close() helper.")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20260903144433.1716731-10-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index dec993c90dc33..144d8b1183a98 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -6396,6 +6396,7 @@ EXPORT_SYMBOL_NS(kern_sys_bpf, "BPF_INTERNAL");
 static const struct bpf_func_proto bpf_sys_bpf_proto = {
 	.func		= bpf_sys_bpf,
 	.gpl_only	= false,
+	.might_sleep	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_ANYTHING,
 	.arg2_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
@@ -6421,6 +6422,7 @@ BPF_CALL_1(bpf_sys_close, u32, fd)
 static const struct bpf_func_proto bpf_sys_close_proto = {
 	.func		= bpf_sys_close,
 	.gpl_only	= false,
+	.might_sleep	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_ANYTHING,
 };
-- 
2.53.0



