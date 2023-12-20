Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA38A41C96;
	Wed, 20 Dec 2023 16:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NCOtLqkP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611D1C433C8;
	Wed, 20 Dec 2023 16:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088895;
	bh=CkVe773od5zNwN1SymkEB6aPx2HgzogXUF/30/FBYqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NCOtLqkPFpCzI7ak5P4U30HoirFU5gt7hLlD6RdefrfJFNWGQl/b9lI3GhL84ddRk
	 vVZlqV+d4qUfM7wW1eccB7V8Q8+UTi/06ZcJ6IpQ7EuvEINWyM8yStvL99GY8L1MDf
	 xMsVlBl2vI8HTrcZr9t5INLlB2F4hkvGwlMcAjtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ye xingchen <ye.xingchen@zte.com.cn>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 068/159] ksmbd: Convert to use sysfs_emit()/sysfs_emit_at() APIs
Date: Wed, 20 Dec 2023 17:08:53 +0100
Message-ID: <20231220160934.536490788@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ye xingchen <ye.xingchen@zte.com.cn>

[ Upstream commit 72ee45fd46d0d3578c4e6046f66fae3218543ce3 ]

Follow the advice of the Documentation/filesystems/sysfs.rst and show()
should only use sysfs_emit() or sysfs_emit_at() when formatting the
value to be returned to user space.

Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/server.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

--- a/fs/ksmbd/server.c
+++ b/fs/ksmbd/server.c
@@ -439,11 +439,9 @@ static ssize_t stats_show(struct class *
 		"reset",
 		"shutdown"
 	};
-
-	ssize_t sz = scnprintf(buf, PAGE_SIZE, "%d %s %d %lu\n", stats_version,
-			       state[server_conf.state], server_conf.tcp_port,
-			       server_conf.ipc_last_active / HZ);
-	return sz;
+	return sysfs_emit(buf, "%d %s %d %lu\n", stats_version,
+			  state[server_conf.state], server_conf.tcp_port,
+			  server_conf.ipc_last_active / HZ);
 }
 
 static ssize_t kill_server_store(struct class *class,
@@ -475,19 +473,13 @@ static ssize_t debug_show(struct class *
 
 	for (i = 0; i < ARRAY_SIZE(debug_type_strings); i++) {
 		if ((ksmbd_debug_types >> i) & 1) {
-			pos = scnprintf(buf + sz,
-					PAGE_SIZE - sz,
-					"[%s] ",
-					debug_type_strings[i]);
+			pos = sysfs_emit_at(buf, sz, "[%s] ", debug_type_strings[i]);
 		} else {
-			pos = scnprintf(buf + sz,
-					PAGE_SIZE - sz,
-					"%s ",
-					debug_type_strings[i]);
+			pos = sysfs_emit_at(buf, sz, "%s ", debug_type_strings[i]);
 		}
 		sz += pos;
 	}
-	sz += scnprintf(buf + sz, PAGE_SIZE - sz, "\n");
+	sz += sysfs_emit_at(buf, sz, "\n");
 	return sz;
 }
 


