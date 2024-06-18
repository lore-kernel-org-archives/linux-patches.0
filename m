Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331C813E8B9;
	Tue, 18 Jun 2024 12:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715094; cv=none; b=cudupXppXq5k/mEWudDHJ9vjHf7I2TDrr0jRI5zCtLcF2+dSDkKFy6GulgH4k8qtjQWugC8rKTu4Z3iaYaIsT0MYLrhW2geEA3oN7+rvOQJHg7cG9knCXFK6sHZmsOj7m7FT0qFEiSRMediARydtpD87s7YxJaPF43Iexbmqmj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715094; c=relaxed/simple;
	bh=2IlLG1UApOj4QKc44+LSSAqes/h/kfdJIqFZ+slRV0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DSV7Kya9nMFBn++enFJIXKHtl9EYrE1AAqyiC7mAt9rs4I0oYuWW/xwFri/s/qmv7ah4RJzKlwa5O9U/Ex9FsGNr28lDynycpfJuVObt1hEnGni3CmeJG6xf+0OG/Lx6zFaC0KGyTAsUEyV+bpKstgfk48dds7+UtdtclTT1IxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMcR6PXd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMcR6PXd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA71BC3277B;
	Tue, 18 Jun 2024 12:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715094;
	bh=2IlLG1UApOj4QKc44+LSSAqes/h/kfdJIqFZ+slRV0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMcR6PXdY//vK+jDFrlyNTXWzDRXkRgBpn3ruPQvUNCwtAEijD4wdhvpDOsFXxzwE
	 a9sEr9CEFn6uSBY97oB6GuWCdQVxwOvPF+c7WMPNr5/0jYXZYfnwL5mj+7tKRigfG7
	 Vy7LWV3wyEJqCJNLXDO7KWn7mksFoLvryw7xkKsI=
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
Subject: [PATCH 5.10 192/770] module: use RCU to synchronize find_module
Date: Tue, 18 Jun 2024 14:30:45 +0200
Message-ID: <20240618123414.687801959@linuxfoundation.org>
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

[ Upstream commit a006050575745ca2be25118b90f1c37f454ac542 ]

Allow for a RCU-sched critical section around find_module, following
the lower level find_module_all helper, and switch the two callers
outside of module.c to use such a RCU-sched critical section instead
of module_mutex.

Reviewed-by: Petr Mladek <pmladek@suse.com>
Acked-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/module.h      | 2 +-
 kernel/livepatch/core.c     | 5 +++--
 kernel/module.c             | 1 -
 kernel/trace/trace_kprobe.c | 4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 6264617bab4d4..86fae5d1c0e39 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -582,7 +582,7 @@ static inline bool within_module(unsigned long addr, const struct module *mod)
 	return within_module_init(addr, mod) || within_module_core(addr, mod);
 }
 
-/* Search for module by name: must hold module_mutex. */
+/* Search for module by name: must be in a RCU-sched critical section. */
 struct module *find_module(const char *name);
 
 struct symsearch {
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index f5faf935c2d8f..e660ea4f90a28 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -19,6 +19,7 @@
 #include <linux/moduleloader.h>
 #include <linux/completion.h>
 #include <linux/memory.h>
+#include <linux/rcupdate.h>
 #include <asm/cacheflush.h>
 #include "core.h"
 #include "patch.h"
@@ -57,7 +58,7 @@ static void klp_find_object_module(struct klp_object *obj)
 	if (!klp_is_module(obj))
 		return;
 
-	mutex_lock(&module_mutex);
+	rcu_read_lock_sched();
 	/*
 	 * We do not want to block removal of patched modules and therefore
 	 * we do not take a reference here. The patches are removed by
@@ -74,7 +75,7 @@ static void klp_find_object_module(struct klp_object *obj)
 	if (mod && mod->klp_alive)
 		obj->mod = mod;
 
-	mutex_unlock(&module_mutex);
+	rcu_read_unlock_sched();
 }
 
 static bool klp_initialized(void)
diff --git a/kernel/module.c b/kernel/module.c
index c0e51ffe26f0a..1f9f6133c30ef 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -641,7 +641,6 @@ static struct module *find_module_all(const char *name, size_t len,
 
 struct module *find_module(const char *name)
 {
-	module_assert_mutex();
 	return find_module_all(name, strlen(name), false);
 }
 
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 7183572898998..5453af26ff764 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -124,9 +124,9 @@ static nokprobe_inline bool trace_kprobe_module_exist(struct trace_kprobe *tk)
 	if (!p)
 		return true;
 	*p = '\0';
-	mutex_lock(&module_mutex);
+	rcu_read_lock_sched();
 	ret = !!find_module(tk->symbol);
-	mutex_unlock(&module_mutex);
+	rcu_read_unlock_sched();
 	*p = ':';
 
 	return ret;
-- 
2.43.0



