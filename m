Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A3E1BDE7;
	Wed,  3 Jan 2024 16:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SpLjmX7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40711C433C8;
	Wed,  3 Jan 2024 16:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301002;
	bh=TavUyKvg2+4ONolpcyy1dVK37yBrrGlz013nVrYOsdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SpLjmX7w0r/4e9IxcL6fROr1jQuagnrhG8ttfZjYvaoRRsbhnAijOvXuYjj9PzRRD
	 5U9TJC0nXOFs+8CC9Dfj/5ri/uaYw51hklwzT0cfVlT6h8ySKGtmRRfKSL159iq/17
	 vA2LuvYaqic3sXCeIBMwk6IuI+MZBcKb9MvK+38M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ye xingchen <ye.xingchen@zte.com.cn>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/100] ksmbd: Convert to use sysfs_emit()/sysfs_emit_at() APIs
Date: Wed,  3 Jan 2024 17:53:54 +0100
Message-ID: <20240103164857.014142622@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
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

From: ye xingchen <ye.xingchen@zte.com.cn>

[ Upstream commit 72ee45fd46d0d3578c4e6046f66fae3218543ce3 ]

Follow the advice of the Documentation/filesystems/sysfs.rst and show()
should only use sysfs_emit() or sysfs_emit_at() when formatting the
value to be returned to user space.

Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/server.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 9804cabe72a84..0c0db2e614ef6 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -442,11 +442,9 @@ static ssize_t stats_show(struct class *class, struct class_attribute *attr,
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
@@ -478,19 +476,13 @@ static ssize_t debug_show(struct class *class, struct class_attribute *attr,
 
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
 
-- 
2.43.0



