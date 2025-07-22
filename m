Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC7C2ED16C;
	Tue, 22 Jul 2025 14:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193392; cv=none; b=ZCh4uldb4qnEc5xeTjfEcXPbZtgodE1xs9k+X5eebNdeYUD1WPHS3mV1aWsAT8j5/iJlnav+j9E6msakaSCEHgGwk9Di2paxeg5pwb8Azd/wl8SA0qHSmsCnu7bO+XLgmsbkXo5m/HfXJ2gyWdl3n5FbeVC51N6hZE7tQaZkvRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193392; c=relaxed/simple;
	bh=5Baut3D85noxLYY83+XB+q6xGEFzcdn8u3dXKUeOL4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZOSYRNxmy046GyDpaerYqzohF6AgB9qtW57L/JMfTxrMjvUHF+htqExO1OCfXMnxvRC90peMy+Cj/J0w8n05AosWE0qi776jydB1oNmEBjWAAcSJ8AFFXFsWgKYjpk26gjLJVT9R0ELzlM8YQhX+xmVpsmkXpR2uID2N1WiqbLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R5B4LaqT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R5B4LaqT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE73C4CEEB;
	Tue, 22 Jul 2025 14:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193392;
	bh=5Baut3D85noxLYY83+XB+q6xGEFzcdn8u3dXKUeOL4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R5B4LaqTkj2XNk4NpoV4cA7IdMlEgtx7IBjwgdwiOq87vTr6Y6mWxvmh2vUT8lknw
	 gI1GtUGD1KmOW/y07d0UE5B/cJubAYpi//9XX6dudyZVb5vDRgCrXN9o113hPTChbe
	 fGsAnIQOWPajyk7VenS4kUk9oWzRaHqXic94Vvl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Sean Nyekjaer <sean@geanix.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.15 079/187] iio: accel: fxls8962af: Fix use after free in fxls8962af_fifo_flush
Date: Tue, 22 Jul 2025 15:44:09 +0200
Message-ID: <20250722134348.672127507@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -877,6 +877,8 @@ static int fxls8962af_buffer_predisable(
 	if (ret)
 		return ret;
 
+	synchronize_irq(data->irq);
+
 	ret = __fxls8962af_fifo_set_mode(data, false);
 
 	if (data->enable_event)


