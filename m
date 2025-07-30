Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1606D19D065;
	Wed, 30 Jul 2025 09:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868491; cv=none; b=fqSoNZ+HlQ3Hb04DQXcgO/qyIB+DD2wQ//NWPX4Iorn2kGllnlnL3CS+iRmxIaIrwo046zd4AOW/bVikEYAdYfwFqOG8GQrgVJ9SVEFwiQo8fXcbSvZK5Q6fYxUZ+cT8f3JE4SbAk4khpwdxnjIQAsFpSutOpT0FFmpUQW1dJpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868491; c=relaxed/simple;
	bh=BcT0tJ7gF3axvOOEVI7Glxq9SOz+TeXkUzZPOkxLkic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=to2x5GxZoQ6+GqJ2O5CqPJJ3Wbdw49ifgtrEpWF1YVZjGuQ/i6n6gB0wXVvH3ORvfP6qBrubR4gzPpgSlJWV7ilcn3hjqUoTTwOuWyXPv6X+sePcb300LACIMQncUXfvtXgWezQNMweyasbimHfgn2ULgbHzzEifVpyeJ2hODiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SCvcnXx6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SCvcnXx6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCBCC4CEE7;
	Wed, 30 Jul 2025 09:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868491;
	bh=BcT0tJ7gF3axvOOEVI7Glxq9SOz+TeXkUzZPOkxLkic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SCvcnXx6Pk0kIA4l5IkWmNv1rZ52TzLQ/Qc4PEL8xIN4VgDM9uDY78dKMvp0pZFjw
	 WGmgRyBu74HxjepimWHUOxXfTWsFlbR7Ye0qcfT7JfaYghcKT8zKwCV8FJ4FdoUKS7
	 HYqF5n3WdaqSNsnUaPZkNwntBr6sw7n8L8h2LWpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 64/76] ksmbd: fix use-after-free in __smb2_lease_break_noti()
Date: Wed, 30 Jul 2025 11:35:57 +0200
Message-ID: <20250730093229.348395662@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 21a4e47578d44c6b37c4fc4aba8ed7cc8dbb13de ]

Move tcp_transport free to ksmbd_conn_free. If ksmbd connection is
referenced when ksmbd server thread terminates, It will not be freed,
but conn->tcp_transport is freed. __smb2_lease_break_noti can be performed
asynchronously when the connection is disconnected. __smb2_lease_break_noti
calls ksmbd_conn_write, which can cause use-after-free
when conn->ksmbd_transport is already freed.

Cc: stable@vger.kernel.org
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ Removed declaration of non-existent function ksmbd_find_netdev_name_iface_list() from transport_tcp.h. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/connection.c    |    4 +++-
 fs/smb/server/transport_tcp.c |   14 +++++++++-----
 fs/smb/server/transport_tcp.h |    1 +
 3 files changed, 13 insertions(+), 6 deletions(-)

--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -39,8 +39,10 @@ void ksmbd_conn_free(struct ksmbd_conn *
 	xa_destroy(&conn->sessions);
 	kvfree(conn->request_buf);
 	kfree(conn->preauth_info);
-	if (atomic_dec_and_test(&conn->refcnt))
+	if (atomic_dec_and_test(&conn->refcnt)) {
+		ksmbd_free_transport(conn->transport);
 		kfree(conn);
+	}
 }
 
 /**
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -93,17 +93,21 @@ static struct tcp_transport *alloc_trans
 	return t;
 }
 
-static void free_transport(struct tcp_transport *t)
+void ksmbd_free_transport(struct ksmbd_transport *kt)
 {
-	kernel_sock_shutdown(t->sock, SHUT_RDWR);
-	sock_release(t->sock);
-	t->sock = NULL;
+	struct tcp_transport *t = TCP_TRANS(kt);
 
-	ksmbd_conn_free(KSMBD_TRANS(t)->conn);
+	sock_release(t->sock);
 	kfree(t->iov);
 	kfree(t);
 }
 
+static void free_transport(struct tcp_transport *t)
+{
+	kernel_sock_shutdown(t->sock, SHUT_RDWR);
+	ksmbd_conn_free(KSMBD_TRANS(t)->conn);
+}
+
 /**
  * kvec_array_init() - initialize a IO vector segment
  * @new:	IO vector to be initialized
--- a/fs/smb/server/transport_tcp.h
+++ b/fs/smb/server/transport_tcp.h
@@ -7,6 +7,7 @@
 #define __KSMBD_TRANSPORT_TCP_H__
 
 int ksmbd_tcp_set_interfaces(char *ifc_list, int ifc_list_sz);
+void ksmbd_free_transport(struct ksmbd_transport *kt);
 int ksmbd_tcp_init(void);
 void ksmbd_tcp_destroy(void);
 


