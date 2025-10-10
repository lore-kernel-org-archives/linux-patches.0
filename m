Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FD32F291D;
	Fri, 10 Oct 2025 13:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102405; cv=none; b=FeTF8UDVdVUi3QV5g+86fbao6ORX5deg1vFvc0g75ZloZFdr6Xh9sFZCTx8YkpnWuGiaCEP+PHmvy1nfEIwrYm5ZnuhJQ9UGNSb5f6H0O2WQxvzjYrA1i14ppmeq4ZS0Za8yQjxfTg6HWYdV8yqtH3xqqc9HhySdYnPgX9BpqLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102405; c=relaxed/simple;
	bh=nIAFPR6IO7NI578m9VShAk3wVj2awsuiajVHYtYMp6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S2gyJxMTNXgCm3qzHOXj4Winqg7SbnyLq9OfXLaPIKAkDLK7s+8HSkBMYGV+IWKru8uF6+nWr7jabeQ7mLEXBrJJa4cZPTcF26nboB5ueyIfOFoEfF3fJ56075sJLimq4PzR9z9i9mfdHprbVnKFyGinj3CgNK/+gIhk5TS4Xfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DJtK2tBO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DJtK2tBO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA74C4CEF8;
	Fri, 10 Oct 2025 13:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102405;
	bh=nIAFPR6IO7NI578m9VShAk3wVj2awsuiajVHYtYMp6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DJtK2tBOuRQcKWBNJn65I4CRbhQAvN/lyWsIh4l4mIafU09mfa6iZzVRvxtpB5Hhx
	 P/Fw75/qmyHaW5E1wqEhtA5fRx6qo8wQD1to3jeL5C7rqMf+5ZijYhTyfkdfyr5JHm
	 BAkJXCFsg48Dmn0T/2qoG5EF3QiFtgr9TDZ+WMtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Subject: [PATCH 6.16 33/41] staging: axis-fifo: fix maximum TX packet length check
Date: Fri, 10 Oct 2025 15:16:21 +0200
Message-ID: <20251010131334.611545364@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
References: <20251010131333.420766773@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -486,11 +486,17 @@ static ssize_t axis_fifo_write(struct fi
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


