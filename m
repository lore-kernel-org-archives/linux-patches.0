Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE7E2FD1B6;
	Tue, 12 Aug 2025 18:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024554; cv=none; b=gNtAICfZBYsRi4bGAzxZee2g1EzxHaUFGnqZxlfgHprAjhRckFuxtwJP9KrMaauG2nSoKq+NBzcb4A3YLTndKb8XFVydRjgpTIIFGJ6dSEvqGnxmNruJhe4NV8NOxzsXepE9FC2Tra2sCd4IAOo9MzcAWMOuWXW+VuIjAJVGTNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024554; c=relaxed/simple;
	bh=MaSOVwy2xTJXqwdV8gLpuSDBdiuCB99PL0FucgxMYqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ScUkgJ/iEopZCfwBO9YzMn7PZXY02Elpnx1d1sJTJi8ZFo8HLFRW9dGn1bICEh3jEYgEix7ag1H8CpO6Pgge39Vt0kfde1gRI5mOmu9JAFdCXlsYCmslxkMTA8u2O9x01qkleDx68YMmFUEdVs1dhEaMuBtggTBf3RrzOYB+EhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G6RChcTp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G6RChcTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD23C4CEF0;
	Tue, 12 Aug 2025 18:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024553;
	bh=MaSOVwy2xTJXqwdV8gLpuSDBdiuCB99PL0FucgxMYqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G6RChcTpkN6rFJPplCOJPm9b9pWWtJ1yW7N+9kNk1lCGZfpL/YIw62JxEkS22aLu+
	 a4nc9xJPREimxjWxM04pMJCrHnYcEm5ka+UtEoueTeqdXSPNVd9byIFwgAweqEx9sK
	 hiHPvMJvRJdKherGXHMDBuBXzgifp9kjnc+TibHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 407/627] cgroup: Add compatibility option for content of /proc/cgroups
Date: Tue, 12 Aug 2025 19:31:42 +0200
Message-ID: <20250812173434.769426201@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Koutný <mkoutny@suse.com>

[ Upstream commit 646faf36d7271c597497ca547a59912fcab49be9 ]

/proc/cgroups lists only v1 controllers by default, however, this is
only enforced since the commit af000ce85293b ("cgroup: Do not report
unavailable v1 controllers in /proc/cgroups") and there is software in
the wild that uses content of /proc/cgroups to decide on availability of
v2 (sic) controllers.

Add a boottime param that can bring back the previous behavior for
setups where the check in the software cannot be changed and it causes
e.g. unintended OOMs.

Also, this patch takes out cgrp_v1_visible from cgroup1_subsys_absent()
guard since it's only important to check which hierarchy (v1 vs v2) the
subsys is attached to. This has no effect on the printed message but
the code is cleaner since cgrp_v1_visible is really about mounted
hierarchies, not the content of /proc/cgroups.

Link: https://lore.kernel.org/r/b26b60b7d0d2a5ecfd2f3c45f95f32922ed24686.camel@decadent.org.uk
Fixes: af000ce85293b ("cgroup: Do not report unavailable v1 controllers in /proc/cgroups")
Fixes: a0ab1453226d8 ("cgroup: Print message when /proc/cgroups is read on v2-only system")
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt |  8 ++++++++
 kernel/cgroup/cgroup-v1.c                       | 14 ++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 07e22ba5bfe3..f6d317e1674d 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -633,6 +633,14 @@
 			named mounts. Specifying both "all" and "named" disables
 			all v1 hierarchies.
 
+	cgroup_v1_proc=	[KNL] Show also missing controllers in /proc/cgroups
+			Format: { "true" | "false" }
+			/proc/cgroups lists only v1 controllers by default.
+			This compatibility option enables listing also v2
+			controllers (whose v1 code is not compiled!), so that
+			semi-legacy software can check this file to decide
+			about usage of v2 (sic) controllers.
+
 	cgroup_favordynmods= [KNL] Enable or Disable favordynmods.
 			Format: { "true" | "false" }
 			Defaults to the value of CONFIG_CGROUP_FAVOR_DYNMODS.
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index fa24c032ed6f..2a4a387f867a 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -32,6 +32,9 @@ static u16 cgroup_no_v1_mask;
 /* disable named v1 mounts */
 static bool cgroup_no_v1_named;
 
+/* Show unavailable controllers in /proc/cgroups */
+static bool proc_show_all;
+
 /*
  * pidlist destructions need to be flushed on cgroup destruction.  Use a
  * separate workqueue as flush domain.
@@ -683,10 +686,11 @@ int proc_cgroupstats_show(struct seq_file *m, void *v)
 	 */
 
 	for_each_subsys(ss, i) {
-		if (cgroup1_subsys_absent(ss))
-			continue;
 		cgrp_v1_visible |= ss->root != &cgrp_dfl_root;
 
+		if (!proc_show_all && cgroup1_subsys_absent(ss))
+			continue;
+
 		seq_printf(m, "%s\t%d\t%d\t%d\n",
 			   ss->legacy_name, ss->root->hierarchy_id,
 			   atomic_read(&ss->root->nr_cgrps),
@@ -1359,3 +1363,9 @@ static int __init cgroup_no_v1(char *str)
 	return 1;
 }
 __setup("cgroup_no_v1=", cgroup_no_v1);
+
+static int __init cgroup_v1_proc(char *str)
+{
+	return (kstrtobool(str, &proc_show_all) == 0);
+}
+__setup("cgroup_v1_proc=", cgroup_v1_proc);
-- 
2.39.5



