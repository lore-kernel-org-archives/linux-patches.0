Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462DF3019C7;
	Wed, 10 Dec 2025 07:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352089; cv=none; b=sELchKLxpQVF/ZtMea17t2X6nhBuvkaAp4nynpnK0u3slKe4VIXK5i6nhqGXuSLtubySjKzrvKVFhDNq70eRe6fXpAY2dtkYvSJ67Mw67hYCwnWm9tfaLJvTcAvYrdcPTRZ9uorl0TSJpYsTWndQPDnOn16S7Q1aO3IoaYLd8Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352089; c=relaxed/simple;
	bh=5Bgj9hraCFTvQeOGJl+oOxgt2qBe8T0A59uUziqxZRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hq6zTHvKlMt2njreCPbqWCQxG1uv2mpHupNAw86NjbTuUr9KGdouLUaG7kl7vsqtv95H6cQDwwNFfuehDBM25Vk/1Zig5CvLgvJi7fQ8AIlwdJVTnluAWcJPuwGDrBeDXRVznRvDTLA4nhDz1k7BV9uIl1KOtMXjlr5S8gKYYYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L4PwTSZ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L4PwTSZ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79FD6C4CEF1;
	Wed, 10 Dec 2025 07:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352088;
	bh=5Bgj9hraCFTvQeOGJl+oOxgt2qBe8T0A59uUziqxZRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L4PwTSZ2la4GSi8VP/XMwAQ1hKJVToedsyyurQH/u6e/w3Vh9k4IhJrFIyTX6ShnP
	 4Rmf2ipOwWm4ks2XHW1d1qNYmuLHMzvsJnklS0Ge8mzoEtlJ+bWk4/S5/41zJZj5Fx
	 9HCYY/hO6XGP5bbUIwwnh3XObl86B/SXvJiVpbtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 6.17 16/60] serial: sh-sci: Fix deadlock during RSCI FIFO overrun error
Date: Wed, 10 Dec 2025 16:29:46 +0900
Message-ID: <20251210072948.239591062@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
References: <20251210072947.850479903@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

commit 75a9f4c54770f062f4b3813a83667452b326dda3 upstream.

On RSCI IP, a deadlock occurs during a FIFO overrun error, as it uses a
different register to clear the FIFO overrun error status.

Cc: stable@kernel.org
Fixes: 0666e3fe95ab ("serial: sh-sci: Add support for RZ/T2H SCI")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20251114101350.106699-3-biju.das.jz@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sh-sci.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -1024,8 +1024,16 @@ static int sci_handle_fifo_overrun(struc
 
 	status = s->ops->read_reg(port, s->params->overrun_reg);
 	if (status & s->params->overrun_mask) {
-		status &= ~s->params->overrun_mask;
-		s->ops->write_reg(port, s->params->overrun_reg, status);
+		if (s->type == SCI_PORT_RSCI) {
+			/*
+			 * All of the CFCLR_*C clearing bits match the corresponding
+			 * CSR_*status bits. So, reuse the overrun mask for clearing.
+			 */
+			s->ops->clear_SCxSR(port, s->params->overrun_mask);
+		} else {
+			status &= ~s->params->overrun_mask;
+			s->ops->write_reg(port, s->params->overrun_reg, status);
+		}
 
 		port->icount.overrun++;
 


