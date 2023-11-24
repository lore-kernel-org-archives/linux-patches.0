Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A1D39FFD;
	Fri, 24 Nov 2023 18:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SyKPFohJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B87FC433C8;
	Fri, 24 Nov 2023 18:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849649;
	bh=kGA4yeavj1LukDbBJwMHSKOMbbtM3CdPKA3knA+h//E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SyKPFohJnqi5U3CWVNdEISGO1tRV6etHjgOjP5mtfPTwpTebMmWbqd8KMCtRFeAfR
	 beKoxcY0rPME3rqiD6VAkvFKZDNfzudIEZOaP4mFhI3WEM/9WCakuNIJCUq+1rKgU4
	 jj9qMp8MU7vcAceDOfF03OerKBLqI/7x3UeFXQS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krister Johansen <kjlx@templeofstupid.com>,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 6.6 265/530] proc: sysctl: prevent aliased sysctls from getting passed to init
Date: Fri, 24 Nov 2023 17:47:11 +0000
Message-ID: <20231124172036.101220387@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1592,6 +1592,13 @@ static const char *sysctl_find_alias(cha
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
@@ -242,6 +242,7 @@ extern void __register_sysctl_init(const
 extern struct ctl_table_header *register_sysctl_mount_point(const char *path);
 
 void do_sysctl_args(void);
+bool sysctl_is_alias(char *param);
 int do_proc_douintvec(struct ctl_table *table, int write,
 		      void *buffer, size_t *lenp, loff_t *ppos,
 		      int (*conv)(unsigned long *lvalp,
@@ -287,6 +288,11 @@ static inline void setup_sysctl_set(stru
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
@@ -530,6 +530,10 @@ static int __init unknown_bootoption(cha
 {
 	size_t len = strlen(param);
 
+	/* Handle params aliased to sysctls */
+	if (sysctl_is_alias(param))
+		return 0;
+
 	repair_env_string(param, val);
 
 	/* Handle obsolete-style parameters */


