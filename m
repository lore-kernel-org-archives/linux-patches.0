Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E23A26A0FF;
	Tue,  8 Apr 2025 12:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113882; cv=none; b=qv1Dqqfp/Ah8UvORT+LfsvH08cdxakRrvdtLp5WL6iWDdag0lpljFt9RQMmi+l+fkGQjE+Z7sxsMwxxnFOcIV7LzahOCL+r2Xsmq/XM0Wq473gf0sugiSpQRXZ1nm/inBJdAKL0ds0vQUMmRqtUMndv+8VcieV6Hw578PouanE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113882; c=relaxed/simple;
	bh=Lr2Ybn2E8byvIOHvATVonyI59TIoY+ab0aMCbwuvJ8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWXacChkwHkoPZeSpOyLfNDSveNSmd/+jbkNCoeNkBB12EUzjX/P9146DZ1/RjKMGO0GudRwgi+Hw3ZGRSLSRbnZ+BlazcOsUJQEemWpzVgDTrswga/xkeuE7jmid/VLaopSQgaSfrrFKDj74htPSEIncAS4bu2XHq2C4nISACo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xcA64aa4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xcA64aa4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46E1C4CEE5;
	Tue,  8 Apr 2025 12:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113882;
	bh=Lr2Ybn2E8byvIOHvATVonyI59TIoY+ab0aMCbwuvJ8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xcA64aa4k99uw/KF4CHIgcuJLJdwaywECVZK1CirbEnE0f4jk7ZSx4HV2ciRAzcs6
	 DxTLAGhjpN6VOkct19GhBd8CRR8QEXGbf0nPS0mwVj/sZqRhlxYT/C1qe7zo89XUKd
	 uMkyGCyjRhS6Sp25mgF30jfQjshc4zqiLSxyNW8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 055/154] Bluetooth: Fix error code in chan_alloc_skb_cb()
Date: Tue,  8 Apr 2025 12:49:56 +0200
Message-ID: <20250408104817.049362776@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index bccad8c048dad..12052b7664414 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -847,11 +847,16 @@ static struct sk_buff *chan_alloc_skb_cb(struct l2cap_chan *chan,
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



