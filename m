Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A56D6FB4
	for <patches@lists.linux.dev>; Mon, 19 Dec 2022 19:25:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44852C433EF;
	Mon, 19 Dec 2022 19:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671477931;
	bh=9QF0bl25L5DLL1DBNGISC6SPFeEo/9AT4+fpHI6PJ4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2AZZ74NsK1P0Hq8p7NgwY8DSkE7wVTXZvAXS+yZlwl8D+6dA8jhPpBgG3lV0MJ3JZ
	 LPkAFEEO9gSlKcz5cI/PI5et0TFPOpi2r1tsg7Ujlnta/mmdt1T+ktQ9oR+Fudk9J9
	 pgnIxbyDuFwFuiPY1DoMjCf8EyiFX/7gtsdchg7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Song Liu <song@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.0 02/28] kallsyms: Make module_kallsyms_on_each_symbol generally available
Date: Mon, 19 Dec 2022 20:22:49 +0100
Message-Id: <20221219182944.294037997@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>
References: <20221219182944.179389009@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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


