Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645533446DA;
	Tue, 17 Mar 2026 17:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768455; cv=none; b=nDziXLTBPIFdVhSQYPlrDTf/OTVfXEP7J/OrA+L2pHN9K7VA2ZyIqFJDzA0AP0S3NMbWCM8vOFyU6Vvt+r9e+nRyQpD6dZGer/Ey1YKxwzD0Su6y9P8yWwFLLagatyBWgjvSANZ0U/G//Hh+OlLOVeg8Ns25x1BGWkyP0LNobIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768455; c=relaxed/simple;
	bh=UhKxAc4aLLSHTBNz3bBmEgv7Wk/tGFawsZ9iX1BprKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogXLL5OoIHb8jEdoY2m1jFEBT9i852uOeUMt95CrUnsNBMZ7isUkDRMEtgTATR0KfyODFe38QUVlFuCo/VC72JTTgSShOXA2/Pezc7lNayVYxoIQn1E0Max1Yyq0GP3am27eyPSEHNUwY6lqd1e/bklkkTmNcZeq2kBy/TcIf2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A82Gqd/7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A82Gqd/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BF8C4CEF7;
	Tue, 17 Mar 2026 17:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768455;
	bh=UhKxAc4aLLSHTBNz3bBmEgv7Wk/tGFawsZ9iX1BprKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A82Gqd/7Do3IjFTpG/1t63Y0x4xfWwqqaj29vGFdIvqy13u2uhIfhz4FQX0iswSVZ
	 d/nSXhPe0p315XY7IStASEXvUzuXR/gaJbNEiINJqkEXNwN6Po8/mGqqwjCVHkMvDF
	 6Kx4x8sfrq3ISELeyQzoX1gp1I1fOol94gD+VcqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.18 311/333] i3c: mipi-i3c-hci: Restart DMA ring correctly after dequeue abort
Date: Tue, 17 Mar 2026 17:35:40 +0100
Message-ID: <20260317163010.918736575@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit b6d586431ae20d5157ee468d0ef62ad26798ef13 upstream.

The DMA dequeue path attempts to restart the ring after aborting an
in-flight transfer, but the current sequence is incomplete. The controller
must be brought out of the aborted state and the ring control registers
must be programmed in the correct order: first clearing ABORT, then
re-enabling the ring and asserting RUN_STOP to resume operation.

Add the missing controller resume step and update the ring control writes
so that the ring is restarted using the proper sequence.

Fixes: 9ad9a52cce282 ("i3c/master: introduce the mipi-i3c-hci driver")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260306072451.11131-11-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/mipi-i3c-hci/dma.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -528,7 +528,9 @@ static bool hci_dma_dequeue_xfer(struct
 	}
 
 	/* restart the ring */
+	mipi_i3c_hci_resume(hci);
 	rh_reg_write(RING_CONTROL, RING_CTRL_ENABLE);
+	rh_reg_write(RING_CONTROL, RING_CTRL_ENABLE | RING_CTRL_RUN_STOP);
 
 	return did_unqueue;
 }


