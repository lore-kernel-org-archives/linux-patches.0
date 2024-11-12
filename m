Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BCE2309CD;
	Tue, 12 Nov 2024 10:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407874; cv=none; b=H5Dyxq7zLIBb35vThwGm7GviaaRz0/dbZ6UVH3lwLY54n7f0oYbahymNQcvMNfK9rinPnJFBD0jQepd4m1qZxvqX+WkfFQam7ohGgYE+BYNNiOcy3vU4ozQl4Nq1gFvKMMspkSzcmXsyiTZbHlXBJsqkg/TZDZmGkEgNcgTrX9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407874; c=relaxed/simple;
	bh=GoNYqleOwNKe/Z0quMGcoeerqo24w47Jb+Nd/nbmv/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a38W2QRLDdUxWzHZwhMSCgcV1Qtx+zGpAmy6dLKKN4ErWIsmd8ZBZUyXjifhSA0DtgYDQc6kKI87TrNFubVa2rmYNIuukFE9TCd/aGjWmIumguoapmcj5nhthYxKqK0u6GudTwJ4389S5MToKzx9H76GeNbZloqybBC8kL+h2es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WWaQB5Oj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WWaQB5Oj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84765C4CED6;
	Tue, 12 Nov 2024 10:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407874;
	bh=GoNYqleOwNKe/Z0quMGcoeerqo24w47Jb+Nd/nbmv/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WWaQB5Ojl3g5XhEGV6zY0yI0J/yKOuA4Y8V+tgv8ZD0t7QWb0rL/gkBB7zLBBiIvY
	 59E5IeYBKPv+hbalQvi1q5bCTyU0KGJnm2sbYtg3/VpUIFSX5AfKnFxRS64cumyauW
	 IaZA+iSWf9GGUSgBGdoFSoQJYsj5mW7oKGN7fG7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 110/119] USB: serial: io_edgeport: fix use after free in debug printk
Date: Tue, 12 Nov 2024 11:21:58 +0100
Message-ID: <20241112101852.923342991@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


