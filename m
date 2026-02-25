Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70E424A06D;
	Wed, 25 Feb 2026 01:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982829; cv=none; b=RjI4cmg8L0LFk7L6ESYuoQ3E/8HAHPo/9UhAxX5If67Frw1R/li13DJs2AVJrfnqcCUTFoNrnO+geNFfuPYoGuQtWGjHey+BhLCVGX613A/dnjzi2r1yrjnvVFL0tj6z9YyGZCp414VzdWQd/l2/tyBL7ete17SceMl5CFMKwz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982829; c=relaxed/simple;
	bh=gfj8WfXsSjJ/7yng3nkl0fBnxakZjYGZb9V7tFUE4xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+UsOuVv3peHe6bOlDdbdbwpIbG2ORjhdkm0dgv/cS+HTrpuPJS4MixarZkBd0Qwvh99e4rXL2d01jJvMjcvCgKK82FxyI8G2gtuokRLY4UGUwTdwI861rS3Ns2f8uLCD8KolNQMNhHXKgPn/47I4guaL7SIRDUxfUhPB2t6NGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xMhVtLGl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xMhVtLGl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68B8C116D0;
	Wed, 25 Feb 2026 01:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982828;
	bh=gfj8WfXsSjJ/7yng3nkl0fBnxakZjYGZb9V7tFUE4xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xMhVtLGlRt8GOv/TdtV0DMGa1KWTz0bhFN8AXZPRQ1d6uvcID8s88fWj2cWI7QhCn
	 8Svuczy23Zv1sBJiWuiDzSa3M4aGeEdXKhp72gMCgffVZnWn8P6V+69ZceibS9Lu72
	 BFnMn7M2X7NMZ+B74bgkjnQuIxq6mv0hTfyRq56E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 007/781] audit: move the compat_xxx_class[] extern declarations to audit_arch.h
Date: Tue, 24 Feb 2026 17:11:56 -0800
Message-ID: <20260225012359.877183087@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 536f8ee8da818..b8d8029c6c480 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -128,12 +128,6 @@ enum audit_nfcfgop {
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



