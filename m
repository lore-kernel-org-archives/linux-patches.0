Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C5E2F39BC;
	Fri, 10 Oct 2025 13:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102559; cv=none; b=FJvPlVM+rh5JMWFyvRpus5RSiRRXnYMB6wq17vUw8oSL4PGee5cXcfbSDF7z59+snl6seUTF5TbWVSP8QXZZTQ9RUbtq6V/jwbTpvmdw4hAienCFwRjGg+Br1vu3/7nelQEQnOz1uMJrbifieQ0Nw/I4V3XC6R1Ir1B6r3IX9xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102559; c=relaxed/simple;
	bh=frQj4bdUQ3XBMTg4vve3dgLr2kX3FUuaEC1bGJD0S68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RX9O29/zDTX1EwYjKSVwi/SO0lpnuP7buojcO6uNR2jkgXwovUoMzvFHVN8vOQ4lieDaUCIp5rtbx2XUm2EtSkWI88xg8KOpzOUCpKUDc8rRosis4bu1aZeFT6RbQ3ei1V/zAAVjJKk60cnCG615FdmCYsRVA7eNGn3TSYHyDsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1zn6XK9N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1zn6XK9N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7035AC4CEF1;
	Fri, 10 Oct 2025 13:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102558;
	bh=frQj4bdUQ3XBMTg4vve3dgLr2kX3FUuaEC1bGJD0S68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1zn6XK9NsjrKqwRPcWVZBrkmNDpQhYNKoOgmmdlXeDLiEbGvzBNd/HFTcu6C5qlLO
	 FG9krhFt+RxsxbJpOCuOJwHRog3pTJKrDpUVCC/YSFHnCnCpkihlb7gxldGs28YbqX
	 W7/Z1iz/XofJkT0N1aMQOKxXTnYSHO3MwUUP+Ze8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Subject: [PATCH 6.6 20/28] staging: axis-fifo: fix maximum TX packet length check
Date: Fri, 10 Oct 2025 15:16:38 +0200
Message-ID: <20251010131331.099776092@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131330.355311487@linuxfoundation.org>
References: <20251010131330.355311487@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>

commit 52ff2b840bc723f3be1f096f8017c78e0515858c upstream.

Since commit 2ca34b508774 ("staging: axis-fifo: Correct handling of
tx_fifo_depth for size validation"), write() operations with packets
larger than 'tx_fifo_depth - 4' words are no longer rejected with -EINVAL.

Fortunately, the packets are not actually getting transmitted to hardware,
otherwise they would be raising a 'Transmit Packet Overrun Error'
interrupt, which requires a reset of the TX circuit to recover from.

Instead, the request times out inside wait_event_interruptible_timeout()
and always returns -EAGAIN, since the wake up condition can never be true
for these packets. But still, they unnecessarily block other tasks from
writing to the FIFO and the EAGAIN return code signals userspace to retry
the write() call, even though it will always fail and time out.

According to the AXI4-Stream FIFO reference manual (PG080), the maximum
valid packet length is 'tx_fifo_depth - 4' words, so attempting to send
larger packets is invalid and should not be happening in the first place:

> The maximum packet that can be transmitted is limited by the size of
> the FIFO, which is (C_TX_FIFO_DEPTH–4)*(data interface width/8) bytes.

Therefore, bring back the old behavior and outright reject packets larger
than 'tx_fifo_depth - 4' with -EINVAL. Add a comment to explain why the
check is necessary. The dev_err() message was removed to avoid cluttering
the dmesg log if an invalid packet is received from userspace.

Fixes: 2ca34b508774 ("staging: axis-fifo: Correct handling of tx_fifo_depth for size validation")
Cc: stable@vger.kernel.org
Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Link: https://lore.kernel.org/r/20250817171350.872105-1-ovidiu.panait.oss@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/axis-fifo/axis-fifo.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/staging/axis-fifo/axis-fifo.c
+++ b/drivers/staging/axis-fifo/axis-fifo.c
@@ -491,11 +491,17 @@ static ssize_t axis_fifo_write(struct fi
 		return -EINVAL;
 	}
 
-	if (words_to_write > fifo->tx_fifo_depth) {
-		dev_err(fifo->dt_device, "tried to write more words [%u] than slots in the fifo buffer [%u]\n",
-			words_to_write, fifo->tx_fifo_depth);
+	/*
+	 * In 'Store-and-Forward' mode, the maximum packet that can be
+	 * transmitted is limited by the size of the FIFO, which is
+	 * (C_TX_FIFO_DEPTH–4)*(data interface width/8) bytes.
+	 *
+	 * Do not attempt to send a packet larger than 'tx_fifo_depth - 4',
+	 * otherwise a 'Transmit Packet Overrun Error' interrupt will be
+	 * raised, which requires a reset of the TX circuit to recover.
+	 */
+	if (words_to_write > (fifo->tx_fifo_depth - 4))
 		return -EINVAL;
-	}
 
 	if (fifo->write_flags & O_NONBLOCK) {
 		/*


