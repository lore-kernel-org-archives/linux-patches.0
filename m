Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E71E4DF
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 23:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=EPRtJdAYUThD9v7MOatRvgqEa9X3fVwxqlIN4DTz3cs=; b=SnYgNMBzREroBXdPEY7ZqIIMzG
	cTnmobatmfXagXhqbITIy4V4ITQRAK7YAEx/+E69OXETmV5ggH1R2qyBW8N55HLDXLE4gc+kys/6F
	uSuOaFyJtC+f2y3omET8kB7nLHBQ/JDqkiv/NSKoVOVa8DeEhDAC/PTgx4G/c4ECoc4as0kMX4dts
	gOPJbb8IsXGj/4pLluzZrFaAsVZbLg85X3cPxknaJLPtK3XDqmj4HA0Tz28c44eCuDodXMVeQM33x
	1rP/K8GTCDr113mywkzg4bTIPqPka82LBxtqt+lyqrBRy0aXqPi635WEuSTk1XJyD56evrKQWDkfl
	yWAponhw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1paluB-00GaJH-7h; Fri, 10 Mar 2023 23:12:07 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: dhowells@redhat.com,
	linux-cachefs@redhat.com,
	jack@suse.com,
	jaharkes@cs.cmu.edu,
	coda@cs.cmu.edu,
	codalist@coda.cs.cmu.edu,
	anton@tuxera.com,
	linux-ntfs-dev@lists.sourceforge.net
Cc: ebiederm@xmission.com,
	keescook@chromium.org,
	yzaikin@google.com,
	j.granados@samsung.com,
	patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 2/5] devpts: simplify two-level sysctl registration for pty_kern_table
Date: Fri, 10 Mar 2023 15:12:03 -0800
Message-Id: <20230310231206.3952808-3-mcgrof@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230310231206.3952808-1-mcgrof@kernel.org>
References: <20230310231206.3952808-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

There is no need to declare two tables to just create directories,
this can be easily be done with a prefix path with register_sysctl().

Simplify this registration.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/devpts/inode.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 4f25015aa534..fe3db0eda8e4 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -72,24 +72,6 @@ static struct ctl_table pty_table[] = {
 	{}
 };
 
-static struct ctl_table pty_kern_table[] = {
-	{
-		.procname	= "pty",
-		.mode		= 0555,
-		.child		= pty_table,
-	},
-	{}
-};
-
-static struct ctl_table pty_root_table[] = {
-	{
-		.procname	= "kernel",
-		.mode		= 0555,
-		.child		= pty_kern_table,
-	},
-	{}
-};
-
 struct pts_mount_opts {
 	int setuid;
 	int setgid;
@@ -630,7 +612,7 @@ static int __init init_devpts_fs(void)
 {
 	int err = register_filesystem(&devpts_fs_type);
 	if (!err) {
-		register_sysctl_table(pty_root_table);
+		register_sysctl("kernel/pty", pty_table);
 	}
 	return err;
 }
-- 
2.39.1

