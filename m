Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C60A2E4984;
	Tue, 15 Jul 2025 13:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585894; cv=none; b=KvIfEIc+LCTcDkZM5HlZlg8a2JmyEYaudhTjieosXhbv7NUw4AKpSGwM5X9yG5uR6GY8cqRqiIVtG7pBCeFwJs3Zdix0aatVZ5WO1xPNqIKhPEdD1C9hamxGcZ2gQMzHnKF+JC9/luovEEZIiUIjRB3ZE4wAdDeUVX76b+cJQzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585894; c=relaxed/simple;
	bh=CxlemCWH6nzzt2Gsva6eA7CkTGpbtJgkp9Ro0wR8cpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AcdwrzC+wkcBQbmUf+naIz5AhKp74O9RaQZbhEDKMn67Euj1Q3TyWnYhRCbDaxure5V+2XpQ8b/pPaPhByZ9q1gixfI+yPjjgRVJqKtaFmYVcLhlREX4D538ZU1PHRmj/VaNfalHR6OujkhIyNHbg7+vH6YXxYa5UXamkwV/NLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gkV1yZtr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gkV1yZtr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92FA7C4CEE3;
	Tue, 15 Jul 2025 13:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585893;
	bh=CxlemCWH6nzzt2Gsva6eA7CkTGpbtJgkp9Ro0wR8cpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gkV1yZtreclyljWsXiqcOFfS14Twob+7fo4qDjJf8GYlnOUuNlUkYpEps+U55KvZv
	 myQt2yaKd/ozGDi1YvXVWaXWZGzg/k0vF0q2R8e3X4+QAXoIJtm+g/HZ3+gJrENHHj
	 kS4i7HsMSi0vJYd2tsdXs0126VOGHUHWxZznUsTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Kuen-Han Tsai <khtsai@google.com>,
	Prashanth K <prashanth.k@oss.qualcomm.com>
Subject: [PATCH 6.6 048/109] Revert "usb: gadget: u_serial: Add null pointer check in gs_start_io"
Date: Tue, 15 Jul 2025 15:13:04 +0200
Message-ID: <20250715130800.798395989@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

From: Kuen-Han Tsai <khtsai@google.com>

commit f6c7bc4a6823a0a959f40866a1efe99bd03c2c5b upstream.

This reverts commit ffd603f214237e250271162a5b325c6199a65382.

Commit ffd603f21423 ("usb: gadget: u_serial: Add null pointer check in
gs_start_io") adds null pointer checks at the beginning of the
gs_start_io() function to prevent a null pointer dereference. However,
these checks are redundant because the function's comment already
requires callers to hold the port_lock and ensure port.tty and port_usb
are not null. All existing callers already follow these rules.

The true cause of the null pointer dereference is a race condition. When
gs_start_io() calls either gs_start_rx() or gs_start_tx(), the port_lock
is temporarily released for usb_ep_queue(). This allows port.tty and
port_usb to be cleared.

Fixes: ffd603f21423 ("usb: gadget: u_serial: Add null pointer check in gs_start_io")
Cc: stable <stable@kernel.org>
Signed-off-by: Kuen-Han Tsai <khtsai@google.com>
Reviewed-by: Prashanth K <prashanth.k@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250617050844.1848232-1-khtsai@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/u_serial.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/usb/gadget/function/u_serial.c
+++ b/drivers/usb/gadget/function/u_serial.c
@@ -539,20 +539,16 @@ static int gs_alloc_requests(struct usb_
 static int gs_start_io(struct gs_port *port)
 {
 	struct list_head	*head = &port->read_pool;
-	struct usb_ep		*ep;
+	struct usb_ep		*ep = port->port_usb->out;
 	int			status;
 	unsigned		started;
 
-	if (!port->port_usb || !port->port.tty)
-		return -EIO;
-
 	/* Allocate RX and TX I/O buffers.  We can't easily do this much
 	 * earlier (with GFP_KERNEL) because the requests are coupled to
 	 * endpoints, as are the packet sizes we'll be using.  Different
 	 * configurations may use different endpoints with a given port;
 	 * and high speed vs full speed changes packet sizes too.
 	 */
-	ep = port->port_usb->out;
 	status = gs_alloc_requests(ep, head, gs_read_complete,
 		&port->read_allocated);
 	if (status)


