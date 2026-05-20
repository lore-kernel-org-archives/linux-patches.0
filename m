Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAE1331220;
	Wed, 20 May 2026 17:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297536; cv=none; b=eR8JP/ymcZsGdfy356Z1BeoNf7xnl6aej12UtB36XuJL/0S3N/40sxjf9a6RqAh58jBjPTUGPUfeI9jKPol7rIF3IcI/88TBJ81QldoyP3IqVAnULBgFv2BlyXhTy9C/BX9XU8BzhZu/kjSWbVGYS5ObTH2FK0SPP+fSkGZ96f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297536; c=relaxed/simple;
	bh=T7N+8hwKymuysgq4mCO5aOTswE2U0oPLf2s9qES+fd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rj1FmWqiRweXflMiPW06U0xQDzOUp4GdOZY8j171ruAth6m0LLycH4ldktJ/L8ET0CiyjUrnIKXAEsh7R6ztdarck/qQO9V+FUWSwSiz8gDfVcAgx9MjtPh7fUiwbKsQxvS5K0BEi+rtsriEmQubB+ie2bPlgKdJAij4KHo2gxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oyMuzsEX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oyMuzsEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B981F000E9;
	Wed, 20 May 2026 17:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297535;
	bh=tUVL/nuF94naZR1D9XQoNCZfPCB3CeWAOpmRpd1+XYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oyMuzsEXIA1UDJEU72WPYdm8/3JNPAuBFvXaa0B5dUOvmG3IxLE/j8Qu4+FEXNIQL
	 LElgBaugNzA3bN8AW/hbOTDYsEinrYjTisn3+5P0fX81+MaTcepMXpNiV1NWAVn+1a
	 GX+OPV1RrY2RqdJxn7cAkSCkSOeArqgH96vQD5hA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Pavlu <petr.pavlu@suse.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 067/957] params: Replace __modinit with __init_or_module
Date: Wed, 20 May 2026 18:09:10 +0200
Message-ID: <20260520162136.017195720@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Pavlu <petr.pavlu@suse.com>

[ Upstream commit 3cb0c3bdea5388519bc1bf575dca6421b133302b ]

Remove the custom __modinit macro from kernel/params.c and instead use the
common __init_or_module macro from include/linux/module.h. Both provide the
same functionality.

Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
Reviewed-by: Daniel Gomez <da.gomez@samsung.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Stable-dep-of: deffe1edba62 ("module: Fix freeing of charp module parameters when CONFIG_SYSFS=n")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/params.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index b96cfd693c996..7c2242f64bf08 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -596,12 +596,6 @@ static ssize_t param_attr_store(const struct module_attribute *mattr,
 }
 #endif
 
-#ifdef CONFIG_MODULES
-#define __modinit
-#else
-#define __modinit __init
-#endif
-
 #ifdef CONFIG_SYSFS
 void kernel_param_lock(struct module *mod)
 {
@@ -626,9 +620,9 @@ EXPORT_SYMBOL(kernel_param_unlock);
  * create file in sysfs.  Returns an error on out of memory.  Always cleans up
  * if there's an error.
  */
-static __modinit int add_sysfs_param(struct module_kobject *mk,
-				     const struct kernel_param *kp,
-				     const char *name)
+static __init_or_module int add_sysfs_param(struct module_kobject *mk,
+					    const struct kernel_param *kp,
+					    const char *name)
 {
 	struct module_param_attrs *new_mp;
 	struct attribute **new_attrs;
@@ -761,7 +755,8 @@ void destroy_params(const struct kernel_param *params, unsigned num)
 			params[i].ops->free(params[i].arg);
 }
 
-struct module_kobject __modinit * lookup_or_create_module_kobject(const char *name)
+struct module_kobject * __init_or_module
+lookup_or_create_module_kobject(const char *name)
 {
 	struct module_kobject *mk;
 	struct kobject *kobj;
-- 
2.53.0



