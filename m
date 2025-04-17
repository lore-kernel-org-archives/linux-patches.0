Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D53252915;
	Thu, 17 Apr 2025 18:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914700; cv=none; b=Q0a81Ctcm9W42f3J/L8S2maPfUDV3CQGMFKf0LaJh0SxhgbpGLEAUQzATTLEBFDVxwLZgj2C2rjByE4HjDAM7S/EeclJ9FsbcMsFcpQq+V1PcFzj6siatVnYzHPVKdAivJ2VPZVN8yLEDHwNLH1nCcJroyLNRzn3yA6D8KRLGeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914700; c=relaxed/simple;
	bh=uRmF3CF3P0KHn8HtLukM4qOSM53s/BvfeiPiJB8G5hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a0UBKNGmsyTa2Q3DElO9Q/lwwA57EZiexmz2a+joeQ1v4twjb8n3nVR9Lv/jrzT/q0RctIVblQFn8DhPptf3Zj9ODgYz+Gh0QHM0+pqaljcBhv/WvbWBg+dU5c/5dcJIls4fKSpsj3R8rPBHIoOSlIHZv8hw9tpkL9nZU3f/a50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e8Wr/OXB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e8Wr/OXB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B86C4CEE4;
	Thu, 17 Apr 2025 18:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914700;
	bh=uRmF3CF3P0KHn8HtLukM4qOSM53s/BvfeiPiJB8G5hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e8Wr/OXB74Vpe7nbDn8K8N3d4gX4+9jpeaUgcrK6YTTC5eJuxo4JAHlekODSuqvwa
	 Ek7NTpUf1SFhI68kuOIKkGkgOxB7Yd4CvenOJ+Thi+h0AH+A3dJdix/QzYUgXlY3lS
	 X6hxOFMdu2t+X0uJKYcT92dRvzL7ekjbTUqwXs/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.13 302/414] mtd: rawnand: Add status chack in r852_ready()
Date: Thu, 17 Apr 2025 19:51:00 +0200
Message-ID: <20250417175123.577858005@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit b79fe1829975556854665258cf4d2476784a89db upstream.

In r852_ready(), the dev get from r852_get_dev() need to be checked.
An unstable device should not be ready. A proper implementation can
be found in r852_read_byte(). Add a status check and return 0 when it is
unstable.

Fixes: 50a487e7719c ("mtd: rawnand: Pass a nand_chip object to chip->dev_ready()")
Cc: stable@vger.kernel.org # v4.20+
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/r852.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mtd/nand/raw/r852.c
+++ b/drivers/mtd/nand/raw/r852.c
@@ -387,6 +387,9 @@ static int r852_wait(struct nand_chip *c
 static int r852_ready(struct nand_chip *chip)
 {
 	struct r852_device *dev = r852_get_dev(nand_to_mtd(chip));
+	if (dev->card_unstable)
+		return 0;
+
 	return !(r852_read_reg(dev, R852_CARD_STA) & R852_CARD_STA_BUSY);
 }
 


