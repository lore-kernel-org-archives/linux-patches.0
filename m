Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BCF1D04BA;
	Wed,  2 Oct 2024 13:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877468; cv=none; b=az166GD/n6IzdACYMXrS4n0sedUNPq2f4S5TSEGoMnbQu0Uz/JEkdv9Zxyz9hFDyboDz2yMqUC/t8B8itoKoTS0nmzHcCcZ5wt0uT1zurqc+O9T4+/C9idcpHu2DdraV10WqxHmxC20Qa6YLdqic3HdhEkkloBg4zQqBs/SjgxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877468; c=relaxed/simple;
	bh=t09Nzovgu2SJBsdu/Ql0ZklBuEn5dF4F/jvIPsLqqBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T2xD7U7i1SR3Q2hXILUvDOqiZuzwjACvZFC647kzF07w4rvMa6ztFKPJB6ZQ/QeFRo2r8M4V5qXgZuQ61QjjwznF2KdEjmrY2Pb/c4cobFffOfD8ip9wOvOSL6PItfOq5GBGZt/9dB2Km8SUkYRAv00s4fblSWFxfxVvb6s4xMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zC6x4cW+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zC6x4cW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A8EC4AF19;
	Wed,  2 Oct 2024 13:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877468;
	bh=t09Nzovgu2SJBsdu/Ql0ZklBuEn5dF4F/jvIPsLqqBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zC6x4cW+yj13jOM1BP2gCgJCvtCrz0UD4PTWqwwSgZs/aP60p9zvKvCqcikboAu4f
	 cpdg8BCl9g/mOirVCD4FGUO2Ma7rECJaUGcbmi10B287fxABJNAN9joHBbIZqK0Z4w
	 dGGokYdXyWwjxmNOnceXZ5Crrv6qEhbqHmFNC8NU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3d602af7549af539274e@syzkaller.appspotmail.com,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Lukasz Majewski <lukma@denx.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 088/634] net: hsr: Use the seqnr lock for frames received via interlink port.
Date: Wed,  2 Oct 2024 14:53:08 +0200
Message-ID: <20241002125814.584618155@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index af6cf64a00e08..464f683e016db 100644
--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -67,7 +67,16 @@ static rx_handler_result_t hsr_handle_frame(struct sk_buff **pskb)
 		skb_set_network_header(skb, ETH_HLEN + HSR_HLEN);
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
2.43.0



