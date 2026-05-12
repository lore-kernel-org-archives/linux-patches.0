Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62BB3EDE45;
	Tue, 12 May 2026 18:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609269; cv=none; b=K1sW3/6wI+aRAbn26FRh2Y/kODTpgXErdjTzv76u40CLJH8UhDemSi3Vm72u9dsRsqjHTlFjsF4J+s0DbxlflYF6IQTdMncPOLJt0WS9HcI/5BWY+wsKncrT3XEZAAopWm68X7GmcX0P17WKaB83fIVRYwmtEVEXBfDaIAgBNic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609269; c=relaxed/simple;
	bh=FLUJicywsWV9QDtRa6XSJD+q7OsOMAsid8z+iVcAYYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8HAtUWZdq4xlXiL31hibcRu2SORno6rcjhN/GAb6/tqh50CGmuEBTHOqLT2XT3clZRwyrZrD7Yx9lhjmfKincT4E4huVJb/Uh2hg7kEEuD4T/epkdT6jwfTU1pM9NUQOk5BRyoRwGdAs0JTNin+SDd/HwJ9OnmqkWZfmUV9iKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sEpK0F8O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sEpK0F8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231BFC2BCB0;
	Tue, 12 May 2026 18:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609269;
	bh=FLUJicywsWV9QDtRa6XSJD+q7OsOMAsid8z+iVcAYYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sEpK0F8OTHHelb2iSaAkDRNutKCfdI02c4+wfphiQxIKTEzBdW6iipBoPJhDBk8nd
	 SFiHWUKd2z1ZkYAWkydITzdhAfJGA2M+6UyG5b6IPQA6bWHI341MVdVknkBgbxKKfG
	 uB5il0zwdbP8pguweH9JSc9zQj3IIWJu+BStZCKs=
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
Subject: [PATCH 7.0 131/307] af_unix: Reject SIOCATMARK on non-stream sockets
Date: Tue, 12 May 2026 19:38:46 +0200
Message-ID: <20260512173942.892352066@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3300,6 +3300,9 @@ static int unix_ioctl(struct socket *soc
 			struct sk_buff *skb;
 			int answ = 0;
 
+			if (sk->sk_type != SOCK_STREAM)
+				return -EOPNOTSUPP;
+
 			mutex_lock(&u->iolock);
 
 			skb = skb_peek(&sk->sk_receive_queue);


