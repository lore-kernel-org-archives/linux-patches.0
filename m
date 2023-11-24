Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D56633075;
	Fri, 24 Nov 2023 18:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i2+wXoqb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71B8C433C8;
	Fri, 24 Nov 2023 18:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851997;
	bh=kbk7wqJAQmvSiz9uZdswUWLCCo1P+Ymova+8ECZ3O38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i2+wXoqbJazXFOOWf9KksDhmwCB9jBHPlosCT5Zjg2qW236RcS82M6Ks9VgcAmWWw
	 3M6rb2vV0uE7RFB1iEw5XBW+horqSJUWw7cKGfmDFJVin7JA+dUnrjmrzaDWtjuOnm
	 8M5JheOH4yVWI9BgETeGr6LZYHc/hOFaFQaEOgU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krister Johansen <kjlx@templeofstupid.com>,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 6.1 179/372] proc: sysctl: prevent aliased sysctls from getting passed to init
Date: Fri, 24 Nov 2023 17:49:26 +0000
Message-ID: <20231124172016.430526927@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

From: Krister Johansen <kjlx@templeofstupid.com>

commit 8001f49394e353f035306a45bcf504f06fca6355 upstream.

The code that checks for unknown boot options is unaware of the sysctl
alias facility, which maps bootparams to sysctl values.  If a user sets
an old value that has a valid alias, a message about an invalid
parameter will be printed during boot, and the parameter will get passed
to init.  Fix by checking for the existence of aliased parameters in the
unknown boot parameter code.  If an alias exists, don't return an error
or pass the value to init.

Signed-off-by: Krister Johansen <kjlx@templeofstupid.com>
Cc: stable@vger.kernel.org
Fixes: 0a477e1ae21b ("kernel/sysctl: support handling command line aliases")
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/proc_sysctl.c  |    7 +++++++
 include/linux/sysctl.h |    6 ++++++
 init/main.c            |    4 ++++
 3 files changed, 17 insertions(+)

--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -1830,6 +1830,13 @@ static const char *sysctl_find_alias(cha
 	return NULL;
 }
 
+bool sysctl_is_alias(char *param)
+{
+	const char *alias = sysctl_find_alias(param);
+
+	return alias != NULL;
+}
+
 /* Set sysctl value passed on kernel command line. */
 static int process_sysctl_arg(char *param, char *val,
 			       const char *unused, void *arg)
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -238,6 +238,7 @@ extern void __register_sysctl_init(const
 extern struct ctl_table_header *register_sysctl_mount_point(const char *path);
 
 void do_sysctl_args(void);
+bool sysctl_is_alias(char *param);
 int do_proc_douintvec(struct ctl_table *table, int write,
 		      void *buffer, size_t *lenp, loff_t *ppos,
 		      int (*conv)(unsigned long *lvalp,
@@ -301,6 +302,11 @@ static inline void setup_sysctl_set(stru
 static inline void do_sysctl_args(void)
 {
 }
+
+static inline bool sysctl_is_alias(char *param)
+{
+	return false;
+}
 #endif /* CONFIG_SYSCTL */
 
 int sysctl_max_threads(struct ctl_table *table, int write, void *buffer,
--- a/init/main.c
+++ b/init/main.c
@@ -533,6 +533,10 @@ static int __init unknown_bootoption(cha
 {
 	size_t len = strlen(param);
 
+	/* Handle params aliased to sysctls */
+	if (sysctl_is_alias(param))
+		return 0;
+
 	repair_env_string(param, val);
 
 	/* Handle obsolete-style parameters */


