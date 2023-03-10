Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3588838
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 23:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=n3ibBOSHwLtyYWSPz4byfz4X1HpWIu7EDA2VdrWLfGg=; b=oY5BhI0UKiQJz+oVu3mMg8gY7t
	zqnqSgmo9/fkhKmgDQNJSot1ASq8dmZpKF3mHqTbtmtmRukQ/tB7GS1fAluaTbQfhd4TOlTqMapR5
	PPp1v2kxfb5Tqdx3/FAIg9O3eYr8KFWck+wdleTjGP4Dfsym9ZsKEUpRKs19Cz2nigJ8ilbF+zrIC
	/ZzQ3KQ2Ih8LAvctLYJv4LfZUEpXXms0Lmu3Wix/wtbK5SmHjF8VFe4zBfvTuQcL1dZWHikG+huRl
	yp5D0i3FpTXu5kH5iMkVSi4ZOoRVeNxM4PhFF7utzvjjCUfJkKJVAfmVtesXWAtp2oqeOqc99R+U9
	Sc/kDHhw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pam5w-00Gbr0-MM; Fri, 10 Mar 2023 23:24:16 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: linux-ia64@vger.kernel.org
Cc: ebiederm@xmission.com,
	keescook@chromium.org,
	yzaikin@google.com,
	j.granados@samsung.com,
	patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH] ia64: simplify one-level sysctl registration for kdump_ctl_table
Date: Fri, 10 Mar 2023 15:24:16 -0800
Message-Id: <20230310232416.3958751-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.37.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

There is no need to declare an extra tables to just create directory,
this can be easily be done with a prefix path with register_sysctl().

Simplify this registration.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---

If ia64 is not removed from the kernel feel free to take this or I can
take it through sysctl-next.

 arch/ia64/kernel/crash.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/arch/ia64/kernel/crash.c b/arch/ia64/kernel/crash.c
index 76730f34685c..88b3ce3e66cd 100644
--- a/arch/ia64/kernel/crash.c
+++ b/arch/ia64/kernel/crash.c
@@ -234,15 +234,6 @@ static struct ctl_table kdump_ctl_table[] = {
 	},
 	{ }
 };
-
-static struct ctl_table sys_table[] = {
-	{
-	  .procname = "kernel",
-	  .mode = 0555,
-	  .child = kdump_ctl_table,
-	},
-	{ }
-};
 #endif
 
 static int
@@ -257,7 +248,7 @@ machine_crash_setup(void)
 	if((ret = register_die_notifier(&kdump_init_notifier_nb)) != 0)
 		return ret;
 #ifdef CONFIG_SYSCTL
-	register_sysctl_table(sys_table);
+	register_sysctl("kernel", kdump_ctl_table);
 #endif
 	return 0;
 }
-- 
2.39.1

