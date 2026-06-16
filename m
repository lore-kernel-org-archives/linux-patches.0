Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB29472769;
	Tue, 16 Jun 2026 16:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628414; cv=none; b=BhntjZC/AZAeHpv8fM9Bnax3mQhPa8TcynlfjB7cCdoOoaSHijvFTvHdtlk/ax+TAn4bL9VHy2dYVyTDZtJTB4tVOcuLpI3iMiEVy/OG51e8hMLq5WoJfRFS3wrvUUJuQ2pctEjK1ZIykg4w/yPgfCvPWjqG9zxXWmnLlge4MJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628414; c=relaxed/simple;
	bh=HYIvruyAxWnBmgCRBkqgTiOZ7jTsLaFsak2MqHvSB/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPF0cYxBj7Ia7Vv0Jgx2TmJ48ANMgRwOve4rq0dxBQjNLLtpCmnN87QoJ2q3UQOoLQ3Y5ECKkJ/nK8v7/WVF8SxF7Ow6hZFuD1IdwQVYBhOnxLq2LvbSM0hLw1tq6TB7S7yMWH7N8h9e9FVhSVhgW5F1fPM+BoaOhOutc8QZP2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0nFuMq5R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0nFuMq5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67751F000E9;
	Tue, 16 Jun 2026 16:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628412;
	bh=Rh9NS7EjoAmovKZBELHiQjCfkuCT54Elb0EfyjcM+JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0nFuMq5RR5SHVLb+2fWf8i+U/yb7mGbz2HJSzXhw5xE2OyOAYyG1293XkhAp/ArG3
	 7+oD/g+OUrYwoxwf2Z3JnOuzVw5wvgkqEwy7Rr4j8ZT5DHGqDJWUUx8JX9HE3QMLSJ
	 im5w93qmFj4TkGt99nJzua1sZX1EiQTpGJ+kaoJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 091/452] Input: ims-pcu - fix usb_free_coherent() size in ims_pcu_buffers_free()
Date: Tue, 16 Jun 2026 20:25:18 +0530
Message-ID: <20260616145122.615651345@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Thomas Fourier <fourier.thomas@gmail.com>

commit dab48a7e74e6a394f3aa0461a2b1fb0c7b38fcb8 upstream.

The input buffer size is pcu->max_in_size, but pcu->max_out_size is
passed to usb_free_coherent().

Change size to match the allocation size.

Fixes: 628329d52474 ("Input: add IMS Passenger Control Unit driver")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://patch.msgid.link/20260522085412.45430-2-fourier.thomas@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/ims-pcu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -1598,7 +1598,7 @@ static void ims_pcu_buffers_free(struct
 	usb_kill_urb(pcu->urb_in);
 	usb_free_urb(pcu->urb_in);
 
-	usb_free_coherent(pcu->udev, pcu->max_out_size,
+	usb_free_coherent(pcu->udev, pcu->max_in_size,
 			  pcu->urb_in_buf, pcu->read_dma);
 
 	kfree(pcu->urb_out_buf);


