Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FA63769F5;
	Thu, 30 Jul 2026 15:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424853; cv=none; b=ekLe3Fq4pq1MXW4Ex96RG/Bf3/3fBnxwrufnunSTxFuXbOp5WXXKXQdmjjC4Yyc8Kwod1b2ZBFqfmmsvumCkzMj7CitQzUvCjEYZMzDylWR5TNZO9nvIsPX8IxocyQ0tpNKJ3X+z6WFD6Yzis0XvSbB5fmWEM1mkcfdi3rMiND4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424853; c=relaxed/simple;
	bh=2fEsvxMlnpenUbz1bA1k0VFpknBRalyo8TjbxBd08jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G82a0qnW1u5a2X4V4ZIfbLPa/CN9nxrGNezBlKoyDLysau+U+iToJP1qjcj5/diridDUuF8tp1+bWqsaKcilldt4JXDQmiFlIptl/oUAkg+IAKY9tlB01uqU4cioZYKG3LpZJLG5jfQJXsLFpJBkv4f17UMEnImUZtOaCbmwCZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Le9fMmOr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Le9fMmOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1E61F000E9;
	Thu, 30 Jul 2026 15:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424851;
	bh=y725PXA2sxUkWRW9kEwLn3AlWpC7b8QhVw5Z6CkAeT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Le9fMmOrLfu+G27vmqlDnMfPUqFqKuZWeTMRr9ORSVgJYkboDYN6nhfSiqr6L5MRO
	 yF2i2HA6fLP3KxMO2U/DUsL0hcg+moGT+ANk0E46QE67wCsmcil671m3C8SGznT+Nq
	 r/IxZefr7D8kQggINt8qevAUm0ieDzvX3wtF4/hE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 538/675] net/iucv: fix use-after-free of a severed iucv_path
Date: Thu, 30 Jul 2026 16:14:28 +0200
Message-ID: <20260730141456.578788027@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit be7cc4656eb1f54029610e82d1f0fdd3f9b5ec0a upstream.

af_iucv queues not-yet-received message notifications on iucv->message_q,
each holding a raw pointer to the connection's iucv_path.  When the peer
severs the connection, iucv_sever_path() frees that path with
iucv_path_free() but leaves the notifications queued.  A later recvmsg()
drains message_q via iucv_process_message_q() and hands the stale path to
message_receive() -- a use-after-free of the freed iucv_path.

Drop the queued notifications when the path is severed; once the path is
gone they can no longer be received.  This also frees the notifications
leaked when a socket is closed with messages still queued.

Fixes: f0703c80e515 ("[AF_IUCV]: postpone receival of iucv-packets")
Closes: https://sashiko.dev/#/patchset/20260705-b4-disp-fc79c0dc-v1-1-d2cdcb57afa9@proton.me?part=1
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Link: https://patch.msgid.link/20260707-b4-disp-783fedbb-v1-1-463b9dbda2ea@proton.me
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/iucv/af_iucv.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -335,6 +335,7 @@ static void iucv_sever_path(struct sock
 	unsigned char user_data[16];
 	struct iucv_sock *iucv = iucv_sk(sk);
 	struct iucv_path *path = iucv->path;
+	struct sock_msg_q *p, *n;
 
 	/* Whoever resets the path pointer, must sever and free it. */
 	if (xchg(&iucv->path, NULL)) {
@@ -346,6 +347,19 @@ static void iucv_sever_path(struct sock
 		} else
 			pr_iucv->path_sever(path, NULL);
 		iucv_path_free(path);
+
+		/*
+		 * Message notifications queued on message_q still reference
+		 * the now freed path; drop them, otherwise a later recvmsg()
+		 * would pass the freed iucv_path to message_receive() via
+		 * iucv_process_message_q().
+		 */
+		spin_lock_bh(&iucv->message_q.lock);
+		list_for_each_entry_safe(p, n, &iucv->message_q.list, list) {
+			list_del(&p->list);
+			kfree(p);
+		}
+		spin_unlock_bh(&iucv->message_q.lock);
 	}
 }
 


