Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FF8171C5
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:33:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6174C4339B;
	Wed,  7 Jun 2023 20:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169993;
	bh=FI1Lpe94fo7zZkRPXnZdOWPTbsAibS/sijKrQKiTKEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uA+1F/46P9pxiE4daKxqdLrGf3lQj7HmODXvvfZ/6yTvdkoXjZzHFSCJdt7QsPgDQ
	 Ru1+VzKWiQh5fQ8jpFmK42Z42mAx2SbOb42wHQT8KmC9GciglZwTzjzZD0ug4TmxnY
	 2cLxqblz+lLgDyVEspxCN4tOPlTVMsms4WW9M6DE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 6.3 264/286] serial: 8250_tegra: Fix an error handling path in tegra_uart_probe()
Date: Wed,  7 Jun 2023 22:16:03 +0200
Message-ID: <20230607200931.935399808@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 134f49dec0b6aca3259cd8259de4c572048bd207 upstream.

If an error occurs after reset_control_deassert(), it must be re-asserted,
as already done in the .remove() function.

Fixes: c6825c6395b7 ("serial: 8250_tegra: Create Tegra specific 8250 driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/f8130f35339cc80edc6b9aac4bb2a60b60a226bf.1684063511.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_tegra.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/8250_tegra.c
+++ b/drivers/tty/serial/8250/8250_tegra.c
@@ -112,13 +112,15 @@ static int tegra_uart_probe(struct platf
 
 	ret = serial8250_register_8250_port(&port8250);
 	if (ret < 0)
-		goto err_clkdisable;
+		goto err_ctrl_assert;
 
 	platform_set_drvdata(pdev, uart);
 	uart->line = ret;
 
 	return 0;
 
+err_ctrl_assert:
+	reset_control_assert(uart->rst);
 err_clkdisable:
 	clk_disable_unprepare(uart->clk);
 


