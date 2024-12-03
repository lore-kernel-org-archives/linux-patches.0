Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312A61F8909;
	Tue,  3 Dec 2024 15:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240689; cv=none; b=oitqXpdkMtSImkbksyQgN/9QtPTK9mi+jRDZPmhSd/Et7bNJ5s+AVJdLS9+X71N5K+ITiLXozUN32H/B+c1JvdNfT7I3E+WQJMX/GJCLIhMp5EbdJGzbUXJc1BYslZhQ7h8ZuEq3z7hFzcNhOzMqHd2Sr1OxRXAueunm4fyIbvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240689; c=relaxed/simple;
	bh=duF8xSfCMS2XJqKyZskmgUqeR8Fb1nrK/lvkDmPdx18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EuCWVPoBbZTtv8bhPXfwCCz9oamVvPj556rV4ZTqdIbFZbHQubO1eYcj1/2ArC5ibEsWn9eq4yOlrlf0usEdQXJ9Z+WmtYdV+XBNeCwdP4G4XPIOPN+C+wumyC/hrQqKHDGIZ160o3aIM7w9Tzp6Pk9Ts8RuYwnXEOLhIgWK1ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UOBkgyJQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UOBkgyJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B39C4CECF;
	Tue,  3 Dec 2024 15:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240689;
	bh=duF8xSfCMS2XJqKyZskmgUqeR8Fb1nrK/lvkDmPdx18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UOBkgyJQnK/bdaM/6BfctGDbVH7Xi3bYdiqTclP3PsWw6pbRaGvp0QBujN2VQumOz
	 WL4ifpy+Q9dYxyR5BA/3UH+PAV3PRlRqkdGY02Jkxbc499XluYQrwm2m2gWZWCzDnS
	 Ix6/fEErkpwe7CoAFfNhaZpZQV8O+vdWfkWq9Ru0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 176/826] sched_ext: scx_bpf_dispatch_from_dsq_set_*() are allowed from unlocked context
Date: Tue,  3 Dec 2024 15:38:23 +0100
Message-ID: <20241203144750.603940719@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 72b85bf6a7f6f6c38c39a1e5b04bc1da1bf5016e ]

4c30f5ce4f7a ("sched_ext: Implement scx_bpf_dispatch[_vtime]_from_dsq()")
added four kfuncs for dispatching while iterating. They are allowed from the
dispatch and unlocked contexts but two of the kfuncs were only added in the
dispatch section. Add missing declarations in the unlocked section.

Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: 4c30f5ce4f7a ("sched_ext: Implement scx_bpf_dispatch[_vtime]_from_dsq()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index ecb88c5285447..16613631543f1 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -6473,6 +6473,8 @@ __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(scx_kfunc_ids_unlocked)
 BTF_ID_FLAGS(func, scx_bpf_create_dsq, KF_SLEEPABLE)
+BTF_ID_FLAGS(func, scx_bpf_dispatch_from_dsq_set_slice)
+BTF_ID_FLAGS(func, scx_bpf_dispatch_from_dsq_set_vtime)
 BTF_ID_FLAGS(func, scx_bpf_dispatch_from_dsq, KF_RCU)
 BTF_ID_FLAGS(func, scx_bpf_dispatch_vtime_from_dsq, KF_RCU)
 BTF_KFUNCS_END(scx_kfunc_ids_unlocked)
-- 
2.43.0



