Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4941613AA47;
	Tue, 18 Jun 2024 12:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714908; cv=none; b=pqTEXo1YaJL0c94N8s9CYN1uDLdbjwMaVcZtNJDs1QjG8d/S1ycvIBLHfbVcmF/UtpzkQaHn98vBkwKEtq5dPVYYqPwX51EyzBJyDUnVCZ4Tu7jCseSv2br5lghMrlQDVmufL3nUZB1gLnROjcaCAWZbotELg1ZCXFlZjSfnhvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714908; c=relaxed/simple;
	bh=lH7SNQ+0nGBU3U9mKcK5EykeLiyTgon9PchC9rELtw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gEiumxvLBqt1s0I7soD1TFhQXjx7UCWxPrdE+f2LvMF0Po3vQXL5iX8BQewwC12V57K1rhwiDsqP7pxLIy338X8keJYHp7NPLklk0wblHBBnOZIRZUDc6X+KgvArsfoIL4wA1Vcc+2EjzjNLrvNHkJsQLOKDFg4hEOhHD1/LC04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ox/oKAnf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ox/oKAnf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30F5C3277B;
	Tue, 18 Jun 2024 12:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714908;
	bh=lH7SNQ+0nGBU3U9mKcK5EykeLiyTgon9PchC9rELtw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ox/oKAnfH41H8BpinfUKgB+NzmbtJYtItulw59/Fl2NetmeXFmLgbPfw7chIwEW9g
	 uMis6ZAZ2JTSoj5sCDHAeF/GLMEY5kjEu1Whk2wrS1ZvSMQ5NEf4Mvqmu3VyWh1fXs
	 lFNN+iaqEWwdhNRxyq448cBWmCyCvpX6MQTxv1lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Waiman Long <longman@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 129/770] inotify: Increase default inotify.max_user_watches limit to 1048576
Date: Tue, 18 Jun 2024 14:29:42 +0200
Message-ID: <20240618123412.256732064@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

From: Waiman Long <longman@redhat.com>

[ Upstream commit 92890123749bafc317bbfacbe0a62ce08d78efb7 ]

The default value of inotify.max_user_watches sysctl parameter was set
to 8192 since the introduction of the inotify feature in 2005 by
commit 0eeca28300df ("[PATCH] inotify"). Today this value is just too
small for many modern usage. As a result, users have to explicitly set
it to a larger value to make it work.

After some searching around the web, these are the
inotify.max_user_watches values used by some projects:
 - vscode:  524288
 - dropbox support: 100000
 - users on stackexchange: 12228
 - lsyncd user: 2000000
 - code42 support: 1048576
 - monodevelop: 16384
 - tectonic: 524288
 - openshift origin: 65536

Each watch point adds an inotify_inode_mark structure to an inode to
be watched. It also pins the watched inode.

Modeled after the epoll.max_user_watches behavior to adjust the default
value according to the amount of addressable memory available, make
inotify.max_user_watches behave in a similar way to make it use no more
than 1% of addressable memory within the range [8192, 1048576].

We estimate the amount of memory used by inotify mark to size of
inotify_inode_mark plus two times the size of struct inode (we double
the inode size to cover the additional filesystem private inode part).
That means that a 64-bit system with 128GB or more memory will likely
have the maximum value of 1048576 for inotify.max_user_watches. This
default should be big enough for most use cases.

Link: https://lore.kernel.org/r/20201109035931.4740-1-longman@redhat.com
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/inotify/inotify_user.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 32b6b97021bef..b564a32403aa5 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -37,6 +37,15 @@
 
 #include <asm/ioctls.h>
 
+/*
+ * An inotify watch requires allocating an inotify_inode_mark structure as
+ * well as pinning the watched inode. Doubling the size of a VFS inode
+ * should be more than enough to cover the additional filesystem inode
+ * size increase.
+ */
+#define INOTIFY_WATCH_COST	(sizeof(struct inotify_inode_mark) + \
+				 2 * sizeof(struct inode))
+
 /* configurable via /proc/sys/fs/inotify/ */
 static int inotify_max_queued_events __read_mostly;
 
@@ -797,6 +806,18 @@ SYSCALL_DEFINE2(inotify_rm_watch, int, fd, __s32, wd)
  */
 static int __init inotify_user_setup(void)
 {
+	unsigned long watches_max;
+	struct sysinfo si;
+
+	si_meminfo(&si);
+	/*
+	 * Allow up to 1% of addressable memory to be allocated for inotify
+	 * watches (per user) limited to the range [8192, 1048576].
+	 */
+	watches_max = (((si.totalram - si.totalhigh) / 100) << PAGE_SHIFT) /
+			INOTIFY_WATCH_COST;
+	watches_max = clamp(watches_max, 8192UL, 1048576UL);
+
 	BUILD_BUG_ON(IN_ACCESS != FS_ACCESS);
 	BUILD_BUG_ON(IN_MODIFY != FS_MODIFY);
 	BUILD_BUG_ON(IN_ATTRIB != FS_ATTRIB);
@@ -823,7 +844,7 @@ static int __init inotify_user_setup(void)
 
 	inotify_max_queued_events = 16384;
 	init_user_ns.ucount_max[UCOUNT_INOTIFY_INSTANCES] = 128;
-	init_user_ns.ucount_max[UCOUNT_INOTIFY_WATCHES] = 8192;
+	init_user_ns.ucount_max[UCOUNT_INOTIFY_WATCHES] = watches_max;
 
 	return 0;
 }
-- 
2.43.0



