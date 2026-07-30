Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5382E9EC7;
	Thu, 30 Jul 2026 14:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421663; cv=none; b=bqWVCKCtJ8KG/+CU2kKot88bu96w1KBLQOMNY4eygm2ZI+vsE2LDOiao/xLG8rLS/5g0zZ49zqUGj/hJ+TpO+HaZNvHfg7V4474Z53kQhpIIDjjg3l5lLW8+75ZzGTx/dj9jM8WdivqCzHUbYZSrrGt1v1Nt3qSpQf0ice1Q9o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421663; c=relaxed/simple;
	bh=b8i8GQFwPxJS+2FZEaSFnfWUnJn8gX9VDjHyzgK6PVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=grv3Cg8yD5izf2eUT3NqajFJr4f8eShREUbVz+eAZjmJuifr/RAj0ox8lCi2X3C+/hGKu3LiQunZur7lp8ZPSWwtKBL8crbEn0vehk/LDJVJeA3HUddhEYdFyt5LGCoxaPhYqLn8+JLQJJITn38f4BEW1bUP56bj353TPQg7rtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1TfUj1Vv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1TfUj1Vv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466C91F000E9;
	Thu, 30 Jul 2026 14:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421661;
	bh=2Q18EEXDg76ySfTLqnb08o8+9Jj6wtD/pP57gRbiN6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1TfUj1Vvq5vjFoc7GeHbHkeAOf48lpsUbwHo+25loZC/2PgPf58iM4XOy5d6dUvW+
	 RJbTXdKiFsMG5l6WdLVCi2c82ts4HDuSgmXtuDzePZ+x+mT4JIMoFQrzH5TmxVQgAu
	 Gwv1Ii1Wt+8hVBkPF3Ci9fENmhiudzfn6LXYv5P0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang <q.h.hack.winter@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 125/744] ksmbd: pin conn during async oplock break notification
Date: Thu, 30 Jul 2026 16:06:38 +0200
Message-ID: <20260730141446.940951047@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qihang <q.h.hack.winter@gmail.com>

[ Upstream commit aa5d8f3f96aa11a4a54ce993c11ce8af11c546f9 ]

smb2_oplock_break_noti() and smb2_lease_break_noti() store a ksmbd_conn
pointer in an async ksmbd_work and then queue that work on ksmbd-io.  The
work only increments conn->r_count, which prevents teardown from passing
the pending-request wait after the increment, but it does not pin the
struct ksmbd_conn object.

If connection teardown races with an oplock break notification, the last
conn reference can be dropped before the queued worker finishes.  The
worker then uses the freed conn in ksmbd_conn_write() and
ksmbd_conn_r_count_dec().

Take a real conn reference when publishing the conn pointer to the async
work item, and drop it after the notification work has decremented
r_count.  Apply the same lifetime rule to lease break notification, which
uses the same work->conn pattern.

Fixes: 3aa660c05924 ("ksmbd: prevent connection release during oplock break notification")
Signed-off-by: Qihang <q.h.hack.winter@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/oplock.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 60e7e821c2455d..3f28dc3b7fc415 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -705,6 +705,7 @@ static void __smb2_oplock_break_noti(struct work_struct *wk)
 out:
 	ksmbd_free_work_struct(work);
 	ksmbd_conn_r_count_dec(conn);
+	ksmbd_conn_put(conn);
 }
 
 /**
@@ -740,7 +741,7 @@ static int smb2_oplock_break_noti(struct oplock_info *opinfo)
 	br_info->open_trunc = opinfo->open_trunc;
 
 	work->request_buf = (char *)br_info;
-	work->conn = conn;
+	work->conn = ksmbd_conn_get(conn);
 	work->sess = opinfo->sess;
 
 	ksmbd_conn_r_count_inc(conn);
@@ -814,6 +815,7 @@ static void __smb2_lease_break_noti(struct work_struct *wk)
 out:
 	ksmbd_free_work_struct(work);
 	ksmbd_conn_r_count_dec(conn);
+	ksmbd_conn_put(conn);
 }
 
 /**
@@ -853,7 +855,7 @@ static int smb2_lease_break_noti(struct oplock_info *opinfo)
 	memcpy(br_info->lease_key, lease->lease_key, SMB2_LEASE_KEY_SIZE);
 
 	work->request_buf = (char *)br_info;
-	work->conn = conn;
+	work->conn = ksmbd_conn_get(conn);
 	work->sess = opinfo->sess;
 
 	ksmbd_conn_r_count_inc(conn);
-- 
2.53.0



