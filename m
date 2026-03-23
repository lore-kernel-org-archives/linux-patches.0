Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DEF3BA238;
	Mon, 23 Mar 2026 16:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282762; cv=none; b=GlxU7aSfXEnjO7UtDZIKKU4rsWlGPg9+J7JhW+uGwSaS7HSHgJCXSCZIcdGlxSwfV3MOkcSqf5qmJOfiGN4HVLB/7Z5G9WasrKJd0s9DGVQECSTVL+LmzOL8uTiVx89bfFHvcZPtcY0kkCaisGh9DviQp6U/cZv2x/q823UjgdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282762; c=relaxed/simple;
	bh=i3hAGPkLWTILLoNYlTW7Hl3hLY5ysr3zD0zde6VAZMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+jlveCc4huxIahwvNeqUi3tMvSm6OcvfAkwD4eeMI+V8Izt9wtFadoegiUHIeRsUBLPTfaO+52q/gPYlXuC03KStowhRkwNsmMp3gDznYxE3bOVxd9mviZdANcx7GLxf6Cyw8rl0/XXCgsF9NxPGpsjub5KkpluBhLabEDBguI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s+M7R1Gc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s+M7R1Gc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C490DC4CEF7;
	Mon, 23 Mar 2026 16:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282762;
	bh=i3hAGPkLWTILLoNYlTW7Hl3hLY5ysr3zD0zde6VAZMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s+M7R1GcJhSlqtHCtVtN15yhpnwCNn3xJEYm5Ep08woN30vqA9yIb6UpXb3XV2ixI
	 qLMCEIV7jwpLObpbdLzJdbQ3nd4sdhLCQ4zl/glRfGktdlFwE3OvYDMqoDFQ3nVk55
	 YRBm3/fSzKz2MU+RdxvoX/2UDyFIfRG7+Dj2K9Is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.1 274/481] i3c: mipi-i3c-hci: Restart DMA ring correctly after dequeue abort
Date: Mon, 23 Mar 2026 14:44:16 +0100
Message-ID: <20260323134531.805332720@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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
@@ -491,7 +491,9 @@ static bool hci_dma_dequeue_xfer(struct
 	}
 
 	/* restart the ring */
+	mipi_i3c_hci_resume(hci);
 	rh_reg_write(RING_CONTROL, RING_CTRL_ENABLE);
+	rh_reg_write(RING_CONTROL, RING_CTRL_ENABLE | RING_CTRL_RUN_STOP);
 
 	return did_unqueue;
 }


