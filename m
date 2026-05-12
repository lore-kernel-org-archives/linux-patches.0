Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC073C0A19;
	Tue, 12 May 2026 17:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608500; cv=none; b=YIcmygN62kbj5el6N67thWSuqYqifb9gwLystxDfhq2EwwddgKJIsAYO1OKy6spUSn4pwJ/rLIZuC0lsJez0btnAJbE64MfrGGPaT8XSn6TwC9BAsLEkeXxq7ap9aOoLeLAS96wLz+pChcMVCp95x5tW9iKMfwZBHZ/8YXYwHyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608500; c=relaxed/simple;
	bh=FeQoxhpa8KMUjcdmodSj86ygyM/AyIQvufcdDG6A9TA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cz30DVSRmIZx+xfv5RsLNx2ejbC+NDBjANhv+291BE+w+UY2GvBVDMpRVmKdWZn1CLDf/qUNEZXbwtHIsCfFqcMduFXLTnIuhRqD7WEJw0wy9o0ak536W+63R18xfE8jJkhCHuIKI55GSLsH4ihT2gqBswTK5j+bAkp0SJOCi8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aUK8ktK+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aUK8ktK+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796FEC2BCB0;
	Tue, 12 May 2026 17:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608499;
	bh=FeQoxhpa8KMUjcdmodSj86ygyM/AyIQvufcdDG6A9TA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aUK8ktK+cMO4fxgNWq10ab4kifykXfPwcD2Wi5le5ZIPj3EzYZW5+SvB3CgbMQzlm
	 Jv5wpCBq9H2iz4MS+cynqhW95pNHBGuu3e7pL6rgOsVB2PP4hV4xfj+bgrkX7v8/UI
	 07Wa1deLj9qysjo5v5kdjfeWFaPD5pAgdQl8SRW4=
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
Subject: [PATCH 6.18 103/270] net/rds: handle zerocopy send cleanup before the message is queued
Date: Tue, 12 May 2026 19:38:24 +0200
Message-ID: <20260512173940.626809338@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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
 


