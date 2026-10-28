Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215131;
	b=kLETiT0nyASMvGqHj65Va61egVCut6RvTwBjXbCds7Z/77ykspv4FsLpK0D61nFRNNU6
	 ZFJNV1uz8AvKYJhDMJwQ9TftBIPgmwwMO9vG3VVVBlGvwpv+O3SEckzzuQtfaluB9+6PL
	 BkMtjFcFE/Dx5Yz7XVSWw9aiz538MvB6OyL+dy6S/n9uZHyUY/V4u2EU4ElS7o+61HE5A
	 pD6cwAZszd1IcMQcprCpTpZJoEMU5csyJ3XD3ZU+1MWsoKAAXGTBaf9F4pa4UTIwV1FPl
	 3WxMfd5TX9Hh6xzcs5NifbUPdvxaCCJv+nJFCGVQ0WzDMfVJjDKY0BPMPrDl0/qn8Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215131;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9I9yyyDHlRRUjdccvh7vCLWCaBqmjmTUtHxjTRGWZTI=;
	b=VmP21+WpnzuP9gcJEBc1C0HzE4Kb/TWEEaZc1rumDEitGUPCh3+jVvozvpjBtc95jFCj
	 efg4uklK410Itttp0qCBKCWB3ao1ZGIlyL1cFaw7m11T8L/xbfusISx59N6YZo8/rsYU3
	 /JLuYSRmIME8kASfwt09x3IH7a/h+XxB/6sP1K1Huz+IeGjxy2ntyIO/uzqHjU9oyOyyd
	 LAUjkQfxGn7JQTLwEy9ICPd2wR2863alWBIfNYwOZCJyrynWcXSbPl2MJceg2qH9W7pYT
	 XLZN3vdjyCJnzKBoPhFdhA0F0KqS+V7eBHTyapA+8IRONHzM7brOlqVsoNS/2hTBWng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zUKDrgIa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C007B606A324;
	Wed, 28 Oct 2026 19:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zUKDrgIa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC761F01829;
	Wed, 28 Oct 2026 19:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215130;
	bh=9I9yyyDHlRRUjdccvh7vCLWCaBqmjmTUtHxjTRGWZTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zUKDrgIaOq7pGZPTxGtmr27qpNBnlWb4LlE/6aAWImMPAuJMXfs8sBDVczDxTqsHG
	 hB7jIc6Rnn12n07hhtU2z5AB50vSvg48y0UHY0woREarZFwTxya8u/dVUUfDXnF6Zh
	 uilxdAo59qUC97MAwPs6iiECfWrladO8a/xwC0zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1104/1887] net: mana: Guard mana_remove against double invocation
Date: Wed, 28 Oct 2026 17:53:20 +0100
Message-ID: <20261028170524.528883263@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erni Sri Satya Vennela <ernis@linux.microsoft.com>

[ Upstream commit 50271d7ec95144d26808025b508f463780517d3c ]

If PM resume fails (e.g., mana_attach() returns an error), mana_probe()
calls mana_remove(), which tears down the device and sets
gd->gdma_context = NULL and gd->driver_data = NULL.

However, a failed resume callback does not automatically unbind the
driver. When the device is eventually unbound, mana_remove() is invoked
a second time. Without a NULL check, it dereferences gc->dev with
gc == NULL, causing a kernel panic.

Add an early return if gdma_context or driver_data is NULL so the second
invocation is harmless. Move the dev = gc->dev assignment after the
guard so it cannot dereference NULL.

Fixes: 635096a86edb ("net: mana: Support hibernation and kexec")
Signed-off-by: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
Link: https://patch.msgid.link/20260420124741.1056179-4-ernis@linux.microsoft.com
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 2d1e5b83a0769..6509d020fcd22 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2276,11 +2276,16 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
 {
 	struct gdma_context *gc = gd->gdma_context;
 	struct mana_context *ac = gd->driver_data;
-	struct device *dev = gc->dev;
+	struct device *dev;
 	struct net_device *ndev;
 	int err;
 	int i;
 
+	if (!gc || !ac)
+		return;
+
+	dev = gc->dev;
+
 	for (i = 0; i < ac->num_ports; i++) {
 		ndev = ac->ports[i];
 		if (!ndev) {
-- 
2.53.0



