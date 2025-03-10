Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C330B230988;
	Mon, 10 Mar 2025 17:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626914; cv=none; b=dCPZTh7LCXGfFoXygyz9dBcrkXrOt9x89Qv/p9xSrMTpXc3Fe+QKDbL43LuO98qByxWTz3kJOwmEk/dvYW/NPPH4rNiTxb7Db9sNIcB0SDMCMHxuMGY045nVKuXOOMSv3pd266lkVmhHJbhmuy9s8Fx6j5zLFHRYMqRrs1I0KKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626914; c=relaxed/simple;
	bh=1AmeVFjHe+0LP4SSkNVGniDiUjFHVVnaswomeBpUmDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GcD1e6gT7d08vwDIJA/uWH1bfkQy9CiaGq4zMbfyivTzAZ9wxBH83gpycrSqKoVe5yKQFxZxzCckseXZDGlazShMQtFkDDdPQIFFewi6l3VFyKQOTaLpQmXWXnk6PZOX3akGPNRq/Y21HaYtUL9oZaUxzEqYQyT93wHkTz3UsmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rc7l/d8V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rc7l/d8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43103C4CEEB;
	Mon, 10 Mar 2025 17:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626914;
	bh=1AmeVFjHe+0LP4SSkNVGniDiUjFHVVnaswomeBpUmDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rc7l/d8VwDQ2vjFCOOlWp+Y9cABpA85HyNfgOWilroc7bTuF7tWuHU5wPcLgiPNBM
	 1x6VgV5Q7WtuqSFoJ5mXNshyjQM9eeRx5SNjOO6phBUZqvSUmT8K4cZGH2/H24qKAa
	 w6SgmUMdvD/hn8Y8XOzwEAm667hQJxEi1yufalxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.13 157/207] usb: xhci: Fix host controllers "dying" after suspend and resume
Date: Mon, 10 Mar 2025 18:05:50 +0100
Message-ID: <20250310170454.034631245@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

From: Michal Pecio <michal.pecio@gmail.com>

commit c7c1f3b05c67173f462d73d301d572b3f9e57e3b upstream.

A recent cleanup went a bit too far and dropped clearing the cycle bit
of link TRBs, so it stays different from the rest of the ring half of
the time. Then a race occurs: if the xHC reaches such link TRB before
more commands are queued, the link's cycle bit unintentionally matches
the xHC's cycle so it follows the link and waits for further commands.
If more commands are queued before the xHC gets there, inc_enq() flips
the bit so the xHC later sees a mismatch and stops executing commands.

This function is called before suspend and 50% of times after resuming
the xHC is doomed to get stuck sooner or later. Then some Stop Endpoint
command fails to complete in 5 seconds and this shows up

xhci_hcd 0000:00:10.0: xHCI host not responding to stop endpoint command
xhci_hcd 0000:00:10.0: xHCI host controller not responding, assume dead
xhci_hcd 0000:00:10.0: HC died; cleaning up

followed by loss of all USB decives on the affected bus. That's if you
are lucky, because if Set Deq gets stuck instead, the failure is silent.

Likely responsible for kernel bug 219824. I found this while searching
for possible causes of that regression and reproduced it locally before
hearing back from the reporter. To repro, simply wait for link cycle to
become set (debugfs), then suspend, resume and wait. To accelerate the
failure I used a script which repeatedly starts and stops a UVC camera.

Some HCs get fully reinitialized on resume and they are not affected.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=219824
Fixes: 36b972d4b7ce ("usb: xhci: improve xhci_clear_command_ring()")
Cc: stable@vger.kernel.org
Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250304113147.3322584-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -779,8 +779,12 @@ static void xhci_clear_command_ring(stru
 	struct xhci_segment *seg;
 
 	ring = xhci->cmd_ring;
-	xhci_for_each_ring_seg(ring->first_seg, seg)
+	xhci_for_each_ring_seg(ring->first_seg, seg) {
+		/* erase all TRBs before the link */
 		memset(seg->trbs, 0, sizeof(union xhci_trb) * (TRBS_PER_SEGMENT - 1));
+		/* clear link cycle bit */
+		seg->trbs[TRBS_PER_SEGMENT - 1].link.control &= cpu_to_le32(~TRB_CYCLE);
+	}
 
 	xhci_initialize_ring_info(ring);
 	/*


