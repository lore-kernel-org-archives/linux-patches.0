Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF08333D514;
	Tue,  6 Jan 2026 17:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720299; cv=none; b=WfJ2TcMak+E8U75383bWfJnie60JU12S8RvnSTjYdWoGYsjjhPcafy18Xz5CFuVokdNjqxK16Z1jZhMtHmsoKE6DfDRfYRvM+6J7lHF6M6cUesS+0nySVsBquXRFmXwQHNSqyggBg8AjAOz+WqAlhDODg2LQmUyb7ps7P0UWgvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720299; c=relaxed/simple;
	bh=IKpTUXxV/tKR2spUcx/rxnzQu2c8R3n5v/tXWFK4tyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lm80SvlCM4l8frjnnN9hF/15ZLWVWp+zjBrCW6gX1zOoz/LnAkTilytvisfUUDHv01V8F2MU6vmd72EPSVchFA/KuOH5fFl8uWK/Qzb/Kk7mkHZZHzLJOitJkDgkJl1qZOksXMTeOixhdwdAav+YNAHTVgUxb8Jg9wstxUYK6N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jM5nowKB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jM5nowKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59AABC116C6;
	Tue,  6 Jan 2026 17:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720298;
	bh=IKpTUXxV/tKR2spUcx/rxnzQu2c8R3n5v/tXWFK4tyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jM5nowKBT3oGwAQA7sQhjD9kD5s37OVQo5n9sAcCvPCatbWnN4yKYMpBJUbLNoN0N
	 SoGS0cvjJGZL6p/qQ2hrRg9BCanflDNjmAxiwOZtM+qg52y2XzLFsX6+sm1r/qIevl
	 Ini3j7vzLnRMh45uArm36S/CSH3KWe4onwP/q/1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Subject: [PATCH 6.12 194/567] serial: sh-sci: Check that the DMA cookie is valid
Date: Tue,  6 Jan 2026 17:59:36 +0100
Message-ID: <20260106170458.503047813@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1761,7 +1761,7 @@ static void sci_dma_check_tx_occurred(st
 	struct dma_tx_state state;
 	enum dma_status status;
 
-	if (!s->chan_tx)
+	if (!s->chan_tx || s->cookie_tx <= 0)
 		return;
 
 	status = dmaengine_tx_status(s->chan_tx, s->cookie_tx, &state);


