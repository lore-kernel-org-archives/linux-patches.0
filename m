Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A997400DF6;
	Sat, 12 Sep 2026 09:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203967; cv=none; b=CNY95Ey7NrQzvqjZKVD2dV6N2rDcnA934VvRMtSBOBJgekjzbHaYTXjNB/Q+yaC6VS776icQB4h7iMsAKk5r2CheXRAM0f8qUp07nTMs5/MOos9R4tE8IETEAY+OIStEvdhIVgFIU0j7+pzMsKLM77TiObl2fjlnSUmQqRPZbNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203967; c=relaxed/simple;
	bh=47sI8W3MnbiWg2uK50ms0yQHCRkJ26jThySd3tyhNao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLoGYEvxI7WHxhvR7l7BmdRDL/azXxlTApquRjmsahgyuMAW6Z09DeA7pVOr14uq9qF5xiTI047shDBOH/o9TYDL/rYkEKNUszF7b3rCIj/MSpIHl6Z3GvV2+gpIzqkpTC/Uo2miOUZcsu5Wrgy5MVRt6HFG2s9gqpGSS5bN4AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UPyZyrzI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UPyZyrzI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E243C1F000FF;
	Sat, 12 Sep 2026 09:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203965;
	bh=CsuTIM7fejqDjioMAVV/zvxSYtaR+OBavHI61tyCfrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UPyZyrzIGmQ++X3ZuZuFqe/puVlKc18ZQkJWOMWikRVut6qcKw7dssblHMjygzGb8
	 4aEl8bZdh5F7aXmUgeQE+8DxJ81ed1WXYheUQXUI70VxDouS6ulg+CT71aZQYbST6m
	 90wd6BWK1sKGN7uwi1wCAOjp97bQrSyjsiqellHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1517/1815] smb/server: abort initialization when proc setup fails
Date: Sat, 12 Sep 2026 08:54:27 +0200
Message-ID: <20260912065724.615485529@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZhangGuoDong <zhangguodong@kylinos.cn>

[ Upstream commit db97f3763727d652112ae70038d4e17b3ce277bb ]

ksmbd_server_init() calls ksmbd_proc_init() before creating the
remaining proc entries and server subsystems. ksmbd_proc_init() tears
down partial state on a procfs or percpu_counter allocation failure,
but returns void, so ksmbd_server_init() continues as if the counters
were usable.

Once userspace starts the server, server_ctrl_handle_init() calls
ksmbd_proc_reset(), which reaches percpu_counter_set() with a NULL
per-CPU counters pointer on SMP systems. The later ksmbd_proc_create()
calls also receive a NULL parent and may create entries in the /proc
root; ksmbd_proc_cleanup() cannot remove those entries because
ksmbd_proc_fs is NULL.

Fixes: b38f99c1217a ("ksmbd: add procfs interface for runtime monitoring and statistics")
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/misc.h   |  4 ++--
 fs/smb/server/proc.c   | 13 ++++++++-----
 fs/smb/server/server.c |  4 +++-
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/smb/server/misc.h b/fs/smb/server/misc.h
index 3909104e18ad4..c7b063f571a7a 100644
--- a/fs/smb/server/misc.h
+++ b/fs/smb/server/misc.h
@@ -43,7 +43,7 @@ struct ksmbd_const_name {
 	const char *name;
 };
 
-void ksmbd_proc_init(void);
+int ksmbd_proc_init(void);
 void ksmbd_proc_cleanup(void);
 void ksmbd_proc_reset(void);
 struct proc_dir_entry *ksmbd_proc_create(const char *name,
@@ -59,7 +59,7 @@ void ksmbd_proc_show_const_name(struct seq_file *m,
 				int count,
 				unsigned int const_value);
 #else
-static inline void ksmbd_proc_init(void) {}
+static inline int ksmbd_proc_init(void) { return 0; }
 static inline void ksmbd_proc_cleanup(void) {}
 static inline void ksmbd_proc_reset(void) {}
 #endif
diff --git a/fs/smb/server/proc.c b/fs/smb/server/proc.c
index 101a2cc45a447..5c9f3f314dbe1 100644
--- a/fs/smb/server/proc.c
+++ b/fs/smb/server/proc.c
@@ -106,14 +106,14 @@ void ksmbd_proc_reset(void)
 		percpu_counter_set(&ksmbd_counters.counters[i], 0);
 }
 
-void ksmbd_proc_init(void)
+int ksmbd_proc_init(void)
 {
 	int i;
-	int retval;
+	int retval = -ENOMEM;
 
 	ksmbd_proc_fs = proc_mkdir("fs/ksmbd", NULL);
 	if (!ksmbd_proc_fs)
-		return;
+		return retval;
 
 	if (!proc_mkdir_mode("sessions", 0400, ksmbd_proc_fs))
 		goto err_out;
@@ -124,11 +124,14 @@ void ksmbd_proc_init(void)
 			goto err_out;
 	}
 
-	if (!ksmbd_proc_create("server", proc_show_ksmbd_stats, NULL))
+	if (!ksmbd_proc_create("server", proc_show_ksmbd_stats, NULL)) {
+		retval = -ENOMEM;
 		goto err_out;
+	}
 
 	ksmbd_proc_reset();
-	return;
+	return 0;
 err_out:
 	ksmbd_proc_cleanup();
+	return retval;
 }
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 95be17b797147..a67ecd765e5d2 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -610,7 +610,9 @@ static int __init ksmbd_server_init(void)
 		return ret;
 	}
 
-	ksmbd_proc_init();
+	ret = ksmbd_proc_init();
+	if (ret)
+		goto err_unregister;
 	create_proc_sessions();
 
 	ksmbd_server_tcp_callbacks_init();
-- 
2.53.0



