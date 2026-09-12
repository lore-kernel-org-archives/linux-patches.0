Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CCB379ED2;
	Sat, 12 Sep 2026 19:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241557; cv=none; b=NNE1tIZmTSlTxCYSp5QF9H9piG4Zq62OZMzB6oPxoQqNtNeNWPVc4MzcrR9P0B8YUHc42TF4Yh23cG9tLpvMY532dBE3KeHY8zwUeKFr9uoJ/4ZGuCZ9z88M0sMURF0cN1AWyV0BG0MwpKd4Wgxgs9m+p55c8ivy9VhEAqFv1k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241557; c=relaxed/simple;
	bh=tv5GyJV1Tg/ujr6qe9x4aZGTrzZoX1AzrKo8bCTZVZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AkI8SzvfPdndFBeSu4Omt63g/EF4l0QycfyEWDMCaQsJ0+C275F0IlcFs5bzspc8vYvGMd8eon1CiAKbjmBSESTK+SR25bd2mjzIPpjStUX3+SixzjpFuXrITMZta3BK+KqFTd9RcEcU5RPRlcvyzu3ozmtZm4pMYg/U4tg8ogc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uVjCgSzs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uVjCgSzs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A757E1F000FF;
	Sat, 12 Sep 2026 19:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241556;
	bh=6ehYtCKIYI6tzD8e012+L8N08NYrX89fPtPaZWhg2xQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uVjCgSzsX7OPjMvk1OAa76w0VK63RD9kGPI5k2kNf0DmZxyVu0jruioHmRlwCR87v
	 53c1RJjQMMXJiZaeJ5HlVv9VNtmzIylc28GqaldhA7tytFJlFn6HxaRkkhg8xjRdXg
	 s9nY61szw9PETLTlQ6DPT2qRBNW7yPk3KESZmp6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Dave Jiang <dave.jiang@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 161/798] NTB: ntb_transport: Fail TX enqueue when the QP link is down
Date: Sat, 12 Sep 2026 08:56:29 +0200
Message-ID: <20260912065520.711994609@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2293,9 +2293,8 @@ int ntb_transport_tx_enqueue(struct ntb_
 	if (!qp || !len)
 		return -EINVAL;
 
-	/* If the qp link is down already, just ignore. */
 	if (!qp->link_is_up)
-		return 0;
+		return -ENOLINK;
 
 	entry = ntb_list_rm(&qp->ntb_tx_free_q_lock, &qp->tx_free_q);
 	if (!entry) {


