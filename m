Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D803309F09;
	Mon, 13 Apr 2026 16:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097687; cv=none; b=corw7w6CRPLcwuB9e8ybEX3vCxvVS8rr6Gsr39sllbaGfwv5Q4fzS2aplSBmXEZSCourGjifQVmV+qjh9lXRGUJwholPBp6qaGgNM/kkvwc+yJFuQf/ipaY/WMsN+wrxA4RGLD6PMo+7MCdNYjCA3e3xcqy5zmWtHpxj4HgccyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097687; c=relaxed/simple;
	bh=7M+DyC4uaE3E/yq6DUkbuIrkaumDHBVphZUwmfXuT2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HOxlD7rPhGeGiX+ZC6m0mAOvXTP2/jBK+o7w+aZGbSjinZ0DV4ngH5ux7oRtaOH61OfBApsiRGwagUaI94yhyldNvja8I8Wh6MZaOWMw+9aHExkoVeg/nhuIIwDHPQgKjZN1VjwdZQcBlL3a+KAKgd3fVQsum7uTk59SzAvrNCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h4BZrt0y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4BZrt0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7663C2BCAF;
	Mon, 13 Apr 2026 16:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097687;
	bh=7M+DyC4uaE3E/yq6DUkbuIrkaumDHBVphZUwmfXuT2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4BZrt0yt+g8/3Z8KVW+ba3MS0u/zvIjvlkAwFsdXVS9yJRRfAkx3U/4loEXsuQNg
	 FKmHnf0ErU/uIZzVVNQISS59k3lcdLugNT5jHraAMEU2PNt7czBbU396zXR0pC49wL
	 51Y6ZUzZ29xi5shw6qZ7m20UYbv6YTqXLjIIJafY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.15 191/570] i3c: mipi-i3c-hci: Restart DMA ring correctly after dequeue abort
Date: Mon, 13 Apr 2026 17:55:22 +0200
Message-ID: <20260413155837.614639368@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


