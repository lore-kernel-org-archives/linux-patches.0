Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3705B78F58;
	Tue, 29 Apr 2025 17:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947648; cv=none; b=KuZrYjCQxLxCe/Fo8fgDOngt4Tf+T602YSSyD3jGlONGHvQLkJJRO7mIg6FXKvVsStnjb4bMbGCYV9ebS71112fQ3oD7yPQDcT+K+G6XFkE4CEuzjWCC1KW91MbIuxe+Pk48MoqJA7X/20v9+zdatM2gYVyxP8CjK+/hqYdpSbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947648; c=relaxed/simple;
	bh=mNBine2AIkH/maHmHQDca4Pn2cZmjOZwC/YA4KYTTc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BVDjM+rbko75O2kf1kc+XivyypjZV36HOFyrTx8Tb2qtIphGxJLm818Bl8hgtyNYi02+u16D8I7ZCcyZHTY1Z9/mHgOQJxkiJVE0Wt/0pZqc4lSGy//nfQPZTzPAuiFjeNm6xC5FmaP0OuRpxpA+3RnlAMxcMuLctGx5OBxvP88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kve8f+y5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kve8f+y5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD19CC4CEE3;
	Tue, 29 Apr 2025 17:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947648;
	bh=mNBine2AIkH/maHmHQDca4Pn2cZmjOZwC/YA4KYTTc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kve8f+y5+k0pDj9GqZ6l9xDinFYND5kIWnHi+smRMuQ6jvpQm3eeOaZi9WHAxxSlL
	 7HSnGUCazqAXvai2L6NvGLPQ8kSr4uVgsjS2hkyxJJ8VilyH6fcwIMt93RXjsPhN4b
	 CVY0CFEvorGNEgEIh5SoV1VAu6f3F3lzda6Ogq84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"T.J. Mercier" <tjmercier@google.com>,
	Waiman Long <longman@redhat.com>,
	Kamalesh Babulal <kamalesh.babulal@oracle.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/280] cgroup/cpuset-v1: Add missing support for cpuset_v2_mode
Date: Tue, 29 Apr 2025 18:40:03 +0200
Message-ID: <20250429161117.654144047@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: T.J. Mercier <tjmercier@google.com>

[ Upstream commit 1bf67c8fdbda21fadd564a12dbe2b13c1ea5eda7 ]

Android has mounted the v1 cpuset controller using filesystem type
"cpuset" (not "cgroup") since 2015 [1], and depends on the resulting
behavior where the controller name is not added as a prefix for cgroupfs
files. [2]

Later, a problem was discovered where cpu hotplug onlining did not
affect the cpuset/cpus files, which Android carried an out-of-tree patch
to address for a while. An attempt was made to upstream this patch, but
the recommendation was to use the "cpuset_v2_mode" mount option
instead. [3]

An effort was made to do so, but this fails with "cgroup: Unknown
parameter 'cpuset_v2_mode'" because commit e1cba4b85daa ("cgroup: Add
mount flag to enable cpuset to use v2 behavior in v1 cgroup") did not
update the special cased cpuset_mount(), and only the cgroup (v1)
filesystem type was updated.

Add parameter parsing to the cpuset filesystem type so that
cpuset_v2_mode works like the cgroup filesystem type:

$ mkdir /dev/cpuset
$ mount -t cpuset -ocpuset_v2_mode none /dev/cpuset
$ mount|grep cpuset
none on /dev/cpuset type cgroup (rw,relatime,cpuset,noprefix,cpuset_v2_mode,release_agent=/sbin/cpuset_release_agent)

[1] https://cs.android.com/android/_/android/platform/system/core/+/b769c8d24fd7be96f8968aa4c80b669525b930d3
[2] https://cs.android.com/android/platform/superproject/main/+/main:system/core/libprocessgroup/setup/cgroup_map_write.cpp;drc=2dac5d89a0f024a2d0cc46a80ba4ee13472f1681;l=192
[3] https://lore.kernel.org/lkml/f795f8be-a184-408a-0b5a-553d26061385@redhat.com/T/

Fixes: e1cba4b85daa ("cgroup: Add mount flag to enable cpuset to use v2 behavior in v1 cgroup")
Signed-off-by: T.J. Mercier <tjmercier@google.com>
Acked-by: Waiman Long <longman@redhat.com>
Reviewed-by: Kamalesh Babulal <kamalesh.babulal@oracle.com>
Acked-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 4378f3eff25d2..e63d6f3b00470 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2339,9 +2339,37 @@ static struct file_system_type cgroup2_fs_type = {
 };
 
 #ifdef CONFIG_CPUSETS_V1
+enum cpuset_param {
+	Opt_cpuset_v2_mode,
+};
+
+static const struct fs_parameter_spec cpuset_fs_parameters[] = {
+	fsparam_flag  ("cpuset_v2_mode", Opt_cpuset_v2_mode),
+	{}
+};
+
+static int cpuset_parse_param(struct fs_context *fc, struct fs_parameter *param)
+{
+	struct cgroup_fs_context *ctx = cgroup_fc2context(fc);
+	struct fs_parse_result result;
+	int opt;
+
+	opt = fs_parse(fc, cpuset_fs_parameters, param, &result);
+	if (opt < 0)
+		return opt;
+
+	switch (opt) {
+	case Opt_cpuset_v2_mode:
+		ctx->flags |= CGRP_ROOT_CPUSET_V2_MODE;
+		return 0;
+	}
+	return -EINVAL;
+}
+
 static const struct fs_context_operations cpuset_fs_context_ops = {
 	.get_tree	= cgroup1_get_tree,
 	.free		= cgroup_fs_context_free,
+	.parse_param	= cpuset_parse_param,
 };
 
 /*
@@ -2378,6 +2406,7 @@ static int cpuset_init_fs_context(struct fs_context *fc)
 static struct file_system_type cpuset_fs_type = {
 	.name			= "cpuset",
 	.init_fs_context	= cpuset_init_fs_context,
+	.parameters		= cpuset_fs_parameters,
 	.fs_flags		= FS_USERNS_MOUNT,
 };
 #endif
-- 
2.39.5



