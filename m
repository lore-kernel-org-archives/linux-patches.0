Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA682FDC5E;
	Sat, 30 May 2026 18:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165978; cv=none; b=a4YXZnHdLYDrZRxJy/iE0FhMdIbIntnpSOhF40PBZISv+V5jR7qn4z8fgU7S2Q6udfVuQWuXTuQuooZUu06Mtx8rrXOb0XP/ogMZNNS4jII+rgQMH/GtC9Pw07BhHLYquMuzOI+P6xkBz6Cz+tci7PBtLbnNlmiskZP6L9MQvvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165978; c=relaxed/simple;
	bh=KJSBItJ51c7sRbsUs8G4S7WUKRqYANqReEySzfi5Sto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kT/P/Z69ew4zjt136Sf8k1YfqLw39gvUlUnZ/whM7JkQe4MuuYnEHDSnPGdUldn8G4mpWCdIYcxxHoLkwdd3fhq4fE47vQEMZcaJ4kfQzhKjxeQxkJyIsBu85EY1xj92ZPb/zxtWTi2TpiYfrLyyzneUR3TpUGvNVT9O6w9yxQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MrtImTXw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MrtImTXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 745F61F00893;
	Sat, 30 May 2026 18:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165977;
	bh=e4xIu/zbXXVfNKuLIYm2LgN0Wo93WZXHCayqOgcztcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MrtImTXwLJv2f4V0Jrw7ygbRZJpjWJffr5lcWax8pJPyj1ndvP108xugqqQ9ljKL9
	 iCVAeK1skhwlHOGRKLVYlwgV3b3uPkSW1qB49WyQbh6sdaEOr6/Zh+ROxF3E8OhfKo
	 8RJa8tRscVJSHkfA11de3VjipntNGLdPw40LRH2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Xiao Liu <lx24@stu.ynu.edu.cn>,
	Nan Li <tonanli66@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Allison Henderson <achender@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 237/589] net/rds: handle zerocopy send cleanup before the message is queued
Date: Sat, 30 May 2026 18:01:58 +0200
Message-ID: <20260530160231.226236835@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

From: Nan Li <tonanli66@gmail.com>

commit 44b550d88b267320459d518c0743a241ab2108fa upstream.

A zerocopy send can fail after user pages have been pinned but before
the message is attached to the sending socket.

The purge path currently infers zerocopy state from rm->m_rs, so an
unqueued message can be cleaned up as if it owned normal payload pages.
However, zerocopy ownership is really determined by the presence of
op_mmp_znotifier, regardless of whether the message has reached the
socket queue.

Capture op_mmp_znotifier up front in rds_message_purge() and use it as
the cleanup discriminator. If the message is already associated with a
socket, keep the existing completion path. Otherwise, drop the pinned
page accounting directly and release the notifier before putting the
payload pages.

This keeps early send failure cleanup consistent with the zerocopy
lifetime rules without changing the normal queued completion path.

Fixes: 0cebaccef3ac ("rds: zerocopy Tx support.")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Co-developed-by: Xiao Liu <lx24@stu.ynu.edu.cn>
Signed-off-by: Xiao Liu <lx24@stu.ynu.edu.cn>
Signed-off-by: Nan Li <tonanli66@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/d2ea98a6313d5467bac00f7c9fef8c7acddb9258.1777550074.git.tonanli66@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rds/message.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -129,24 +129,34 @@ static void rds_rm_zerocopy_callback(str
  */
 static void rds_message_purge(struct rds_message *rm)
 {
+	struct rds_znotifier *znotifier;
 	unsigned long i, flags;
-	bool zcopy = false;
+	bool zcopy;
 
 	if (unlikely(test_bit(RDS_MSG_PAGEVEC, &rm->m_flags)))
 		return;
 
 	spin_lock_irqsave(&rm->m_rs_lock, flags);
+	znotifier = rm->data.op_mmp_znotifier;
+	rm->data.op_mmp_znotifier = NULL;
+	zcopy = !!znotifier;
+
 	if (rm->m_rs) {
 		struct rds_sock *rs = rm->m_rs;
 
-		if (rm->data.op_mmp_znotifier) {
-			zcopy = true;
-			rds_rm_zerocopy_callback(rs, rm->data.op_mmp_znotifier);
+		if (znotifier) {
+			rds_rm_zerocopy_callback(rs, znotifier);
 			rds_wake_sk_sleep(rs);
-			rm->data.op_mmp_znotifier = NULL;
 		}
 		sock_put(rds_rs_to_sk(rs));
 		rm->m_rs = NULL;
+	} else if (znotifier) {
+		/*
+		 * Zerocopy can fail before the message is queued on the
+		 * socket, so there is no rs to carry the notification.
+		 */
+		mm_unaccount_pinned_pages(&znotifier->z_mmp);
+		kfree(rds_info_from_znotifier(znotifier));
 	}
 	spin_unlock_irqrestore(&rm->m_rs_lock, flags);
 


