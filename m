Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C81D528
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 20:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=WXKrajJbqkbUb299wVP+wMZwzux4ve5i7i48jqTzVOM=; b=3AqsqJI8lCaM8wKT1MeU5adKVx
	yZUVeEU7kgWNaQDeh/xzFucDN4Eo2WI0oQhEQtYjLrZzlxLm/K6EgYpusTJvObavKIQq5OQ7/aGV6
	P2qhNLsnCTtYcoT2Gq6mV8hgc9pqnjQJyJPPBTxPS6+CxINAW06uYQhM/r+B2a+rTf1gZC3ORUVpl
	SFWiS9VweZ2Oedn5boZUmx5k9N3jEUYi+qIyoewiOXydRoabiTbtzYKZ6ihTguLW4MLFxkxmc2Cnx
	42fqvnsTQpDvHVmGcTxt7SbWhhrBrKOXofmIibo3iaW6acX0VORs7MqgDieHMi6lTGwAMqQNMKExv
	jE531YOQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pXpXS-003FxH-71; Thu, 02 Mar 2023 20:28:30 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: ebiederm@xmission.com,
	keescook@chromium.org,
	yzaikin@google.com,
	john.johansen@canonical.com,
	paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
	luto@amacapital.net,
	wad@chromium.org,
	dverkamp@chromium.org,
	paulmck@kernel.org,
	baihaowen@meizu.com,
	frederic@kernel.org,
	jeffxu@google.com,
	ebiggers@kernel.org,
	tytso@mit.edu,
	guoren@kernel.org
Cc: j.granados@samsung.com,
	zhangpeng362@huawei.com,
	tangmeng@uniontech.com,
	willy@infradead.org,
	nixiaoming@huawei.com,
	sujiaxun@uniontech.com,
	patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	apparmor@lists.ubuntu.com,
	linux-security-module@vger.kernel.org,
	linux-csky@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 05/11] loadpin: simplify sysctls use with register_sysctl()
Date: Thu,  2 Mar 2023 12:28:20 -0800
Message-Id: <20230302202826.776286-6-mcgrof@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230302202826.776286-1-mcgrof@kernel.org>
References: <20230302202826.776286-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

register_sysctl_paths() is not required, we can just use
register_sysctl() with the required path specified.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 security/loadpin/loadpin.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/security/loadpin/loadpin.c b/security/loadpin/loadpin.c
index d73a281adf86..c971464b4ad5 100644
--- a/security/loadpin/loadpin.c
+++ b/security/loadpin/loadpin.c
@@ -52,12 +52,6 @@ static bool deny_reading_verity_digests;
 #endif
 
 #ifdef CONFIG_SYSCTL
-static struct ctl_path loadpin_sysctl_path[] = {
-	{ .procname = "kernel", },
-	{ .procname = "loadpin", },
-	{ }
-};
-
 static struct ctl_table loadpin_sysctl_table[] = {
 	{
 		.procname       = "enforce",
@@ -262,7 +256,7 @@ static int __init loadpin_init(void)
 		enforce ? "" : "not ");
 	parse_exclude();
 #ifdef CONFIG_SYSCTL
-	if (!register_sysctl_paths(loadpin_sysctl_path, loadpin_sysctl_table))
+	if (!register_sysctl("kernel/loadpin", loadpin_sysctl_table))
 		pr_notice("sysctl registration failed!\n");
 #endif
 	security_add_hooks(loadpin_hooks, ARRAY_SIZE(loadpin_hooks), "loadpin");
-- 
2.39.1

