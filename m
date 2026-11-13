Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591007;
	b=aAjJhunFMlJw8oh0edF1p+RoGP+d0IZ8//kj+UAWhf2+u3VMTrtfxvLKJi7hrPdV42zN
	 SH+nNHggJsyQZ0mMfWhs7Im3hd9XRY+1eRHCkydWNJziH4Ys7AMqyAeP+wEvwYPhcD3GT
	 pJSq8nCmNIPPFWtLNJdghi8TeCTxAw0U7vFwDNGs52dzZ1Y7yTY17E1CBMyApMS5iUzIW
	 GBU+gS9C5t+aerN3RVke+hSeUOE3v5bO//hdrUjTF2BhPv+DJZ4A5x8sXcT4o4hVibiZP
	 yIWm5dJCg4BPmMEdlQ1PoQDnpLpXpk+W4Ajuu63R8dYv/1mQWFgZrCaVMTcCvqzRDtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591007;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l7lzhcRaBwbzGBx7gxEIgdRQAcKFrU49jafjR98X/5c=;
	b=2xlKVOk6kQh3YxKA2KF15SN2bBRpC8DrW4Ogz0bdewE+HBu76SCFvxkoXmrRYh3q3Y50
	 O9ne8tLifO5hXD5CZCC6nSaRfDnAl3KK7leWoR/kAggW9Y3ubdf9coee29qWnqwbq492J
	 g+MdLMPf6Ago0ARQb6QeuTjs3ISVpowy1dARklBNlGR6xZTTF4xviR8FE0INLriAsLJ6P
	 SZw0Nx4UA6HQAV7lIfSiz8wItv/m7I4cETPB3DFCgZN1W+61GWfTNf1DvLC5Rshhtx1aa
	 IaMs7/vXpvrpZBNeeVzVpJirgTFi9PwmkmwWCiFO73/Z3sv4oUeoVtsQXlxTSiZYWLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SBQE4mYG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BDC60703FD;
	Fri, 13 Nov 2026 17:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SBQE4mYG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615F71F000C4;
	Fri, 13 Nov 2026 17:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591007;
	bh=l7lzhcRaBwbzGBx7gxEIgdRQAcKFrU49jafjR98X/5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SBQE4mYG0OAbp0Q+V0ldPpxjH4A3+d/ZsKpkt9JAe8y1o8ip1Nc6JxhbDcTqkryBv
	 B9mElkBa/IObrubyYZjt+7zpb/X2PKySwvboXvO34R79HVP7HXU5/DAo3Zoux8a7FJ
	 b2vZHku+z8eSdRfeO3Dvd4cMJpRvBcJekT2i62S4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <mgr@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 177/670] net/9p/usbg: always reset completion when disconnecting
Date: Fri, 13 Nov 2026 10:45:41 -0500
Message-ID: <20261113153818.043455129@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Michael Grzeschik <mgr@kernel.org>

[ Upstream commit 08c6b9f484a406d9d87c5b2580725d2e0597f3b9 ]

When some tx or rx transfers were pending while closing the connection,
the completion handler could catch one pending completion call. To
ensure a normal start when mounting again, we have to reset the
completion and flush any pending completions.

Fixes: a3be076dc174 ("net/9p/usbg: Add new usb gadget function transport")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Grzeschik <mgr@kernel.org>
Message-ID: <20260922-usb9pfsfixes-v1-3-9d8dcc52904c@kernel.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_usbg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/9p/trans_usbg.c b/net/9p/trans_usbg.c
index f1773749d9124..0b04363c39793 100644
--- a/net/9p/trans_usbg.c
+++ b/net/9p/trans_usbg.c
@@ -467,6 +467,7 @@ static void p9_usbg_close(struct p9_client *client)
 	mutex_unlock(&usb9pfs_lock);
 
 	disable_usb9pfs(usb9pfs);
+	reinit_completion(&usb9pfs->send);
 }
 
 static int p9_usbg_request(struct p9_client *client, struct p9_req_t *p9_req)
@@ -755,6 +756,7 @@ static void usb9pfs_disable(struct usb_function *f)
 		usb9pfs->client->status = Disconnected;
 	spin_unlock_irqrestore(&usb9pfs->lock, flags);
 	usb9pfs_clear_tx(usb9pfs);
+	reinit_completion(&usb9pfs->send);
 }
 
 static struct usb_function *usb9pfs_alloc(struct usb_function_instance *fi)
-- 
2.53.0



