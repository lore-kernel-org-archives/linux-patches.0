Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E388431328E;
	Tue, 16 Jun 2026 16:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629069; cv=none; b=k60aDfG3K9Tc9Q8mq1sg3VBKUYJvnMt0bjwmbpPlHTX5WLQNv8VA1/jy9Whu5W0cZFgTXKcZ2zSbQjTm5D7CBZ/bFqlG33B2eXO4/uUJYJ4L2RKoPIG2KvcaLWYUZCGPjTwwGvq8HRtsbcDjRF1gncy/3ZLKBbVrqupgg9FxACE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629069; c=relaxed/simple;
	bh=PbJuk+FFMVxuUflrGXw5rwLguWcxDM2aRxQi74vwtYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tr5XV0KVnl6O0/BdCuWJ3xNuv1QUNjDdufdNbZfSoBk7DyuGA3c6XhA2Zb+pDDvGVzRktwIxnGmXKBWmqzW3jh14cY6MyfwcvWHVkiOhtpEszJBWXb4tnBfvdeg3PGWeJzEMJ3ZLhtYFWCmCv77/MWUUYds78AtuVTVFm8h3w5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v/snFwsc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v/snFwsc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A131F000E9;
	Tue, 16 Jun 2026 16:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629068;
	bh=AvPl+v6o3Asd8DnkWADI9+FcZjVZu1VhurFIzJlTkIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v/snFwsc1M98IbJpDhEh3ZLbnOynssa/rcrjjRZbly0Z4SYxgwwR/5aAwORlX9XE2
	 7lFaDuk7r6uVXCB17IXTKGa/uKBLqoo9vkh9WMsWqZSL0RuANK+IGr4BIWJZMDWn7b
	 NhXNa8LgFMpC3nY6n8mxjXwoXg3yE1xh1NUjGRJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Portnoy <dddhkts1@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 214/452] ksmbd: fix NULL-deref of opinfo->conn in oplock/lease break notifiers
Date: Tue, 16 Jun 2026 20:27:21 +0530
Message-ID: <20260616145129.037375824@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gil Portnoy <dddhkts1@gmail.com>

[ Upstream commit b003086d76968298f22e7cf62239833b5a3a06b1 ]

smb2_oplock_break_noti() and smb2_lease_break_noti() read opinfo->conn
into a local with neither READ_ONCE() nor a NULL check.  Both run from
oplock_break() after opinfo_get_list() has dropped ci->m_lock, so a
concurrent SMB2 LOGOFF (session_fd_check()) can set op->conn = NULL
under ci->m_lock within that window.  ksmbd_conn_r_count_inc(conn) then
writes through NULL at offset 0xc4 -- a remotely triggerable oops.

Guard both reads the way compare_guid_key() already does: read
opinfo->conn with READ_ONCE() and return early if it is NULL, before
allocating the work struct so nothing leaks.  A NULL conn means the
client is gone and the break is moot, so return 0; oplock_break() treats
that as success and runs the normal teardown.

Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
Assisted-by: Henry (Claude):claude-opus-4
Signed-off-by: Gil Portnoy <dddhkts1@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/oplock.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 5302c30a4a91d7..bba17ea84023e2 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -714,11 +714,16 @@ static void __smb2_oplock_break_noti(struct work_struct *wk)
  */
 static int smb2_oplock_break_noti(struct oplock_info *opinfo)
 {
-	struct ksmbd_conn *conn = opinfo->conn;
+	struct ksmbd_conn *conn;
 	struct oplock_break_info *br_info;
 	int ret = 0;
-	struct ksmbd_work *work = ksmbd_alloc_work_struct();
+	struct ksmbd_work *work;
+
+	conn = READ_ONCE(opinfo->conn);
+	if (!conn)
+		return 0;
 
+	work = ksmbd_alloc_work_struct();
 	if (!work)
 		return -ENOMEM;
 
@@ -818,11 +823,15 @@ static void __smb2_lease_break_noti(struct work_struct *wk)
  */
 static int smb2_lease_break_noti(struct oplock_info *opinfo)
 {
-	struct ksmbd_conn *conn = opinfo->conn;
+	struct ksmbd_conn *conn;
 	struct ksmbd_work *work;
 	struct lease_break_info *br_info;
 	struct lease *lease = opinfo->o_lease;
 
+	conn = READ_ONCE(opinfo->conn);
+	if (!conn)
+		return 0;
+
 	work = ksmbd_alloc_work_struct();
 	if (!work)
 		return -ENOMEM;
-- 
2.53.0



