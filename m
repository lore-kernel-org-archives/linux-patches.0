Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F20A318EC1;
	Thu,  2 Jul 2026 16:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010751; cv=none; b=F/B/XrFFyJp7zzT4Qphr68lY9uF+0K2K9hcgshpG2oN/YRxZIIqQVRxrGCLf5b+PeWdqX3ZHor+FuBsqEY7JVUtoYN0AUPiFayTVTcg1gb1MT0WV+IggspvmpZptSPd17lPC21xtyRA31B+gt+SE2Kv87/fybX3O6EBawsKI7DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010751; c=relaxed/simple;
	bh=rk0zJn8lP3Siv2qXzGKuM3KIpt7KVX27GeaN5GqMngM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ge+Pi4b5JfWhlFG7I85s/dSPpuFZZEvp0GYo47eW1w9GW61qUhOFD0iStgYc5dOyVob4W8ZVy8vZ7Vu63oezT4B3wYACPBd+fcqh3kS6/5RrdRJAW9/tEO38/M3f6diqY5j0mwe4dG5HNTg34JoGhO6EwmlCM/qa6xcgjCtwAQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oVTXLo8U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oVTXLo8U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074051F00A3A;
	Thu,  2 Jul 2026 16:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010750;
	bh=JR5ZrQ9j8B5WSqN4XlnEYZKcJOT29BOCgyOcf+DrD9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oVTXLo8UuQwTvJP+0jqkGJw4H9E3W/TM+eVvEE6QaaTvan69sXN+llxgNIGcpg2s6
	 RgiVhjea7feuUdYJ3+9eQokrzxqWpw164ii34qhB7Cx7NoRSf7f/9hzJl1GSvhWt7J
	 Y+EzyzYsGQUtOhXRZ869omlw6rbZ1SIsl6/zeGNg=
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
	Jakub Kicinski <kuba@kernel.org>,
	Alexander Martyniuk <alexevgmart@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/175] af_unix: Reject SIOCATMARK on non-stream sockets
Date: Thu,  2 Jul 2026 18:18:44 +0200
Message-ID: <20260702155116.273831200@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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
Signed-off-by: Alexander Martyniuk <alexevgmart@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 32892a40d139c2..8bd78cad69e7c5 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -3139,6 +3139,9 @@ static int unix_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 			struct sk_buff *skb;
 			int answ = 0;
 
+			if (sk->sk_type != SOCK_STREAM)
+				return -EOPNOTSUPP;
+
 			skb = skb_peek(&sk->sk_receive_queue);
 			if (skb && skb == READ_ONCE(unix_sk(sk)->oob_skb))
 				answ = 1;
-- 
2.53.0



