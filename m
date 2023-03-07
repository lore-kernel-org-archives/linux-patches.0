Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED55BA34
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:32:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7ECC433EF;
	Tue,  7 Mar 2023 17:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210348;
	bh=GrnfRcLnLIq4XqFqaqs3UE/7e5/E1iMJ/HYr2B6b4eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T5PX5vh7Pt+Jfwzw3465YaWdS34bj5nZ6cPx+juZD/0+C7hs2Cgjq1D+BitJBK5GA
	 miSqJtdwqbNhGup/KyTid9C7GHC7KGdm/FDrnHgUBiPehkZEKckYrAw2FhUQOgDOoj
	 wok86avp0jdpGzKmf7NkFnja9rdJtUUAURLEpCpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0512/1001] tty: serial: qcom-geni-serial: stop operations in progress at shutdown
Date: Tue,  7 Mar 2023 17:54:44 +0100
Message-Id: <20230307170043.650684610@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit d8aca2f96813d51df574a811eda9a2cbed00f261 ]

We don't stop transmissions in progress at shutdown. This is fine with
FIFO SE mode but with DMA (support for which we'll introduce later) it
causes trouble so fix it now.

Fixes: e83766334f96 ("tty: serial: qcom_geni_serial: No need to stop tx/rx on UART shutdown")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20221229155030.418800-2-brgl@bgdev.pl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/qcom_geni_serial.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/qcom_geni_serial.c b/drivers/tty/serial/qcom_geni_serial.c
index 57f04f8bf5043..851a5d2133aa2 100644
--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -891,6 +891,8 @@ static int setup_fifos(struct qcom_geni_serial_port *port)
 static void qcom_geni_serial_shutdown(struct uart_port *uport)
 {
 	disable_irq(uport->irq);
+	qcom_geni_serial_stop_tx(uport);
+	qcom_geni_serial_stop_rx(uport);
 }
 
 static int qcom_geni_serial_port_setup(struct uart_port *uport)
-- 
2.39.2



