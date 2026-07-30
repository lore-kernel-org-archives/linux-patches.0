Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66EEE3955D7;
	Thu, 30 Jul 2026 16:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428020; cv=none; b=VccmmUTtWryl8dJl/VyzQUUQci/RS/d80ze++B1uUqPPnkJ4+HrX4ovHL+85JnVGymaOWgDortxMmNp/Z1mwzIdv1GmPUzCQmNU9odM5Hc3IGg5TJItYl9nkd1IMFdgq8qqZVi34qHlwgD+gOUVz5FYg/nX53/0ryPro9a9nb44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428020; c=relaxed/simple;
	bh=ETaXGPOvDiPHV6Ho4F8xHvgK1kcDnCQk3iF/jQcELto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujlSZxSlatXPIJHyJDzsTPvIVyH21/hu7IvL4jU9I2OcRXsv91deAK++lvWoXrSh8ObYZoTW12ApOai5hWre2SLRDE8A9iP8soskLbtEhYjqR556CJ9HF91dOx1O3z42MniihLDdXhvyAmUHC9b9Na/VZJm9/2y1mO8FB0ExNJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZADWo54s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZADWo54s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A521F000E9;
	Thu, 30 Jul 2026 16:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428019;
	bh=Y2cQSMSgopcaw8AwetPcbFIYTBLfr8FmHYqD7PLvGS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZADWo54sMI51EwakUBc1hAUSe4t+PlTyveBdG64p28FPl64lVFNSbr8Jnmf0NzzJ4
	 8banB8DDFa0+tHKpyZhTr/QINHSSCSIy8/GJe1+cPZD2QNV86EhX5hufpQ4jp9g87P
	 jduh5g2+eRCjJxSVVo6BG7bqe2eWxYwwt0OmSjFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 321/484] net/iucv: fix use-after-free of a severed iucv_path
Date: Thu, 30 Jul 2026 16:13:38 +0200
Message-ID: <20260730141430.459810076@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
 


