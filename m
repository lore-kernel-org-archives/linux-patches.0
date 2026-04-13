Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E164307AC7;
	Mon, 13 Apr 2026 16:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098624; cv=none; b=V1BlfYA/KSqNm6soUUK/opONn6bKTXrmhKgv6LmkEoRkEptFOaxvPhI3t1uaXIuiRZa5t0vaOrf+7MmqGu71efumWJOVr2tFEWS9VoW9tUkOfMlYxDcg8iWRdG/NCp2j9LEy23KTCHY+0BW4Fi9Aw42Lyxa/cXJV/grQX1FgAPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098624; c=relaxed/simple;
	bh=Wi7yVG87MFOJt5g8iJNBjGxQekhjHH9MQypli/5XHno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWVQM33r1cPzTFWXT7UvA+0r/W/rfWmRxrLWMT/yBNdY06i7iEe0s0uOieHv7lpvBe+FnRy+WnirsNBgifaS/+moi8k1t1Cf15aq4HgrKyrwcPAy0xWy3ZpsFlpPUBjsAlYc9P7H1436RvI6RBIe8ZjuFXEGGoji8Vn2RrFdjAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VH5342Yy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VH5342Yy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26543C2BCAF;
	Mon, 13 Apr 2026 16:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098624;
	bh=Wi7yVG87MFOJt5g8iJNBjGxQekhjHH9MQypli/5XHno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VH5342Yy1HX5LitBivB53CP8zQ3yuI1uZsR35vgfwlSrbTyGDnqPv4l0P6aKYRaGN
	 hRGa+Ojlf6fz5AwUhySjBMN2Zt4PsJE6WgjBoobq0486qxJxRNdHQoVh8sJe3hUgNd
	 eneL3AdXqxPyAmuLnoDmsMHVX7VxrdMlqqpR3AxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Vincent Mailhol <mailhol@kernel.org>,
	stable@kernel.org
Subject: [PATCH 5.10 025/491] can: ucan: Fix infinite loop from zero-length messages
Date: Mon, 13 Apr 2026 17:54:30 +0200
Message-ID: <20260413155819.995406049@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 1e446fd0582ad8be9f6dafb115fc2e7245f9bea7 upstream.

If a broken ucan device gets a message with the message length field set
to 0, then the driver will loop for forever in
ucan_read_bulk_callback(), hanging the system.  If the length is 0, just
skip the message and go on to the next one.

This has been fixed in the kvaser_usb driver in the past in commit
0c73772cd2b8 ("can: kvaser_usb: leaf: Fix potential infinite loop in
command parsers"), so there must be some broken devices out there like
this somewhere.

Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Vincent Mailhol <mailhol@kernel.org>
Cc: stable@kernel.org
Assisted-by: gkh_clanker_2000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2026022319-huff-absurd-6a18@gregkh
Fixes: 9f2d3eae88d2 ("can: ucan: add driver for Theobroma Systems UCAN devices")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/ucan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -745,7 +745,7 @@ static void ucan_read_bulk_callback(stru
 		len = le16_to_cpu(m->len);
 
 		/* check sanity (length of content) */
-		if (urb->actual_length - pos < len) {
+		if ((len == 0) || (urb->actual_length - pos < len)) {
 			netdev_warn(up->netdev,
 				    "invalid message (short; no data; l:%d)\n",
 				    urb->actual_length);


