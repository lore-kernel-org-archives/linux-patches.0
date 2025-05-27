Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3669319E967;
	Tue, 27 May 2025 17:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366453; cv=none; b=MeT8kxc/Ji/fb5qIxfAhGmnUgW8fqBIa5EoTReGu6/jEYDnc6wH8YER2WGyIthAr8e8NRCe8jmh6xtWjIYZyqsHgGrEQ1IY7W/FtHfJJct+zCcB+wK6izZItxHpVUdULIvXKbGrQr9WRU9L8snRScKj3PH3SFAFIjZ27LqXMTzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366453; c=relaxed/simple;
	bh=bshOtjdByvhTisKUS+ULvS8TFSiXoZrgozU2W/kxXpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TUn7uaw1Y6C9MdV8bYsaaNNEPz55vOxY+7v7yBDvg5FZb4DVZlXSC1/C1JIC0cmAcKQtzpaeXWkmCfrQofpYAkVmU7+oO1aVR9PTgHDD44OXLWZU+BhfkygILmrbj2HOceENqsDLr4fQVvWuGLbsEPhaJio2nD815pg5tGqf090=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qacZyMRG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qacZyMRG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2BC9C4CEE9;
	Tue, 27 May 2025 17:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366453;
	bh=bshOtjdByvhTisKUS+ULvS8TFSiXoZrgozU2W/kxXpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qacZyMRGWF7Q5+psljvjFRASDin0j5Uq1/H5OO6blKmWoiljs4PQ4kwhwG3mUxgeS
	 BB+CEbnBr4gIC2imPdpN42odxfjkBP5pYoXPfMyrW7GTivFZYmNjSFAp+IQT6tyh0K
	 WtE/ajiDw0TN2FSWVWPGXoepPj5sVKIHUkfEWKik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 072/783] cifs: Fix establishing NetBIOS session for SMB2+ connection
Date: Tue, 27 May 2025 18:17:49 +0200
Message-ID: <20250527162516.060896365@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 781802aa5a5950f99899f13ff9d760f5db81d36d ]

Function ip_rfc1001_connect() which establish NetBIOS session for SMB
connections, currently uses smb_send() function for sending NetBIOS Session
Request packet. This function expects that the passed buffer is SMB packet
and for SMB2+ connections it mangles packet header, which breaks prepared
NetBIOS Session Request packet. Result is that this function send garbage
packet for SMB2+ connection, which SMB2+ server cannot parse. That function
is not mangling packets for SMB1 connections, so it somehow works for SMB1.

Fix this problem and instead of smb_send(), use smb_send_kvec() function
which does not mangle prepared packet, this function send them as is. Just
API of this function takes struct msghdr (kvec) instead of packet buffer.

[MS-SMB2] specification allows SMB2 protocol to use NetBIOS as a transport
protocol. NetBIOS can be used over TCP via port 139. So this is a valid
configuration, just not so common. And even recent Windows versions (e.g.
Windows Server 2022) still supports this configuration: SMB over TCP port
139, including for modern SMB2 and SMB3 dialects.

This change fixes SMB2 and SMB3 connections over TCP port 139 which
requires establishing of NetBIOS session. Tested that this change fixes
establishing of SMB2 and SMB3 connections with Windows Server 2022.

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsproto.h |  3 +++
 fs/smb/client/connect.c   | 20 +++++++++++++++-----
 fs/smb/client/transport.c |  2 +-
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 278092a15f890..1609ca825d825 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -31,6 +31,9 @@ extern void cifs_small_buf_release(void *);
 extern void free_rsp_buf(int, void *);
 extern int smb_send(struct TCP_Server_Info *, struct smb_hdr *,
 			unsigned int /* length */);
+extern int smb_send_kvec(struct TCP_Server_Info *server,
+			 struct msghdr *msg,
+			 size_t *sent);
 extern unsigned int _get_xid(void);
 extern void _free_xid(unsigned int);
 #define get_xid()							\
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 92685fc675b59..22f29d2725928 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3028,8 +3028,10 @@ ip_rfc1001_connect(struct TCP_Server_Info *server)
 	 * sessinit is sent but no second negprot
 	 */
 	struct rfc1002_session_packet req = {};
-	struct smb_hdr *smb_buf = (struct smb_hdr *)&req;
+	struct msghdr msg = {};
+	struct kvec iov = {};
 	unsigned int len;
+	size_t sent;
 
 	req.trailer.session_req.called_len = sizeof(req.trailer.session_req.called_name);
 
@@ -3058,10 +3060,18 @@ ip_rfc1001_connect(struct TCP_Server_Info *server)
 	 * As per rfc1002, @len must be the number of bytes that follows the
 	 * length field of a rfc1002 session request payload.
 	 */
-	len = sizeof(req) - offsetof(struct rfc1002_session_packet, trailer.session_req);
+	len = sizeof(req.trailer.session_req);
+	req.type = RFC1002_SESSION_REQUEST;
+	req.flags = 0;
+	req.length = cpu_to_be16(len);
+	len += offsetof(typeof(req), trailer.session_req);
+	iov.iov_base = &req;
+	iov.iov_len = len;
+	iov_iter_kvec(&msg.msg_iter, ITER_SOURCE, &iov, 1, len);
+	rc = smb_send_kvec(server, &msg, &sent);
+	if (rc < 0 || len != sent)
+		return (rc == -EINTR || rc == -EAGAIN) ? rc : -ECONNABORTED;
 
-	smb_buf->smb_buf_length = cpu_to_be32((RFC1002_SESSION_REQUEST << 24) | len);
-	rc = smb_send(server, smb_buf, len);
 	/*
 	 * RFC1001 layer in at least one server requires very short break before
 	 * negprot presumably because not expecting negprot to follow so fast.
@@ -3070,7 +3080,7 @@ ip_rfc1001_connect(struct TCP_Server_Info *server)
 	 */
 	usleep_range(1000, 2000);
 
-	return rc;
+	return 0;
 }
 
 static int
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 0dc80959ce488..03434dbe9374c 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -179,7 +179,7 @@ delete_mid(struct mid_q_entry *mid)
  * Our basic "send data to server" function. Should be called with srv_mutex
  * held. The caller is responsible for handling the results.
  */
-static int
+int
 smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
 	      size_t *sent)
 {
-- 
2.39.5



