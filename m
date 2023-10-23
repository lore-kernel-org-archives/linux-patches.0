Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2471915E84
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oxKZarNF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90439C433C7;
	Mon, 23 Oct 2023 11:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060473;
	bh=Vui3eJrnpHziMPwQq/vrVa3JtFcO8wIwMmpiAJKDRtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oxKZarNFbGx1ovc+s8+K2xZLR2Te7DoU8ADDKFK2nRBxBoUXkpeffEk0/r/o5o9yw
	 4+mCdYEFyeovnC0SNXY1lukinq1R/FKNhHe1obrD0ztObHDApAPgAGT47yHl7/lrVl
	 E8wJwbG5Wjq1rll/fBFbgWbe6VSftsMhxTDPD9RE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 184/196] kallsyms: Add helper kallsyms_on_each_match_symbol()
Date: Mon, 23 Oct 2023 12:57:29 +0200
Message-ID: <20231023104833.588256511@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 4dc533e0f2c04174e1ae4aa98e7cffc1c04b9998 ]

Function kallsyms_on_each_symbol() traverses all symbols and submits each
symbol to the hook 'fn' for judgment and processing. For some cases, the
hook actually only handles the matched symbol, such as livepatch.

Because all symbols are currently sorted by name, all the symbols with the
same name are clustered together. Function kallsyms_lookup_names() gets
the start and end positions of the set corresponding to the specified
name. So we can easily and quickly traverse all the matches.

The test results are as follows (twice): (x86)
kallsyms_on_each_match_symbol:     7454,     7984
kallsyms_on_each_symbol      : 11733809, 11785803

kallsyms_on_each_match_symbol() consumes only 0.066% of
kallsyms_on_each_symbol()'s time. In other words, 1523x better
performance.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Stable-dep-of: b022f0c7e404 ("tracing/kprobes: Return EADDRNOTAVAIL when func matches several symbols")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kallsyms.h |  8 ++++++++
 kernel/kallsyms.c        | 18 ++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index 649faac31ddb1..0cd33be7142ad 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -69,6 +69,8 @@ static inline void *dereference_symbol_descriptor(void *ptr)
 int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 				      unsigned long),
 			    void *data);
+int kallsyms_on_each_match_symbol(int (*fn)(void *, unsigned long),
+				  const char *name, void *data);
 
 /* Lookup the address for a symbol. Returns 0 if not found. */
 unsigned long kallsyms_lookup_name(const char *name);
@@ -168,6 +170,12 @@ static inline int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct
 {
 	return -EOPNOTSUPP;
 }
+
+static inline int kallsyms_on_each_match_symbol(int (*fn)(void *, unsigned long),
+						const char *name, void *data)
+{
+	return -EOPNOTSUPP;
+}
 #endif /*CONFIG_KALLSYMS*/
 
 static inline void print_ip_sym(const char *loglvl, unsigned long ip)
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 32cba13eee6c4..824bcc7b5dbc3 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -303,6 +303,24 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 	return 0;
 }
 
+int kallsyms_on_each_match_symbol(int (*fn)(void *, unsigned long),
+				  const char *name, void *data)
+{
+	int ret;
+	unsigned int i, start, end;
+
+	ret = kallsyms_lookup_names(name, &start, &end);
+	if (ret)
+		return 0;
+
+	for (i = start; !ret && i <= end; i++) {
+		ret = fn(data, kallsyms_sym_address(get_symbol_seq(i)));
+		cond_resched();
+	}
+
+	return ret;
+}
+
 static unsigned long get_symbol_pos(unsigned long addr,
 				    unsigned long *symbolsize,
 				    unsigned long *offset)
-- 
2.42.0



