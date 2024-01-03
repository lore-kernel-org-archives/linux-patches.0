Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07C31BDFE;
	Wed,  3 Jan 2024 17:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I/Jh7j9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9D3C433C7;
	Wed,  3 Jan 2024 17:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704302014;
	bh=MOk+YhFlL2hk2ZCCdRxFC9hzwQK3oAynEQT66I5TBZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I/Jh7j9HsK3hqnLrDhIvBK6jGKhLdCXEAM4vMlQtC1fwiyYYncTpVOU+/ZXwfvyp4
	 qWk/HQPyXI6Qg/UU5Zm8ooQ5EylV3+X6xeVVNNH76VtoEUN3NAnK2nBfTwqxp0Sewq
	 J0iKAXePetlvjb9OqJVdY7MCaXHz6xYdeRQGsKuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 06/49] ksmbd: no need to wait for binded connection termination at logoff
Date: Wed,  3 Jan 2024 17:55:26 +0100
Message-ID: <20240103164835.933166888@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164834.970234661@linuxfoundation.org>
References: <20240103164834.970234661@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 67797da8a4b82446d42c52b6ee1419a3100d78ff ]

The connection could be binded to the existing session for Multichannel.
session will be destroyed when binded connections are released.
So no need to wait for that's connection at logoff.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/connection.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 4b38c3a285f60..b6fa1e285c401 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -167,23 +167,7 @@ void ksmbd_all_conn_set_status(u64 sess_id, u32 status)
 
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
-- 
2.43.0



