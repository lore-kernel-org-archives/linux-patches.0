Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E371DE89F;
	Tue,  8 Oct 2024 13:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393469; cv=none; b=fmFvc9g9rtILE1kYGE5mCGYUGkLqBGpjWBmIKWVG9/y2IzLFSskOOjW9q504KJWzzwHxU2/h4YlaP7O5jpkwW3NGQVYU6V6hl8J+LvSEk8DuSXG4JtKS1W2CpITnAMO8x29Js6udgZxh/heO2kj6phMc4MUT8I514c6pR1QZnfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393469; c=relaxed/simple;
	bh=0chEUejavC1w2F3aMQpSuvllH4BbTgqD2h+1YZ5W+Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=raKamw/cXIZEawCIfzabpFxqn+yQR8cqDxj4w9AE78XZAObM3HPShcwsgXPc1fiym742oqO8+hIaWwvsupkwUps1q0vJj60+JyCSNOE4U8BIyq47a2qYzNkDwux1sO0VxW3q7A7Oprcnm7VBlfBJrKoYYrxs7ZHHckSU0zPBr64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HWEOEtHI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HWEOEtHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02F1C4CEC7;
	Tue,  8 Oct 2024 13:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393469;
	bh=0chEUejavC1w2F3aMQpSuvllH4BbTgqD2h+1YZ5W+Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HWEOEtHIz/9EOloDs2AHnzEs3GzxrCcEdBMFp0O2segFfHx6VjwWqbZu4ZSUQtcdX
	 bI7bA8zdD3KOlrB6k6ALACf4zzB5qb0J5FECP/Q8SAAEG9s41yp08LtbfbtJNNRo/J
	 Mv/6O9pXAmIyI1rtlGihZV9o5+a+0cOcZGCZE+3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 130/386] cgroup: Disallow mounting v1 hierarchies without controller implementation
Date: Tue,  8 Oct 2024 14:06:15 +0200
Message-ID: <20241008115634.553871918@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Koutný <mkoutny@suse.com>

[ Upstream commit 3c41382e920f1dd5c9f432948fe799c07af1cced ]

The configs that disable some v1 controllers would still allow mounting
them but with no controller-specific files. (Making such hierarchies
equivalent to named v1 hierarchies.) To achieve behavior consistent with
actual out-compilation of a whole controller, the mounts should treat
respective controllers as non-existent.

Wrap implementation into a helper function, leverage legacy_files to
detect compiled out controllers. The effect is that mounts on v1 would
fail and produce a message like:
  [ 1543.999081] cgroup: Unknown subsys name 'memory'

Signed-off-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup-v1.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 9cb00ebe9ac6d..01149e47e1a72 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -46,6 +46,12 @@ bool cgroup1_ssid_disabled(int ssid)
 	return cgroup_no_v1_mask & (1 << ssid);
 }
 
+static bool cgroup1_subsys_absent(struct cgroup_subsys *ss)
+{
+	/* Check also dfl_cftypes for file-less controllers, i.e. perf_event */
+	return ss->legacy_cftypes == NULL && ss->dfl_cftypes;
+}
+
 /**
  * cgroup_attach_task_all - attach task 'tsk' to all cgroups of task 'from'
  * @from: attach to all cgroups of a given task
@@ -932,7 +938,8 @@ int cgroup1_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		if (ret != -ENOPARAM)
 			return ret;
 		for_each_subsys(ss, i) {
-			if (strcmp(param->key, ss->legacy_name))
+			if (strcmp(param->key, ss->legacy_name) ||
+			    cgroup1_subsys_absent(ss))
 				continue;
 			if (!cgroup_ssid_enabled(i) || cgroup1_ssid_disabled(i))
 				return invalfc(fc, "Disabled controller '%s'",
@@ -1024,7 +1031,8 @@ static int check_cgroupfs_options(struct fs_context *fc)
 	mask = ~((u16)1 << cpuset_cgrp_id);
 #endif
 	for_each_subsys(ss, i)
-		if (cgroup_ssid_enabled(i) && !cgroup1_ssid_disabled(i))
+		if (cgroup_ssid_enabled(i) && !cgroup1_ssid_disabled(i) &&
+		    !cgroup1_subsys_absent(ss))
 			enabled |= 1 << i;
 
 	ctx->subsys_mask &= enabled;
-- 
2.43.0



