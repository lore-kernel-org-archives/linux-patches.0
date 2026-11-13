Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590085;
	b=l+KUK8WCjG/aeeygbH3+1dyW5b6FOKk7S0wDLcCMD3jOFsRY/Yjw/MFXpwWSevwtW1NY
	 BLLlF3BFnPOKFxsP3n4ULT8ermmG8Wp0T7LvJPoq9z8q5KKhOGXN2/kcxUqkgImgDBe/D
	 PozGxevz/U0LdqXEJHC2QNPY6ZjUq1488CcECQ4/nLrvYw25FiyM9fi2TKu+OV3jpTZCL
	 g1txXzvncIf9oSnPFu5mDL8kZJUWgwwGPay/MHnfft5NArJFgQe2iFmu1vZu91uwjm2c1
	 rLTfg7cVq8jyKQAhyD1bMbcY8AuVUIRSGIkLbzXROYG2QxAEN/ylrOgc40khtspT4Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590085;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wIacNmAKvVsCqGOPmfD0f8IdGNI1xJTgG46rOlof1vo=;
	b=3cdcVRnh1c4jvxbKBfR9+DMpN2IQJrZ+kaGxZECAzNG/25j0vzoQP7jFgbHxrBByAnhx
	 Tpv0qwVuezd5INwsJ79OH/7HviON3+QqNsJ3G0FVTUdiWzo9lis97ZWfsgFXZJJEUKhZG
	 2z4WEvlFYHQb6NbaSGMhSHA4xeozj1KCIDw0AI6xpMhKyfHEDu2kHN+WriX8NS103OOrW
	 Ko5TEfmoCSYj9EBkQZoGYz+AdoRmw+O14bFXPx/IoF7vKr1VY/0tuKBrewy8IdxNbkLzN
	 6/bJi5oWML0dWnrGKxK/NUP/cm6jczyq32kRDwGHjkxsJIg9MMNcYkazUWl/Hojobgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="W2T1aa/G";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9352606A8BF;
	Fri, 13 Nov 2026 17:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W2T1aa/G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854641F000C5;
	Fri, 13 Nov 2026 17:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590085;
	bh=wIacNmAKvVsCqGOPmfD0f8IdGNI1xJTgG46rOlof1vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W2T1aa/GS+qthR5HPUfXMHisF4PmHbGOmycBO+nlGdCWey47jjwXH0MQbymad3V9V
	 rWUHjKbKePlUNBLLG9A04iamFhatR1jHj2DKfr2FkfJiEH4D5wVIcgAIzPHa55s6q1
	 s14QDYxEZWf6ffyqbWfAhb+MfamCR+R7Cs2Nfvak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 113/686] mkiss: restart the transmit queue when the interface is opened
Date: Fri, 13 Nov 2026 10:44:06 -0500
Message-ID: <20261113153824.673597337@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

ax_close() stops the transmit queue, but ax_open_dev() never starts it
again, and the core does not do it either. After "ip link set ax0 down"
followed by "ip link set ax0 up" the queue stays stopped: the qdisc
never calls ax_xmit() any more, so the 20 s transmit timeout recovery
in ax_xmit() is never reached, and mkiss_write_wakeup() cannot wake the
queue because ax_close() cleared TTY_DO_WRITE_WAKEUP. The interface is
up but does not transmit a single frame until the line discipline is
detached and attached again.

Start the queue in ax_open_dev(), as network drivers do in ndo_open.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 76c8761457861c18de2d32607e5c7b19c49326ca)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/mkiss.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/hamradio/mkiss.c b/drivers/net/hamradio/mkiss.c
index f11019d155764..8b0e2ca5d0ea3 100644
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -589,6 +589,11 @@ static int ax_open_dev(struct net_device *dev)
 	if (ax->tty == NULL)
 		return -ENODEV;
 
+	/* ax_close() stopped the queue: restart it, or the interface
+	 * never transmits again after it is set down and up.
+	 */
+	netif_start_queue(dev);
+
 	return 0;
 }
 
-- 
2.53.0



