Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C0015A495;
	Mon, 29 Jan 2024 17:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548289; cv=none; b=RX6YyrwMSxZCYzL4z+knsbSChHHO/63guPrKGnnMrUQwsnwVbLabs7gBVPlnmNr3KhgQf73YHrmefghJFSaJhc91dKymMkvvugX1TSe4j3/L1um1Su8YkBNIZCtc8zb7YuQ4i18OKg/6pJMQmfBCsUUUIylbms7kPh0hU9zNDPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548289; c=relaxed/simple;
	bh=Ooa1555XiIOalIf/Xq+Xk3UJJCuVfxXirhFK6K7ayrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NY3FHvqGR8Er1irP3iJf7PaevGdfbCXzzGwm8YqyaXiDobp5Ja6QDRfUsNWa9hu3czyY3IaQdkaef+rvTYI+tV09wo5QDFrsoR+pFxYcvZ92xodrD7qJGKlyqy7mwNO/3SxOcs+163V1Kp7K5S9dz2Z+dYSnWVIdQT+Oue/ST6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MPaejL3H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MPaejL3H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D1BC43390;
	Mon, 29 Jan 2024 17:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548289;
	bh=Ooa1555XiIOalIf/Xq+Xk3UJJCuVfxXirhFK6K7ayrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MPaejL3H70BKQX8nWP5ZrBY65ygwvW/IrAZ2iU37Uo0cuVM3wd0ZeuyoHkbXWmJqU
	 DZt55AmGmp3BUjM1deBW/KSUPhPq1qyp1Io8J6dWut8qbT6fAWBHrvu/QUKNx4genY
	 WO7vdG1PdGJKvApLncJQOcTcYKYJQoc4X452iwRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 072/185] ksmbd: send lease break notification on FILE_RENAME_INFORMATION
Date: Mon, 29 Jan 2024 09:04:32 -0800
Message-ID: <20240129170000.921783632@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 3fc74c65b367476874da5fe6f633398674b78e5a ]

Send lease break notification on FILE_RENAME_INFORMATION request.
This patch fix smb2.lease.v2_epoch2 test failure.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/oplock.c  |   12 +++++++-----
 fs/smb/server/smb2pdu.c |    1 +
 2 files changed, 8 insertions(+), 5 deletions(-)

--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -541,14 +541,12 @@ static struct oplock_info *same_client_h
 				continue;
 			}
 
-			if (lctx->req_state != lease->state)
-				lease->epoch++;
-
 			/* upgrading lease */
 			if ((atomic_read(&ci->op_count) +
 			     atomic_read(&ci->sop_count)) == 1) {
 				if (lease->state != SMB2_LEASE_NONE_LE &&
 				    lease->state == (lctx->req_state & lease->state)) {
+					lease->epoch++;
 					lease->state |= lctx->req_state;
 					if (lctx->req_state &
 						SMB2_LEASE_WRITE_CACHING_LE)
@@ -559,13 +557,17 @@ static struct oplock_info *same_client_h
 				    atomic_read(&ci->sop_count)) > 1) {
 				if (lctx->req_state ==
 				    (SMB2_LEASE_READ_CACHING_LE |
-				     SMB2_LEASE_HANDLE_CACHING_LE))
+				     SMB2_LEASE_HANDLE_CACHING_LE)) {
+					lease->epoch++;
 					lease->state = lctx->req_state;
+				}
 			}
 
 			if (lctx->req_state && lease->state ==
-			    SMB2_LEASE_NONE_LE)
+			    SMB2_LEASE_NONE_LE) {
+				lease->epoch++;
 				lease_none_upgrade(opinfo, lctx->req_state);
+			}
 		}
 		read_lock(&ci->m_lock);
 	}
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5579,6 +5579,7 @@ static int smb2_rename(struct ksmbd_work
 	if (!file_info->ReplaceIfExists)
 		flags = RENAME_NOREPLACE;
 
+	smb_break_all_levII_oplock(work, fp, 0);
 	rc = ksmbd_vfs_rename(work, &fp->filp->f_path, new_name, flags);
 out:
 	kfree(new_name);


