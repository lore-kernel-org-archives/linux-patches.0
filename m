Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A909E4D37AF;
	Wed, 30 Sep 2026 18:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793558; cv=none; b=n5m2bwfpJY+OrXDq4HWM/cpzcTZQIuWmI/gSVo/ufyEHpkqnDytkygcO/btB8aVIicVVDZYUdPjvWz+xqvo9QKQEiUm4AsH8CYzt5ZCCdqr3zHmavTy7QaNLCu0B4yoNyHqMEFfLR7wOxczMh5MlvHLaLTMolv0+Hgj297foloE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793558; c=relaxed/simple;
	bh=i7uZtdCzfl7wMZjUFpv8jqM2EqzgT8bskNJ9JUqUTwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNhVddWFinPWIkFLnVuoDRC/iDplsLOgFz6lgCjtzAvxfC8gWVg28Tq2jRnwZqZN5xdq/tXrUEaaQ+zxdQ3T4lyo4z1fhid3VrKmjXFtwJju8aesE+aJqJt2wn8zLgOENLCOTHDCfv3U/1fChqe0vsWKwD497uODLn8L/sL0DOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gKR/HYa0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gKR/HYa0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C08721F000FF;
	Wed, 30 Sep 2026 18:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793557;
	bh=n6bk4WIOeTyNMfZlol3I0huroWTyVFF8gMxei0hwClU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gKR/HYa01e6NLxw03IDUAWp+lmmNfAH7VdrdSJOmNWccAOBzYWSl86WHBxFKbPZcW
	 7qaG684cDUM42SeuHqTE0NK704GJJiLRfdjYCi8j4odVB0hbqunCJHQCHbdTcVfQH/
	 9qvzAEY1BU/AGASAuFfsR87mylo7bKDT058DOaj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Paul Geurts <paul.geurts@prodrive-technologies.com>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 6.18 296/395] nfc: trf7970a: power down on startup RX gain failure
Date: Wed, 30 Sep 2026 17:29:18 +0200
Message-ID: <20260930152347.077428160@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit d2acbde7e67df44efa8f0963462d1192e7694ffc upstream.

trf7970a_startup() powers up the device before applying the optional RX
gain reduction. If the register read or write fails, it returns without
undoing that power-up. Probe's unwind only drops the separate regulator
references acquired by probe, leaving the additional VIN enable from
startup unbalanced. The system resume caller also has no power-down on
this error.

Call trf7970a_power_down() before returning the RX gain error to deassert
the enable GPIOs, release the startup VIN reference and restore the
powered-off state. Runtime PM has not been enabled yet, so the full
shutdown helper is not appropriate here. Preserve the original SPI error.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 5d69351820ea ("NFC: trf7970a: Create device-tree parameter for RX gain reduction")
Cc: stable@vger.kernel.org
Assisted-by: OpenAI:GPT-5.6
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Paul Geurts <paul.geurts@prodrive-technologies.com>
Link: https://patch.msgid.link/20260913042625.31296-1-mhun512@gmail.com
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/trf7970a.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -1997,8 +1997,10 @@ static int trf7970a_startup(struct trf79
 		return ret;
 
 	ret = trf7970a_update_rx_gain_reduction(trf);
-	if (ret)
+	if (ret) {
+		trf7970a_power_down(trf);
 		return ret;
+	}
 
 	pm_runtime_set_active(trf->dev);
 	pm_runtime_enable(trf->dev);


