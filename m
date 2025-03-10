Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA18234970;
	Mon, 10 Mar 2025 17:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627590; cv=none; b=eNBuq3qg6mXOykCyjT9wVCB0sSu4R8Fa2FqdK+dWISfozrDhSIXg8iVCKaHv6RrozCXq1kAsTJhaBO218BVBh/PwruOkl4TmBZv1SRhX0fyf7hfvvTfxbfPBPOMMgwiLGLU7hvCxAT/h1UYvdO7Ni/JF/Qo38qe5+lZ6TrqWR/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627590; c=relaxed/simple;
	bh=bCaGCj6MjvVfdxaMLs3QiqPQxl13RhRLkZURA9xyovQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRvHF6sPfj7THRzLQaDX5FkqnNE3FLjE+djGVN+2Pfz1t3dmTRgNscYW2OaR0gdm9FpxjPkQ1OHkXuwou5KIdZlPZYysZ6EEyzS5IZ96pi2ST49a4wOeRfV3c57TSVWQYeqxVtped+uSjXHKAFMw5mJMZZ6PK2niv3CPpIFAHUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L/joFH7Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L/joFH7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9BE8C4CEEC;
	Mon, 10 Mar 2025 17:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627590;
	bh=bCaGCj6MjvVfdxaMLs3QiqPQxl13RhRLkZURA9xyovQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L/joFH7Y3tWNz9mHbXchGBNZL9zM49yFDqBmuhhw07npIT3xmlCuUpnLqQ4GU0iML
	 D7ziM+V+Ff3bjjnsv3qnz3CP4iSKqYEIDCpGsf007HcHMMRpbritkXw00UiqmVcDkR
	 RGd8uiteFVe8p3NMoW/BiWJoqtTVV8Km1Nrq/lws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Stapelberg <michael@stapelberg.ch>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 149/269] coredump: Only sort VMAs when core_sort_vma sysctl is set
Date: Mon, 10 Mar 2025 18:05:02 +0100
Message-ID: <20250310170503.656244583@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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
index f8bc1630eba05..fa21cdd610b21 100644
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
index 45737b43dda5c..2b8c36c9660c5 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -63,6 +63,7 @@ static void free_vma_snapshot(struct coredump_params *cprm);
 
 static int core_uses_pid;
 static unsigned int core_pipe_limit;
+static unsigned int core_sort_vma;
 static char core_pattern[CORENAME_MAX_SIZE] = "core";
 static int core_name_size = CORENAME_MAX_SIZE;
 unsigned int core_file_note_size_limit = CORE_FILE_NOTE_SIZE_DEFAULT;
@@ -1025,6 +1026,15 @@ static struct ctl_table coredump_sysctls[] = {
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
@@ -1255,8 +1265,9 @@ static bool dump_vma_snapshot(struct coredump_params *cprm)
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



