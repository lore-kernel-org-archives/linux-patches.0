Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F33492E58;
	Sat, 12 Sep 2026 19:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240365; cv=none; b=fr7kHniJ2IbgJ2f6mSbZST+NM75XmExa2lA9JWhAPOnn7zDSgSNl4C648lNh8cajrp1eOIz6RtICeYptxmBWJdgT90+m01gguvnNuDBzHkPCOY/uNG4NW8QuPcDVv1IKyQjWWW+40WzOCvfEXSDoNmsLcpbQHnlCB/iiH2on0ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240365; c=relaxed/simple;
	bh=UYDQaAMt5dTZPVk5F0jm4h633xFjPF5kmaaDjeRaPJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m9J0zMU4oMr4XxgTmmg+X2MrbuIKj7COnFVDyBzwXZnsmxmMANNDsiWC1gzVf/ueRYusAc+X2MU+dqpJEcCy3YHaWXPe/MDnU2rAEpYWKGFITID7wEjMJUzUkKgeqpBgnqyrsytlsq8e5tIxP48dpZjUZPfhSYp2yVeu9SpvJL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NkqhxhfE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NkqhxhfE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69281F00893;
	Sat, 12 Sep 2026 19:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240363;
	bh=nzfmw7adUFJl1jWuw5IB6aL6ne02dRsXkwEcbU9En5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NkqhxhfEKGsu8F/c48z4O/WaICNb2Qtb5FQtp8du8WpIWH4hapc05PLY8FymY9UdP
	 lpuD+vJm4z4cLttSCExcjsw0rplG+mHAVUBWWfqHmA9Sd/gCszaVySrvxiUJG6LOOZ
	 9mQJYmJ7ZC9NIVGzSLZmAK/sgjH7+sVXJIzVTOEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 851/935] 8139cp: fix Rx and Tx not being disabled in cp_suspend
Date: Sat, 12 Sep 2026 09:04:41 +0200
Message-ID: <20260912065546.346743332@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2b84b4565e64f..6938093e36ace 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -2063,7 +2063,7 @@ static int __maybe_unused cp_suspend(struct device *device)
 
 	/* Disable Rx and Tx */
 	cpw16 (IntrMask, 0);
-	cpw8  (Cmd, cpr8 (Cmd) & (~RxOn | ~TxOn));
+	cpw8  (Cmd, cpr8 (Cmd) & ~(RxOn | TxOn));
 
 	spin_unlock_irqrestore (&cp->lock, flags);
 
-- 
2.53.0



