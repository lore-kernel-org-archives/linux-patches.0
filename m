Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7ED1E570D;
	Mon, 21 Oct 2024 10:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506819; cv=none; b=ODgukQ6QfAXTXkBjW7iUQrVkYG+tt4XlywzR6wFFu3lZ/0GAmQRT9z43KtuBOykzLKnOo2n12WQFJQHnMfP49s0wT/wOXYtWjv+ML9RZis2QhivQZZDnXG5CLcLXyinOPq9Grnae8XzRCI97HkGnJ7jZveZ7HL3revp8VldEYx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506819; c=relaxed/simple;
	bh=FOLoKGMkiiZuwJcqUMPAcZBTg8RUZ/5QU/LZ59Pd0iI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDMOS69dreJ2Bku0rVQ/cYFQYsW6Fdo05GAdhdnI3wiRrF5kfNU50y6zdiPnh6NF31SjquTMQuzvvFRsjG2odNz9WN/DuLZYCYc2LLE+xUJScxniO8dYFz+XryRYf3rhZTDTUgDcV7X8RSRU6PGstLhg+ZNAdRfct4Lcyp+tgbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ai/+ak7G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ai/+ak7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BFE8C4CEC3;
	Mon, 21 Oct 2024 10:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506818;
	bh=FOLoKGMkiiZuwJcqUMPAcZBTg8RUZ/5QU/LZ59Pd0iI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ai/+ak7Gv8ueyizsRn5lcgzu7I85pihHqCOrarbez8/dZgMzQIw78aRvuc2OVj1RX
	 ZGq9Y4rE1VXIsKvkiaPHAYYNN9WRr+Izic6//+4F4LJLSksb3c3GHve/USGjCEymhg
	 j2arSa/nKEUkucGn9mspeXpgaJqKyLvL/exHg1Z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Douglas Anderson <dianders@chromium.org>
Subject: [PATCH 6.11 131/135] serial: qcom-geni: fix shutdown race
Date: Mon, 21 Oct 2024 12:24:47 +0200
Message-ID: <20241021102304.471693559@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit 23f5f5debcaac1399cfeacec215278bf6dbc1d11 upstream.

A commit adding back the stopping of tx on port shutdown failed to add
back the locking which had also been removed by commit e83766334f96
("tty: serial: qcom_geni_serial: No need to stop tx/rx on UART
shutdown").

Holding the port lock is needed to serialise against the console code,
which may update the interrupt enable register and access the port
state.

Fixes: d8aca2f96813 ("tty: serial: qcom-geni-serial: stop operations in progress at shutdown")
Fixes: 947cc4ecc06c ("serial: qcom-geni: fix soft lockup on sw flow control and suspend")
Cc: stable@vger.kernel.org	# 6.3
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20241009145110.16847-4-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/qcom_geni_serial.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -1096,10 +1096,12 @@ static void qcom_geni_serial_shutdown(st
 {
 	disable_irq(uport->irq);
 
+	uart_port_lock_irq(uport);
 	qcom_geni_serial_stop_tx(uport);
 	qcom_geni_serial_stop_rx(uport);
 
 	qcom_geni_serial_cancel_tx_cmd(uport);
+	uart_port_unlock_irq(uport);
 }
 
 static void qcom_geni_serial_flush_buffer(struct uart_port *uport)


