Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6557CC142
	for <patches@lists.linux.dev>; Mon,  4 Sep 2023 18:35:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC980C433C8;
	Mon,  4 Sep 2023 18:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693852500;
	bh=uOl8bCqQp8PKjdS9X2+5MsGUoeyiQSqC5HOShuKtQsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ZTvOdbA+Kqaofa3aC0EfK62LMn+uFbJ8py7z2PEMi0U4TWqKwn/MTGxRBvoXUGO1
	 Y/GRKFWXVrr9kDiEEWknozvpmYQd7iM09s70VledrtzRn/Ib5NGWXMmVILfy8Ff3PE
	 gdfnz8CHgdqEf4Ot3wYAWt2Kg8RQrhWJJxet4QVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rajendra Nayak <quic_rjendra@quicinc.com>,
	Matthias Kaehlcke <mka@chromium.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>
Subject: [PATCH 6.1 21/31] serial: qcom-geni: fix opp vote on shutdown
Date: Mon,  4 Sep 2023 19:30:29 +0100
Message-ID: <20230904182948.052674627@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230904182946.999390199@linuxfoundation.org>
References: <20230904182946.999390199@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 8ece7b754bc34ffd7fcc8269ccb9128e72ca76d8 upstream.

The operating-performance-point vote needs to be dropped when shutting
down the port to avoid wasting power by keeping resources like power
domains in an unnecessarily high performance state (e.g. when a UART
connected Bluetooth controller is not in use).

Fixes: a5819b548af0 ("tty: serial: qcom_geni_serial: Use OPP API to set clk/perf state")
Cc: stable@vger.kernel.org      # 5.9
Cc: Rajendra Nayak <quic_rjendra@quicinc.com>
Cc: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Acked-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230714130214.14552-2-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/qcom_geni_serial.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -129,6 +129,7 @@ struct qcom_geni_serial_port {
 	u32 tx_fifo_width;
 	u32 rx_fifo_depth;
 	bool setup;
+	unsigned long clk_rate;
 	int (*handle_rx)(struct uart_port *uport, u32 bytes, bool drop);
 	unsigned int baud;
 	void *rx_fifo;
@@ -1061,6 +1062,7 @@ static void qcom_geni_serial_set_termios
 			baud * sampling_rate, clk_rate, clk_div);
 
 	uport->uartclk = clk_rate;
+	port->clk_rate = clk_rate;
 	dev_pm_opp_set_rate(uport->dev, clk_rate);
 	ser_clk_cfg = SER_CLK_EN;
 	ser_clk_cfg |= clk_div << CLK_DIV_SHFT;
@@ -1330,10 +1332,13 @@ static void qcom_geni_serial_pm(struct u
 
 	if (new_state == UART_PM_STATE_ON && old_state == UART_PM_STATE_OFF) {
 		geni_icc_enable(&port->se);
+		if (port->clk_rate)
+			dev_pm_opp_set_rate(uport->dev, port->clk_rate);
 		geni_se_resources_on(&port->se);
 	} else if (new_state == UART_PM_STATE_OFF &&
 			old_state == UART_PM_STATE_ON) {
 		geni_se_resources_off(&port->se);
+		dev_pm_opp_set_rate(uport->dev, 0);
 		geni_icc_disable(&port->se);
 	}
 }


