Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E943A4F46;
	Tue, 17 Mar 2026 17:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767291; cv=none; b=oul4aXt0MDlcCtSHj1kIrJpy3rrAonHFXYrArbtYUfodGmq7JydiS/UYTEPIfzY6wqrPkf4LS8M6ggSzcLw3DW+o2lKByU6YiB0fLoWWziwzB/HoSzY+To/tuTxfybw3uOoBCMqvpyRyiH+8giDRKkQ/DJfVYffMAW9d+JCUxoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767291; c=relaxed/simple;
	bh=wKnt8nF4BeufhvG3Mm5i6rhhHf4dgKGmomPzyVcOURg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c1OrW6vZnzgTIDlHO2dU0L0JblzafwBvyX9uJvz00QRZYtQYRd+0xkNNZWRTjwjhjvPJMTGPeJ7xoAfPiuzI/ct9OBhb5uy5QrO78hFipTfb8XFiOQO6O43GOy9lNfWMBY0d4kH0k1wFvriFPLrUXBErfmF4mEglSatD0C9wvvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fW7FwcZ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fW7FwcZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D54C19424;
	Tue, 17 Mar 2026 17:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767290;
	bh=wKnt8nF4BeufhvG3Mm5i6rhhHf4dgKGmomPzyVcOURg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fW7FwcZ/MkoVkiUzodDz8nZ7Qs5/FRnFdwBdNGaNX343aqiVVjJvOkX2vzUqDce/a
	 GUMNgm0saJIfDlNFcR/FMvgxK6XNHrF7/DT09bRdR7HPA5GibmfWH4M+YYi2MwIUv+
	 5FAWPMcpWnJ3iZPCHd9QUlKFiAL6TQ9u4wyxU8ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 055/333] net: sfp: improve Huawei MA5671a fixup
Date: Tue, 17 Mar 2026 17:31:24 +0100
Message-ID: <20260317163001.408831722@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Álvaro Fernández Rojas <noltari@gmail.com>

[ Upstream commit 87d126852158467ab87d5cbc36ccfd3f15464a6c ]

With the current sfp_fixup_ignore_tx_fault() fixup we ignore the TX_FAULT
signal, but we also need to apply sfp_fixup_ignore_los() in order to be
able to communicate with the module even if the fiber isn't connected for
configuration purposes.
This is needed for all the MA5671a firmwares, excluding the FS modded
firmware.

Fixes: 2069624dac19 ("net: sfp: Add tx-fault workaround for Huawei MA5671A SFP ONT")
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260306125139.213637-1-noltari@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 43aefdd8b70f7..ca09925335725 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -367,6 +367,12 @@ static void sfp_fixup_ignore_tx_fault(struct sfp *sfp)
 	sfp->state_ignore_mask |= SFP_F_TX_FAULT;
 }
 
+static void sfp_fixup_ignore_tx_fault_and_los(struct sfp *sfp)
+{
+	sfp_fixup_ignore_tx_fault(sfp);
+	sfp_fixup_ignore_los(sfp);
+}
+
 static void sfp_fixup_ignore_hw(struct sfp *sfp, unsigned int mask)
 {
 	sfp->state_hw_mask &= ~mask;
@@ -530,7 +536,7 @@ static const struct sfp_quirk sfp_quirks[] = {
 	// Huawei MA5671A can operate at 2500base-X, but report 1.2GBd NRZ in
 	// their EEPROM
 	SFP_QUIRK("HUAWEI", "MA5671A", sfp_quirk_2500basex,
-		  sfp_fixup_ignore_tx_fault),
+		  sfp_fixup_ignore_tx_fault_and_los),
 
 	// Lantech 8330-262D-E and 8330-265D can operate at 2500base-X, but
 	// incorrectly report 2500MBd NRZ in their EEPROM.
-- 
2.51.0



