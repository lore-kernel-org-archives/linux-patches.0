Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4F843CED7;
	Mon, 17 Aug 2026 14:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975863; cv=none; b=rr5GISbXoEheYw3sgmhlbmnVp9ExiIQWqiKO7xPDtdcXotXmoSPTW6KGl6nLm50OtE5Yetk466/IcyuQjtVFVeXEJELU2Wdwr22WIk0HcQbrQ162OxxKdTde+7HJIWyKcNFm1z5uXpeqL/5xcG+KomiVufj0PMwrBhlSaipIs+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975863; c=relaxed/simple;
	bh=kkGhs3N85YCEVBdSdElQ3uls11kNIR7YkWo3k+8Vk7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+NATxi/DP7S4N+nOqtR+/TAVyxk+Oisa3LVVke7hqT7QMTHFTt1gY7VGew/VsuyQK+sF1lGz9rSDAF+0LH+4XbUlyTVfH44aEEIiEUMTASeAziinZJOaBpnV5e4tY8VKEu/P++bcSs0QjSq58ddDjHibaMi7k7aVeVizm1Jfqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EN6S1ESF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EN6S1ESF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E77F1F000E9;
	Mon, 17 Aug 2026 14:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975861;
	bh=2sj6D/LPLCH46v8u74vlFgUGWeYL94DUTHbIYxmV6Ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EN6S1ESFUWnz4dCiz+Fng1PiGuU6K4K9h32UrtIgAHtRi1q8xtavhGLljUsFWfkpK
	 miLR5kxq9mEnIfaUCNQLi8qy+mHoaqs7Vf7n1umSa8YmbPwu2QyowZbo4pnn0/M8ab
	 WDDoinvusZJ4wrxJNM+yt6iPkyVtC0hvpRVVEUAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 174/389] net/iucv: fix use-after-free of a severed iucv_path
Date: Mon, 17 Aug 2026 15:30:13 +0200
Message-ID: <20260817132545.961549037@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -358,6 +358,7 @@ static void iucv_sever_path(struct sock
 	unsigned char user_data[16];
 	struct iucv_sock *iucv = iucv_sk(sk);
 	struct iucv_path *path = iucv->path;
+	struct sock_msg_q *p, *n;
 
 	/* Whoever resets the path pointer, must sever and free it. */
 	if (xchg(&iucv->path, NULL)) {
@@ -369,6 +370,19 @@ static void iucv_sever_path(struct sock
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
 


