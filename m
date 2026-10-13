Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE95A4E4C5A;
	Tue, 13 Oct 2026 11:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892288; cv=none; b=NeieCxt0MyVqIYRoMYZHEz0eiYRr8mQoZqGgKb0peF3Yf0QmTXv7YiY2o8I9bXgKwoUbSLzdDlC6xfgumwC5Vw410x5xy82tgZvIPw55Q6agBHHlLYbLrkCGDKeAHq/88t1JNTBcvJldRswOLasstOQXZ0G3Cj1rKAYvEFBhvJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892288; c=relaxed/simple;
	bh=YtvSYoKmXShKNF1rGE2U6IxruI1BzTb5kezRKo0SI3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EH1SJ224/3CHfvCZOZ90zM+JdgI9BO96YrRA9o8/bDb70xBhVVgMp9+42WfM86ts+fYm+IDPUxjd5rzbOPqFGaB13DjrrMEq32UcyAl1yfc7QlUOozmOoQLJx4ok3HuKqt6XLYU4sugWnTVZskRBhS+tBahiWayQ7IYThAh1OSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mspaExLJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mspaExLJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5AE1F000FF;
	Tue, 13 Oct 2026 11:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892287;
	bh=cZKo+Y1OVliySP1l+0CJ3KvsiTwCXBmkkD9Q9vuCxAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mspaExLJFNScBiWGwAReFfl9DDCd2rqudxiOcT30yPWaVri4mtrZnvxHEcLFyTK4D
	 t9cDVvrihq/SGknxGxM5k2ICNX5kSZuX71MdU6dMH/PDa6VkoHvH+P7A9znDHdr6Bu
	 +9V6LZmff4Snbu5JPusTiAJ91RlWIdICtgyHFcm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Maxim Skokov <skokovmaksimevg@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.2 121/281] Bluetooth: RFCOMM: free the skb when the DLC has no owner
Date: Tue, 13 Oct 2026 13:37:17 +0200
Message-ID: <20261013112858.085983892@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Maxim Skokov <skokovmaksimevg@gmail.com>

commit 9d1afbf60ed53c5b051cd124153e0ae3078c8b93 upstream.

rfcomm_recv_data() hands the skb to d->data_ready() and returns 0
without freeing it, so the callback owns the skb from that point on.
The tty implementation frees it when the DLC has been detached from its
device:

  static void rfcomm_dev_data_ready(struct rfcomm_dlc *dlc,
                                    struct sk_buff *skb)
  {
          struct rfcomm_dev *dev = dlc->owner;

          if (!dev) {
                  kfree_skb(skb);
                  return;
          }

The socket implementation returns without freeing it, and the skb is
leaked.

A connected DLC can have no owner: rfcomm_sock_destruct() clears
d->owner, while the DLC itself stays on the session until it is closed.
Data frames that arrive in that window still find d->state ==
BT_CONNECTED in rfcomm_recv_data() and are handed to the callback, one
leaked skb each.

The leak does not stop on its own either.  The remote runs out of
credits only once RFCOMM_RX_THROTTLED is set, and for a socket the only
place that sets it is rfcomm_sk_data_ready() itself, below the return.
rfcomm_process_dlcs() keeps granting credits, so the remote keeps
sending and the leak keeps growing.

Free the skb, as the tty side does.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Closes: https://lore.kernel.org/linux-bluetooth/CABXGCsPe5wykd8Aj-hm+SJ7SGQyb8yoGNnx3XDpPmBathj+EGg@mail.gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Maxim Skokov <skokovmaksimevg@gmail.com>
Assisted-by: Claude:claude-opus-5
Reviewed-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/rfcomm/sock.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -48,8 +48,11 @@ static void rfcomm_sock_kill(struct sock
 static void rfcomm_sk_data_ready(struct rfcomm_dlc *d, struct sk_buff *skb)
 {
 	struct sock *sk = d->owner;
-	if (!sk)
+
+	if (!sk) {
+		kfree_skb(skb);
 		return;
+	}
 
 	atomic_add(skb->len, &sk->sk_rmem_alloc);
 	skb_queue_tail(&sk->sk_receive_queue, skb);


