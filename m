Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225A32C15A9;
	Sat, 12 Sep 2026 13:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220857; cv=none; b=oJZAOT+fUKIqMxDNH539mLxQfq0RPP9tdSMLGIyL3GtzWffhQrGk7Vdj5orx1YuNzhx3Z9ANfLeFNv5WhyDzitaf+6BQGdywisPvumaaHAr7SjskHzqxEMl0Y2sGoAFReZ2MW03j59M5JLW/MXCJxarBR72XiqYhK7zEeU1Zkdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220857; c=relaxed/simple;
	bh=WubfD7KpLvoY0uLemgAFAao9SbZ93yk0d7UUSRxUt6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p4Io+L0anYtG39X0afpOliJebzmyhNwy/MDoeXLGbdRpJap2dr66Q/EPZyMJu6x7KGAHpedpQ8XgUmPCETEjlwFx6Q2k8BR0ldn/E4/digeyJ1ZWNbAF/gKtjBqJUsNHGtEvH5YsLSggTAAMqol13kCPL6N7oRsDN188M1tkrJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CBmqCm0H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CBmqCm0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A276F1F000FF;
	Sat, 12 Sep 2026 13:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220854;
	bh=78E9B6OtBwK8QokPYxwz9yzYyqapz/Ggy0PvSADOrqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CBmqCm0HISjJy/UK4E9/u7tJQMbUHy3t3VtBoWeHHUg5uF0HR+UIB0lUEIXc4kHOS
	 T/um2hSYfDyqxi51c0Ia7zN2w6+HtFrgWxkW3JWGAXqLWiXBsnVxZtTREIWPz93TjF
	 nXS+JKWMMrF6Pc4pepYbGJnn9rhbPszSlwBrod/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Dave Jiang <dave.jiang@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0264/1424] NTB: ntb_transport: Fail TX enqueue when the QP link is down
Date: Sat, 12 Sep 2026 08:44:56 +0200
Message-ID: <20260912065613.189978353@linuxfoundation.org>
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

From: Koichiro Den <den@valinux.co.jp>

commit 873ce713fef5dde0939220f04f3484ec86a16fba upstream.

Commit f195a1a6fe41 ("ntb: Drop packets when qp link is down") meant to
make ntb_transport_tx_enqueue() drop packets submitted while the QP link
is down, but it only returns 0 without consuming the packet. Zero means
success by this function's contract, so ntb_netdev reports NETDEV_TX_OK
and forgets the skb: nothing queued it, nothing frees it, and it leaks,
one skb for every transmit racing a link-down.

Return -ENOLINK instead, restoring the contract that a non-zero return
leaves the buffer owned by the caller. With the preceding patch,
ntb_netdev frees the skb on non-retryable enqueue failures and returns
NETDEV_TX_OK, so a packet racing with link-down is dropped without leaking
or entering a busy retry loop.

Fixes: f195a1a6fe41 ("ntb: Drop packets when qp link is down")
Cc: stable@vger.kernel.org
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260817053519.4135287-4-den@valinux.co.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ntb/ntb_transport.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -2304,9 +2304,8 @@ int ntb_transport_tx_enqueue(struct ntb_
 	if (!qp || !len)
 		return -EINVAL;
 
-	/* If the qp link is down already, just ignore. */
 	if (!qp->link_is_up)
-		return 0;
+		return -ENOLINK;
 
 	entry = ntb_list_rm(&qp->ntb_tx_free_q_lock, &qp->tx_free_q);
 	if (!entry) {


