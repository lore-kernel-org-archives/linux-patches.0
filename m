Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B7630568E;
	Sat, 12 Sep 2026 16:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231867; cv=none; b=St6rCu+JHCuR2OPMAE5v/6UYn0yyA708aMrFp/qEIudP5yIkmZysJl4G4DZfTlWxVuNaHTTI0rGGykaP76fGaefxGoT1876vvtH0ZaZsog0w8pyveCh6apq5YSIB8ha/NAAvyiM/3WPIkfTsaJjrPWT8jP3JTUcHZBeP9x+VoXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231867; c=relaxed/simple;
	bh=e4/LjYQt9YprpkqwJpyJivRXEzw3IPJCNRE5Z31A5z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXkdG5oT9kf0N0g+AJUh5s4R/ys0ZxFbe+Q90SOwvDTB9VO87gC/lMZATtdzk+sSNWhMsQEIF8hjpNS0X0Y86ekRe1l6FcF2fhuz5fwIQYl68bRfyFee/lqLD9NITT5AzJBFHhwwbZzAcnV8ZefrulPS+WH5FEeS/YWT1StG4KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LZJuTeq4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LZJuTeq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34381F000FF;
	Sat, 12 Sep 2026 16:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231866;
	bh=J9t8EkUw7kPGmMPykz9EAs28zueZtyVeCy4e+sOQZjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LZJuTeq4vIeTP4bwwNUEHnqUqP+w/5iQq0CQjxt2x47KTTejJXuqd9wiOwvb3Vr0p
	 DZKlH0dZBNRWqH7eY1mmEA7tcArdPcuoDeTZFUPeu31yJ9f9kkfYUvSl6C4KE2tC4t
	 roO8J3hkwPtVty4n4KUkKCTZq3dcTrfnuDeJ5nsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1059/1191] 8139cp: fix Rx and Tx not being disabled in cp_suspend
Date: Sat, 12 Sep 2026 09:03:07 +0200
Message-ID: <20260912065611.957930911@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f5786d78ed230..4091762275d6a 100644
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



