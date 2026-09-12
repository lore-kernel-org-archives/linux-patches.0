Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA4733939A;
	Sat, 12 Sep 2026 15:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226576; cv=none; b=oJfaH2MyNf9/NtqMeN96FE6K+n92GORkTrw+bZ2KYvOVRwWdzuhqB3+x2i7v7lvbMq/KiPPnF4jheSLMC3RGZ0olHxOhyERMcLWQ7uQvUy0hpK6lNWE+D4EqICwqcDAkgLMoKvXHW3bqgUa77gQYdcfyc2pUTr7X/FF1YwOsAIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226576; c=relaxed/simple;
	bh=/rFbs122q7Pm3HHZUHqBfQbbYIhZWgV4w8pYtZkDDW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bvfXDhMrgrCnfaJHIo16wd8QgUv0jLqbO05Kis9X624Itt+uS69gviDliU0aeS88R41k/mkyf8Pei8yvczYEKJn9uXyqXXLvwlWBb1qhXNMMDr3Nn7NYgWuBwlhuBYUB3fQQkQSWAqqs7XatpmfvBDhr8ttcojgAsg+aDdR8YX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mvv6dHfd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mvv6dHfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5461F000FF;
	Sat, 12 Sep 2026 15:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226574;
	bh=GcjKnoW7cu7D+/hBbsDzr3LkL3aIxmTsacK+C0J7kpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mvv6dHfd76OKKwmeBermEau1SMPFpZh/g6gKnBIAdp4tGO2O07a1rf7YhtHC6YZof
	 VglZwsy8QadhX4Kt4slbfCcHnnrS6oP6GFQgZAqVT++XnnhaWprvUJcfIYM1q2dNvN
	 NZ2bdHb9+Ec0QRuRFS+YbFMIyCfOBs4v5b0KimsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3d602af7549af539274e@syzkaller.appspotmail.com,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Lukasz Majewski <lukma@denx.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1417/1424] net: hsr: Use the seqnr lock for frames received via interlink port.
Date: Sat, 12 Sep 2026 09:04:09 +0200
Message-ID: <20260912065638.992747278@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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



