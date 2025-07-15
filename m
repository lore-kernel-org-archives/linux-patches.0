Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C152EF65C;
	Tue, 15 Jul 2025 13:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587187; cv=none; b=H2np/8Qu3P/7mhH1dVynW/xBPhiSvajwv+FaDZbxBQaSGbW0sRYYzSjhKNb++mQCmL9TnOsXyQ7Lgd3l1rrupXgzc008Tee4p4A9nfsAxotFj7zwcph9/MylxYP1g7RqiWlfIt/++f9c26rx5/BwpXauOL7T6mZcZepV5f6tFj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587187; c=relaxed/simple;
	bh=rjQpVgcrU0aOojY2DtM5IBPQZPdMUtqCYSlZepI9XQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHLljJsCR1UDY0Vd0XijwrVLRpxDFOuAjrdoswyXJ8L5mjcgacL9/AorhOMy7wbQ7heiIA75HzbvRTWLIufbLvZWo1DwYLXZsvuAjdsYff9U1QAcbaEsQbIn6hkFi8Em8rhJirKkKtB7vxytU0YLHBOrbccWxP7BkJCgjHlQtP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mj/tRcQ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mj/tRcQ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF292C4CEE3;
	Tue, 15 Jul 2025 13:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587187;
	bh=rjQpVgcrU0aOojY2DtM5IBPQZPdMUtqCYSlZepI9XQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mj/tRcQ/zdudN05p/TlS/Xp/R00phNaihDwdjBlyQIZ6zkGhjMsupZ7WymcDmLQg2
	 KUS+RuguhuCsTrtetioNce5JiHDHWZT3mixeYxWQj7CAGKkeI+1VXcpY/4yJ/c/Er/
	 AmQpaCJbuXP9mq0XeYrSfOSwu76PqJ2uW1Jds7g4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyan Xu <research@securitygossip.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.15 192/192] ksmbd: fix potential use-after-free in oplock/lease break ack
Date: Tue, 15 Jul 2025 15:14:47 +0200
Message-ID: <20250715130822.629147906@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 50f930db22365738d9387c974416f38a06e8057e upstream.

If ksmbd_iov_pin_rsp return error, use-after-free can happen by
accessing opinfo->state and opinfo_put and ksmbd_fd_put could
called twice.

Reported-by: Ziyan Xu <research@securitygossip.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |   29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8535,11 +8535,6 @@ static void smb20_oplock_break_ack(struc
 		goto err_out;
 	}
 
-	opinfo->op_state = OPLOCK_STATE_NONE;
-	wake_up_interruptible_all(&opinfo->oplock_q);
-	opinfo_put(opinfo);
-	ksmbd_fd_put(work, fp);
-
 	rsp->StructureSize = cpu_to_le16(24);
 	rsp->OplockLevel = rsp_oplevel;
 	rsp->Reserved = 0;
@@ -8547,16 +8542,15 @@ static void smb20_oplock_break_ack(struc
 	rsp->VolatileFid = volatile_id;
 	rsp->PersistentFid = persistent_id;
 	ret = ksmbd_iov_pin_rsp(work, rsp, sizeof(struct smb2_oplock_break));
-	if (!ret)
-		return;
-
+	if (ret) {
 err_out:
+		smb2_set_err_rsp(work);
+	}
+
 	opinfo->op_state = OPLOCK_STATE_NONE;
 	wake_up_interruptible_all(&opinfo->oplock_q);
-
 	opinfo_put(opinfo);
 	ksmbd_fd_put(work, fp);
-	smb2_set_err_rsp(work);
 }
 
 static int check_lease_state(struct lease *lease, __le32 req_state)
@@ -8686,11 +8680,6 @@ static void smb21_lease_break_ack(struct
 	}
 
 	lease_state = lease->state;
-	opinfo->op_state = OPLOCK_STATE_NONE;
-	wake_up_interruptible_all(&opinfo->oplock_q);
-	atomic_dec(&opinfo->breaking_cnt);
-	wake_up_interruptible_all(&opinfo->oplock_brk);
-	opinfo_put(opinfo);
 
 	rsp->StructureSize = cpu_to_le16(36);
 	rsp->Reserved = 0;
@@ -8699,16 +8688,16 @@ static void smb21_lease_break_ack(struct
 	rsp->LeaseState = lease_state;
 	rsp->LeaseDuration = 0;
 	ret = ksmbd_iov_pin_rsp(work, rsp, sizeof(struct smb2_lease_ack));
-	if (!ret)
-		return;
-
+	if (ret) {
 err_out:
+		smb2_set_err_rsp(work);
+	}
+
+	opinfo->op_state = OPLOCK_STATE_NONE;
 	wake_up_interruptible_all(&opinfo->oplock_q);
 	atomic_dec(&opinfo->breaking_cnt);
 	wake_up_interruptible_all(&opinfo->oplock_brk);
-
 	opinfo_put(opinfo);
-	smb2_set_err_rsp(work);
 }
 
 /**


