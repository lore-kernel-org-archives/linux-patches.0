Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F314C215F48;
	Thu, 12 Dec 2024 15:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016088; cv=none; b=ZMZqZNgj883HU1ECoLC5tekQ+jYKW7CdqMGJyn4tUDcoBBF04J3vkOsYrCMaIzMX83u1+NLfeXf7sOAbNRD+vkYW1cKH/EfgpE/Jk4yKEPADXEv7rcx1wwUBFo1jfTqU7rlv7IPoKjrCpJvmS+n+pUf1BvDLth5ODxGLrLlNqQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016088; c=relaxed/simple;
	bh=DsHTaQyuZRGQe6cVfLvuaap5ew4kmg73Zxeq30Wgmdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezwkdUF0p3rC9U+rv5RQUPBLjqORbarrCuv+RyOgnStRjU2R2jHOGAIZSanV8tUBJASX7pJZ9JzqkGJUIJLK4ql07B6ujtO4fhrsBiv5IlQT3HrwMkizqll7BUV85IjOlcfS/8Et5d4LhoDeHZBUYmc1+gWzV0H7+8nbtYuXhM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FCCOTOe9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FCCOTOe9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33983C4CECE;
	Thu, 12 Dec 2024 15:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016087;
	bh=DsHTaQyuZRGQe6cVfLvuaap5ew4kmg73Zxeq30Wgmdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FCCOTOe9YQ6fJIJFceL6JDatWuG30rhUF7DRHGVQEqmkV6mMi9X53Mo2VUpZhs12y
	 MX4Y+QXeffeI1AaYlPVUn+gEHzpzIcUJNBg6w8Cq9omcfYqovuI/Und/4awiPkDqW8
	 fwbeeWQOun6vGEt3fHYiGvNaQewAO+OPIHLide6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 098/466] x86/pkeys: Change caller of update_pkru_in_sigframe()
Date: Thu, 12 Dec 2024 15:54:27 +0100
Message-ID: <20241212144310.689011423@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>

[ Upstream commit 6a1853bdf17874392476b552398df261f75503e0 ]

update_pkru_in_sigframe() will shortly need some information which
is only available inside xsave_to_user_sigframe(). Move
update_pkru_in_sigframe() inside the other function to make it
easier to provide it that information.

No functional changes.

Signed-off-by: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20241119174520.3987538-2-aruna.ramakrishna%40oracle.com
Stable-dep-of: ae6012d72fa6 ("x86/pkeys: Ensure updated PKRU value is XRSTOR'd")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/fpu/signal.c | 20 ++------------------
 arch/x86/kernel/fpu/xstate.h | 15 ++++++++++++++-
 2 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 1065ab995305c..8f62e0666dea5 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -63,16 +63,6 @@ static inline bool check_xstate_in_sigframe(struct fxregs_state __user *fxbuf,
 	return true;
 }
 
-/*
- * Update the value of PKRU register that was already pushed onto the signal frame.
- */
-static inline int update_pkru_in_sigframe(struct xregs_state __user *buf, u32 pkru)
-{
-	if (unlikely(!cpu_feature_enabled(X86_FEATURE_OSPKE)))
-		return 0;
-	return __put_user(pkru, (unsigned int __user *)get_xsave_addr_user(buf, XFEATURE_PKRU));
-}
-
 /*
  * Signal frame handlers.
  */
@@ -168,14 +158,8 @@ static inline bool save_xstate_epilog(void __user *buf, int ia32_frame,
 
 static inline int copy_fpregs_to_sigframe(struct xregs_state __user *buf, u32 pkru)
 {
-	int err = 0;
-
-	if (use_xsave()) {
-		err = xsave_to_user_sigframe(buf);
-		if (!err)
-			err = update_pkru_in_sigframe(buf, pkru);
-		return err;
-	}
+	if (use_xsave())
+		return xsave_to_user_sigframe(buf, pkru);
 
 	if (use_fxsr())
 		return fxsave_to_user_sigframe((struct fxregs_state __user *) buf);
diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
index 0b86a5002c846..6b2924fbe5b8d 100644
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -69,6 +69,16 @@ static inline u64 xfeatures_mask_independent(void)
 	return fpu_kernel_cfg.independent_features;
 }
 
+/*
+ * Update the value of PKRU register that was already pushed onto the signal frame.
+ */
+static inline int update_pkru_in_sigframe(struct xregs_state __user *buf, u32 pkru)
+{
+	if (unlikely(!cpu_feature_enabled(X86_FEATURE_OSPKE)))
+		return 0;
+	return __put_user(pkru, (unsigned int __user *)get_xsave_addr_user(buf, XFEATURE_PKRU));
+}
+
 /* XSAVE/XRSTOR wrapper functions */
 
 #ifdef CONFIG_X86_64
@@ -256,7 +266,7 @@ static inline u64 xfeatures_need_sigframe_write(void)
  * The caller has to zero buf::header before calling this because XSAVE*
  * does not touch the reserved fields in the header.
  */
-static inline int xsave_to_user_sigframe(struct xregs_state __user *buf)
+static inline int xsave_to_user_sigframe(struct xregs_state __user *buf, u32 pkru)
 {
 	/*
 	 * Include the features which are not xsaved/rstored by the kernel
@@ -281,6 +291,9 @@ static inline int xsave_to_user_sigframe(struct xregs_state __user *buf)
 	XSTATE_OP(XSAVE, buf, lmask, hmask, err);
 	clac();
 
+	if (!err)
+		err = update_pkru_in_sigframe(buf, pkru);
+
 	return err;
 }
 
-- 
2.43.0



