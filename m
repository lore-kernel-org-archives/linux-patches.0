Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034228;
	b=5FC/u5FAX0n+CGJBYqQamq/r8eBW3Qt/Ryr2ZKAYKu5N1w/QI8QfbUDwop79/I+n4U8T
	 wGwa27KWPfQFGzQBeNIY+nWGEpe6LW303pNABXPBPXXNHsCAOAHFMekcQXHOjJTXwlYkQ
	 EIr++AylFFmydJQ4jgKdKYUbIxps6aojZ6lQb0jRh2/2Nu4SSfiLsiSXaZqiWFtAm4Le7
	 4a7g3opN5WUGJkUkOy5OnvMCZ6x05daRaY3weP+eKnoD9ret27pYKhsJGxrozUQdGjmHa
	 kmZ5QcfhiU0jwJ/gYWAk4BnASMj0s0fh7LSS6BFfH85xJzshWOwt0/bUNeDLnP6XdZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034228;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oAzIlwaSLQod9LSADfVt+7f4gLiFUJHt71zhtccIkVw=;
	b=Gq+oL37V4z7eHoZ0dBUcTUG90lcbj7IJ7LPyXM4YmcG34DaflpgQn5UwQecQFuyvr6Pb
	 O0Sn61N8XS3fFGTjqA4FKaRSMWDwcBjNfy0XdYfMwkOEeQWarSuBYFDmynQKDpcl/Udt3
	 oA6t5MRf0KQnKxplO6gYJF/wF1qTbdsBBF5hSpNNzOsgG9hjq9TOCKkSaTespMZgFOucz
	 LwYI79biYv/HrSPzotDW1a8cqsTsCAAeptVsMolHJUfjqOuAp1rmFIfDtAIDzv4VL1D01
	 JzdcovEWxbzxeJFez+yBKqmlzgBUaCAPE+7DAfRthNw6llylINHeSQW8DKa3SrDEoMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mISsJLAc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA3E606A336;
	Wed, 18 Nov 2026 20:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mISsJLAc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823E01F000C4;
	Wed, 18 Nov 2026 20:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034228;
	bh=oAzIlwaSLQod9LSADfVt+7f4gLiFUJHt71zhtccIkVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mISsJLAc8KQgcmbXriVpgw1Cn+wbDkdXyyw8w0k+G61WhJ0oi3td34URgMDQgy0VQ
	 yEekjRsvTuNnoRcJwjcoM+4fGbKxOqgjYjcqvfseZ07B0UkKOGdALkUbLRZDr06sYc
	 6CJokkztqvGW4c4cLhl6+33SImFsDoE9bODT+WYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0296/3318] ksmbd: fix SMB2 byte-range lock end offset
Date: Wed, 18 Nov 2026 15:15:18 +0100
Message-ID: <20261118150324.540321158@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 54d90311f9b4eb23f3b0b62650b0cfddb11a12ef ]

SMB2 describes a byte-range lock using an offset and a length, while
Linux file_lock uses an inclusive end offset. smb2_lock() currently sets
fl_end to start + length and consequently locks one extra byte for every
nonzero-length request.

