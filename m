Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E6E3FF1BD;
	Fri, 15 May 2026 16:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862343; cv=none; b=ZQNn6afKYUoG41Kl0Zz+8WYeiyVrcgyVkOxyVkP6RXY9TsK09byKgGQZRTSY0RaUgerA1JHjE72Af2xw1t0JvUhawCGJhRGJeviUWYSJka9TqBHsZ4R4GMnD5NvgFZ43sTVGOPDgSWfuWi0kqtjmYI0QKXUZyhu63C9HDHfqu88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862343; c=relaxed/simple;
	bh=Ori2c8vsEx2JRMbOcBmavVwvpWEVJfsgy/ZFerEFFZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ImZX7FqpjNdh5v0B7n2AF5TvqhDn3qvdHD0TTa+QbqDZgLhnZFSALosX2WpYjPZjVDDb7lZwoQ1eRX9jeQKt96C/MN4WvYrFijTaWZZgbfo+9CH+jVcweEYFPFTEFAKortjEyYPq442dN0HWHoC50wCw4Ald3xczokK3jqeXz4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pKjSbRqk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pKjSbRqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACEC3C2BCB0;
	Fri, 15 May 2026 16:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862343;
	bh=Ori2c8vsEx2JRMbOcBmavVwvpWEVJfsgy/ZFerEFFZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pKjSbRqkxKTPGDrw1bpPOey6H56jP34EZptBLCYeYztligeD/SZ5vgpWOmAnrTiQv
	 Ie8dM2rVP/vmc5eC/VN8mfL1hEMLP42PNYTyWO5YDqC+8lpNdpEECEYqq4msCcjBby
	 mTC2OfWyPnHv6ei5pfGqy13aSckzxkMGSl8F+Sg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Scally <dan.scally@ideasonboard.com>,
	=?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <barnabas.pocze+renesas@ideasonboard.com>,
	Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.0 013/201] media: rzv2h-ivc: Fix concurrent buffer list access
Date: Fri, 15 May 2026 17:47:11 +0200
Message-ID: <20260515154658.824430519@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barnabás Pőcze <barnabas.pocze+renesas@ideasonboard.com>

commit 72773ff1cdfaebc593f53b1719b2c1773ecf8c43 upstream.

The list of buffers (`rzv2h_ivc::buffers.queue`) is protected by a
spinlock (`rzv2h_ivc::buffers.lock`). However, in
`rzv2h_ivc_transfer_buffer()`, which runs in a separate workqueue, the
`list_del()` call is executed without holding the spinlock, which makes
it possible for the list to be concurrently modified

Fix that by removing a buffer from the list in the lock protected section.

Cc: stable@vger.kernel.org
Fixes: f0b3984d821b ("media: platform: Add Renesas Input Video Control block driver")
Reviewed-by: Daniel Scally <dan.scally@ideasonboard.com>
Signed-off-by: Barnabás Pőcze <barnabas.pocze+renesas@ideasonboard.com>
[assign ivc->buffers.curr in critical section as reported by Barnabas]
Signed-off-by: Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc-video.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc-video.c
+++ b/drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc-video.c
@@ -158,14 +158,13 @@ static void rzv2h_ivc_transfer_buffer(st
 	scoped_guard(spinlock_irqsave, &ivc->buffers.lock) {
 		buf = list_first_entry_or_null(&ivc->buffers.queue,
 					       struct rzv2h_ivc_buf, queue);
-	}
-
-	if (!buf)
-		return;
+		if (!buf)
+			return;
 
-	list_del(&buf->queue);
+		list_del(&buf->queue);
+		ivc->buffers.curr = buf;
+	}
 
-	ivc->buffers.curr = buf;
 	buf->addr = vb2_dma_contig_plane_dma_addr(&buf->vb.vb2_buf, 0);
 	rzv2h_ivc_write(ivc, RZV2H_IVC_REG_AXIRX_SADDL_P0, buf->addr);
 


