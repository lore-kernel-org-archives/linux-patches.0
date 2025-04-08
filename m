Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B19C148;
	Tue,  8 Apr 2025 12:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116699; cv=none; b=VBFxHsoOBCHKMrSg3oRXcf4aVLxhfOGZ3KIlnsLzOSq1mAQXgAP2hwl9pI1RYbzkVgS4qeqIcv8KMwNM8g58u4X9Diqt47/RQmqh6NOwS/gPPVi541DSyW5JnkQHMzJZN/0MkKU3WgBoFR9roQe9V2VeGdDCl7iHXdsTYlK3b/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116699; c=relaxed/simple;
	bh=eXhJsiKzKEc2jh4zRDaQ41CMpcvHeZ4UonI6O/sranA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DmX72N5S8uEP9PYma5Zp7931olB8rPmna6c5wxQSJ8dzmacKMoz6RP21o2ca07dBVVtRiTIDztwr3hPHGvVXGSvK2MaOh1Soag+Joq+TYus1IZAT/F3msMnMg6LDwLVq7ddLuffRCLMRiQpOeqp/+0sU2WcYEViCQqyFHI+BffA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xrBN9b1q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xrBN9b1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE67AC4CEE5;
	Tue,  8 Apr 2025 12:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116699;
	bh=eXhJsiKzKEc2jh4zRDaQ41CMpcvHeZ4UonI6O/sranA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xrBN9b1q2kTQoRI3GEE071P54tdQB9kcHz8iKVb/wos/WPglQN8xJ50BF4VdOJ7Kb
	 aX30s6mjwNXMxwQ1kOZvYxU1Su+Hc0oq4jIe4ICJ5iaINQqpEmhjdokIuagDUi9udP
	 AjJMmqg/wq3xCyYs7KmZzYf8WZl6iOIT2+oOnP9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 236/423] ksmbd: fix r_count dec/increment mismatch
Date: Tue,  8 Apr 2025 12:49:22 +0200
Message-ID: <20250408104851.222257806@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit ddb7ea36ba7129c2ed107e2186591128618864e1 ]

r_count is only increased when there is an oplock break wait,
so r_count inc/decrement are not paired. This can cause r_count
to become negative, which can lead to a problem where the ksmbd
thread does not terminate.

Fixes: 3aa660c05924 ("ksmbd: prevent connection release during oplock break notification")
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/oplock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 592fe665973a8..304aefecaaaf5 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -724,8 +724,8 @@ static int smb2_oplock_break_noti(struct oplock_info *opinfo)
 	work->conn = conn;
 	work->sess = opinfo->sess;
 
+	ksmbd_conn_r_count_inc(conn);
 	if (opinfo->op_state == OPLOCK_ACK_WAIT) {
-		ksmbd_conn_r_count_inc(conn);
 		INIT_WORK(&work->work, __smb2_oplock_break_noti);
 		ksmbd_queue_work(work);
 
@@ -833,8 +833,8 @@ static int smb2_lease_break_noti(struct oplock_info *opinfo)
 	work->conn = conn;
 	work->sess = opinfo->sess;
 
+	ksmbd_conn_r_count_inc(conn);
 	if (opinfo->op_state == OPLOCK_ACK_WAIT) {
-		ksmbd_conn_r_count_inc(conn);
 		INIT_WORK(&work->work, __smb2_lease_break_noti);
 		ksmbd_queue_work(work);
 		wait_for_break_ack(opinfo);
-- 
2.39.5



