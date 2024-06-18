Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DDC13E8B9;
	Tue, 18 Jun 2024 12:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715097; cv=none; b=eW/V2YDwLCsRhfakQqkbbciA27kYmE5vfhUKFk+ysINWvxkprifeTGJqxZ1mz12/YR574mqH/NarR8cvPNvq55iSAJgTxXQnZxpBov5nDqaYOmfqhIfIfn+fEfTFVmYG0y6bQnT5BFPz61C40/jm/lJhdSX1iba+IaR3BqGqUsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715097; c=relaxed/simple;
	bh=H4yxPYhlhE6970ACa2BTc7/DO5FL9QZ7p35HSnJ+qlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pk1AlF1wnuvrqaE0vYB5HjngSLOKoPouqZSxj1vhBOSlPA9UYuPQNZ9ntVTuvKnC1ypjAFTGf1N0tkuJxAbnLBiRLI+9cQ8zbvZUNbRYDM3B7Q+qgJ38v7TzZS/8MHDPISbrNlOR2Uhm4zqARgYiX+W7KZtjZ5jFWnyX2gkp4Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FvzAp1fB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FvzAp1fB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE2DC3277B;
	Tue, 18 Jun 2024 12:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715097;
	bh=H4yxPYhlhE6970ACa2BTc7/DO5FL9QZ7p35HSnJ+qlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FvzAp1fBTSjP2FeBC4Z0bLhTAWCNaAOeKW6i3vlH46+p2R9QzzwIFEM6H0TmRtXqc
	 a6XQlcK70nf4zPpI3Phh7GsowSqKqEx14f7vGGwXkl80NI64fjC4JMXEZzBBeOKixD
	 R3AZLUvm1C4SFjJ5logVQGfSo2S5VbyfHCYiy0Fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Mladek <pmladek@suse.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Christoph Hellwig <hch@lst.de>,
	Jessica Yu <jeyu@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 193/770] kallsyms: refactor {,module_}kallsyms_on_each_symbol
Date: Tue, 18 Jun 2024 14:30:46 +0200
Message-ID: <20240618123414.726153762@linuxfoundation.org>
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

[ Upstream commit 013c1667cf78c1d847152f7116436d82dcab3db4 ]

Require an explicit call to module_kallsyms_on_each_symbol to look
for symbols in modules instead of the call from kallsyms_on_each_symbol,
and acquire module_mutex inside of module_kallsyms_on_each_symbol instead
of leaving that up to the caller.  Note that this slightly changes the
behavior for the livepatch code in that the symbols from vmlinux are not
iterated anymore if objname is set, but that actually is the desired
behavior in this case.

Reviewed-by: Petr Mladek <pmladek@suse.com>
Acked-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kallsyms.c       |  6 +++++-
 kernel/livepatch/core.c |  2 --
 kernel/module.c         | 13 ++++---------
 3 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index fe9de067771c3..a0d3f0865916f 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -177,6 +177,10 @@ unsigned long kallsyms_lookup_name(const char *name)
 	return module_kallsyms_lookup_name(name);
 }
 
+/*
+ * Iterate over all symbols in vmlinux.  For symbols from modules use
+ * module_kallsyms_on_each_symbol instead.
+ */
 int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 				      unsigned long),
 			    void *data)
@@ -192,7 +196,7 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 		if (ret != 0)
 			return ret;
 	}
-	return module_kallsyms_on_each_symbol(fn, data);
+	return 0;
 }
 
 static unsigned long get_symbol_pos(unsigned long addr,
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index e660ea4f90a28..147ed154ebc77 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -164,12 +164,10 @@ static int klp_find_object_symbol(const char *objname, const char *name,
 		.pos = sympos,
 	};
 
-	mutex_lock(&module_mutex);
 	if (objname)
 		module_kallsyms_on_each_symbol(klp_find_callback, &args);
 	else
 		kallsyms_on_each_symbol(klp_find_callback, &args);
-	mutex_unlock(&module_mutex);
 
 	/*
 	 * Ensure an address was found. If sympos is 0, ensure symbol is unique;
diff --git a/kernel/module.c b/kernel/module.c
index 1f9f6133c30ef..330387d63c633 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -255,11 +255,6 @@ static void mod_update_bounds(struct module *mod)
 struct list_head *kdb_modules = &modules; /* kdb needs the list of modules */
 #endif /* CONFIG_KGDB_KDB */
 
-static void module_assert_mutex(void)
-{
-	lockdep_assert_held(&module_mutex);
-}
-
 static void module_assert_mutex_or_preempt(void)
 {
 #ifdef CONFIG_LOCKDEP
@@ -4457,8 +4452,7 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 	unsigned int i;
 	int ret;
 
-	module_assert_mutex();
-
+	mutex_lock(&module_mutex);
 	list_for_each_entry(mod, &modules, list) {
 		/* We hold module_mutex: no need for rcu_dereference_sched */
 		struct mod_kallsyms *kallsyms = mod->kallsyms;
@@ -4474,10 +4468,11 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 			ret = fn(data, kallsyms_symbol_name(kallsyms, i),
 				 mod, kallsyms_symbol_value(sym));
 			if (ret != 0)
-				return ret;
+				break;
 		}
 	}
-	return 0;
+	mutex_unlock(&module_mutex);
+	return ret;
 }
 #endif /* CONFIG_KALLSYMS */
 
-- 
2.43.0



