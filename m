Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C804A99E;
	Wed, 20 Dec 2023 16:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AQGipB/P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD1FC433C8;
	Wed, 20 Dec 2023 16:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703089034;
	bh=P9UJZBpTVuWqE3B3sa/ScgV1ooxpdApARCH273kwYv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AQGipB/PWSci766orWaOR+MOwtuPap9QgMhFZVpcxrBkyUY5AnFtjQvpOzxGCeVvZ
	 jVBTYsnTg3gmsjVyej+yEtliDoXHzH1S4BW0/dW9DjoIUfzwr26neGkLLfEV9oYf2G
	 QLTYAbe4/PCJx2karTQe+5CwK8gbCceP995uyqY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 145/159] ksmbd: no need to wait for binded connection termination at logoff
Date: Wed, 20 Dec 2023 17:10:10 +0100
Message-ID: <20231220160938.085794187@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 67797da8a4b82446d42c52b6ee1419a3100d78ff ]

The connection could be binded to the existing session for Multichannel.
session will be destroyed when binded connections are released.
So no need to wait for that's connection at logoff.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/connection.c |   16 ----------------
 1 file changed, 16 deletions(-)

--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -167,23 +167,7 @@ void ksmbd_all_conn_set_status(u64 sess_
 
 void ksmbd_conn_wait_idle(struct ksmbd_conn *conn, u64 sess_id)
 {
-	struct ksmbd_conn *bind_conn;
-
 	wait_event(conn->req_running_q, atomic_read(&conn->req_running) < 2);
-
-	down_read(&conn_list_lock);
-	list_for_each_entry(bind_conn, &conn_list, conns_list) {
-		if (bind_conn == conn)
-			continue;
-
-		if ((bind_conn->binding || xa_load(&bind_conn->sessions, sess_id)) &&
-		    !ksmbd_conn_releasing(bind_conn) &&
-		    atomic_read(&bind_conn->req_running)) {
-			wait_event(bind_conn->req_running_q,
-				atomic_read(&bind_conn->req_running) == 0);
-		}
-	}
-	up_read(&conn_list_lock);
 }
 
 int ksmbd_conn_write(struct ksmbd_work *work)


