Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623626;
	b=n4ZqI6dmWJz4miQhrdyjFyQnKltIiieLH847vrhzPIi51aYuXVQOur713jz2u+WmHn5G
	 +A4ZxIajrtzzZOLbSL8jPwrPWsfABP52YCB+0VhaQDshZd1A6rZp0+96d5TaAV6Y/VpmL
	 YLd7DKx++vpQbvl1iyRYqt0CA+I9xcpFBprGCOBftnNFfS974pIkh8mi54sYVW44nkUMq
	 6RmmtIXMiHk2JMvE7nTzqoDmLxxm1Og4GxBYfmUEYinZ5XJL5blVL1YhWcB76OGaxS80a
	 4yHMjSJ4DxJ8YZH2rSnL1LN4IJfsv7XfWOjy0L1UdSzJumod/qmRv4PSKFS2VbHsHFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623626;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Go+rKGzJ5UEXpglZLRhEQMmyHB8SptwwZIYZmKkF3YA=;
	b=uFUG49ai/kwAjH9ro10pCItfqVkWSe8QNkTEI1MhvKLhPF5de+TYMTDSMXm0jGBaA68o
	 o85HoCmC1RGgyhmWg6Zk2Ez+VFSYzeYykFNGwow9UyS13Uar/JEomJSnTy94M03Q+OFiO
	 6NgJ9+Gdu/+6v5hgXExmvpsM0uQfVu/j2cwU2H6erxFW6Wrw43AgQUYosN2SZfCiXRrh0
	 xQh7ninz3lSBy9qXpSb6kQokaAvDEjlnkaZhSRxT8hohKaQknogEwBAyfjkaAVNQMzgDD
	 5MyU+OYd2iYMrBRtxzatC0+6pSkbgw8eMHfhKxavQ8SBfqyq4ulBq+gFi7MYrkr23Aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="eK/BdEaR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A02606A31E;
	Wed, 25 Nov 2026 16:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eK/BdEaR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E18BC1F000CF;
	Wed, 25 Nov 2026 16:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623626;
	bh=Go+rKGzJ5UEXpglZLRhEQMmyHB8SptwwZIYZmKkF3YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eK/BdEaRf/g2dNuA9gHCiFb1q3dRdv9NwJ45ANy4pelkgBzZZ8mTp+BMqqMdF+SaF
	 P9eUp7jXfsNhVw/m6Ba3b/HeEsPaiyrdfGR+rbXGr118y7GeOhe44yVdue2UZpkG81
	 vqF1rF9rPV/ws0mL/Z9G2a6FgXZdYuMT0dZAJUhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.18 883/990] comedi: ni_660x: dont poll without a DMA channel
Date: Wed, 25 Nov 2026 15:37:30 +0100
Message-ID: <20261125143842.698606211@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


