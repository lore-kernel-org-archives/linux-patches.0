Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22663B9D97;
	Mon, 23 Mar 2026 16:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282222; cv=none; b=B9YpjGTZ9RkUfGCnj7pDGq/78oPPbbPB4adV3wLmMWblH77hmzXGUG3FAX4jsceCLerJ6BYBDPbV5jhHGcb1eLvfRW6eTwAL8+z/FMFAcbf92M9im7zvqz8dMSWSpHU5wMvAH9wD79a/aSu6SXFD04ha7sTl+e5Owvg4awvaC0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282222; c=relaxed/simple;
	bh=mj8gUYt5wYomzfC4jqZbuczVkdlJcWDtZbVIIADy2bQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CjcUVUPJAfaxZFG0t1IE8ftxGiE4F1uN2+Xt1rw30YOM5Oc+je/84n1cPE63RRCFW8Z8zRWa+RmFFCa7k5EjqMhulBxAPGU4hduht9RVtAs9BYtR/f5BHGqECrbYT8hmcrVXsu25dU+diBa3Ks+X98323JOUzNUI9BmpGKteK+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aVZ9+tHG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aVZ9+tHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B77C4CEF7;
	Mon, 23 Mar 2026 16:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282221;
	bh=mj8gUYt5wYomzfC4jqZbuczVkdlJcWDtZbVIIADy2bQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVZ9+tHGTDTtcGUFqvPRQp/jN+hUFvsA4N4GwtJ2KTXEEOEGLKo8AiE6m8Wt3ixWC
	 SRJ9CwYwFhgadqjW6s6GbNi4UanmSAiDsxX8zl+G+l4OOJock+XdVedBeLAVjaW1st
	 wmnnDIoDni4PYraacZR+8tZT4SCKUy0yPyDHfqRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	stable@kernel.org
Subject: [PATCH 6.1 075/481] can: ems_usb: ems_usb_read_bulk_callback(): check the proper length of a message
Date: Mon, 23 Mar 2026 14:40:57 +0100
Message-ID: <20260323134527.062150850@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 38a01c9700b0dcafe97dfa9dc7531bf4a245deff upstream.

When looking at the data in a USB urb, the actual_length is the size of
the buffer passed to the driver, not the transfer_buffer_length which is
set by the driver as the max size of the buffer.

When parsing the messages in ems_usb_read_bulk_callback() properly check
the size both at the beginning of parsing the message to make sure it is
big enough for the expected structure, and at the end of the message to
make sure we don't overflow past the end of the buffer for the next
message.

Cc: Vincent Mailhol <mailhol@kernel.org>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: stable@kernel.org
Assisted-by: gkh_clanker_2000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2026022316-answering-strainer-a5db@gregkh
Fixes: 702171adeed3 ("ems_usb: Added support for EMS CPC-USB/ARM7 CAN/USB interface")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/ems_usb.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -445,6 +445,11 @@ static void ems_usb_read_bulk_callback(s
 		start = CPC_HEADER_SIZE;
 
 		while (msg_count) {
+			if (start + CPC_MSG_HEADER_LEN > urb->actual_length) {
+				netdev_err(netdev, "format error\n");
+				break;
+			}
+
 			msg = (struct ems_cpc_msg *)&ibuf[start];
 
 			switch (msg->type) {
@@ -474,7 +479,7 @@ static void ems_usb_read_bulk_callback(s
 			start += CPC_MSG_HEADER_LEN + msg->length;
 			msg_count--;
 
-			if (start > urb->transfer_buffer_length) {
+			if (start > urb->actual_length) {
 				netdev_err(netdev, "format error\n");
 				break;
 			}


