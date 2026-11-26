Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705629;
	b=2Y+VsnA6p4qhc1xoR8p8Ka/QajwgjSS47TLvSOI+Qrmk+Y6ZvcurC3dbtijyTdZaOSo3
	 3EAMBimxATtcY1v4UVRP9wRfuK2fmOH/6OWX8A1RBOgI3a9PlJDq+E1rQcdmWspSljMIx
	 +J+Ig2kQgXrSlHwFiMIOSICMWNmtTer6FlmUvzmpyj2ZoSgUUm7bOcVx0ORP0pj3/Ihif
	 EVTzDSVxYTkxswDd0Rbrn09PdiWmvyGLcozg5nfO8QF/kVqUQDKiPH11Ka644YLBUKwZ4
	 +giRymNYjTPzcU2kqQFmnP9N2jwkQvZfJ0gNfSoa5Hg92zeGuseLkbUNyTOJoGw5VTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705629;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ml8RRv0equpW5QrzCZXpluQhQ6llhN6er3wk+L6Dtx0=;
	b=3e111VcKkj2mQkDj5v0/5qlQpsttxRPHg9fuZADgxdEv3pF6j92I8i8ahfqHqorLtQUW
	 otx9qSjE255Hyxadjx2jxbjmeYf2FAAZpKbLQBXFbYWnul65id+9YV/NLamc1UAheUWK1
	 k6n30L56VdWl8UGVJm4uYhHiOjnqciCkhkgkfn+VpAjQerpo5GVKsZNJr5m0VwC2fHkDr
	 CgZYz5Nw1z9qhO8a5zvLvTl1JYGrLfG28+DDhVjPkxHNuxrBBfqwPTtRQQYbJs4WlXdJa
	 OOMQQ4ISzCfxT28cZkM+bRKVWrwGhW7oTSpBJqmVDm+Tc9h/NtD02KvEu+QYppFWhfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PA6ldxlG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461D8606A31C;
	Thu, 26 Nov 2026 15:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PA6ldxlG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7099B1F000C6;
	Thu, 26 Nov 2026 15:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705628;
	bh=ml8RRv0equpW5QrzCZXpluQhQ6llhN6er3wk+L6Dtx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PA6ldxlGqeguiDZ5Nekrp/581pA6k1TnCQuXeSzVdLcewCt7S5n7d69/F1t99tv8a
	 N0XcOSSaFooZx7wel59kzBq5s1gDdFjTcel0sPXHaogdEASTUvJj3CDSwN3pCwu638
	 4LNbVO9EfLQvfj43iXxheaJjFW8KxUfMqy5v6QMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 5.15 260/319] comedi: ni_660x: dont poll without a DMA channel
Date: Thu, 26 Nov 2026 15:40:28 +0100
Message-ID: <20261126144012.616176072@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -460,7 +460,8 @@ static int ni_660x_input_poll(struct com
 
 	/* lock to avoid race with comedi_poll */
 	spin_lock_irqsave(&devpriv->interrupt_lock, flags);
-	mite_sync_dma(counter->mite_chan, s);
+	if (counter->mite_chan)
+		mite_sync_dma(counter->mite_chan, s);
 	spin_unlock_irqrestore(&devpriv->interrupt_lock, flags);
 	return comedi_buf_read_n_available(s);
 }


