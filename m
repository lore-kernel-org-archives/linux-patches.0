Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C418437A85D;
	Thu, 30 Jul 2026 15:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426421; cv=none; b=U+Ydu377xKyrOqacqNPueOtlDQE1qNdzCcXI1/zscNbvOtOChPjLPfhtOD8ETXQvkFfGKBF52OpB/QwZypA8UQYZLD+af1Ayop6h+voLf5nbK2VOIOgACDHRSlVCDSjPxCR6vhPPAW4t6k+AUCtwlfaNFwlDZkQhuP4JR/d60ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426421; c=relaxed/simple;
	bh=Lp111esMV7AXFElaUGZ3Je+J+Eo882goBA+QbwOcyYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MjPHXjzSCb2IyXkUmXweHrTU8EOwn9Gi+qPLQE/CH9XP9FQv3Z9aJ+1mKLiI9bod4nbcv7ajcaPfv5HS1/prTyR5BugzWq0HIUNcgeS0nHj+Mn6GoVR1HNOsJuXIMnu03pyt0ZB8PL9TibEHVPTnTMrI3ZrPy5uKEFTrrYZzMUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ue5K2xTj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ue5K2xTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2431F000E9;
	Thu, 30 Jul 2026 15:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426419;
	bh=waZII385yPDLyxbqr4t4M5iyauDw573s/YgVeQJYXz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ue5K2xTj5ItMcHpFT9MKOq1IAtmif5ihJ/4FcPssxLJG/68ZJuePX/5tupN2y300X
	 5G+aNyRF03QyClGL9T0C4tpiWa4xNLlmmFnF1mz6yOc4vQD8kOTAY0P996+/xMEP0g
	 +fenC2tZ8H9OsUL4pjU9W4C47UyOpuFkJrjeLdy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 412/602] net/iucv: fix use-after-free of a severed iucv_path
Date: Thu, 30 Jul 2026 16:13:24 +0200
Message-ID: <20260730141444.622631808@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
@@ -334,6 +334,7 @@ static void iucv_sever_path(struct sock
 	unsigned char user_data[16];
 	struct iucv_sock *iucv = iucv_sk(sk);
 	struct iucv_path *path = iucv->path;
+	struct sock_msg_q *p, *n;
 
 	/* Whoever resets the path pointer, must sever and free it. */
 	if (xchg(&iucv->path, NULL)) {
@@ -345,6 +346,19 @@ static void iucv_sever_path(struct sock
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
 


