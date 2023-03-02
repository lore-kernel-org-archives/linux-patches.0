Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20BDD524
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 20:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=G2dvxuEO3y0hAzFqFB/q2zGbeQi/W5a2UeiLF5jk9G8=; b=dz5ZgYi0lmfMYDtwxeNMmARonM
	bGKbYQrkx2v9+PjH3cal0POP2lH7QGVLsumOWP5m4oUHoTA4tIZoVq7nwf0xv3F6KIvgMiPJMu7+X
	0o4Ko9mOYbBvD5AZjAIbXFyfIT0A4CrDKfVULMACnA2mIezbuYKLOyERcRHU1l583qQiZKfSePJCa
	2LZXJSBJ64TQkJvCq0UqFAQE0p8uE6dgsv9fOAtyT8N4BZwVtUmdFZ6E1TuDrwoCDowsHQs5L35h7
	hXz+2zE/s6nLemRtxxIDFJFMoyFobXifCqs8HoANisI/dBldTE+xmMW0dpM22OOEdTizcKnhRDGdg
	8G5txOUA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pXpXS-003FxP-Gb; Thu, 02 Mar 2023 20:28:30 +0000
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
Subject: [PATCH 09/11] fs-verity: simplify sysctls with register_sysctl()
Date: Thu,  2 Mar 2023 12:28:24 -0800
Message-Id: <20230302202826.776286-10-mcgrof@kernel.org>
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

register_sysctl_paths() is only needed if your child (directories) have
entries but this does not so just use register_sysctl() so to do away
with the path specification.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/verity/signature.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/fs/verity/signature.c b/fs/verity/signature.c
index e7d3ca919a1e..b8c51ad40d3a 100644
--- a/fs/verity/signature.c
+++ b/fs/verity/signature.c
@@ -88,12 +88,6 @@ int fsverity_verify_signature(const struct fsverity_info *vi,
 #ifdef CONFIG_SYSCTL
 static struct ctl_table_header *fsverity_sysctl_header;
 
-static const struct ctl_path fsverity_sysctl_path[] = {
-	{ .procname = "fs", },
-	{ .procname = "verity", },
-	{ }
-};
-
 static struct ctl_table fsverity_sysctl_table[] = {
 	{
 		.procname       = "require_signatures",
@@ -109,8 +103,7 @@ static struct ctl_table fsverity_sysctl_table[] = {
 
 static int __init fsverity_sysctl_init(void)
 {
-	fsverity_sysctl_header = register_sysctl_paths(fsverity_sysctl_path,
-						       fsverity_sysctl_table);
+	fsverity_sysctl_header = register_sysctl("fs/verity", fsverity_sysctl_table);
 	if (!fsverity_sysctl_header) {
 		pr_err("sysctl registration failed!\n");
 		return -ENOMEM;
-- 
2.39.1

