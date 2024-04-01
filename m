Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C931CA8F;
	Mon,  1 Apr 2024 16:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988737; cv=none; b=imQkbgzglPtxRWmGu2KDgfrIWCa3x8IoQGq2UOTjvqL2JJ4gzB8htBPcSF+EFFy7NhMg6TUCoGeuVKKNhtvpvjE5x8SNHhkrciUcGd2TE+Ws1EQ6pp5LfFe8W81YHSHk9SSsSUNafzrDqUBi1/FimY4GDThUZXW6P/htWOfg1fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988737; c=relaxed/simple;
	bh=PIi5Kskv6CRGssBIVLh7vcv6KoJ9tjgcNSoOeMN9D+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y49WVrR9asq/FqSrEpe+RMAxW/FldDBVnDccVMDHL6Q5y2f3J2iOaOPEuIeL5CLST9jHtZvxZCd2XupsUyNg9LfA2nwl6zz1XH2Nb9eo+7h1HJnFPGsjh+TcTwTgxW+cx1dPfQCeRJ36VDwgX/pwv9hGCMEm0WTN1hDLeYMfTRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W+U40MGp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W+U40MGp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5728C433F1;
	Mon,  1 Apr 2024 16:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988737;
	bh=PIi5Kskv6CRGssBIVLh7vcv6KoJ9tjgcNSoOeMN9D+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W+U40MGphYwLtBrst7ooN98/fmg0Lf91kg+kq1gdhKKiOcC4aLgrz0vDN2s8kZDev
	 AdFF9vJb2d3PQmZ2cPxfJc162n4bwwpHWmOJ9NqXN9woW4ob4VZFPrIYX3iA9/IKVt
	 6slugcQYt2PcDCC5XeVpfqgDof6dYuVqcgwW1P44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH 6.7 274/432] Revert "tty: serial: simplify qcom_geni_serial_send_chunk_fifo()"
Date: Mon,  1 Apr 2024 17:44:21 +0200
Message-ID: <20240401152601.347025783@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

commit 3d9319c27ceb35fa3d2c8b15508967f3fc7e5b78 upstream.

This reverts commit 5c7e105cd156fc9adf5294a83623d7a40c15f9b9.

As identified by KASAN, the simplification done by the cleanup patch
was not legal.

>From tracing through the code, it can be seen that we're transmitting
from a 4096-byte circular buffer. We copy anywhere from 1-4 bytes from
it each time. The simplification runs into trouble when we get near
the end of the circular buffer. For instance, we might start out with
xmit->tail = 4094 and we want to transfer 4 bytes. With the code
before simplification this was no problem. We'd read buf[4094],
buf[4095], buf[0], and buf[1]. With the new code we'll do a
memcpy(&buf[4094], 4) which reads 2 bytes past the end of the buffer
and then skips transmitting what's at buf[0] and buf[1].

KASAN isn't 100% consistent at reporting this for me, but to be extra
confident in the analysis, I added traces of the tail and tx_bytes and
then wrote a test program:

  while true; do
    echo -n "abcdefghijklmnopqrstuvwxyz0" > /dev/ttyMSM0
    sleep .1
  done

I watched the traces over SSH and saw:
  qcom_geni_serial_send_chunk_fifo: 4093 4
  qcom_geni_serial_send_chunk_fifo: 1 3

Which indicated that one byte should be missing. Sure enough the
output that should have been:

  abcdefghijklmnopqrstuvwxyz0

In one case was actually missing a byte:

  abcdefghijklmnopqrstuvwyz0

Running "ls -al" on large directories also made the missing bytes
obvious since columns didn't line up.

While the original code may not be the most elegant, we only talking
about copying up to 4 bytes here. Let's just go back to the code that
worked.

Fixes: 5c7e105cd156 ("tty: serial: simplify qcom_geni_serial_send_chunk_fifo()")
Cc: stable <stable@kernel.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Jiri Slaby <jirislaby@kernel.org>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20240304174952.1.I920a314049b345efd1f69d708e7f74d2213d0b49@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/qcom_geni_serial.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -851,19 +851,21 @@ static void qcom_geni_serial_stop_tx(str
 }
 
 static void qcom_geni_serial_send_chunk_fifo(struct uart_port *uport,
-					     unsigned int remaining)
+					     unsigned int chunk)
 {
 	struct qcom_geni_serial_port *port = to_dev_port(uport);
 	struct circ_buf *xmit = &uport->state->xmit;
-	unsigned int tx_bytes;
+	unsigned int tx_bytes, c, remaining = chunk;
 	u8 buf[BYTES_PER_FIFO_WORD];
 
 	while (remaining) {
 		memset(buf, 0, sizeof(buf));
 		tx_bytes = min(remaining, BYTES_PER_FIFO_WORD);
 
-		memcpy(buf, &xmit->buf[xmit->tail], tx_bytes);
-		uart_xmit_advance(uport, tx_bytes);
+		for (c = 0; c < tx_bytes ; c++) {
+			buf[c] = xmit->buf[xmit->tail];
+			uart_xmit_advance(uport, 1);
+		}
 
 		iowrite32_rep(uport->membase + SE_GENI_TX_FIFOn, buf, 1);
 


