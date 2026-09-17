Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B62D394E8A;
	Thu, 17 Sep 2026 15:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658959; cv=none; b=jmCEzf6S4c0hCWg6n8SIVO3uM9NAIGzIRizLFqg+hfCnoEJQDK2mVKguYm3R6YVfcRrUnySJECnVDv/0H9lrpLo3o+jV4S7Yp1h00vZ19z3yXIjQhqymdX8XSQQySBE94DiJktj7qsi9+jcTL11U99clsQjnXyZF0G+CaZfbAu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658959; c=relaxed/simple;
	bh=lkc2Ek5l/xI49/VJ2mUvloU11+kwRE3Lgg+L+64iQys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDlHPY/VdzIraXXe1MxskuWLwN0r+uCywJ8agm2pxnSF3sUZPX953XE4zu7C2ipUPkKu12A9MjwP758u+w+HfPt1311cJB1z0x4v6qZlbgeyAkncPbN7k6GhLIUzrtOZNbOENXH/C8VfyKaxmJGC1taUQ1pONvEqtJCQgQE3sjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ILwt/tws; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILwt/tws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BF41F00893;
	Thu, 17 Sep 2026 15:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658953;
	bh=q+9duK7J0fyvWRL13Fd9xy97unx+dw+NjzDDi8DDoU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ILwt/twssMBrLluIGxaSQhV8RJYduHJbEOcnWA28vEIXI9Vcr4rD2n58WvQ/hvrAF
	 KNu9TpKxSfDb+jNoknquLlq17LbOAJ8saNRkYaxQpdDfubwSEUTfaofV0tdDbe2kGU
	 CPP9LRQ402rXCJ2Od8AB0YMN+yoLGjVgtE84P/3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 095/733] smb/server: cancel async requests when closing connection
Date: Thu, 17 Sep 2026 16:06:43 +0100
Message-ID: <20260917151353.304292072@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit 4fd5bad647bfa45eb86bfd2f03ba1bef3fcd5851 ]

An async request may still be waiting when a connection is closed.
This can stop the connection from closing.

Cancel active async requests before waiting for them to finish.

Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Stable-dep-of: d12168084c8c ("ksmbd: safely drain sessions during logoff")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/connection.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index af73c2ed5d249..17f4ac5597789 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -294,6 +294,26 @@ void ksmbd_conn_try_dequeue_request(struct ksmbd_work *work)
 	wake_up_all(&conn->req_running_q);
 }
 
+static void ksmbd_conn_cancel_async_requests(struct ksmbd_conn *conn)
+{
+	struct ksmbd_work *work, *tmp;
+
+	ksmbd_debug(CONN, "Cancel pending async requests on releasing connection\n");
+	spin_lock(&conn->request_lock);
+	list_for_each_entry_safe(work, tmp, &conn->async_requests,
+				 async_request_entry) {
+		if (work->state != KSMBD_WORK_ACTIVE)
+			continue;
+
+		ksmbd_debug(CONN, "Cancel async request id %d\n",
+			    work->async_id);
+		work->state = KSMBD_WORK_CANCELLED;
+		if (work->cancel_fn)
+			work->cancel_fn(work->cancel_argv);
+	}
+	spin_unlock(&conn->request_lock);
+}
+
 void ksmbd_conn_lock(struct ksmbd_conn *conn)
 {
 	mutex_lock(&conn->srv_mutex);
@@ -608,6 +628,7 @@ int ksmbd_conn_handler_loop(void *p)
 	}
 
 	ksmbd_conn_set_releasing(conn);
+	ksmbd_conn_cancel_async_requests(conn);
 	/* Wait till all reference dropped to the Server object*/
 	ksmbd_debug(CONN, "Wait for all pending requests(%d)\n", atomic_read(&conn->r_count));
 	wait_event(conn->r_count_q, atomic_read(&conn->r_count) == 0);
-- 
2.53.0



