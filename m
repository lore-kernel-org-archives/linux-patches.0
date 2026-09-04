Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B144137B2;
	Fri,  4 Sep 2026 05:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499994; cv=none; b=hhkZi4g5v+OYwc6PCaHjKr/V5ivlwu7DE8nyhGfcn6TxselBsb43354+EC1mGjpPz7zu1xPYwsawFKXBHO5jTiUQdmfmbEFGoptH/CehyFr10hf9UKORYkw/1bEXfn+J7m7Mm3xosr3S5Ff1IJnK84jdF53g/c/N4LzoBPVvxLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499994; c=relaxed/simple;
	bh=rq2w6+YsPV6KiJyiFhiUc2vHQp1CYH/g9cHpZcTqRwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nAKcyc3T43PZMVnnWz6LbH5kMjln8+ZQTXfKIxrsbngclX8B6lN82nYi7Lq7noXtY4u6crFKDAS3KW6QmpGKGI98ObnDVBReXQKgClxfR776eWrJBl1Sp8TcHUqVdv9rRqSgJcInH2YCxdgQhmG/geWYf3HLkQmXUo3QHNglhKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SObyOOYd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SObyOOYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A831F00A3D;
	Fri,  4 Sep 2026 05:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499993;
	bh=/jEhVVo/E75blGvlcm1otvtsgALWKTMSHkpJziPmnRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SObyOOYdo4vkUit1AQ5BFkoVVZ6s6fdC6nTjwgdmtRgOngc8/6KIN5hJ4KZd9PhX4
	 sxjJf5OgQxgrz6XbSiVAmZkxTHnTEYQgubGisBYdUNOI1w9OVt/SW5IRj9DQLyWvje
	 F8PbRF7IGC3WE/WI8UF8vqQm4YQbF4VkPx/kh418=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Dave Jiang <dave.jiang@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 613/713] NTB: ntb_transport: Fail TX enqueue when the QP link is down
Date: Fri,  4 Sep 2026 06:59:41 +0200
Message-ID: <20260904045817.567382769@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2353,9 +2353,8 @@ int ntb_transport_tx_enqueue(struct ntb_
 	if (!qp || !len)
 		return -EINVAL;
 
-	/* If the qp link is down already, just ignore. */
 	if (!qp->link_is_up)
-		return 0;
+		return -ENOLINK;
 
 	entry = ntb_list_rm(&qp->ntb_tx_free_q_lock, &qp->tx_free_q);
 	if (!entry) {


