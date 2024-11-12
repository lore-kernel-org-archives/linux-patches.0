Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0ED321A704;
	Tue, 12 Nov 2024 10:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408436; cv=none; b=S8LiBDBmAAa1AjIQwv8IWKCx1TCMklWweblTqo21jQJRsInFxCZBnOSpeJF69jgXGyNI+qZrV2sh2Ysw6OXhXgE5Ybvoi4uMqFmofekE8BICJmuDOrZCN+hmY64mvMN+bG39PP4oMcTK4vGrjjYqS73hRft7iCaar+UgN2kwck4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408436; c=relaxed/simple;
	bh=QNiDnZeIgEiKYkxa5eLbfk0SEqYKCecIFlm1KUoE+yQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ICEsDjcRT9JYzW/kkNviPImv1c7LZP3Jcf6CT5ospvKuUYXEaox2jKWEEk6w6vMCanPV1zXaYSNcsEnMfvYlH0FzVNa7kDbwDb2OjRvNWEF6eXqNz6xsvYa5JloS4toMR0/LtFFD3iknTHx7L3BN3uFherCwzPjko5wznFq97O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MiW+Um32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MiW+Um32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A351C4CECD;
	Tue, 12 Nov 2024 10:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408435;
	bh=QNiDnZeIgEiKYkxa5eLbfk0SEqYKCecIFlm1KUoE+yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MiW+Um322T0qoMmS9F2Uezld9CbtiMH3GueISX9KciyP+EbSCi3FvG7VAQO+ZyUcL
	 pn67+JjAJPInKBL59w7Tnx2Leb7m7DBTV/nCIO77GKRic8WICgyna4re26i5TvwvUL
	 ATU3omPlHAyT+ZlHzDL7aai0xQLjRd3wv9h4MOW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.11 160/184] USB: serial: io_edgeport: fix use after free in debug printk
Date: Tue, 12 Nov 2024 11:21:58 +0100
Message-ID: <20241112101907.010842832@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 37bb5628379295c1254c113a407cab03a0f4d0b4 upstream.

The "dev_dbg(&urb->dev->dev, ..." which happens after usb_free_urb(urb)
is a use after free of the "urb" pointer.  Store the "dev" pointer at the
start of the function to avoid this issue.

Fixes: 984f68683298 ("USB: serial: io_edgeport.c: remove dbg() usage")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/io_edgeport.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -770,11 +770,12 @@ static void edge_bulk_out_data_callback(
 static void edge_bulk_out_cmd_callback(struct urb *urb)
 {
 	struct edgeport_port *edge_port = urb->context;
+	struct device *dev = &urb->dev->dev;
 	int status = urb->status;
 
 	atomic_dec(&CmdUrbs);
-	dev_dbg(&urb->dev->dev, "%s - FREE URB %p (outstanding %d)\n",
-		__func__, urb, atomic_read(&CmdUrbs));
+	dev_dbg(dev, "%s - FREE URB %p (outstanding %d)\n", __func__, urb,
+		atomic_read(&CmdUrbs));
 
 
 	/* clean up the transfer buffer */
@@ -784,8 +785,7 @@ static void edge_bulk_out_cmd_callback(s
 	usb_free_urb(urb);
 
 	if (status) {
-		dev_dbg(&urb->dev->dev,
-			"%s - nonzero write bulk status received: %d\n",
+		dev_dbg(dev, "%s - nonzero write bulk status received: %d\n",
 			__func__, status);
 		return;
 	}


