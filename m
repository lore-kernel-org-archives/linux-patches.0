Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217280;
	b=VMREznYwZe4uhvh63YfM4Q8zIUFLX3KYWg+tFGe9T88F13ISjpo3owtIcNDqvI9/PJBL
	 +Opn9CBj+qbxi3cywWr9Motiye7/TA2aDMmBWnyJhjMFvD1vqVcBoJJRcTyybuSB+kETy
	 9lKW4AlWUY26ZBXChs+fLdKDBAqu0/YvAJQlHs7Mn6x6839U4YGug8G6HoGlnfDcM7cDO
	 GNS6yZlNndK5MY6ZwhC70hdVgUwYuU99aY6sRpgKKs/UKSH3lJdoV9QynPKr9wY9ToATh
	 SOz++7pfpfkbopeiDdlRipwbticBxl7e6Nv54ruaHt9d6kF0mcSVsewpzEAFkIcSE2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217280;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VS6lUGGwwoGTFZ9UXdeNKJT5JaPy7vCT5t5Sn8eARCE=;
	b=slAMleEYCTivkRvjSHW+qOsj5tJOveQvnTTjA+TvnL3aMZ+E5Q9z1itNneyfF58mQmWF
	 UDJcDFjDPk/xUkslwopiS47dBXwS4H2SXQXPyI0RLu94J3eL9zlhuc64f2ZRQwNenKIOe
	 G3llpydEHl+7qGfOiIcBxAGkv5MohFSUxPgtSXp/ELNKVeO+Zzni87eGu4ver+Zer566S
	 3K1eic9UrCsx7gphqtBN33NGY5XUgYtivnqwjl4iPjG0mPFTeZ0gMNbGYcekVoZ9DFjyX
	 ZcWzpMMg5AbrnrPhshORWCrM4FHdNV9KF2+mn5JvtF+KuXaSw3bmCJbQa2bVsagJoNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IpFD8ges;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36964606A31A;
	Wed, 28 Oct 2026 19:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IpFD8ges
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859881F01825;
	Wed, 28 Oct 2026 19:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217280;
	bh=VS6lUGGwwoGTFZ9UXdeNKJT5JaPy7vCT5t5Sn8eARCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IpFD8ges0rXa/JObMi8irEl5Qtofes2c5IabFpzqag0xH1YPpUUfSh5Eu+7p1Mtol
	 yXJFGJPq1pO+rXBh4a75cb3OkS/0Fp0AklMCuMCbAe42L89H2ZKhIX9c+6C+0jOJf1
	 0jmYu9ug+0Ef9OE2uUG2rV1WEkESeE2m1CPiOPhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang <q.h.hack.winter@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1850/1887] ksmbd: pin conn during async oplock break notification
Date: Wed, 28 Oct 2026 18:05:46 +0100
Message-ID: <20261028170541.548908974@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 64724b371e5f1..9272b33340fc8 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -758,6 +758,7 @@ static void __smb2_oplock_break_noti(struct work_struct *wk)
 out:
 	ksmbd_free_work_struct(work);
 	ksmbd_conn_r_count_dec(conn);
+	ksmbd_conn_put(conn);
 }
 
 /**
@@ -788,7 +789,7 @@ static int smb2_oplock_break_noti(struct oplock_info *opinfo)
 	br_info->open_trunc = opinfo->open_trunc;
 
 	work->request_buf = (char *)br_info;
-	work->conn = conn;
+	work->conn = ksmbd_conn_get(conn);
 	work->sess = opinfo->sess;
 
 	if (opinfo->op_state == OPLOCK_ACK_WAIT) {
@@ -862,6 +863,7 @@ static void __smb2_lease_break_noti(struct work_struct *wk)
 out:
 	ksmbd_free_work_struct(work);
 	ksmbd_conn_r_count_dec(conn);
+	ksmbd_conn_put(conn);
 }
 
 /**
@@ -897,7 +899,7 @@ static int smb2_lease_break_noti(struct oplock_info *opinfo)
 	memcpy(br_info->lease_key, lease->lease_key, SMB2_LEASE_KEY_SIZE);
 
 	work->request_buf = (char *)br_info;
-	work->conn = conn;
+	work->conn = ksmbd_conn_get(conn);
 	work->sess = opinfo->sess;
 
 	if (opinfo->op_state == OPLOCK_ACK_WAIT) {
-- 
2.53.0



