Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBE64195DA;
	Sat, 12 Sep 2026 09:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203981; cv=none; b=D15ko+NxwUQHsqveVDBS/dCKwYHY0kEls+G5SoTIPyV5XryGBRyQh4S6N4+WibrfJoEX4j4kcqrEZ7NfTi+Aolr/Ju8TPQlTAJsctKN2OwIE2xGO6P89KfSTZPQvp3j4nY2oljHpq9s2sgO9U4QV2Q2PTsVCPN9f2lVYnH0nsuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203981; c=relaxed/simple;
	bh=TO0tQdbTmc6EMWcoH1oMJ76Hk/S3vR0X0lO2/x8joU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Af/HRdFF6GisFLDzS8itHvvadzYqCLiFCzy8JzW7wIQ0LlknSGA6l/1zXK1wA9vJCIl6tMRWddRZ+WQfKO7qxqX2wtxuDODoq8Vsy16Pt1eArGshsSRbdU28lkBdEoUWUMt5r5ZiAdw7YzjI4rLdOgRU4IQA6LBXXd/EGS64u7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TFi198is; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TFi198is"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9B61F000FF;
	Sat, 12 Sep 2026 09:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203979;
	bh=xeUTJKGD9dBg9dAYgEpYn8HfOk9DGuK9YJbjvPNunLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TFi198isAqmT2VQeA8+dKBe6RVMdn1XbsNWSnMK+HUphob1+goe64nX6KHjzBtPsA
	 i+cSb2r7zepTDbcgbKX3mHYgUf9GjTcCSZN7hUJ3kGZ6G5yqCzyxdxeqR9R0qky4Mj
	 7ffgyYlE4mKOT31YedQ8qFeB2rPwE6cVPzkBl3zU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1520/1815] ksmbd: recognize replayed SMB2 lock sequences
Date: Sat, 12 Sep 2026 08:54:30 +0200
Message-ID: <20260912065724.684677124@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 5ce5227cd60b7213359e91837727ed1b6d457d49 ]

A server returns success without processing a lock request when a valid
LockSequenceArray entry contains the same sequence number. The current
verifier only invalidates mismatched entries, so matching requests are
submitted to the VFS again and recorded as duplicate locks.

Make the verifier report matching sequences and skip lock processing for
those replays. Also correct the field comment to describe the sequence
and index bit layout used by the implementation and the protocol. Use
the capabilities advertised by the server when deciding whether lock
sequence verification applies to a multichannel connection.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Stable-dep-of: 29f74f0f2e6d ("ksmbd: defer publishing granted locks to prevent UAF/double-free race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/common/smb2pdu.h |  4 ++--
 fs/smb/server/smb2pdu.c | 34 +++++++++++++++++++++++-----------
 2 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index e7ff52b8aba5f..37b660b2047b0 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -847,8 +847,8 @@ struct smb2_lock_req {
 	__le16 StructureSize; /* Must be 48 */
 	__le16 LockCount;
 	/*
-	 * The least significant four bits are the index, the other 28 bits are
-	 * the lock sequence number (0 to 64). See MS-SMB2 2.2.26
+	 * The least significant four bits are the lock sequence number. The
+	 * other 28 bits are the index (0 to 64). See MS-SMB2 2.2.26.
 	 */
 	__le32 LockSequenceNumber;
 	__u64  PersistentFileId;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 843a353b4f882..b8714628e1fc5 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -786,31 +786,38 @@ static bool smb2_lock_sequence_applicable(struct ksmbd_work *work,
 {
 	return fp->is_resilient || fp->is_durable || fp->is_persistent ||
 	       (work->conn->dialect >= SMB30_PROT_ID &&
-		(work->conn->cli_cap & SMB2_GLOBAL_CAP_MULTI_CHANNEL));
+		(work->conn->vals->req_capabilities &
+		 SMB2_GLOBAL_CAP_MULTI_CHANNEL));
 }
 
-static void smb2_verify_lock_sequence(struct ksmbd_work *work,
-				      struct ksmbd_file *fp,
-				      struct smb2_lock_req *req)
+static bool smb2_verify_lock_sequence(struct ksmbd_work *work,
+				       struct ksmbd_file *fp,
+				       struct smb2_lock_req *req)
 {
 	u32 val, index;
 	u8 sequence;
+	bool replay = false;
 
 	if (work->conn->dialect == SMB20_PROT_ID ||
 	    !smb2_lock_sequence_applicable(work, fp))
-		return;
+		return false;
 
 	val = le32_to_cpu(req->LockSequenceNumber);
 	sequence = val & 0xf;
 	index = val >> 4;
 	if (!index || index > KSMBD_LOCK_SEQ_ARRAY_SIZE)
-		return;
+		return false;
 
 	spin_lock(&fp->f_lock);
-	if (fp->lock_seq[index - 1].valid &&
-	    fp->lock_seq[index - 1].sequence != sequence)
-		fp->lock_seq[index - 1].valid = false;
+	if (fp->lock_seq[index - 1].valid) {
+		if (fp->lock_seq[index - 1].sequence == sequence)
+			replay = true;
+		else
+			fp->lock_seq[index - 1].valid = false;
+	}
 	spin_unlock(&fp->f_lock);
+
+	return replay;
 }
 
 static void smb2_update_lock_sequence(struct ksmbd_work *work,
@@ -8547,6 +8554,7 @@ int smb2_lock(struct ksmbd_work *work)
 	LIST_HEAD(rollback_list);
 	int prior_lock = 0, bkt;
 	unsigned int id = KSMBD_NO_FID, pid = KSMBD_NO_FID;
+	bool lock_replayed;
 
 	WORK_BUFFERS(work, req, rsp);
 
@@ -8579,7 +8587,9 @@ int smb2_lock(struct ksmbd_work *work)
 	if (err)
 		goto out2;
 
-	smb2_verify_lock_sequence(work, fp, req);
+	lock_replayed = smb2_verify_lock_sequence(work, fp, req);
+	if (lock_replayed)
+		goto lock_success;
 
 	filp = fp->filp;
 	lock_count = le16_to_cpu(req->LockCount);
@@ -8858,6 +8868,7 @@ int smb2_lock(struct ksmbd_work *work)
 	if (atomic_read(&fp->f_ci->op_count) > 1)
 		smb_break_all_oplock(work, fp);
 
+lock_success:
 	rsp->StructureSize = cpu_to_le16(4);
 	ksmbd_debug(SMB, "successful in taking lock\n");
 	rsp->hdr.Status = STATUS_SUCCESS;
@@ -8865,7 +8876,8 @@ int smb2_lock(struct ksmbd_work *work)
 	err = ksmbd_iov_pin_rsp(work, rsp, sizeof(struct smb2_lock_rsp));
 	if (err)
 		goto out;
-	smb2_update_lock_sequence(work, fp, req);
+	if (!lock_replayed)
+		smb2_update_lock_sequence(work, fp, req);
 
 	ksmbd_fd_put(work, fp);
 	return 0;
-- 
2.53.0



