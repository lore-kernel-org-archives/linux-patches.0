Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0431A28504A;
	Tue, 17 Jun 2025 16:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176998; cv=none; b=k77YB+zoGIDR2gtZR0fON6z+mtLsWrKQJjg0PpnD2BbDBYBsPBbgH2t4LNRKt31KkO+HPSp7E+qIo/Ufe+VCvIhoVZu9bYsu3PN3KF7Koc8KhHTdnDkJ2WWTA0uiTUmZWN+DJZsimcBdLnOzZSJtYG4lB3fPJOZ3U9tPFezP9vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176998; c=relaxed/simple;
	bh=Gd9HPLAInEel218diRDaOuzya3XkpeN81cE+EskeXw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MxVpIsg7s4RSpMJFsiz6P3HVo1cckeQLUGjAY3NkJ4VOBTs+i7m6+E8g4mhnuiIpBrqMBAiBnFmMOSZh5y2Jr3L+x9Wb5p3lQTg1VmGHSGKJCu0uq4Tg3+Fs6j3hZpxIfZLjUOcebW11VsenaUyJs9Y8MagYPhy2m2ZXsF5UTOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qwyze6ei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qwyze6ei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889AFC4CEE3;
	Tue, 17 Jun 2025 16:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176997;
	bh=Gd9HPLAInEel218diRDaOuzya3XkpeN81cE+EskeXw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qwyze6eiVZP8fOPKUJRxRN6ojOPvV/m2ofE+7P0nFsUuO359r+YdBFekrRGLagn3i
	 cKjWZYLtwQ786KiwkdNMASZti//yZ+Vivyg5dBLIjFqMHVtCy+AqzT3sh5vjuFKGWP
	 6ft35ZjeOMlvQkR+UIW2+uLuZFW/duIPZqfwNfIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagarika Sharma <sharmasagarika@google.com>,
	Minh-Anh Nguyen <minhanhdn@google.com>,
	YiFei Zhu <zhuyifei@google.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Quentin Monnet <qmo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 247/780] bpftool: Fix regression of "bpftool cgroup tree" EINVAL on older kernels
Date: Tue, 17 Jun 2025 17:19:15 +0200
Message-ID: <20250617152501.509936316@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YiFei Zhu <zhuyifei@google.com>

[ Upstream commit 43745d11bfd9683abdf08ad7a5cc403d6a9ffd15 ]

If cgroup_has_attached_progs queries an attach type not supported
by the running kernel, due to the kernel being older than the bpftool
build, it would encounter an -EINVAL from BPF_PROG_QUERY syscall.

Prior to commit 98b303c9bf05 ("bpftool: Query only cgroup-related
attach types"), this EINVAL would be ignored by the function, allowing
the function to only consider supported attach types. The commit
changed so that, instead of querying all attach types, only attach
types from the array `cgroup_attach_types` is queried. The assumption
is that because these are only cgroup attach types, they should all
be supported. Unfortunately this assumption may be false when the
kernel is older than the bpftool build, where the attach types queried
by bpftool is not yet implemented in the kernel. This would result in
errors such as:

  $ bpftool cgroup tree
  CgroupPath
  ID       AttachType      AttachFlags     Name
  Error: can't query bpf programs attached to /sys/fs/cgroup: Invalid argument

This patch restores the logic of ignoring EINVAL from prior to that patch.

Fixes: 98b303c9bf05 ("bpftool: Query only cgroup-related attach types")
Reported-by: Sagarika Sharma <sharmasagarika@google.com>
Reported-by: Minh-Anh Nguyen <minhanhdn@google.com>
Signed-off-by: YiFei Zhu <zhuyifei@google.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Quentin Monnet <qmo@kernel.org>
Link: https://lore.kernel.org/bpf/20250428211536.1651456-1-zhuyifei@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
index 93b139bfb9880..3f1d6be512151 100644
--- a/tools/bpf/bpftool/cgroup.c
+++ b/tools/bpf/bpftool/cgroup.c
@@ -221,7 +221,7 @@ static int cgroup_has_attached_progs(int cgroup_fd)
 	for (i = 0; i < ARRAY_SIZE(cgroup_attach_types); i++) {
 		int count = count_attached_bpf_progs(cgroup_fd, cgroup_attach_types[i]);
 
-		if (count < 0)
+		if (count < 0 && errno != EINVAL)
 			return -1;
 
 		if (count > 0) {
-- 
2.39.5



