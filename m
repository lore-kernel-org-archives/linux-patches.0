Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9A52F9D82;
	Sat, 12 Sep 2026 07:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198253; cv=none; b=R1MKY6NcQ9UzlXj+7bBLe0C/LpLZsZ4r1027oR7ce02MQ5OHBB5SpQnlWJSBBa01BpvSyAxMaTFhCVBVR5Qv8Nz9w8d9ED1F+JDZHaq2mUNem2L58lTR/uQrCMKHDAkHBHJ6aV09qgamObdCLaPEht+KY3KU8ogqZOVpZijc+AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198253; c=relaxed/simple;
	bh=3dnxgQT4YnpJ8PKpQjenXdw62pdGLqdl36D+EVOGXhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezE0FvWFWXBPvuesthAxI8V6UT7VC0ceY3AQqEEtphAA+OdSJPtjXjm6pI+oC1Cd7RKkXRy/ebbKfovP+f8La4d0PBoUzN39pbfjFSkVlhcBzeGJlZJMbXEOwXyGR4QOwocY1fjcABwH8/LzhsbssBeSe7MibDHKKyCt9MnAliw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GXur/YZU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GXur/YZU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911211F000FF;
	Sat, 12 Sep 2026 07:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198252;
	bh=2nGX2JdKk4/aClBvAK9vpoTtcxVOMk1ZWovZX/1tk1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GXur/YZUAhp7Pi2hmO3jlpFx/Jk4r0Kzia+jGE927BxMrSA0sQWaOM6EXknHVbShY
	 vn1nvtcC7vm1gQ3ZqE5eVhwKgddqnu3pK+Cz1JfPbyEnNAR643/qQOTnapqNtbPjOJ
	 xX2TaN5rOdM+Tl1TJKdvPkBvvNErMoHAETk7rs+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.hwang@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0342/1815] bpf: Mark tracing_multi trampolines as ftrace managed
Date: Sat, 12 Sep 2026 08:34:52 +0200
Message-ID: <20260912065656.942828292@linuxfoundation.org>
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

[ Upstream commit 30bdd6d1384d894931f113eb595636092d8e650c ]

Since tracing_multi link does not set ftrace_managed, it would fail to
release the tracing_multi link when attaching tracing_multi link and
then attaching fentry link.

[    3.714215] WARNING: kernel/bpf/trampoline.c:1727 at bpf_trampoline_multi_detach+0x20b/0x240, CPU#1: test_progs/97
...
[    3.733170]  bpf_tracing_multi_link_release+0x14/0x30
[    3.733890]  bpf_link_free+0x58/0x130
[    3.734414]  bpf_link_release+0x23/0x30

Fix it by setting 'ftrace_managed = true' in register_fentry_multi().

Fixes: aef4dfa790b2 ("bpf: Add bpf_trampoline_multi_attach/detach functions")
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/bpf/20260711124822.29406-2-leon.hwang@linux.dev
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/trampoline.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 1a721fc4bef56..6eadf64f7ec90 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -1536,6 +1536,7 @@ static int register_fentry_multi(struct bpf_trampoline *tr, struct bpf_tramp_ima
 	if (bpf_trampoline_use_jmp(tr->flags))
 		addr = ftrace_jmp_set(addr);
 
+	tr->func.ftrace_managed = true;
 	ftrace_hash_add(data->reg, data->entry, ip, addr);
 	tr->cur_image = im;
 	return 0;
-- 
2.53.0



