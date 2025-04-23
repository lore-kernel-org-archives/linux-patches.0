Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989C2290095;
	Wed, 23 Apr 2025 15:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421016; cv=none; b=d6VBMgaF070SRZbfzWy18YhZ3wjzC31BY+49YH+V02an2rhTG8W+65qgyiOAnsUBKTEvjdNDycAFIXUAGPa6CnW63+7qWhTVWkayyLwVzgMCoC71RWBrIWySuMqM+oGZyEjr1wLPQINM5kLFltjqjMPfS2TBcIs0EXhqyiC/YFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421016; c=relaxed/simple;
	bh=ABaneZ0AjLCqORiDAkTGRtjuOOIr7FtxJQaHbGQZzQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/aBsjav2TUHexOyaYYQ1NmKzwVC7nMpD1ft+9HwbXKYstxJ1jSe0vV80fb8f8HZ6WWei/iiQFeaC8vTF3nn3jUcnG05HMAIda/yWUEq+ws5zSop9Y0W2nRQ1NoZV8gAykDa8PuW1REFfOmIyAgk+cvpfBMmWn6l/M7Daly31BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oYAk1C15; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYAk1C15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABFACC4AF0B;
	Wed, 23 Apr 2025 15:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421015;
	bh=ABaneZ0AjLCqORiDAkTGRtjuOOIr7FtxJQaHbGQZzQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oYAk1C15VeWqwx4r7qnIDha+r/jx++X3P/t2iE/i8rGj+hzl6Z1hbmlbzffqqsNF8
	 SMB/ncx2j4PsGVAuIxYBoCQL03bv2q1yeyDwUVjB6unXbb+PXm1gZfB9yTL3BT9Lcg
	 RLSAf9ugvt50cPrlh3/UF7GwneOeySYz3osI2E/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.14 144/241] ksmbd: fix use-after-free in __smb2_lease_break_noti()
Date: Wed, 23 Apr 2025 16:43:28 +0200
Message-ID: <20250423142626.439434152@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 21a4e47578d44c6b37c4fc4aba8ed7cc8dbb13de upstream.

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
@@ -8,6 +8,7 @@
 
 int ksmbd_tcp_set_interfaces(char *ifc_list, int ifc_list_sz);
 struct interface *ksmbd_find_netdev_name_iface_list(char *netdev_name);
+void ksmbd_free_transport(struct ksmbd_transport *kt);
 int ksmbd_tcp_init(void);
 void ksmbd_tcp_destroy(void);
 


