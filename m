Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8482F2377;
	Tue, 17 Jun 2025 16:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176038; cv=none; b=BJbfysSv7qVI7MWx1wjL97Y/a9mFrTsSaIX9/HXgF7Pz9QpthNmsH3sUHuWVUhrKKpR9k3/jBzkUeCWiODn7xOph3tI15m0zxNBRe9/9EQMYiJSfLOtdmv9R1zhIShdO16pqzQeMbUsDEpZqN7Aj6ZgBGGV16e0qY3erU37R4JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176038; c=relaxed/simple;
	bh=BD+Z2vgxbqUSzYLtp0r3YcS0SgLugvjl2Gh/jykWZQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=INugCel15FoD9M48bZpRqTiMwujdZdaT0YR5WblqYVXMD8gwGlBk3D1iET5h1ui41JmUpF0KDSFG7+lVw1j/og6FrMcTwAONb/+ZeKbrGX7E8vyp1XOdIXHO/Bo7A00Y0YbD8yyGT9rbCg2daSCqMc0/9c4J9DXwC4e3mSw7QLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8oeYKC7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8oeYKC7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCCFAC4CEF2;
	Tue, 17 Jun 2025 16:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176038;
	bh=BD+Z2vgxbqUSzYLtp0r3YcS0SgLugvjl2Gh/jykWZQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8oeYKC7O8KrqKw3KnJc05/zHB8CHPldTLIcVBoGU0isv1r9MrrcHVPFE4L0UDCcQ
	 qfPfc3hjahb+vnijEjcvenwDok+1YKosEPyKEKsfS0cbDEUmrdj4iCPqTTyrHe45ae
	 C0VG4FQ81kgv6yEhinYK/Dv8DCndlzDm74q0qJec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuewen Yan <xuewen.yan@unisoc.com>,
	Di Shen <di.shen@unisoc.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 190/512] bpf: Revert "bpf: remove unnecessary rcu_read_{lock,unlock}() in multi-uprobe attach logic"
Date: Tue, 17 Jun 2025 17:22:36 +0200
Message-ID: <20250617152427.337615774@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Di Shen <di.shen@unisoc.com>

[ Upstream commit 4e2e6841ff761cc15a54e8bebcf35d7325ec78a2 ]

This reverts commit 4a8f635a6054.

Althought get_pid_task() internally already calls rcu_read_lock() and
rcu_read_unlock(), the find_vpid() was not.

The documentation for find_vpid() clearly states:
"Must be called with the tasklist_lock or rcu_read_lock() held."

Add proper rcu_read_lock/unlock() to protect the find_vpid().

Fixes: 4a8f635a6054 ("bpf: remove unnecessary rcu_read_{lock,unlock}() in multi-uprobe attach logic")
Reported-by: Xuewen Yan <xuewen.yan@unisoc.com>
Signed-off-by: Di Shen <di.shen@unisoc.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20250520054943.5002-1-xuewen.yan@unisoc.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 66075e86b691c..3ec7df7dbeec4 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -3349,7 +3349,9 @@ int bpf_uprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	}
 
 	if (pid) {
+		rcu_read_lock();
 		task = get_pid_task(find_vpid(pid), PIDTYPE_TGID);
+		rcu_read_unlock();
 		if (!task) {
 			err = -ESRCH;
 			goto error_path_put;
-- 
2.39.5



