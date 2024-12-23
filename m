Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672CF1B21BD;
	Mon, 23 Dec 2024 16:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969775; cv=none; b=BegtQTx1NL7uw9R40MJmLv855RDm3VHao9Qshajg9J1+0ZSHo1+RfSktikLAOzrJzk9++wiEtOB/e2sbsuGmNgNEi/KNTbmsVZyCHk/edGbM2WOsVDr5Rx1IzXx24HTsaoiDh49Ey2kfRKwhRew/Ur1a+PmEeXG0p7aLhVuz5Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969775; c=relaxed/simple;
	bh=/sOV36XvVj89C9GufbxpjRJUbTFLZeYE8WZYEvbkhfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NmGnWtiTW3adzGVH9p9OVGD1GDX0nOuKwiV1I4XzsdzGQeMvT5AAB2eDjB60U/hjmv652arjzzwCshbNxcdlJna3Nf51vgSMzKVn2Yai9FagRhqJojKYmERbQMM7pl8fqi8qcVzquBQYMyJf3zsve2dzx5wXOD0juTQKq89RrUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D7NRFbj5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D7NRFbj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900A8C4CED3;
	Mon, 23 Dec 2024 16:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969775;
	bh=/sOV36XvVj89C9GufbxpjRJUbTFLZeYE8WZYEvbkhfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D7NRFbj5n3QQrcDm7UXDQkowiYtEn3ZPghTSm7ksIscrzaQ6Wnf3sEXBVZn/GN+gJ
	 uEemTu23srT5PEjLQ7RMg5XD4PIAVVZ5bxVpCL5j/4qqJDFQROQF+V9nEek3MN1B2y
	 gcJhNVQbVd/iXO8DsAvJJcilEvUivmoyioM4bh7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marios Makassikis <mmakassikis@freebox.fr>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 044/160] ksmbd: count all requests in req_running counter
Date: Mon, 23 Dec 2024 16:57:35 +0100
Message-ID: <20241223155410.377001668@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marios Makassikis <mmakassikis@freebox.fr>

[ Upstream commit 83c47d9e0ce79b5d7c0b21b9f35402dbde0fa15c ]

This changes the semantics of req_running to count all in-flight
requests on a given connection, rather than the number of elements
in the conn->request list. The latter is used only in smb2_cancel,
and the counter is not used

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 43fb7bce8866 ("ksmbd: fix broken transfers when exceeding max simultaneous operations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/connection.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index e6a72f75ab94..3980645085ed 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -120,8 +120,8 @@ void ksmbd_conn_enqueue_request(struct ksmbd_work *work)
 	if (conn->ops->get_cmd_val(work) != SMB2_CANCEL_HE)
 		requests_queue = &conn->requests;
 
+	atomic_inc(&conn->req_running);
 	if (requests_queue) {
-		atomic_inc(&conn->req_running);
 		spin_lock(&conn->request_lock);
 		list_add_tail(&work->request_entry, requests_queue);
 		spin_unlock(&conn->request_lock);
@@ -132,11 +132,12 @@ void ksmbd_conn_try_dequeue_request(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
 
+	atomic_dec(&conn->req_running);
+
 	if (list_empty(&work->request_entry) &&
 	    list_empty(&work->async_request_entry))
 		return;
 
-	atomic_dec(&conn->req_running);
 	spin_lock(&conn->request_lock);
 	list_del_init(&work->request_entry);
 	spin_unlock(&conn->request_lock);
-- 
2.39.5



