Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721E31AC450;
	Thu, 15 Aug 2024 14:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730937; cv=none; b=ch3wkS6PWy4DHpZzbVpzQfsEAI2dz2BbCzndRbugRK/euf4q7y+HYIwENORBfPTjq3DhrZNhPnyuSb7zy0cgWTbDTVjvO+FvWpYtHgY+rwpTaWSXVYGn23hpkCaoHCxfXtztE5FczdBdtUOLr/yRLK27wxASl3vKGFBlfVtUiaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730937; c=relaxed/simple;
	bh=XcZ3SPA6wpIWfqLmk+ErnO3OHLfhzQb0jLkOT468GHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IrbWclQRmZJdRvhR4yZrfIXshHMY/Sc/y1HdVXkvg5wvHUHytoWBcx4W//aWn5S6mSXblmVYB/kGMkhikYbNiy9IXdkJogZvOpbKPEB/55Aj6bTFvHAeSkjQ4mCHo5Aov/jAKL1n85Jg1cU3W76YoGOShhSTVdQuMd2sOAzG2jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6/CRC7p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6/CRC7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CA5C32786;
	Thu, 15 Aug 2024 14:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730937;
	bh=XcZ3SPA6wpIWfqLmk+ErnO3OHLfhzQb0jLkOT468GHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g6/CRC7p4Xz/oKySxhaPeM4PzYDSeluBKDDimhmObadtkI9uaExzgzH5L4QwLYp6M
	 WF2cJP6LRB9fd+SK+MjNlgjwyMWeWmldpA/W6a3GbThBDWWHoP/aT4gT+TPjk6peKR
	 MZG42hpuCgW3MBoDLF9c7XxDTtCdFTg3gFTmrXgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6bdfd184eac7709e5cc9@syzkaller.appspotmail.com,
	Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>,
	Guillaume Nault <gnault@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 39/67] pppoe: Fix memory leak in pppoe_sendmsg()
Date: Thu, 15 Aug 2024 15:25:53 +0200
Message-ID: <20240815131839.819941430@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>

[ Upstream commit dc34ebd5c018b0edf47f39d11083ad8312733034 ]

syzbot reports a memory leak in pppoe_sendmsg [1].

The problem is in the pppoe_recvmsg() function that handles errors
in the wrong order. For the skb_recv_datagram() function, check
the pointer to skb for NULL first, and then check the 'error' variable,
because the skb_recv_datagram() function can set 'error'
to -EAGAIN in a loop but return a correct pointer to socket buffer
after a number of attempts, though 'error' remains set to -EAGAIN.

skb_recv_datagram
      __skb_recv_datagram          // Loop. if (err == -EAGAIN) then
                                   // go to the next loop iteration
          __skb_try_recv_datagram  // if (skb != NULL) then return 'skb'
                                   // else if a signal is received then
                                   // return -EAGAIN

Found by InfoTeCS on behalf of Linux Verification Center
(linuxtesting.org) with Syzkaller.

Link: https://syzkaller.appspot.com/bug?extid=6bdfd184eac7709e5cc9 [1]

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+6bdfd184eac7709e5cc9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6bdfd184eac7709e5cc9
Signed-off-by: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Link: https://lore.kernel.org/r/20240214085814.3894917-1-Ilia.Gavrilov@infotecs.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/pppoe.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index ba8b6bd8233ca..96cca4ee470a4 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -1007,26 +1007,21 @@ static int pppoe_recvmsg(struct socket *sock, struct msghdr *m,
 	struct sk_buff *skb;
 	int error = 0;
 
-	if (sk->sk_state & PPPOX_BOUND) {
-		error = -EIO;
-		goto end;
-	}
+	if (sk->sk_state & PPPOX_BOUND)
+		return -EIO;
 
 	skb = skb_recv_datagram(sk, flags, &error);
-	if (error < 0)
-		goto end;
+	if (!skb)
+		return error;
 
-	if (skb) {
-		total_len = min_t(size_t, total_len, skb->len);
-		error = skb_copy_datagram_msg(skb, 0, m, total_len);
-		if (error == 0) {
-			consume_skb(skb);
-			return total_len;
-		}
+	total_len = min_t(size_t, total_len, skb->len);
+	error = skb_copy_datagram_msg(skb, 0, m, total_len);
+	if (error == 0) {
+		consume_skb(skb);
+		return total_len;
 	}
 
 	kfree_skb(skb);
-end:
 	return error;
 }
 
-- 
2.43.0



