Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9560E377567;
	Tue, 12 May 2026 17:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608525; cv=none; b=Us0j1uNO69R6UxOP5AtbsvS9MNPV7OhenS3eyotJwO04yTPfD1uFVnAxInOQpnMskgU5tVwRTuMeYFlIzyIuXPYMdY8ge0GQtwiW6q2jgKllc4sMUvFaWYGPH2965jy0EToJsllCtrB+R8wk7biuE3K4W1SvLfsXRFu0OekXHLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608525; c=relaxed/simple;
	bh=UXEvyx67JSUImfBr8l6sHr6ay4bXhYQA/RuukhHcYtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UrUM3TBkfVbpuErcvkl2CLy4ufvs5Xdd0Vs9pm62aw0e/oAd5kRd+DWIv4TB8gSyALEERBUSvdaZkUE3thMqEtK3x8dmLo7xu0FWVWn952IVHzs64O0GTlIFneGaRga5FjC/9/cQ556Et8TywiPPbAfgYRiTnESLFOMbK8Zjzbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uJ2UNahq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uJ2UNahq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7ECC2BCB0;
	Tue, 12 May 2026 17:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608525;
	bh=UXEvyx67JSUImfBr8l6sHr6ay4bXhYQA/RuukhHcYtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uJ2UNahqlYYXM9QQL7JYM3xMz63aG45XkBrEIW2biGNVYyU6Xx+yAsS/8xFYe6gW0
	 +22yZpVrPqpRy2P1TnH8vRb0vQLm6QA6kp4YXJlU1MPZM36+ThaMKnjdmwAKzWR2zL
	 GwTEpYqWXmEveek8ilP2cLIkQNMjfCVONqmnSMZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jiexun Wang <wangjiexun2025@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 112/270] af_unix: Reject SIOCATMARK on non-stream sockets
Date: Tue, 12 May 2026 19:38:33 +0200
Message-ID: <20260512173940.817820724@linuxfoundation.org>
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

From: Jiexun Wang <wangjiexun2025@gmail.com>

commit d119775f2bad827edc28071c061fdd4a91f889a5 upstream.

SIOCATMARK reports whether the receive queue is at the urgent mark for
MSG_OOB.

In AF_UNIX, MSG_OOB is supported only for SOCK_STREAM sockets.
SOCK_DGRAM and SOCK_SEQPACKET reject MSG_OOB in sendmsg() and recvmsg(),
so they should not support SIOCATMARK either.

Return -EOPNOTSUPP for non-stream sockets before checking the receive
queue.

Fixes: 314001f0bf92 ("af_unix: Add OOB support")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Suggested-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Jiexun Wang <wangjiexun2025@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260506140825.2987635-1-n05ec@lzu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/unix/af_unix.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -3339,6 +3339,9 @@ static int unix_ioctl(struct socket *soc
 			struct sk_buff *skb;
 			int answ = 0;
 
+			if (sk->sk_type != SOCK_STREAM)
+				return -EOPNOTSUPP;
+
 			mutex_lock(&u->iolock);
 
 			skb = skb_peek(&sk->sk_receive_queue);


