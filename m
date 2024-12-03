Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02831EF0AE;
	Tue,  3 Dec 2024 15:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239349; cv=none; b=rKFl8UjU4LKG92tWZe+8g7Byg0zd+J2J0vw5/gCnL1RMu5DJurzlDclmVdmPWep9zxhTuSrT4uHTuNm2hZ65Jd1dUSqZlcMVEKr3tcAB5DMkFneiIhtveRb7Vl3/0A0LhjFmvG3jh8FOpYy/o/U1lK8izYjh80BxSH8SFvu/xhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239349; c=relaxed/simple;
	bh=8SUbUUaam3sYXQwZNnDLoC2h9BMxZQa0pYZtU8jNKfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iVun1O4XjQXh7b9LKqWWifZ06ApQu448L4vaDMS7Cw0eb3dcraTOh6Td3XpTJ11va5bL+jfszqdOvxKz03+2jXAUyG3DH1ApR/Dl+SUcefT27flZOe64VklQgIfcFc/hMbZjDhIv6JBwZO1FhpfP2e0qGz2vwvtQU8qq4Liyqu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=to+/ef3N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="to+/ef3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258D5C4CECF;
	Tue,  3 Dec 2024 15:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239349;
	bh=8SUbUUaam3sYXQwZNnDLoC2h9BMxZQa0pYZtU8jNKfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=to+/ef3Nw5B+MXOMwnvJwYgeriyV1u7Sg4KoC6QqIAIbvol1So6XfSFGHjpc6NcBv
	 khQPqCkBxnoCCUr78qVep2gI/vSd6v3zmEGwJelse9oCEIUvdkJZJLZgKUMKgVY/UO
	 NvcgsMz6TtEZKPs5MpWNz0N4IFbJUU3u8Xfw4gGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	George McCollister <george.mccollister@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 584/817] net: hsr: fix hsr_init_sk() vs network/transport headers.
Date: Tue,  3 Dec 2024 15:42:36 +0100
Message-ID: <20241203144018.717185279@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9cfb5e7f0ded2bfaabc270ceb5f91d13f0e805b9 ]

Following sequence in hsr_init_sk() is invalid :

    skb_reset_mac_header(skb);
    skb_reset_mac_len(skb);
    skb_reset_network_header(skb);
    skb_reset_transport_header(skb);

It is invalid because skb_reset_mac_len() needs the correct
network header, which should be after the mac header.

This patch moves the skb_reset_network_header()
and skb_reset_transport_header() before
the call to dev_hard_header().

As a result skb->mac_len is no longer set to a value
close to 65535.

Fixes: 48b491a5cc74 ("net: hsr: fix mac_len checks")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: George McCollister <george.mccollister@gmail.com>
Link: https://patch.msgid.link/20241122171343.897551-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 049e22bdaafb7..1f40259597bc0 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -266,6 +266,8 @@ static struct sk_buff *hsr_init_skb(struct hsr_port *master)
 	skb->dev = master->dev;
 	skb->priority = TC_PRIO_CONTROL;
 
+	skb_reset_network_header(skb);
+	skb_reset_transport_header(skb);
 	if (dev_hard_header(skb, skb->dev, ETH_P_PRP,
 			    hsr->sup_multicast_addr,
 			    skb->dev->dev_addr, skb->len) <= 0)
@@ -273,8 +275,6 @@ static struct sk_buff *hsr_init_skb(struct hsr_port *master)
 
 	skb_reset_mac_header(skb);
 	skb_reset_mac_len(skb);
-	skb_reset_network_header(skb);
-	skb_reset_transport_header(skb);
 
 	return skb;
 out:
-- 
2.43.0



