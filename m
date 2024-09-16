Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6282C155391;
	Mon, 16 Sep 2024 12:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488427; cv=none; b=AGlOrmYwQNI3f5ehpEw3PZWMOXrCGUQ6FedTfT3c7WXqJ2F4JdHpl+y4vyFjCbJkeT03v/iGUAvjWm7UP2mwk5YZOuGJfsWntnOliIzui1DvKJcCDdCfX3FcM6c8rN6nZkxJ+BnqI7Cxq9HlyJfage3RHZ6bpEAMiErOeKDxur8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488427; c=relaxed/simple;
	bh=k0ybQAEsTdJv3h9NKzef9FXrg3iYI1QIAcU1QDzD1Ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBlnJHhX5fYXTd0qtfsyCtOPHrW/5t47DLZGHIEyVqKce6DzcxdLVBBtgBbZ3TRL8x3Xl+jspN81dfqHEcgyoD0+I2UE/CQS5I3CRGT/EfMiTQu82/oDdHi8jWfCkkYGgN57Z4We/RqqjCLql52LIBn1Jrar5m532nf1ugQLqa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BAR3aVmO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BAR3aVmO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25E7C4CEC4;
	Mon, 16 Sep 2024 12:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488427;
	bh=k0ybQAEsTdJv3h9NKzef9FXrg3iYI1QIAcU1QDzD1Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BAR3aVmOr3XR+avflCYcXNDnRB2uDvrGhVVlScwXnOgIkOAKvlbmeMn3E3+PCk/6z
	 yg4qfHsJcQqX7+GHeSuUgGTmYhJCwcnYD4Dm6qHyR9kE55qylVURri6d2BdJcuGFrn
	 2QtwyMQjCVjZQ/ZGOFPASM68DVK71l12jxPzeNsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Thorsten Leemhuis <regressions@leemhuis.info>
Subject: [PATCH 6.10 110/121] tracing/kprobes: Fix build error when find_module() is not available
Date: Mon, 16 Sep 2024 13:44:44 +0200
Message-ID: <20240916114232.732979657@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit b10545b6b86b7a0b3e26b4c2a5c99b72d49bc4de upstream.

The kernel test robot reported that the find_module() is not available
if CONFIG_MODULES=n.
Fix this error by hiding find_modules() in #ifdef CONFIG_MODULES with
related rcu locks as try_module_get_by_name().

Link: https://lore.kernel.org/all/172056819167.201571.250053007194508038.stgit@devnote2/

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202407070744.RcLkn8sq-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202407070917.VVUCBlaS-lkp@intel.com/
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_kprobe.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -794,6 +794,24 @@ static int validate_module_probe_symbol(
 	return 0;
 }
 
+#ifdef CONFIG_MODULES
+/* Return NULL if the module is not loaded or under unloading. */
+static struct module *try_module_get_by_name(const char *name)
+{
+	struct module *mod;
+
+	rcu_read_lock_sched();
+	mod = find_module(name);
+	if (mod && !try_module_get(mod))
+		mod = NULL;
+	rcu_read_unlock_sched();
+
+	return mod;
+}
+#else
+#define try_module_get_by_name(name)	(NULL)
+#endif
+
 static int validate_probe_symbol(char *symbol)
 {
 	struct module *mod = NULL;
@@ -805,12 +823,7 @@ static int validate_probe_symbol(char *s
 		modname = symbol;
 		symbol = p + 1;
 		*p = '\0';
-		/* Return 0 (defer) if the module does not exist yet. */
-		rcu_read_lock_sched();
-		mod = find_module(modname);
-		if (mod && !try_module_get(mod))
-			mod = NULL;
-		rcu_read_unlock_sched();
+		mod = try_module_get_by_name(modname);
 		if (!mod)
 			goto out;
 	}


