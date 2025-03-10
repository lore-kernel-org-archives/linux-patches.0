Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C63233737;
	Mon, 10 Mar 2025 17:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626729; cv=none; b=biRobMzMYY84Jg3E/a+mqZS/mGqx3e+h9rEaIMHLUI7CbHuF5mvLG4y4Ewz+pvo45P87i9Mm0CGsat1tS9sO0C91Edapc/3rJVOSW2wh5EJyGc5kbuxgYHno4xxScAnWhRRES9kIK7uEMPzuXsLiU5x/DmU/ABxl95V63JrFGpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626729; c=relaxed/simple;
	bh=K/Z8CFzkjX5E5KrljE/lBKAHnPI9xsrgBa/i/hTpVyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izUXd1uq8/KCtBXLk0UfiC/NZJrqyqwFskLv2xOyEpqB5qxHLfjcZLk6HEb0Z23eQMND/yPoe2v2wjDvFw1SDwNsCOw4sskmjDZP8v0WvwIgcb9R7M9CkGSGygwdBXipjo8kUCbfVtO27bQ15zP+7PbIy7oa7GOvD+83ukYW66E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NagLaJ7w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NagLaJ7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1256C4CEED;
	Mon, 10 Mar 2025 17:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626729;
	bh=K/Z8CFzkjX5E5KrljE/lBKAHnPI9xsrgBa/i/hTpVyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NagLaJ7wIkR3eJRxF26Zkq4B+dmlNqCTsaSuhA4TlJ8eY2wE7PpHggWTysiMJl/UX
	 SLH0Ej0BfBn4hGrJEs1Lnoiv4g0isFvlfehWsMX9KZtOkcvm/WnpD1d6blZpIp3NIB
	 whlGsJHSDSrP4cXdsyLh9HmMmYxHx4gG9K0/6SDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Stapelberg <michael@stapelberg.ch>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 092/207] coredump: Only sort VMAs when core_sort_vma sysctl is set
Date: Mon, 10 Mar 2025 18:04:45 +0100
Message-ID: <20250310170451.418624345@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

From: Kees Cook <kees@kernel.org>

[ Upstream commit 39ec9eaaa165d297d008d1fa385748430bd18e4d ]

The sorting of VMAs by size in commit 7d442a33bfe8 ("binfmt_elf: Dump
smaller VMAs first in ELF cores") breaks elfutils[1]. Instead, sort
based on the setting of the new sysctl, core_sort_vma, which defaults
to 0, no sorting.

Reported-by: Michael Stapelberg <michael@stapelberg.ch>
Closes: https://lore.kernel.org/all/20250218085407.61126-1-michael@stapelberg.de/ [1]
Fixes: 7d442a33bfe8 ("binfmt_elf: Dump smaller VMAs first in ELF cores")
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/sysctl/kernel.rst | 11 +++++++++++
 fs/coredump.c                               | 15 +++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
index b2b36d0c3094d..7a85b6eb884ea 100644
--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -212,6 +212,17 @@ pid>/``).
 This value defaults to 0.
 
 
+core_sort_vma
+=============
+
+The default coredump writes VMAs in address order. By setting
+``core_sort_vma`` to 1, VMAs will be written from smallest size
+to largest size. This is known to break at least elfutils, but
+can be handy when dealing with very large (and truncated)
+coredumps where the more useful debugging details are included
+in the smaller VMAs.
+
+
 core_uses_pid
 =============
 
diff --git a/fs/coredump.c b/fs/coredump.c
index d48edb37bc35c..c6f4c745e1bd8 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -63,6 +63,7 @@ static void free_vma_snapshot(struct coredump_params *cprm);
 
 static int core_uses_pid;
 static unsigned int core_pipe_limit;
+static unsigned int core_sort_vma;
 static char core_pattern[CORENAME_MAX_SIZE] = "core";
 static int core_name_size = CORENAME_MAX_SIZE;
 unsigned int core_file_note_size_limit = CORE_FILE_NOTE_SIZE_DEFAULT;
@@ -1026,6 +1027,15 @@ static struct ctl_table coredump_sysctls[] = {
 		.extra1		= (unsigned int *)&core_file_note_size_min,
 		.extra2		= (unsigned int *)&core_file_note_size_max,
 	},
+	{
+		.procname	= "core_sort_vma",
+		.data		= &core_sort_vma,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_douintvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
 };
 
 static int __init init_fs_coredump_sysctls(void)
@@ -1256,8 +1266,9 @@ static bool dump_vma_snapshot(struct coredump_params *cprm)
 		cprm->vma_data_size += m->dump_size;
 	}
 
-	sort(cprm->vma_meta, cprm->vma_count, sizeof(*cprm->vma_meta),
-		cmp_vma_size, NULL);
+	if (core_sort_vma)
+		sort(cprm->vma_meta, cprm->vma_count, sizeof(*cprm->vma_meta),
+		     cmp_vma_size, NULL);
 
 	return true;
 }
-- 
2.39.5



