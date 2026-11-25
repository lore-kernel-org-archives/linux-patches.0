Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620487;
	b=I9NADtxSaeldIdVOxVZNHyyu1+MbJ6ImKpzyyBxEaktHcLaoaeIlUIu/mpc8hNgfVzPd
	 Rq4a2FpMTjeXngr0vqBaqxjjimTwB1vICg6eNq4csVH7N94HU7QCgOovcWQmrNCmSmYhq
	 xkmg9SWtDn9gLPM5lF98ZUieDUUNvV6AF5nS3DVaAkWVUg+Le9ECYwH4i6yPBxWKTS36H
	 68WotPlhuoO4LF8CjuRUrrrwXYLnjhYT9vEySRYr+zVHzTC5HPt/VtAyI5jwBuTHRUnoz
	 HaqZ9SKhKmF5LoeCx0PbWapZCCd6UrdWXzYtwGtQg8vGrFT2S7FYZf1qHdBgZEqUCeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620487;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BV3pK8WkWD9uQdh3svrnC1HZjqbPSrLLiS2UqnnPZ9c=;
	b=ZIG37gEPhHd3yyHO16Z2bjrw12ywnne+VbdxSD3xPaFtwHRTYZ2dl1VEMEKhraCbaTv+
	 n97Ju4YL79aB9wwa09FeoyRzyit/6bBvcQgVu5tqEUYw3MVnZq+37jeXnS+HPAaYNIm8b
	 5sl+E6X0IRKP4rt0qcCG3tkIbOcXHLaVBuwr8jgtjtLSHm05pUCLywAoPpaYrL+9615FB
	 XdvKvJ4jCZ5WiIsBtVh+SIwew7DYTNhhvfaxR48U57laB5ZDtn734WwTHpvGt0wFB5cma
	 vF7pz43lwrUTw/49g/uoKeL47RH+uGxpMhnWLNi4sajMFRuHBN6RQb4OYahlOIWujgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fdmTFbEQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910C4606A327;
	Wed, 25 Nov 2026 15:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fdmTFbEQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FBC1F000D0;
	Wed, 25 Nov 2026 15:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620487;
	bh=BV3pK8WkWD9uQdh3svrnC1HZjqbPSrLLiS2UqnnPZ9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fdmTFbEQ0y4GNp9WT20GpNo/eOQdQMrpP5oR4UkrOi3e3pt0XPr+8S6mlmJLBGovY
	 XDrixr6zLYxaId2haJNO2WZOkJcLOCN99HaxOkhh7cO/4rkd9kWIWvm/3W8zevMSq4
	 qSRd9xoj6pDqK7zqnOjvVgQEyqqWLMdpsZEGRR+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 7.3 0889/1005] comedi: ni_660x: dont poll without a DMA channel
Date: Wed, 25 Nov 2026 15:37:07 +0100
Message-ID: <20261125143842.523420497@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit 5a0c88567a5ebbe24ecb7828e200f63ed972718f upstream.

A counter command owns a MITE DMA channel from ni_660x_cmd() to
ni_660x_cancel(). A command does not only end by COMEDI_CANCEL: when the
reader is too slow mite_sync_input_dma() sets COMEDI_CB_OVERFLOW, and
counter errors set COMEDI_CB_ERROR, and comedi_handle_events() then calls
->cancel() from the interrupt handler. That releases the channel and
clears counter->mite_chan, but s->busy stays set until the owner has read
the rest of the data and seen the end of the acquisition.

do_poll_ioctl() only looks at s->busy, so a COMEDI_POLL in that state
ends in mite_sync_dma(NULL, s), which dereferences the channel.

Test the channel like ni_pcidio_poll() and ni_sync_ai_dma() do. The
pointer only changes under dev->mutex, which the ioctl holds, or in the
interrupt handler under interrupt_lock, which is taken here.

Fixes: 894db1197347 ("Staging: Comedi: ni_600x: Added support for comedi_poll.")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261027-llm-char-misc-comedi-v1-3-1899771ee15b@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/drivers/ni_660x.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/comedi/drivers/ni_660x.c
+++ b/drivers/comedi/drivers/ni_660x.c
@@ -459,7 +459,8 @@ static int ni_660x_input_poll(struct com
 
 	/* lock to avoid race with comedi_poll */
 	spin_lock_irqsave(&devpriv->interrupt_lock, flags);
-	mite_sync_dma(counter->mite_chan, s);
+	if (counter->mite_chan)
+		mite_sync_dma(counter->mite_chan, s);
 	spin_unlock_irqrestore(&devpriv->interrupt_lock, flags);
 	return comedi_buf_read_n_available(s);
 }


