Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BC829D26C;
	Tue, 17 Mar 2026 17:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766984; cv=none; b=l4ps6rNn5KWaoHy53eimZgodZfR2TaB89eEL/ZYVnoLuM/SaCEspkDiN5qhO+DI++l8Ep7+44lZeRxfkRYT3yEurPAwf8QGBTiki6cD4yXWwaT2VGpuUEQ1+PKW0ZbOrqpvGWkVr0ty0LsvOIbzeH+qnEs1ue0/uCg7Z3BOrSuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766984; c=relaxed/simple;
	bh=eqof6o9LSwcHF3bOQzKBVZHm4HWI/CghhsG4FHr8+Sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khcXemHmFgD/m0in2FfB93lGlhss2thlWk09tqX3/LEhlOAcAftI/nnDWAVYoST9GjGsw1HkExSlhtc1q7zfjGir/fNSohj1ITc3slfAWLTSV14we9RK9bEsbP3wZeLgqIMzNuOZyoWZCbh7mXV4+C8m8o90KfV+qJQkI88xd/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WDrzVw9Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WDrzVw9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829E5C4CEF7;
	Tue, 17 Mar 2026 17:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766984;
	bh=eqof6o9LSwcHF3bOQzKBVZHm4HWI/CghhsG4FHr8+Sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WDrzVw9ZuP5MBtJR6ChZvTtaILRNRk743PidFwKc5R4XWUZVsjOTytNLgeBwxCgzf
	 EMAZYkCdzgmaS5w3eKrtJvgHqPecIy7yN8hzwhE5M3bLbj58QxhRkk1zqo+1HQlBvC
	 LZ5bSdPa7OgbQm9WoiHnegO0lJyDzTr6lybGxpzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.19 367/378] i3c: mipi-i3c-hci: Restart DMA ring correctly after dequeue abort
Date: Tue, 17 Mar 2026 17:35:24 +0100
Message-ID: <20260317163020.481441464@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


