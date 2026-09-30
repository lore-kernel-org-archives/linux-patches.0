Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F8A360ECA;
	Wed, 30 Sep 2026 18:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794556; cv=none; b=UjcDtG2+R+UQgZn0QYoBlf3GivB/y6dVR8pxJRk6NL0o+QlGRXNj4998jPyyTBUtHyrMvyFkku5zBp0ijF8p7eJ9SKTQjADsQ8agrbBiQSUDqDa/HzB+Wq8g51C/nPziLsddyq52QPwqoL/O5xZy+Ppd2dZODRDvCboT4IWEpKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794556; c=relaxed/simple;
	bh=z+8PDwBeZm0rdNQ7uDx9tMxs/dLCwybiXQrsoGtr+rY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kKe4btvJRg2tkLrWMSY9cT/Ya7vmPwt7y17ueifbzVrvE438eUS6Iz0LbHQveQLR2uMSzw0iTA4pUYknodryX0EN/aHDznF5I7u+GZSetrbikrGwXjJD/Kbovn6ucr1//G0zoMluskNQ5bRePOxdIzGR7wwvvRIdMVsHBFZkMUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L6tjGED4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L6tjGED4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACBE1F000FF;
	Wed, 30 Sep 2026 18:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794554;
	bh=hCb4SJOzp5/lcfhFDhD3n9Gt6rJk6fKZfrmolf2ZTDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L6tjGED4upxjifMn0aJS60CFK7WPLZRCqt8rNI2b64Vh6I4mysIbWXIWeAMLqX1Xx
	 YioHdWOV9ixfjurJUiMMRDuWCxX5ObL0Olvcbbor8mT52r8Ef1mimzdHPtBRf11yMi
	 v5SLvk3NMvbtQW/Ttfo6mI1P2tiVyCMYNNVDn2Mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0252/1193] ksmbd: fix lease break and ack state handling
Date: Wed, 30 Sep 2026 17:15:36 +0200
Message-ID: <20260930152439.781138156@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 5015191096db311759fef98769270336cd8b1324 ]

Do not skip valid lease states containing WRITE_CACHING when breaking
level-II/read leases for writes and truncates.

Handle lease break acknowledgments according to the SMB2 rule that the
acknowledged state must be a subset of the server's break target. Apply
the acknowledged state directly and keep the break pending on failed ACKs.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/oplock.c  |  24 +++------
 fs/smb/server/smb2pdu.c | 106 ++++++++++------------------------------
 2 files changed, 34 insertions(+), 96 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 296eb3db37355..2ae3d36e05abf 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1485,14 +1485,8 @@ void smb_break_all_levII_oplock(struct ksmbd_work *work, struct ksmbd_file *fp,
 			continue;
 		}
 
