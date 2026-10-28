Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207852;
	b=pF/wcS9eXKQ+NPIfbth107lfkvfibkw2LYnF9SohPS6jgs53ObaVL3EkNkmSj525Bi0X
	 vuRaL1G2c36CoATTHNjgC5XdGee8hr+GahHXB2TLxJi129dFORIYBxD/bc3lJ2grHHyhk
	 0dx/aa2cRumOURrbmpYi78uqLnDQ/d1bZce6+Rvp1rrG/2yowo2HpOJSsvrts+I2eMx4h
	 ySePIUtsmAYoazYlMl5+5N74NzdtS2bju0M7Vx3i5aqdhF5B1vh5rjLbIm6sFSUmbyb1u
	 SuAqE9pyAOFp38RRHy4FvQlua4OVBJEhAePc/XJ/E00RFUwDp42p5Vjoreu2VDfXevg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207852;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D/gwHeeZBKpxfKZuYui4TkzSl+2XfCJGUNXNSgw67UQ=;
	b=xov+gDsgxOvna1WLVqOPDu3rNCiVEOAU3cWIrLKNBVKF6HBNXVOW1uGJdjudgCLknrvQ
	 jgQScyBsT5br+6asss6bnMNTL/jCLdIo2bTNlGp1AxfTVh90Qz15kUxEJbp4WfuPQaCfn
	 Y/M33oq1TQ9YE/8S8QKDDAyLkzbbl+AvwpOuQexoWWM8Ee7Lh/GajWDlUOBRTq4p8PsGN
	 n0dhv4mHvtRLLlQnsPupbtswgbIYJb3ZfLsB/HXyicI2CZ1cvlUyISShfmF13u7zSw96N
	 6tjxO9spv/0peehnPTAe2s5azb3mw4zv/kNzQJvovaofXB5mRv/kWw4/JrxZKQmNBJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p0X7ihp6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E865606A320;
	Wed, 28 Oct 2026 17:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p0X7ihp6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB361F031E1;
	Wed, 28 Oct 2026 17:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207852;
	bh=D/gwHeeZBKpxfKZuYui4TkzSl+2XfCJGUNXNSgw67UQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p0X7ihp6fazjOm+P5M2WCUhqiylYq9yQgo/SuSEW12D/cypobdwK3fTkzlRAC4ogt
	 /xvjt+sqj/rmcQFPKxxQhVLD1VaskscuLNAB+M1X6xY5rd/JfQexJBSq+6/6WN97fd
	 l0GhZU+M6UkX60KqANjTRhpAOkJ+b6rlqQF8yayk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashutosh Desai <ashutoshdesai993@gmail.com>,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 161/247] ax25: fix OOB read after address header strip in ax25_rcv()
Date: Wed, 28 Oct 2026 17:59:24 +0100
Message-ID: <20261028165951.228834419@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashutosh Desai <ashutoshdesai993@gmail.com>

A crafted AX.25 frame with a valid address header but no control byte
causes skb->len to reach zero after skb_pull() strips the header.
The subsequent reads of skb->data[0] (control) and skb->data[1] (PID)
are then out of bounds.

Linearize the skb after confirming the device is an AX.25 interface.
Guard with skb->len < 1 after the pull - one byte suffices for LAPB
control frames which have no PID byte. Add a separate skb->len < 2
check inside the UI branch before accessing the PID byte.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Ashutosh Desai <ashutoshdesai993@gmail.com>
[F6BVP: v5 as posted on netdev; the author withdrew it only because the
subsystem was being removed from the kernel that day. Applied unchanged.]
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
(cherry picked from commit e653f27001ca2a31a445ee20d9f90be65b85d7e3)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/ax25_in.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/ax25/ax25_in.c b/net/ax25/ax25_in.c
index f2d66af863595..f105e638611fa 100644
--- a/net/ax25/ax25_in.c
+++ b/net/ax25/ax25_in.c
@@ -199,6 +199,9 @@ static int ax25_rcv(struct sk_buff *skb, struct net_device *dev,
 	if ((ax25_dev = ax25_dev_ax25dev(dev)) == NULL)
 		goto free;
 
+	if (skb_linearize(skb))
+		goto free;
+
 	/*
 	 *	Parse the address header.
 	 */
@@ -217,6 +220,9 @@ static int ax25_rcv(struct sk_buff *skb, struct net_device *dev,
 	 */
 	skb_pull(skb, ax25_addr_size(&dp));
 
+	if (skb->len < 1)
+		goto free;
+
 	/* For our port addresses ? */
 	if (ax25cmp(&dest, dev_addr) == 0 && dp.lastrepeat + 1 == dp.ndigi)
 		mine = 1;
@@ -227,6 +233,9 @@ static int ax25_rcv(struct sk_buff *skb, struct net_device *dev,
 
 	/* UI frame - bypass LAPB processing */
 	if ((*skb->data & ~0x10) == AX25_UI && dp.lastrepeat + 1 == dp.ndigi) {
+		if (skb->len < 2)
+			goto free;
+
 		skb_set_transport_header(skb, 2); /* skip control and pid */
 
 		ax25_send_to_raw(&dest, skb, skb->data[1]);
-- 
2.53.0



