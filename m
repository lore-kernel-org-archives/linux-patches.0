Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD663451DA;
	Sat, 17 Oct 2026 17:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259805; cv=none; b=bhYQvgeyqDlk5D4qZLixsYiemKROaqZPxoCh4hB4+FQOxy+k+4LiTaI0lbVqDWRDqyZLsP6ihp8AUmg7IlMrUD04ybxKFy60RfIzewlizcVgbEIiYNc6XAc/89AZo+WcVL0DhWKLOlDNOvzutEklxDLp3qUG07i7RYTPBW516aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259805; c=relaxed/simple;
	bh=7x2a13VbVeqQW/R2nHlXTMuBWnNOt1fClrR2l3EcScg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=meBUR0s9ZCfZMrDJA+8ShYBTDRvkJ7fUtv83sejzQWtfJKpLvFDWH5Mh/mFpra5pnZSzSjzU33X8WkPEFx48MLMyzQPSIXE8lPkz5/HXfK3Ast+Z+xwPfGc+t+MZrHccLT2+10es0qLgSYXHknPkBXS1RRtK5ZTn6DsORaiunLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KAZwescO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KAZwescO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A91F1F000C4;
	Sat, 17 Oct 2026 17:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259804;
	bh=laUDm/Dc1c40afYI6qrqojUjVCZjaAEawT2e2i9lQMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KAZwescOh5s4QZVdhBS/Ycy2Uj6sH47uo4b2csABF6s5aH76dphm1TtYZSbdxmLal
	 u3aO3RUvk2nLKPOSXlO8WqtHZOk7lLeAeD/MeZx6j29QsduxqDmLmv1CzZR3FgK5i8
	 daSYl8gZIu3QHECGcH5XiLvFEJIIZ5FDquQOmaY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Chen <chen.dylane@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1337/1674] bpf: Disable preemption in bpf_get_stackid
Date: Sat, 17 Oct 2026 18:00:09 +0200
Message-ID: <20261017160505.462428914@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 15f1bd8574662f1b7b26aaa2e23ebf4066f0117d ]

The get_perf_callchain call needs disabled preemption plus we need
it disabled as long as we access its returned trace entries buffer.

Note the bpf_get_stackid_pe function is executed already with
preemption disabled.

Fixes: d5a3b1f69186 ("bpf: introduce BPF_MAP_TYPE_STACK_TRACE")
Reported-by: Tao Chen <chen.dylane@linux.dev>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/bpf/20260803210149.296496-6-jolsa@kernel.org

Closes: https://lore.kernel.org/bpf/20260206090653.1336687-2-chen.dylane@linux.dev/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/stackmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index cf079fbfcc6f2..0888ce258b5e4 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -300,6 +300,7 @@ BPF_CALL_3(bpf_get_stackid, struct pt_regs *, regs, struct bpf_map *, map,
 	if (max_depth > sysctl_perf_event_max_stack)
 		max_depth = sysctl_perf_event_max_stack;
 
+	guard(preempt)();
 	trace = get_perf_callchain(regs, 0, kernel, user, max_depth,
 				   false, false);
 
-- 
2.53.0



