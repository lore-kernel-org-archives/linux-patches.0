Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93033191A7;
	Mon, 29 Dec 2025 16:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025695; cv=none; b=oZ4gMLsYHB0aardiPcP8SnYr+SOi7GfSmS5le5XzpfePjlc59ITByOZrME/z4IKehBGFYYVlTFfUq2p0w4WIx1JbjEdqLvKqWLUrl6Ab/07DMMLpcU+VK7nLRz2KzPumC9iYtDu0ivIC9SjGvAO718kMGx4FmhLloAfj7cvK/GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025695; c=relaxed/simple;
	bh=KXNoA2ZLPmrjitnmqvsq86N0R7JZI7uBM+CMThFKXxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LiGf6WCm06/a/jmiakeMyBj6/e6hQ/Oh2ZcnbPDUvp40UXdVwmNiaQG5idz7JU4jG8+Jw+vlSUwrgOrOl38L1jW36BTrDiYs/MHZpU7aqR1YAElz6Gefr2npdQKi3MfCptz3cqfK6nJTpHAQIalEjMJdfHZxHfizRDEnNhAZLww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vO4UggDz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vO4UggDz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C2FC4CEF7;
	Mon, 29 Dec 2025 16:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025695;
	bh=KXNoA2ZLPmrjitnmqvsq86N0R7JZI7uBM+CMThFKXxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vO4UggDzqDL/F1rcaudQXUpdycWosM/bl2+V3bt68fos8xpZgw1cehfpWT8KX+8SG
	 NJ7ehzMIQuEErbnooQjYYCO4iUMjssCsicGLbKfgynv/QkSxaKMAJ/ZqZUI7JTMrBa
	 N53KuVs166Kh40T9eCbGHTEVtLVHhhR5zcYIDRA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 6.18 303/430] serial: sh-sci: Check that the DMA cookie is valid
Date: Mon, 29 Dec 2025 17:11:45 +0100
Message-ID: <20251229160735.486877826@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit c3ca8a0aac832fe8047608bb2ae2cca314c6d717 upstream.

The driver updates struct sci_port::tx_cookie to zero right before the TX
work is scheduled, or to -EINVAL when DMA is disabled.
dma_async_is_complete(), called through dma_cookie_status() (and possibly
through dmaengine_tx_status()), considers cookies valid only if they have
values greater than or equal to 1.

Passing zero or -EINVAL to dmaengine_tx_status() before any TX DMA
transfer has started leads to an incorrect TX status being reported, as the
cookie is invalid for the DMA subsystem. This may cause long wait times
when the serial device is opened for configuration before any TX activity
has occurred.

Check that the TX cookie is valid before passing it to
dmaengine_tx_status().

Fixes: 7cc0e0a43a91 ("serial: sh-sci: Check if TX data was written to device in .tx_empty()")
Cc: stable <stable@kernel.org>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://patch.msgid.link/20251217135759.402015-1-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sh-sci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -1740,7 +1740,7 @@ static void sci_dma_check_tx_occurred(st
 	struct dma_tx_state state;
 	enum dma_status status;
 
-	if (!s->chan_tx)
+	if (!s->chan_tx || s->cookie_tx <= 0)
 		return;
 
 	status = dmaengine_tx_status(s->chan_tx, s->cookie_tx, &state);