-		if (brk_op->is_lease && (brk_op->o_lease->state &
-		    (~(SMB2_LEASE_READ_CACHING_LE |
-				SMB2_LEASE_HANDLE_CACHING_LE)))) {
-			ksmbd_debug(OPLOCK, "unexpected lease state(0x%x)\n",
-				    brk_op->o_lease->state);
-			goto next;
-		} else if (brk_op->level !=
-				SMB2_OPLOCK_LEVEL_II) {
+		if (!brk_op->is_lease &&
+		    brk_op->level != SMB2_OPLOCK_LEVEL_II) {
 			ksmbd_debug(OPLOCK, "unexpected oplock(0x%x)\n",
 				    brk_op->level);
 			goto next;
@@ -1553,15 +1547,13 @@ void smb_break_all_oplock(struct ksmbd_work *work, struct ksmbd_file *fp)
  */
 __u8 smb2_map_lease_to_oplock(__le32 lease_state)
 {
-	if (lease_state == (SMB2_LEASE_HANDLE_CACHING_LE |
-			    SMB2_LEASE_READ_CACHING_LE |
-			    SMB2_LEASE_WRITE_CACHING_LE)) {
+	if ((lease_state & SMB2_LEASE_WRITE_CACHING_LE) &&
+	    (lease_state & SMB2_LEASE_HANDLE_CACHING_LE)) {
 		return SMB2_OPLOCK_LEVEL_BATCH;
-	} else if (lease_state != SMB2_LEASE_WRITE_CACHING_LE &&
-		 lease_state & SMB2_LEASE_WRITE_CACHING_LE) {
-		if (!(lease_state & SMB2_LEASE_HANDLE_CACHING_LE))
-			return SMB2_OPLOCK_LEVEL_EXCLUSIVE;
-	} else if (lease_state & SMB2_LEASE_READ_CACHING_LE) {
+	} else if (lease_state & SMB2_LEASE_WRITE_CACHING_LE) {
+		return SMB2_OPLOCK_LEVEL_EXCLUSIVE;
+	} else if (lease_state & (SMB2_LEASE_READ_CACHING_LE |
+				  SMB2_LEASE_HANDLE_CACHING_LE)) {
 		return SMB2_OPLOCK_LEVEL_II;
 	}
 	return 0;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 807bfcebb5c24..b76a00fe93d7e 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8743,16 +8743,17 @@ static void smb20_oplock_break_ack(struct ksmbd_work *work)
 	ksmbd_fd_put(work, fp);
 }
 
-static int check_lease_state(struct lease *lease, __le32 req_state)
+static bool smb2_lease_state_valid(__le32 state)
 {
-	if ((lease->new_state ==
-	     (SMB2_LEASE_READ_CACHING_LE | SMB2_LEASE_HANDLE_CACHING_LE)) &&
-	    !(req_state & SMB2_LEASE_WRITE_CACHING_LE)) {
-		lease->new_state = req_state;
-		return 0;
-	}
+	return !(state & ~(SMB2_LEASE_READ_CACHING_LE |
+			   SMB2_LEASE_HANDLE_CACHING_LE |
+			   SMB2_LEASE_WRITE_CACHING_LE));
+}
 
-	if (lease->new_state == req_state)
+static int check_lease_state(struct lease *lease, __le32 req_state)
+{
+	if (smb2_lease_state_valid(req_state) &&
+	    !(req_state & ~lease->new_state))
 		return 0;
 
 	return 1;
@@ -8770,9 +8771,7 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 	struct smb2_lease_ack *req;
 	struct smb2_lease_ack *rsp;
 	struct oplock_info *opinfo;
-	__le32 err = 0;
 	int ret = 0;
-	unsigned int lease_change_type;
 	__le32 lease_state;
 	struct lease *lease;
 
@@ -8796,80 +8795,23 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 		goto err_out;
 	}
 
-	if (check_lease_state(lease, req->LeaseState)) {
-		rsp->hdr.Status = STATUS_REQUEST_NOT_ACCEPTED;
-		ksmbd_debug(OPLOCK,
-			    "req lease state: 0x%x, expected state: 0x%x\n",
-			    req->LeaseState, lease->new_state);
-		goto err_out;
-	}
-
 	if (!atomic_read(&opinfo->breaking_cnt)) {
 		rsp->hdr.Status = STATUS_UNSUCCESSFUL;
 		goto err_out;
 	}
 
-	/* check for bad lease state */
-	if (req->LeaseState &
-	    (~(SMB2_LEASE_READ_CACHING_LE | SMB2_LEASE_HANDLE_CACHING_LE))) {
-		err = STATUS_INVALID_OPLOCK_PROTOCOL;
-		if (lease->state & SMB2_LEASE_WRITE_CACHING_LE)
-			lease_change_type = OPLOCK_WRITE_TO_NONE;
-		else
-			lease_change_type = OPLOCK_READ_TO_NONE;
-		ksmbd_debug(OPLOCK, "handle bad lease state 0x%x -> 0x%x\n",
-			    le32_to_cpu(lease->state),
-			    le32_to_cpu(req->LeaseState));
-	} else if (lease->state == SMB2_LEASE_READ_CACHING_LE &&
-		   req->LeaseState != SMB2_LEASE_NONE_LE) {
-		err = STATUS_INVALID_OPLOCK_PROTOCOL;
-		lease_change_type = OPLOCK_READ_TO_NONE;
-		ksmbd_debug(OPLOCK, "handle bad lease state 0x%x -> 0x%x\n",
-			    le32_to_cpu(lease->state),
-			    le32_to_cpu(req->LeaseState));
-	} else {
-		/* valid lease state changes */
-		err = STATUS_INVALID_DEVICE_STATE;
-		if (req->LeaseState == SMB2_LEASE_NONE_LE) {
-			if (lease->state & SMB2_LEASE_WRITE_CACHING_LE)
-				lease_change_type = OPLOCK_WRITE_TO_NONE;
-			else
-				lease_change_type = OPLOCK_READ_TO_NONE;
-		} else if (req->LeaseState & SMB2_LEASE_READ_CACHING_LE) {
-			if (lease->state & SMB2_LEASE_WRITE_CACHING_LE)
-				lease_change_type = OPLOCK_WRITE_TO_READ;
-			else
-				lease_change_type = OPLOCK_READ_HANDLE_TO_READ;
-		} else {
-			lease_change_type = 0;
-		}
-	}
-
-	switch (lease_change_type) {
-	case OPLOCK_WRITE_TO_READ:
-		ret = opinfo_write_to_read(opinfo);
-		break;
-	case OPLOCK_READ_HANDLE_TO_READ:
-		ret = opinfo_read_handle_to_read(opinfo);
-		break;
-	case OPLOCK_WRITE_TO_NONE:
-		ret = opinfo_write_to_none(opinfo);
-		break;
-	case OPLOCK_READ_TO_NONE:
-		ret = opinfo_read_to_none(opinfo);
-		break;
-	default:
-		ksmbd_debug(OPLOCK, "unknown lease change 0x%x -> 0x%x\n",
-			    le32_to_cpu(lease->state),
-			    le32_to_cpu(req->LeaseState));
-	}
-
-	if (ret < 0) {
-		rsp->hdr.Status = err;
+	if (check_lease_state(lease, req->LeaseState)) {
+		rsp->hdr.Status = STATUS_REQUEST_NOT_ACCEPTED;
+		ksmbd_debug(OPLOCK,
+			    "req lease state: 0x%x, expected state: 0x%x\n",
+			    req->LeaseState, lease->new_state);
 		goto err_out;
 	}
 
-	lease_state = lease->state;
+	lease_state = req->LeaseState;
+	lease->state = lease_state;
+	lease->new_state = SMB2_LEASE_NONE_LE;
+	opinfo->level = smb2_map_lease_to_oplock(lease_state);
 
 	rsp->StructureSize = cpu_to_le16(36);
 	rsp->Reserved = 0;
@@ -8878,16 +8820,20 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 	rsp->LeaseState = lease_state;
 	rsp->LeaseDuration = 0;
 	ret = ksmbd_iov_pin_rsp(work, rsp, sizeof(struct smb2_lease_ack));
-	if (ret) {
-err_out:
-		smb2_set_err_rsp(work);
-	}
+	if (ret)
+		goto err_out;
 
 	opinfo->op_state = OPLOCK_STATE_NONE;
 	wake_up_interruptible_all(&opinfo->oplock_q);
 	atomic_dec(&opinfo->breaking_cnt);
 	wake_up_interruptible_all(&opinfo->oplock_brk);
 	opinfo_put(opinfo);
+	return;
+
+err_out:
+	smb2_set_err_rsp(work);
+	opinfo_put(opinfo);
+	return;
 }
 
 /**
-- 
2.53.0



