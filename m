Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C99925D525;
	Tue, 25 Mar 2025 12:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906277; cv=none; b=eqJKtJgNr7AxjOrxttQWGJIMHzC6+OrSlHgoElfxF4cM0ttaczv2AK9MuyiqKGehgJqCStS8nrZXOuQEq6ofhnPy0LShc3N3kV46MCZ+x96xDTCGZ7gY47h6ktZSNc/28O7bjyEZVeqJ6X7ehi8lL0L2tsDZoLyZgZzrKDUGRpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906277; c=relaxed/simple;
	bh=v+ZfnYtLu5mFZjFsHksfGpD0xxnwdo7x3vAJYS65Ph8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a1qGxB1odi1Nhu76VCXcXGIAY4pTxgMEubXa2iop1Is97ipJ8qbHZR8Op4KnMvUsEvky7JgwAkudqZcGO2aOysniNyaXknf1tVt5U8f/kB6dT051qlwjQjGyAs1qHyLChzUGJRsqehmwgOQy+1Vp9J1vLVKy2vW1Eaw/G/VQ2WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I0KCFiZK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I0KCFiZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4F9C4CEE4;
	Tue, 25 Mar 2025 12:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906276;
	bh=v+ZfnYtLu5mFZjFsHksfGpD0xxnwdo7x3vAJYS65Ph8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I0KCFiZKuWrmwGlQJmB4IEOFjugk9UM60id2YZvSndsvjBBu09ji8yMqXtc/PNbid
	 crOzwh8YOOm8z64P/zUPcz1ljVqZHx/0v7uNvwEjW4tifFhDKmxmpjE34Bsn0hoeM2
	 dz2MAf64LBnQi7IsFQD3/VVAfB7N7eYlHtBY8mQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/116] Bluetooth: Fix error code in chan_alloc_skb_cb()
Date: Tue, 25 Mar 2025 08:21:57 -0400
Message-ID: <20250325122149.983653925@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 72d061ee630d0dbb45c2920d8d19b3861c413e54 ]

The chan_alloc_skb_cb() function is supposed to return error pointers on
error.  Returning NULL will lead to a NULL dereference.

Fixes: 6b8d4a6a0314 ("Bluetooth: 6LoWPAN: Use connected oriented channel instead of fixed one")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/6lowpan.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index 50cfec8ccac4f..3c29778171c58 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -825,11 +825,16 @@ static struct sk_buff *chan_alloc_skb_cb(struct l2cap_chan *chan,
 					 unsigned long hdr_len,
 					 unsigned long len, int nb)
 {
+	struct sk_buff *skb;
+
 	/* Note that we must allocate using GFP_ATOMIC here as
 	 * this function is called originally from netdev hard xmit
 	 * function in atomic context.
 	 */
-	return bt_skb_alloc(hdr_len + len, GFP_ATOMIC);
+	skb = bt_skb_alloc(hdr_len + len, GFP_ATOMIC);
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+	return skb;
 }
 
 static void chan_suspend_cb(struct l2cap_chan *chan)
-- 
2.39.5



