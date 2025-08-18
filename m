Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331A921CC59;
	Mon, 18 Aug 2025 13:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524289; cv=none; b=GSK+FctQBho2Jr2h1zLQywGwjSQTYn5IGJ3Kf+Z4mO1iLUo4O7eiqX7mJ8XuIqVBeHTePWj7SjU8WzeifkwrA+p2OExorZTW1JFQem74Sr2fRp9zVSIT98ez6R6Do+a457ZTCBcza2EmWzMiK5zOUgB6nfM5ClVgqmxNFlXCGzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524289; c=relaxed/simple;
	bh=tCN8UXOl60H8N1DPuo6VqyaQDA2UtsOfhgXf9oUfovQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eCxK3CL/014T6YtRNiN1ZguEu1+ISJA/XDqFe6gWD/f80EHP3HLeyKb56kvbWv3D8B0XIDDW68645foYvoDK/Im8SwG4LorDEGsRiA3U9+42PdF8/sQs60F2Mu4ZPxlhfJK+pYfe8rs47Ljd0guHH0ViSCA+lzXKlI2hHrPpcYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dL7Y9s6P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dL7Y9s6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4CD6C116D0;
	Mon, 18 Aug 2025 13:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524289;
	bh=tCN8UXOl60H8N1DPuo6VqyaQDA2UtsOfhgXf9oUfovQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dL7Y9s6P49j7WIWWf+bYflzykEq1PDjpYPN3bjhQcflIDR8tvIPG37R0LZv1W3UUU
	 i/ur5Jar+kHHF3CspuryAz6MZPyYTDLquJtIgFRXxGQHvguoRHyVYRWTxBbZRrByEQ
	 BuxqOgXapC1U/ZJeecRZ48BPi6W2mm8DK7rNERAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Buday Csaba <buday.csaba@prolan.hu>,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 425/515] net: phy: smsc: add proper reset flags for LAN8710A
Date: Mon, 18 Aug 2025 14:46:51 +0200
Message-ID: <20250818124514.783522000@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Buday Csaba <buday.csaba@prolan.hu>

[ Upstream commit 57ec5a8735dc5dccd1ee68afdb1114956a3fce0d ]

According to the LAN8710A datasheet (Rev. B, section 3.8.5.1), a hardware
reset is required after power-on, and the reference clock (REF_CLK) must be
established before asserting reset.

Signed-off-by: Buday Csaba <buday.csaba@prolan.hu>
Cc: Csókás Bence <csokas.bence@prolan.hu>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250728152916.46249-2-csokas.bence@prolan.hu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/smsc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index b6489da5cfcd..48487149c225 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -785,6 +785,7 @@ static struct phy_driver smsc_phy_driver[] = {
 
 	/* PHY_BASIC_FEATURES */
 
+	.flags		= PHY_RST_AFTER_CLK_EN,
 	.probe		= smsc_phy_probe,
 
 	/* basic functions */
-- 
2.39.5



