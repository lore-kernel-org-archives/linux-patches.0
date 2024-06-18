Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F61E13DDCA;
	Tue, 18 Jun 2024 12:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715100; cv=none; b=NNUYRxgH8D5dXSoSqG0PX+VwHjGcWjmTvq3Ii3wNhA6J1S0LyqyNI5uhnFR5SpLDP3+yJoOnG6Y1ltrSAV50rCm8vn1VSzr+ol8yO9FnZNsjA5me/Tw0CiI4japx87BRsJpdsd3IFmW+gQAUa2e60x9NiRnfrRmAEZHfpexPACM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715100; c=relaxed/simple;
	bh=qbRYXUTKdrZslcjsWd1oMtoB59rNoKr/BE9cRv6fSTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P24ylPBW1SrRUP3SMgVCNFjgbmCvC1rksBnjhZB9XfIS8QAF7vbwxNYdoOzw6MjIkgEx2eCdwXnpr4O/ZOAANrninOKqPv/y7BBlnCvw3zjKWErvJpV/94D2HV1kR5odr9xyQGZ+WcPaytkZPE101T1+CFmuKkbGtOwUmoEQbMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=02YeYw4y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="02YeYw4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3DFC3277B;
	Tue, 18 Jun 2024 12:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715099;
	bh=qbRYXUTKdrZslcjsWd1oMtoB59rNoKr/BE9cRv6fSTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=02YeYw4yG/Js0Eq+4LhLRG3SnDdxwpgpiilA7dyDcOdYKMHf1I3MGlhwckd4+2hyL
	 iQfpd8/knC8VNOJEu9EaibaGrmZo8GTnl8XaWG7Qi+zy/DQp3rWwTDcbfTDlfe21Op
	 r6swMNazFSJH+00+yHegPPkO3IwPJq9SFUKchpek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miroslav Benes <mbenes@suse.cz>,
	Christoph Hellwig <hch@lst.de>,
	Jessica Yu <jeyu@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 194/770] kallsyms: only build {,module_}kallsyms_on_each_symbol when required
Date: Tue, 18 Jun 2024 14:30:47 +0200
Message-ID: <20240618123414.763809420@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 3e3552056ab42f883d7723eeb42fed712b66bacf ]

kallsyms_on_each_symbol and module_kallsyms_on_each_symbol are only used
by the livepatching code, so don't build them if livepatching is not
enabled.

Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kallsyms.h | 17 ++++-------------
 include/linux/module.h   | 16 ++++------------
 kernel/kallsyms.c        |  2 ++
 kernel/module.c          |  2 ++
 4 files changed, 12 insertions(+), 25 deletions(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index 481273f0c72d4..465060acc9816 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -71,15 +71,14 @@ static inline void *dereference_symbol_descriptor(void *ptr)
 	return ptr;
 }
 
-#ifdef CONFIG_KALLSYMS
-/* Lookup the address for a symbol. Returns 0 if not found. */
-unsigned long kallsyms_lookup_name(const char *name);
-
-/* Call a function on each kallsyms symbol in the core kernel */
 int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 				      unsigned long),
 			    void *data);
 
+#ifdef CONFIG_KALLSYMS
+/* Lookup the address for a symbol. Returns 0 if not found. */
+unsigned long kallsyms_lookup_name(const char *name);
+
 extern int kallsyms_lookup_size_offset(unsigned long addr,
 				  unsigned long *symbolsize,
 				  unsigned long *offset);
@@ -108,14 +107,6 @@ static inline unsigned long kallsyms_lookup_name(const char *name)
 	return 0;
 }
 
-static inline int kallsyms_on_each_symbol(int (*fn)(void *, const char *,
-						    struct module *,
-						    unsigned long),
-					  void *data)
-{
-	return 0;
-}
-
 static inline int kallsyms_lookup_size_offset(unsigned long addr,
 					      unsigned long *symbolsize,
 					      unsigned long *offset)
diff --git a/include/linux/module.h b/include/linux/module.h
index 86fae5d1c0e39..59cbd8e1be2d6 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -604,10 +604,6 @@ int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
 /* Look for this name: can be of form module:name. */
 unsigned long module_kallsyms_lookup_name(const char *name);
 
-int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
-					     struct module *, unsigned long),
-				   void *data);
-
 extern void __noreturn __module_put_and_exit(struct module *mod,
 			long code);
 #define module_put_and_exit(code) __module_put_and_exit(THIS_MODULE, code)
@@ -791,14 +787,6 @@ static inline unsigned long module_kallsyms_lookup_name(const char *name)
 	return 0;
 }
 
-static inline int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
-							   struct module *,
-							   unsigned long),
-						 void *data)
-{
-	return 0;
-}
-
 static inline int register_module_notifier(struct notifier_block *nb)
 {
 	/* no events will happen anyway, so this can always succeed */
@@ -887,4 +875,8 @@ static inline bool module_sig_ok(struct module *module)
 }
 #endif	/* CONFIG_MODULE_SIG */
 
+int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
+					     struct module *, unsigned long),
+				   void *data);
+
 #endif /* _LINUX_MODULE_H */
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index a0d3f0865916f..8043a90aa50ed 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -177,6 +177,7 @@ unsigned long kallsyms_lookup_name(const char *name)
 	return module_kallsyms_lookup_name(name);
 }
 
+#ifdef CONFIG_LIVEPATCH
 /*
  * Iterate over all symbols in vmlinux.  For symbols from modules use
  * module_kallsyms_on_each_symbol instead.
@@ -198,6 +199,7 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 	}
 	return 0;
 }
+#endif /* CONFIG_LIVEPATCH */
 
 static unsigned long get_symbol_pos(unsigned long addr,
 				    unsigned long *symbolsize,
diff --git a/kernel/module.c b/kernel/module.c
index 330387d63c633..949d09d2d8297 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -4444,6 +4444,7 @@ unsigned long module_kallsyms_lookup_name(const char *name)
 	return ret;
 }
 
+#ifdef CONFIG_LIVEPATCH
 int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 					     struct module *, unsigned long),
 				   void *data)
@@ -4474,6 +4475,7 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 	mutex_unlock(&module_mutex);
 	return ret;
 }
+#endif /* CONFIG_LIVEPATCH */
 #endif /* CONFIG_KALLSYMS */
 
 /* Maximum number of characters written by module_flags() */
-- 
2.43.0



