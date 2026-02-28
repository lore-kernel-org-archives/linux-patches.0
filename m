Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68CF3446B0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302038; cv=none; b=tWvfDdoLlNwykpxSCoGl+h59p5UgsxXdhFob2h9WOvZXlt0siwyQLFd4AXiPrq7TSi7K5RrpW2PBRF/b1e4ZnjQKUxDL60/Kgjxv4Erkcs/FgbZSzNQUQ0jocFKcZGDUbuk3rU8OEu2IRwZF2B36Lbkw4D8sZbElCzI7o1evBT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302038; c=relaxed/simple;
	bh=6YC7rlJTRMvs1ZYSFso1FYt/NLF4iZ8PdMnRIm+qBVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q6ncCB2fDqp+PQReXaAR9LzvCFYdQqGd0VATgVBc0lWCRuhHeykXuN6pyWW7/iImDdiVml59PDzIkj9wT1Yyw54asyFxO66CWa0yI6698Pt5poPxE5Ziuwr0OGU6hyyJO1lWD6EhzLOQkz02bhAEhNHR5U3ESqYE66udmxwUduQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kaTqCHpy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kaTqCHpy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39705C19424;
	Sat, 28 Feb 2026 18:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302038;
	bh=6YC7rlJTRMvs1ZYSFso1FYt/NLF4iZ8PdMnRIm+qBVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kaTqCHpyvra9wXjXgt7LxQA69g91jqMYGy9Y+IpVW3dYPX1hfp7eqMNhdAjET8w9n
	 rzfWohNjmABweVe6Jp8YnFOaZ4DTpiDwottd7JY/WUCXBa7xoDknzJJ6xcBw5ARZ+0
	 +zROf/YXx8NmdMBQ+DMEAtSNMhiSraBWRFTffUL/73/vNflQ9bnzkOCBCTkvKglewU
	 GKrHvTRB2emL2l6YmYhcH28DNlwD6dhK1rnjOqkNKlrjgk11xsumHjJCJ1+m6DacIP
	 X8xg9z6pAbMDXjeiUsV2lQR/mdJrZ55h22JiZbpj3ayu/WaDO5YFkxIx9I1CaCJs5X
	 QTpWPS6bvw5tQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ben Dooks <ben.dooks@codethink.co.uk>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/283] audit: move the compat_xxx_class[] extern declarations to audit_arch.h
Date: Sat, 28 Feb 2026 13:02:32 -0500
Message-ID: <20260228180709.1583486-10-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ben Dooks <ben.dooks@codethink.co.uk>

[ Upstream commit 76489955c6d4a065ca69dc88faf7a50a59b66f35 ]

The comapt_xxx_class symbols aren't declared in anything that
lib/comapt_audit.c is including (arm64 build) which is causing
the following sparse warnings:

lib/compat_audit.c:7:10: warning: symbol 'compat_dir_class'
  was not declared. Should it be static?
lib/compat_audit.c:12:10: warning: symbol 'compat_read_class'
  was not declared. Should it be static?
lib/compat_audit.c:17:10: warning: symbol 'compat_write_class'
  was not declared. Should it be static?
lib/compat_audit.c:22:10: warning: symbol 'compat_chattr_class'
  was not declared. Should it be static?
lib/compat_audit.c:27:10: warning: symbol 'compat_signal_class'
  was not declared. Should it be static?

Trying to fix this by chaning compat_audit.c to inclde <linux/audit.h>
does not work on arm64 due to compile errors with the extra includes
that changing this header makes. The simpler thing would be just to
move the definitons of these symbols out of <linux/audit.h> into
<linux/audit_arch.h> which is included.

Fixes: 4b58841149dca ("audit: Add generic compat syscall support")
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
[PM: rewrite subject line, fixed line length in description]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/audit.h      | 6 ------
 include/linux/audit_arch.h | 7 +++++++
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 7ca75f8873799..517c665da2597 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -125,12 +125,6 @@ enum audit_nfcfgop {
 extern int __init audit_register_class(int class, unsigned *list);
 extern int audit_classify_syscall(int abi, unsigned syscall);
 extern int audit_classify_arch(int arch);
-/* only for compat system calls */
-extern unsigned compat_write_class[];
-extern unsigned compat_read_class[];
-extern unsigned compat_dir_class[];
-extern unsigned compat_chattr_class[];
-extern unsigned compat_signal_class[];
 
 /* audit_names->type values */
 #define	AUDIT_TYPE_UNKNOWN	0	/* we don't know yet */
diff --git a/include/linux/audit_arch.h b/include/linux/audit_arch.h
index 0e34d673ef171..2b8153791e6a5 100644
--- a/include/linux/audit_arch.h
+++ b/include/linux/audit_arch.h
@@ -23,4 +23,11 @@ enum auditsc_class_t {
 
 extern int audit_classify_compat_syscall(int abi, unsigned syscall);
 
+/* only for compat system calls */
+extern unsigned compat_write_class[];
+extern unsigned compat_read_class[];
+extern unsigned compat_dir_class[];
+extern unsigned compat_chattr_class[];
+extern unsigned compat_signal_class[];
+
 #endif
-- 
2.51.0

