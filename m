Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811821D517F;
	Tue, 15 Oct 2024 13:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998432; cv=none; b=D7jHY6m6E8NwSAZ8slZi8JuusSOim6hnNc3yIwWJTs2+6CdaFMvwbwcsuCZ21+FeJ8poEaU5+zvKJ9FTIxYaeI3dN+L+7GcG5+N93ggzl2p65WjYTcUvwWPQlfTOJrHSKb+0psIGNrofCc/3Y6AkCanEc0u+OFhvQaBSfwui6Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998432; c=relaxed/simple;
	bh=50NXQDNvuIIfGDPKtbRY+3zkhLA0SvZ7wRBziGHecFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aScEINcPZPtdz8qRQBGM6JmpUvP90gxmAbQpfBAsMaix8XL4ABMKZXVhgeRxuaAyOpUNNNDnSDljywBL4WafIACcS2+F67QlGaWKPCslcx7dr1QyBCxCcD16ofvLup3ZyBiMZ1S8aDtonhBzuAZeHdDYo5mTCEVfyc51jGC0/v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IS2RTrXZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IS2RTrXZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6CDCC4CEC6;
	Tue, 15 Oct 2024 13:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998432;
	bh=50NXQDNvuIIfGDPKtbRY+3zkhLA0SvZ7wRBziGHecFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IS2RTrXZZ09skoFeOIDOFRmRYXUpwdmISp5V9JeTgwUcHqvuKb8ygtQUxJO+v7Tvn
	 YcnW3BmUYhQxTldQoNIrPon5cD7n1U7YdhNjgIStou6QZ40Bwh/gO2h0cMRp7CWU7M
	 EkDt/UQxaIesr2MiEw0RgrLOxd9x0WcjChaSMxIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Sherry Yang <sherry.yang@oracle.com>
Subject: [PATCH 5.10 444/518] kallsyms: Make kallsyms_on_each_symbol generally available
Date: Tue, 15 Oct 2024 14:45:48 +0200
Message-ID: <20241015123934.140714948@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit d721def7392a7348ffb9f3583b264239cbd3702c ]

Making kallsyms_on_each_symbol generally available, so it can be
used outside CONFIG_LIVEPATCH option in following changes.

Rather than adding another ifdef option let's make the function
generally available (when CONFIG_KALLSYMS option is defined).

Cc: Christoph Hellwig <hch@lst.de>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20220510122616.2652285-2-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Stable-dep-of: b022f0c7e404 ("tracing/kprobes: Return EADDRNOTAVAIL when
func matches several symbols")
Signed-off-by: Sherry Yang <sherry.yang@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kallsyms.h | 7 ++++++-
 kernel/kallsyms.c        | 2 --
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index 465060acc9816..430f1cefbb9e1 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -71,11 +71,11 @@ static inline void *dereference_symbol_descriptor(void *ptr)
 	return ptr;
 }
 
+#ifdef CONFIG_KALLSYMS
 int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 				      unsigned long),
 			    void *data);
 
-#ifdef CONFIG_KALLSYMS
 /* Lookup the address for a symbol. Returns 0 if not found. */
 unsigned long kallsyms_lookup_name(const char *name);
 
@@ -155,6 +155,11 @@ static inline bool kallsyms_show_value(const struct cred *cred)
 	return false;
 }
 
+static inline int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
+					  unsigned long), void *data)
+{
+	return -EOPNOTSUPP;
+}
 #endif /*CONFIG_KALLSYMS*/
 
 static inline void print_ip_sym(const char *loglvl, unsigned long ip)
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 8043a90aa50ed..a0d3f0865916f 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -177,7 +177,6 @@ unsigned long kallsyms_lookup_name(const char *name)
 	return module_kallsyms_lookup_name(name);
 }
 
-#ifdef CONFIG_LIVEPATCH
 /*
  * Iterate over all symbols in vmlinux.  For symbols from modules use
  * module_kallsyms_on_each_symbol instead.
@@ -199,7 +198,6 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 	}
 	return 0;
 }
-#endif /* CONFIG_LIVEPATCH */
 
 static unsigned long get_symbol_pos(unsigned long addr,
 				    unsigned long *symbolsize,
-- 
2.43.0



