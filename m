Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712C9A32;
	Tue, 22 Jul 2025 14:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192910; cv=none; b=AMFuDleON2jN6ifVSqEbUHQ/ePMMyCNBFkgzmiGLYJXTqqlqhJNkbGBvUNbbzGZxzZh+ESKDX61lPpWFLezw2ItlLhlHEZ4C554aoOhofLmnU1nYrJw4mGj93Too0YkGDpS9fcy8dsHWq3u/tOeuN1OBsrJCgeuJLU9W3YZ748A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192910; c=relaxed/simple;
	bh=MP3/+FIx8vzp/+EBHfIUmHssihXVQfKAw9I3jcsZxec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WwGma/5YPqmiRLxvVSC0Yr4rmN+tC24fiJubDrKzBsVjV1CDmA/JnTUJCYF7a9zPAkzWGZXAM9Rlv/eqfTvJzszyGkIJ4rpD+Ps6Ygr8FE7E6XYkeLCPdg6ZqC/jvWIMXJhHUbEq3UAF4tqkP3/eFv68SOVbqTvWTUTXMR3tlHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eTQV03pn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eTQV03pn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F23FC4CEEB;
	Tue, 22 Jul 2025 14:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192909;
	bh=MP3/+FIx8vzp/+EBHfIUmHssihXVQfKAw9I3jcsZxec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eTQV03pnRQsbKGStpTMC+iUUUGEkIsrO+L21dlbCYXSpna6CoabBOaRSTy3bb37EX
	 cDXyMEr82XX5aj4bG2QLVAP1rInLySzaqJgYX0q2G7g8dXYY6CrYaQMgaKDylJFtgZ
	 ZF3bIfegxKBBsNCOaamyQLIkeTx7zZORXJzV+MBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Sean Nyekjaer <sean@geanix.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 067/158] iio: accel: fxls8962af: Fix use after free in fxls8962af_fifo_flush
Date: Tue, 22 Jul 2025 15:44:11 +0200
Message-ID: <20250722134343.264774767@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Nyekjaer <sean@geanix.com>

commit 1fe16dc1a2f5057772e5391ec042ed7442966c9a upstream.

fxls8962af_fifo_flush() uses indio_dev->active_scan_mask (with
iio_for_each_active_channel()) without making sure the indio_dev
stays in buffer mode.
There is a race if indio_dev exits buffer mode in the middle of the
interrupt that flushes the fifo. Fix this by calling
synchronize_irq() to ensure that no interrupt is currently running when
disabling buffer mode.

Unable to handle kernel NULL pointer dereference at virtual address 00000000 when read
[...]
_find_first_bit_le from fxls8962af_fifo_flush+0x17c/0x290
fxls8962af_fifo_flush from fxls8962af_interrupt+0x80/0x178
fxls8962af_interrupt from irq_thread_fn+0x1c/0x7c
irq_thread_fn from irq_thread+0x110/0x1f4
irq_thread from kthread+0xe0/0xfc
kthread from ret_from_fork+0x14/0x2c

Fixes: 79e3a5bdd9ef ("iio: accel: fxls8962af: add hw buffered sampling")
Cc: stable@vger.kernel.org
Suggested-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Link: https://patch.msgid.link/20250603-fxlsrace-v2-1-5381b36ba1db@geanix.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/fxls8962af-core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/accel/fxls8962af-core.c
+++ b/drivers/iio/accel/fxls8962af-core.c
@@ -865,6 +865,8 @@ static int fxls8962af_buffer_predisable(
 	if (ret)
 		return ret;
 
+	synchronize_irq(data->irq);
+
 	ret = __fxls8962af_fifo_set_mode(data, false);
 
 	if (data->enable_event)


