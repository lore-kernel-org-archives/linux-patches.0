Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D6833D6F7
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301619; cv=none; b=CSoiOMpbISrOJ0mbQgfo0QGC4yRUpH4QSDyTE32R7SEhBy/8ZURJYdoghSMPzNBoLSofQ5pAq3znU9kj/WoV6H1YVLEXRn94MHlncbZfYctkiAEYfkgEHQuLcMygikLRZDNEQL/Lqjf77NI01bqjlte3rQGaMror1gdKKjeXNe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301619; c=relaxed/simple;
	bh=OOICxZkFD/sF/1XpkzskYCXir2swhUVs1zaay9R9tIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMTzp4MUCd2efFChBM+XCewi15HksjPLnqtkUuNYRk9K7RtJD6BmZk1KhM8HSj325bj/fovK8rrV9STkwPDL9lZPN4yM4G8b9O2yJ/UJJ9H6p5jBTY7UYXBCbFTQUJFACKO+pCMjxNQL7rH5mewmN6rzSEZfXlZPmlsoxHHFjeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kxOebdky; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kxOebdky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5623EC116D0;
	Sat, 28 Feb 2026 18:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301618;
	bh=OOICxZkFD/sF/1XpkzskYCXir2swhUVs1zaay9R9tIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kxOebdkywDJS5EwGlFJ0wcI7rbVI0fdZ5nZ2VZidxKISF+ig1/Ne1veNWjUlx38C5
	 llvHHgIQtuRTUjBSTpezCcXKFmPuDqis9Vg9mWhO2QVZpiOjIqfLTw9HzPkLPR9xBA
	 fljU9cioPbO0dcjou+yoK10bJTwudcVpDIfvWYr6329x2qtH5F/eSYTicyn5G//BpP
	 8VeCb+HG328mDkCcJtc4kyznJh0tiFzPXUW13bNEov7OmdUzOuYL+OgFz8pBIDqAUZ
	 7jOd9EbKO7y5Z4gXRh8lVe8ODgOfFsq+qeechBYo3bUpe/TTX1Qo+au2awqLJfVPNH
	 g8gYLGIYaoZpA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ben Dooks <ben.dooks@codethink.co.uk>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 008/385] audit: move the compat_xxx_class[] extern declarations to audit_arch.h
Date: Sat, 28 Feb 2026 12:53:50 -0500
Message-ID: <20260228180011.1568201-8-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index e3f06eba9c6e6..73fb8a4bcf2ae 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -126,12 +126,6 @@ enum audit_nfcfgop {
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

