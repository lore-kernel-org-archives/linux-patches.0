Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB1D2EA478;
	Tue, 22 Jul 2025 13:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192372; cv=none; b=vAnN1oLaRo2IlyNDJAuztvh0VWexy288NL5kxv0jVzU6KX0yT3qRHwdi0zzCdX2rF7Vydwo/tOvCmWRnOmOYQtBydqhNcwDfMg7PoXV1f/LGKhwo5oXgHg3JequbUpv90Uni0KESivuHamGf4FA8oQf8BFYUDOvJjfOTcEboHD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192372; c=relaxed/simple;
	bh=InvfmkI0T7Iw7uEFRPkrKZ8rt3g/NdTbOeiA2RiGe1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cZnGrEaQfzbnmZtZho5a3t3IYtrdv5uuIKhF3tEkI8gEjCJ89jZdX3URbceRWenW67K5cevr8ztbCsBZ6gW+yO0Gu7aEZoopIUzpDlWw8sqyMRDbWmw70qSrYoaPNWxOmyVlId87S/Mw7gSlHJAu6au7da32tnNewaNG3nN6pgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x4r+oUFw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x4r+oUFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DCBEC4CEEB;
	Tue, 22 Jul 2025 13:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192372;
	bh=InvfmkI0T7Iw7uEFRPkrKZ8rt3g/NdTbOeiA2RiGe1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x4r+oUFwKMvppzk9gGpPqHq92JX15QKpgHujATLFQyGGgQnBasMPjLP2+bRIHlNxs
	 HSpkflksDLge1yXQ1015bAJYmfZtxQTYHokgt6gKHaF06u2yQJp2ivv4zIdVeLJJzx
	 EQ5SsZGRGTVRbhUN4bCgZeBUYcwKG84zfe6Hv8jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Sean Nyekjaer <sean@geanix.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 047/111] iio: accel: fxls8962af: Fix use after free in fxls8962af_fifo_flush
Date: Tue, 22 Jul 2025 15:44:22 +0200
Message-ID: <20250722134335.142953879@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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


