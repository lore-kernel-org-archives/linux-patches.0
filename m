Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E83547067;
	Thu, 17 Sep 2026 18:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668212; cv=none; b=Re/Jf1wuU2AJ98FvyyL2Xxp/3wuV0mxWVvKxikdoSIBG450CaLmvP1bAivHuLBTgMGpxFx4BfCp7nzOTDs8PI2cqVezkAkf8oydSVDsYiNeusaR94RzDNAUBBlNRg9RJU1S9DaX6FSOhpTNAmP04fv+hA3WXvX6eon+dxpL3EGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668212; c=relaxed/simple;
	bh=LH3brjBYyQQ6/5SMuQmW762uOzLMAWcUMrHVmvgQFUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5aSQ2v8zmY7zptIt9JoDT75AWMuyWcVRrj4YH6axm+15mdndQ6/TlDm/lD50mjZ7ErHAPMvK0PL+WoX/09NKCZMyHl8U6WR48dvVealKnXaha3Ygnl8YF1I6XSQnB7PdWmX6+RDJJ1/jcAhSFbXrGMBGzP32XYQ8HBB3Ya8nTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rIuQv+iL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rIuQv+iL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6371F00893;
	Thu, 17 Sep 2026 18:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668210;
	bh=YL6x3fFUQS9+0t8Cd8+ZZ8miqQcKgjqcofjSw3KNteM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rIuQv+iL4432gEYiWNfihv9t+DMLGb2m79o39Q4JbBLJrVBfyrXesa1tLHfX0tCsb
	 a0Yldl6gL8srCYBgLF+0NqtKEr65B5YVKrw364AJKzp5KkHM+lpKwPGqBKX/mh0mQb
	 ftL9w0OKag94vqeVD6w+hDD6qlDf5aCyW9Iw4rZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0350/1102] ksmbd: fix lease break and ack state handling
Date: Thu, 17 Sep 2026 16:04:53 +0100
Message-ID: <20260917151548.430991671@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 935e337a95b8e..e2d7763ebcff4 100644
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
index ebb35e95aef54..ba8f9a4b687ce 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8769,16 +8769,17 @@ static void smb20_oplock_break_ack(struct ksmbd_work *work)
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
@@ -8796,9 +8797,7 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 	struct smb2_lease_ack *req;
 	struct smb2_lease_ack *rsp;
 	struct oplock_info *opinfo;
-	__le32 err = 0;
 	int ret = 0;
-	unsigned int lease_change_type;
 	__le32 lease_state;
 	struct lease *lease;
 
@@ -8822,80 +8821,23 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
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
@@ -8904,16 +8846,20 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
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



