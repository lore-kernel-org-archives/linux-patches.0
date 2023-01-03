Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40A0138D
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 08:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59DA5C433D2;
	Tue,  3 Jan 2023 08:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672733706;
	bh=9G4Pv9Gt39/6SAjBBLxJSaHaXDOBFavoT07Za35EAVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZADW0zGLSUnbtYiHhQvmCp0tgVq0Oi9Q1gAM9acG3RfFlsUWex1N/1+90x701KF4a
	 ljQUPcAkt4JiOUv28MmEu3xkJQvt+Xx/Di+utf4/kWNxH2RVOMw/8tIkjlvQVYV8uY
	 zXibq1x0LKMOZqJhCzSo7LD5yTZL0PNLqTRa1Emw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c88a7030da47945a3cc3@syzkaller.appspotmail.com,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.10 06/63] Make sure nd->path.mnt and nd->path.dentry are always valid pointers
Date: Tue,  3 Jan 2023 09:13:36 +0100
Message-Id: <20230103081308.942805751@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 7d01ef7585c07afaf487759a48486228cd065726 ]

Initialize them in set_nameidata() and make sure that terminate_walk() clears them
once the pointers become potentially invalid (i.e. we leave RCU mode or drop them
in non-RCU one).  Currently we have "path_init() always initializes them and nobody
accesses them outside of path_init()/terminate_walk() segments", which is asking
for trouble.

With that change we would have nd->path.{mnt,dentry}
	1) always valid - NULL or pointing to currently allocated objects.
	2) non-NULL while we are successfully walking
	3) NULL when we are not walking at all
	4) contributing to refcounts whenever non-NULL outside of RCU mode.

Fixes: 6c6ec2b0a3e0 ("fs: add support for LOOKUP_CACHED")
Reported-by: syzbot+c88a7030da47945a3cc3@syzkaller.appspotmail.com
Tested-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namei.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -529,6 +529,8 @@ static void set_nameidata(struct nameida
 	p->stack = p->internal;
 	p->dfd = dfd;
 	p->name = name;
+	p->path.mnt = NULL;
+	p->path.dentry = NULL;
 	p->total_link_count = old ? old->total_link_count : 0;
 	p->saved = old;
 	current->nameidata = p;
@@ -602,6 +604,8 @@ static void terminate_walk(struct nameid
 		rcu_read_unlock();
 	}
 	nd->depth = 0;
+	nd->path.mnt = NULL;
+	nd->path.dentry = NULL;
 }
 
 /* path_put is needed afterwards regardless of success or failure */
@@ -2243,8 +2247,6 @@ static const char *path_init(struct name
 	}
 
 	nd->root.mnt = NULL;
-	nd->path.mnt = NULL;
-	nd->path.dentry = NULL;
 
 	/* Absolute pathname -- fetch the root (LOOKUP_IN_ROOT uses nd->dfd). */
 	if (*s == '/' && !(flags & LOOKUP_IN_ROOT)) {


