Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27928F4F1;
	Sat, 12 Sep 2026 16:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231930; cv=none; b=hfe8wwqZKb8FRSMl/BiQJ5jx/n39PTL9ZBjhU3MNvmQO6Py0y2xsiKW2ypYg4JyYssJPY8mH3Zcr9n8y3x2MHfTVoOwO6PxWYwYJhfxfes7I0Qop4is0ZDoMGgsPc18TYddu14hyIWHfwGJh3kYJTxjf24lOP0Aah7rSjj8X1GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231930; c=relaxed/simple;
	bh=o4lRnE16KG7R0Kex9I+ncUJ9YRxyhRlQIe49sibxVQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UPP1kH28v0wqakImtAdjcX+QKVxhBqtA+XKi8lDwlbuzbA/+qPb/MEe+QxgRkuDRYZgxc1J5VMJv2mTPLdk6QTZkMelwZE1CXCG/VkSddi0lv6Umd22N1b4kYcEzedFYr0vS8YrF7WWFIfOg+YNr2mjfPFXpqZ0slBG5n5vQyJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EOy5t/Hv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EOy5t/Hv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7E01F000FF;
	Sat, 12 Sep 2026 16:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231929;
	bh=4cZp9qYeOjvAYstFRcBCmVON4BxqjykMlw4IAzvYe2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EOy5t/Hv2YBBspPil0PjgJrfxcUDkDiBAd5oYq86NwZgYXpTF5muedfhagfTwkIK6
	 4ftAqadpHVf78jfvdVc4BkntlfEk0USEUb84Mq2jEFAlTh+40f+RcxX1BrF+UlfAfd
	 aZdobl7r1ipysNjEJnH4slLjqRqa51wTvc6c0HJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1097/1191] Bluetooth: RFCOMM: Validate MTU in rfcomm_apply_pn() to prevent infinite loop
Date: Sat, 12 Sep 2026 09:03:45 +0200
Message-ID: <20260912065612.799503228@linuxfoundation.org>
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

From: Hyunwoo Kim <imv4bel@gmail.com>

[ Upstream commit 44c98fd082eafd49d55a8a4077ff488175b2fe24 ]

rfcomm_apply_pn() accepts the MTU value from a remote PN (Parameter
Negotiation) frame without checking for zero. When the remote peer
sends an MTU of zero, d->mtu is set to 0. This causes the sendmsg
path to enter an infinite loop when fragmenting data, as each fragment
has size == min_t(size_t, len, 0) == 0, so the remaining length never
decreases. The infinite allocation of zero-length skbs exhausts all
system memory.

Fix by clamping d->mtu to RFCOMM_DEFAULT_MTU when the negotiated
value is zero, consistent with the initial value assigned in
rfcomm_dlc_alloc().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/rfcomm/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index 349f62a18190e..2914ac1c50024 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -1454,6 +1454,10 @@ static int rfcomm_apply_pn(struct rfcomm_dlc *d, int cr, struct rfcomm_pn *pn)
 
 	d->mtu = __le16_to_cpu(pn->mtu);
 
+	/* MTU 0 causes an infinite loop when fragmenting in sendmsg */
+	if (!d->mtu)
+		d->mtu = RFCOMM_DEFAULT_MTU;
+
 	if (cr && d->mtu > s->mtu)
 		d->mtu = s->mtu;
 
-- 
2.53.0



