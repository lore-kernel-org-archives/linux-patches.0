Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB23923A562;
	Sat, 12 Sep 2026 16:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232349; cv=none; b=AJitAKYIzOzYigbbWXmJew1X4nPhj9OxyePqd1folAzFoUvHJ9eXXkgmjNDoaWla5YdHRZjtDfokyrQl2A6cY9tc3ZEgOYb/rn6eFG0A95MS7LWisSSqKoaW5/SGp8HUHyiyw/e6GA88Nwbp5EUniQs+Rop9Wdif0NCsgrQU8ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232349; c=relaxed/simple;
	bh=7igSa8uNBgUtvqVZ4QxnAUAblOGwTcaxh5ZVTOyrF40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bFiTbJkKZcD/k0hdc/gGiUSsKNVY2KrxU30vYz3oe1yGnOo9xox+nGUfbfmpL9vQvRv2fOB6TLjPYChcKakWNmrkqH4UEFrf1T2Ze+9PnVsVGFcJ71EptL6Mw6cYolZf8IeAvNBwzswYQd7gHO91pYDZXaUR5q4SR3C98iNlEj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=POjn+bTh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="POjn+bTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4331F000FF;
	Sat, 12 Sep 2026 16:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232348;
	bh=E+733aHMF5T4TghrZGHrIM1T5FJ5KbkGxhL4Ts8KnNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=POjn+bTh+8hgkmTduvC4ce2Fn0K1xQRhDh5vldWtStSkS0goF/ECOIFUi1GjGY172
	 EFvc6Uuy5qKnaEI40rAAMUSuoXWLwANnwpe5wDH/8jfxXOPQoNtKxE/eDkw8qz01yQ
	 uuAJxhquVb0YD1ebqiFCMqkizmaz5lT6g/YpcwJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3d602af7549af539274e@syzkaller.appspotmail.com,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Lukasz Majewski <lukma@denx.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1183/1191] net: hsr: Use the seqnr lock for frames received via interlink port.
Date: Sat, 12 Sep 2026 09:05:11 +0200
Message-ID: <20260912065614.707934996@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 430d67bdcb04ee8502c2b10dcbaced4253649189 ]

syzbot reported that the seqnr_lock is not acquire for frames received
over the interlink port. In the interlink case a new seqnr is generated
and assigned to the frame.
Frames, which are received over the slave port have already a sequence
number assigned so the lock is not required.

Acquire the hsr_priv::seqnr_lock during in the invocation of
hsr_forward_skb() if a packet has been received from the interlink port.

Reported-by: syzbot+3d602af7549af539274e@syzkaller.appspotmail.com
Closes: https://groups.google.com/g/syzkaller-bugs/c/KppVvGviGg4/m/EItSdCZdBAAJ
Fixes: 5055cccfc2d1c ("net: hsr: Provide RedBox support (HSR-SAN)")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Lukasz Majewski <lukma@denx.de>
Tested-by: Lukasz Majewski <lukma@denx.de>
Link: https://patch.msgid.link/20240906132816.657485-2-bigeasy@linutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_slave.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
index 8c6694245b282..75566a1fbd768 100644
--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -73,7 +73,16 @@ static rx_handler_result_t hsr_handle_frame(struct sk_buff **pskb)
 	}
 	skb_reset_mac_len(skb);
 
-	hsr_forward_skb(skb, port);
+	/* Only the frames received over the interlink port will assign a
+	 * sequence number and require synchronisation vs other sender.
+	 */
+	if (port->type == HSR_PT_INTERLINK) {
+		spin_lock_bh(&hsr->seqnr_lock);
+		hsr_forward_skb(skb, port);
+		spin_unlock_bh(&hsr->seqnr_lock);
+	} else {
+		hsr_forward_skb(skb, port);
+	}
 
 finish_consume:
 	return RX_HANDLER_CONSUMED;
-- 
2.53.0



