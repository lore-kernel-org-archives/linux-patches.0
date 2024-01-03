Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F141BDDE;
	Wed,  3 Jan 2024 17:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rWpsjGqx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45469C433CA;
	Wed,  3 Jan 2024 17:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301314;
	bh=XKskyg5xyUXde2mGQJULjDRiQ68IZ7wKPG33s4jae8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rWpsjGqxDpbHrra1PAIl5cQP8vKuwBFNTV1VKmpAFlH0qEdGOBRShueRDKyL2NgH2
	 XwVCX2J+UXtTqHFMP1x6H908eA4xsXjkbrt4VyZVsIFaGE2sxDjygJ9OSraVyAxX5M
	 J14mBSWonNEX3j0tywrC4kVYtgjz9B1Dc93JZjIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Song Liu <song@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.1 099/100] kallsyms: Make module_kallsyms_on_each_symbol generally available
Date: Wed,  3 Jan 2024 17:55:28 +0100
Message-ID: <20240103164910.986530391@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

commit 73feb8d5fa3b755bb51077c0aabfb6aa556fd498 upstream.

Making module_kallsyms_on_each_symbol generally available, so it
can be used outside CONFIG_LIVEPATCH option in following changes.

Rather than adding another ifdef option let's make the function
generally available (when CONFIG_KALLSYMS and CONFIG_MODULES
options are defined).

Cc: Christoph Hellwig <hch@lst.de>
Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20221025134148.3300700-2-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/module.h   |    9 +++++++++
 kernel/module/kallsyms.c |    2 --
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -879,8 +879,17 @@ static inline bool module_sig_ok(struct
 }
 #endif	/* CONFIG_MODULE_SIG */
 
+#if defined(CONFIG_MODULES) && defined(CONFIG_KALLSYMS)
 int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 					     struct module *, unsigned long),
 				   void *data);
+#else
+static inline int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
+						 struct module *, unsigned long),
+						 void *data)
+{
+	return -EOPNOTSUPP;
+}
+#endif  /* CONFIG_MODULES && CONFIG_KALLSYMS */
 
 #endif /* _LINUX_MODULE_H */
--- a/kernel/module/kallsyms.c
+++ b/kernel/module/kallsyms.c
@@ -494,7 +494,6 @@ unsigned long module_kallsyms_lookup_nam
 	return ret;
 }
 
-#ifdef CONFIG_LIVEPATCH
 int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 					     struct module *, unsigned long),
 				   void *data)
@@ -531,4 +530,3 @@ out:
 	mutex_unlock(&module_mutex);
 	return ret;
 }
-#endif /* CONFIG_LIVEPATCH */


