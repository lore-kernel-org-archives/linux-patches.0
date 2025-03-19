Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CE01DDA36;
	Wed, 19 Mar 2025 14:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394970; cv=none; b=q8wMDHPmXUtdIxyDwvU0K/1lZeibp4yZ6UDtnPl6TohK30qmfDAca4qbIg5SDideHZFPjOyLoO3fDzLEbinvq9KmhcKe/ez5hAT14oWlsgbid8ld4NMreSyheSHk4kCwoQsoGECr3SE88jbVYjdG/9frDCzMxV0kf4992yft23Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394970; c=relaxed/simple;
	bh=A1H/Y6g6rYQO7Qlfs3wvqL8+aD+hl5zqV92bIXom4/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uvDvd3dR+HBu26E4quefM2u0g+NOuIZX5ONHxrDP1EBEz9kib0PbRk8dmXnm450C1yIqNeuNkcOw7oFCh/AxbmkjLEUYSeknSLZHEiJgY/jznG6yQS+3PaRCET7EbHlyVcBNV58gQ7hB8IjJe5HhQCvhzqNN8BXaaIDNyTUc6uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ant/1QOs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ant/1QOs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59397C4CEE4;
	Wed, 19 Mar 2025 14:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394970;
	bh=A1H/Y6g6rYQO7Qlfs3wvqL8+aD+hl5zqV92bIXom4/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ant/1QOspKNf1vax7h6o44EuRn2ffSYer1QAtKml3TFXRplSj5TzKULUHQQqN6vDM
	 xJiCp1DRkiKLt9bfeBqT/f6ohTa67SPpCf+Y+WFJiGDNxg1IwwJBpUuBy0j7zavXMf
	 bnIECfuekaR8L+wKUnev7EH6CAZAv/MjRuAeUNM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.13 205/241] sched_ext: Validate prev_cpu in scx_bpf_select_cpu_dfl()
Date: Wed, 19 Mar 2025 07:31:15 -0700
Message-ID: <20250319143032.809824260@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Righi <arighi@nvidia.com>

commit 9360dfe4cbd62ff1eb8217b815964931523b75b3 upstream.

If a BPF scheduler provides an invalid CPU (outside the nr_cpu_ids
range) as prev_cpu to scx_bpf_select_cpu_dfl() it can cause a kernel
crash.

To prevent this, validate prev_cpu in scx_bpf_select_cpu_dfl() and
trigger an scx error if an invalid CPU is specified.

Fixes: f0e1a0643a59b ("sched_ext: Implement BPF extensible scheduler class")
Cc: stable@vger.kernel.org # v6.12+
Signed-off-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -6376,6 +6376,9 @@ __bpf_kfunc_start_defs();
 __bpf_kfunc s32 scx_bpf_select_cpu_dfl(struct task_struct *p, s32 prev_cpu,
 				       u64 wake_flags, bool *is_idle)
 {
+	if (!ops_cpu_valid(prev_cpu, NULL))
+		goto prev_cpu;
+
 	if (!static_branch_likely(&scx_builtin_idle_enabled)) {
 		scx_ops_error("built-in idle tracking is disabled");
 		goto prev_cpu;


