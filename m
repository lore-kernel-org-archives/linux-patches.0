Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607BF32BF24;
	Sat, 30 May 2026 16:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160396; cv=none; b=DGGvOAnUMkuDwt7KcFjOu65Rq8y94jaPs7Awye9McUWncPca5i21sh24VfdqbMhFCf+4meRmB9vU9AH5AxcXeLryRPSULl1ymIFb0FLolzq6CF906EEPbvdF5EFpezLUquJATET0EV5PwRjyYPVhpid3lCKfloiCou/LnuFr3Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160396; c=relaxed/simple;
	bh=K5RtQNsVNOTbpnFi25FseJRa83iyb81q+oYzgCW5mNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OXlhFH3Gi+xNzOFIhlICUDtuyO36uDnOudduvuFPlJQbrvywDE8yPG6hAeLd5KYUhP3wSXP9EgQElKDjaq4soJbOtvyU5BQyFoOXlVK4tO6wyb8yhP8vn/h4uAOjvgY4PphrjBKu2odWwD1SLEVPuno3qkXcaJ/lCjLT+TQHPIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ulANT1tw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ulANT1tw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48391F00893;
	Sat, 30 May 2026 16:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160395;
	bh=xpwsqNTvP6T1xEi9tr6bq+gNC/DajKT6q1LoveJr1Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ulANT1twubWN4O91RbAPFO+FdYDKbJ+h5kLRM94/TQ8IqlSd7nTkNQLxmKPKjFtfe
	 FiBiABqN3jkHY3+nIgB5YT4pglG9qaDW5c2Qjf+F9QzTU+RAocoKy853OBiX4PypLg
	 yR5JyadstpDrETHrsyulX1/qsF5TmuEi/v+Nercc=
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
Subject: [PATCH 6.1 326/969] net/rds: handle zerocopy send cleanup before the message is queued
Date: Sat, 30 May 2026 17:57:30 +0200
Message-ID: <20260530160309.395827075@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


