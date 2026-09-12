Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172EA34389C;
	Sat, 12 Sep 2026 09:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204324; cv=none; b=XlZuyZ4aEh4whh++sI2uJyDnTQsFb8DUnEU5IWXJ1clQ9O7Mch5qJEkyrEV4lg/jswwc2/IEcvSdQ+uB+qeYCRHY2UGOkxSNODHh/E/ilhIgW/bab6TmwP8zgxKp96NS6E9m+yBFj5U8gRN2wj891ZqqNsnNPrnZxlla/bbNuVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204324; c=relaxed/simple;
	bh=V31V7X58h3LniWBceba20CJ/CjHdsseb01TFXqxQUAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCC0V4OyiT8lQQo98pi/WIzB9pnIoIdVVqejOZxy4dY0QHlngGQ48zzLwkl+a4hJLbpUtdJkCoWyVBK9jxi9Ecx9omOstTxvCRP2yJdGvV5DtNsmvujr0HWOQoz1gXfIbaVijYWjhF9OQ99S2DduIXYXMooac8T4bBWaag0+IK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LBBFhKAJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LBBFhKAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3413A1F000FF;
	Sat, 12 Sep 2026 09:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204322;
	bh=cajU4fUeXO7MtTxgdnuoV/LBWmGHkpaWoaPyTFLC7Rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LBBFhKAJ3bLyZAh5FxI01Qq7eljPbPv+KjDtwrljYzbv1W7UFKgJux7kd6enFCe70
	 uAhw0xAD6a59abHNy9MoPNz7HIK2oNf7QfOBwioBz5f82w3YKcDLKgYGgMfDuvztMu
	 2aSWPjFLdk7HbzJyq7HHI2sVs1TNVTCwQw9QTXJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1588/1815] 8139cp: fix Rx and Tx not being disabled in cp_suspend
Date: Sat, 12 Sep 2026 08:55:38 +0200
Message-ID: <20260912065726.268743747@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit cb7643b78d35392f0f434774d78b4c77b80f677f ]

On QEMU rtl8139 model, frames that arrive while the interface is
suspended still end up in the stack after resume. With pm_test=devices,
which keeps devices suspended for 5s, 200 frames sent to interface
during that time and 50 frames after resume, eth0 reports 113
received frames.

cp_suspend() is supposed to stop receiver and the transmitter, but
the mask is wrong: (~RxOn | ~TxOn) is ~0, nothing is cleared and Cmd
still reads 0x0d when cp_suspend() returns.

Use ~(RxOn | TxOn) so both bits are actually cleared.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260817043057.20099-1-kmehltretter@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/8139cp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index 5652da8a178c0..9016527e229ac 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -2066,7 +2066,7 @@ static int __maybe_unused cp_suspend(struct device *device)
 
 	/* Disable Rx and Tx */
 	cpw16 (IntrMask, 0);
-	cpw8  (Cmd, cpr8 (Cmd) & (~RxOn | ~TxOn));
+	cpw8  (Cmd, cpr8 (Cmd) & ~(RxOn | TxOn));
 
 	spin_unlock_irqrestore (&cp->lock, flags);
 
-- 
2.53.0



