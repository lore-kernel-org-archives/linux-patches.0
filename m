Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA133BB24;
	Tue, 14 May 2024 10:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684086; cv=none; b=UD1QUqtkr05pRkNQJ1cDPWcJV+OujRY/daJuZRDM8VWB/DWysCgNQamSDa/9BqIiUqNPs90rqyXTJxyimdg2T5YYllre39hVLTNfJzqZ9UvvEuj4xeCwLY1B+klfgGQSNEwyB7nvSrcrWcGFCDo3v2DYiYqFbi/W1xFpGXc+QnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684086; c=relaxed/simple;
	bh=w5x/BxbtevC8MsUGpqrNb6opOImKFmg/Cnsh/EEvPic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvnScwAgc+0S2BZbMbdWuTC0UxUM1AghvUhXAyToyuftqbdmjLGwb/WDi7So/KWCnRapNHug1Mak6CKXuLGtk5iTHvb20bClF4sQF29WOr8WuzDLhBz1flsfSxkLLRo0tO7mJVVZ5gQHRI4kpbL5dcTnk2GJ7d/urShMPcvK6dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xQ5WQvC0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xQ5WQvC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D905C32781;
	Tue, 14 May 2024 10:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684086;
	bh=w5x/BxbtevC8MsUGpqrNb6opOImKFmg/Cnsh/EEvPic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xQ5WQvC0UuW1UcOXQrDtvvM84Kv/vzlnQ+0TBFtvdEMoCahW3bLEUePZtqmGZI0P6
	 3h1+YRkTx3A+Nwaq8kUCQknw516hYMdaZV+GaziPvR3PtkyKtgBNJwygv6ftOL627W
	 jcwUcCqqWv+8LNPsUsX4wCqgqpqQAxX6WvY2bbLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.8 323/336] ksmbd: avoid to send duplicate lease break notifications
Date: Tue, 14 May 2024 12:18:47 +0200
Message-ID: <20240514101050.818584599@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 97c2ec64667bacc49881d2b2dd9afd4d1c3fbaeb upstream.

This patch fixes generic/011 when enable smb2 leases.

if ksmbd sends multiple notifications for a file, cifs increments
the reference count of the file but it does not decrement the count by
the failure of queue_work.
So even if the file is closed, cifs does not send a SMB2_CLOSE request.

Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/oplock.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -612,13 +612,23 @@ static int oplock_break_pending(struct o
 
 		if (opinfo->op_state == OPLOCK_CLOSING)
 			return -ENOENT;
-		else if (!opinfo->is_lease && opinfo->level <= req_op_level)
-			return 1;
+		else if (opinfo->level <= req_op_level) {
+			if (opinfo->is_lease &&
+			    opinfo->o_lease->state !=
+			     (SMB2_LEASE_HANDLE_CACHING_LE |
+			      SMB2_LEASE_READ_CACHING_LE))
+				return 1;
+		}
 	}
 
-	if (!opinfo->is_lease && opinfo->level <= req_op_level) {
-		wake_up_oplock_break(opinfo);
-		return 1;
+	if (opinfo->level <= req_op_level) {
+		if (opinfo->is_lease &&
+		    opinfo->o_lease->state !=
+		     (SMB2_LEASE_HANDLE_CACHING_LE |
+		      SMB2_LEASE_READ_CACHING_LE)) {
+			wake_up_oplock_break(opinfo);
+			return 1;
+		}
 	}
 	return 0;
 }
@@ -886,7 +896,6 @@ static int oplock_break(struct oplock_in
 		struct lease *lease = brk_opinfo->o_lease;
 
 		atomic_inc(&brk_opinfo->breaking_cnt);
-
 		err = oplock_break_pending(brk_opinfo, req_op_level);
 		if (err)
 			return err < 0 ? err : 0;