Translate nonzero lengths to start + length - 1 and reject ranges that
cannot be represented by loff_t instead of silently truncating them at
OFFSET_MAX. Track zero-length locks from the request length so one-byte
ranges are not mistaken for zero-length locks after endpoint conversion.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 44 +++++++++++++----------------------------
 1 file changed, 14 insertions(+), 30 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 5d6469c759074..4ed7fae342be5 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7541,7 +7541,7 @@ static int smb2_set_flock_flags(struct file_lock *flock, int flags)
 }
 
 static struct ksmbd_lock *smb2_lock_init(struct file_lock *flock,
-					 unsigned int cmd, int flags,
+					 unsigned int cmd, int flags, bool zero_len,
 					 struct list_head *lock_list)
 {
 	struct ksmbd_lock *lock;
@@ -7555,8 +7555,7 @@ static struct ksmbd_lock *smb2_lock_init(struct file_lock *flock,
 	lock->start = flock->fl_start;
 	lock->end = flock->fl_end;
 	lock->flags = flags;
-	if (lock->start == lock->end)
-		lock->zero_len = 1;
+	lock->zero_len = zero_len;
 	INIT_LIST_HEAD(&lock->clist);
 	INIT_LIST_HEAD(&lock->flist);
 	INIT_LIST_HEAD(&lock->llist);
@@ -7649,32 +7648,18 @@ int smb2_lock(struct ksmbd_work *work)
 
 		lock_start = le64_to_cpu(lock_ele[i].Offset);
 		lock_length = le64_to_cpu(lock_ele[i].Length);
-		if (lock_start > U64_MAX - lock_length) {
+		if (lock_start > OFFSET_MAX ||
+		    (lock_length &&
+		     lock_length - 1 > OFFSET_MAX - lock_start)) {
 			pr_err("Invalid lock range requested\n");
 			rsp->hdr.Status = STATUS_INVALID_LOCK_RANGE;
 			locks_free_lock(flock);
 			goto out;
 		}
 
-		if (lock_start > OFFSET_MAX)
-			flock->fl_start = OFFSET_MAX;
-		else
-			flock->fl_start = lock_start;
-
-		lock_length = le64_to_cpu(lock_ele[i].Length);
-		if (lock_length > OFFSET_MAX - flock->fl_start)
-			lock_length = OFFSET_MAX - flock->fl_start;
-
-		flock->fl_end = flock->fl_start + lock_length;
-
-		if (flock->fl_end < flock->fl_start) {
-			ksmbd_debug(SMB,
-				    "the end offset(%llx) is smaller than the start offset(%llx)\n",
-				    flock->fl_end, flock->fl_start);
-			rsp->hdr.Status = STATUS_INVALID_LOCK_RANGE;
-			locks_free_lock(flock);
-			goto out;
-		}
+		flock->fl_start = lock_start;
+		flock->fl_end = lock_length ?
+			flock->fl_start + lock_length - 1 : flock->fl_start;
 
 		/* Check conflict locks in one request */
 		list_for_each_entry(cmp_lock, &lock_list, llist) {
@@ -7690,7 +7675,8 @@ int smb2_lock(struct ksmbd_work *work)
 			}
 		}
 
-		smb_lock = smb2_lock_init(flock, cmd, flags, &lock_list);
+		smb_lock = smb2_lock_init(flock, cmd, flags, !lock_length,
+					   &lock_list);
 		if (!smb_lock) {
 			err = -EINVAL;
 			locks_free_lock(flock);
@@ -7764,7 +7750,7 @@ int smb2_lock(struct ksmbd_work *work)
 				/* check zero byte lock range */
 				if (cmp_lock->zero_len && !smb_lock->zero_len &&
 				    cmp_lock->start > smb_lock->start &&
-				    cmp_lock->start < smb_lock->end) {
+				    cmp_lock->start <= smb_lock->end) {
 					spin_unlock(&conn->llist_lock);
 					up_read(&conn_list_lock);
 					pr_err("previous lock conflict with zero byte lock range\n");
@@ -7773,17 +7759,15 @@ int smb2_lock(struct ksmbd_work *work)
 
 				if (smb_lock->zero_len && !cmp_lock->zero_len &&
 				    smb_lock->start > cmp_lock->start &&
-				    smb_lock->start < cmp_lock->end) {
+				    smb_lock->start <= cmp_lock->end) {
 					spin_unlock(&conn->llist_lock);
 					up_read(&conn_list_lock);
 					pr_err("current lock conflict with zero byte lock range\n");
 					goto out;
 				}
 
-				if (((cmp_lock->start <= smb_lock->start &&
-				      cmp_lock->end > smb_lock->start) ||
-				     (cmp_lock->start < smb_lock->end &&
-				      cmp_lock->end >= smb_lock->end)) &&
+				if (cmp_lock->start <= smb_lock->end &&
+				    smb_lock->start <= cmp_lock->end &&
 				    !cmp_lock->zero_len && !smb_lock->zero_len) {
 					spin_unlock(&conn->llist_lock);
 					up_read(&conn_list_lock);
-- 
2.53.0



