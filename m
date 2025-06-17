Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BDC32F94A8;
	Tue, 17 Jun 2025 16:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177264; cv=none; b=OxQmjN021cnT9wdTkRHyhyaca5iXhAw3zkjpeoECW7z8TW8AsLXjOd3Tf3p6JoTTeQDgUjJomycRfKYQ6Y0yJxqooKLBeBQBaK79okz6t8zDmhqsCPe1FfeakDT3DTbqBz6dt+MazFDyV0JLPxi8iLyUo56UxSlwib4JL2ndD1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177264; c=relaxed/simple;
	bh=y4M6hRRqwPnEnNx1Cr3oF7wNAB/WUaD0Gj+5QZq87bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjnT2bQ2Z/Ru81XIdPF8AO69zBjvIXNjNKl6VbRgkb2FTA9qz8t922Xijl6GLOvhDgKj7KleF8g4E0LLS6M1Zbtq9fl/KySFa+ECKCisA9e2w/Fm9LyWJ7h/ntWh3f0cgN5N0qqQ+tet/ICcRiYEGDmWP4e7X58kjn0rVDnaZ04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MYGDO29z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MYGDO29z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B81C4CEE3;
	Tue, 17 Jun 2025 16:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177264;
	bh=y4M6hRRqwPnEnNx1Cr3oF7wNAB/WUaD0Gj+5QZq87bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MYGDO29z5QcCWzZYglFTpiaYz9NIeu5V3y1oGzw0mpQPDU9laD0gq76LcbtAxA+W2
	 UP8nZ6J2a93ZnsYKPwHxyQMkRvUJgILBz/zHYgQZMPY/g5B3ZBKgSNrF7Azmp0LFG8
	 hGKYSl7QJKcBQHxcUcDR73nvVQA9GZXwrRhQ9i9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Pawel Laszczak <pawell@cadence.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.6 347/356] usb: cdnsp: Fix issue with detecting command completion event
Date: Tue, 17 Jun 2025 17:27:42 +0200
Message-ID: <20250617152352.105287810@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawel Laszczak <pawell@cadence.com>

commit f4ecdc352646f7d23f348e5c544dbe3212c94fc8 upstream.

In some cases, there is a small-time gap in which CMD_RING_BUSY can be
cleared by controller but adding command completion event to event ring
will be delayed. As the result driver will return error code.

This behavior has been detected on usbtest driver (test 9) with
configuration including ep1in/ep1out bulk and ep2in/ep2out isoc
endpoint.

Probably this gap occurred because controller was busy with adding some
other events to event ring.

The CMD_RING_BUSY is cleared to '0' when the Command Descriptor has been
executed and not when command completion event has been added to event
ring.

To fix this issue for this test the small delay is sufficient less than
10us) but to make sure the problem doesn't happen again in the future
the patch introduces 10 retries to check with delay about 20us before
returning error code.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/PH7PR07MB9538AA45362ACCF1B94EE9B7DD96A@PH7PR07MB9538.namprd07.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-gadget.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/usb/cdns3/cdnsp-gadget.c
+++ b/drivers/usb/cdns3/cdnsp-gadget.c
@@ -546,6 +546,7 @@ int cdnsp_wait_for_cmd_compl(struct cdns
 	dma_addr_t cmd_deq_dma;
 	union cdnsp_trb *event;
 	u32 cycle_state;
+	u32 retry = 10;
 	int ret, val;
 	u64 cmd_dma;
 	u32  flags;
@@ -577,8 +578,23 @@ int cdnsp_wait_for_cmd_compl(struct cdns
 		flags = le32_to_cpu(event->event_cmd.flags);
 
 		/* Check the owner of the TRB. */
-		if ((flags & TRB_CYCLE) != cycle_state)
+		if ((flags & TRB_CYCLE) != cycle_state) {
+			/*
+			 * Give some extra time to get chance controller
+			 * to finish command before returning error code.
+			 * Checking CMD_RING_BUSY is not sufficient because
+			 * this bit is cleared to '0' when the Command
+			 * Descriptor has been executed by controller
+			 * and not when command completion event has
+			 * be added to event ring.
+			 */
+			if (retry--) {
+				udelay(20);
+				continue;
+			}
+
 			return -EINVAL;
+		}
 
 		cmd_dma = le64_to_cpu(event->event_cmd.cmd_trb);
 


