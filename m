Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B2D1ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:46:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582A5C433C8;
	Tue, 25 Jul 2023 11:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285595;
	bh=2Boqgdv+d+CAbaPylFU5D9+yQB76GtZgHvvqAMNFois=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dEkAc/Cl2pLedhJjBbcXxVWlv5/HBDwaxleWBGn3/+djGZGw2uRMlofp8R/Higu98
	 8n8hQ7GMU819X36j9U1H+NRkGCSRxyI6zlGcg9CVTJ5/I85/3IJElw+7jgviPAXLZD
	 i66ocFsp/6TgDxaUvnRIUua17sDuJ1h/rg4wM0QU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Andi Shyti <andi.shyti@kernel.org>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 5.4 262/313] tty: serial: samsung_tty: Fix a memory leak in s3c24xx_serial_getclk() in case of error
Date: Tue, 25 Jul 2023 12:46:55 +0200
Message-ID: <20230725104532.390623539@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
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

commit a9c09546e903f1068acfa38e1ee18bded7114b37 upstream.

If clk_get_rate() fails, the clk that has just been allocated needs to be
freed.

Cc: <stable@vger.kernel.org> # v3.3+
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Fixes: 5f5a7a5578c5 ("serial: samsung: switch to clkdev based clock lookup")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Message-ID: <e4baf6039368f52e5a5453982ddcb9a330fc689e.1686412569.git.christophe.jaillet@wanadoo.fr>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/samsung.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -1199,8 +1199,12 @@ static unsigned int s3c24xx_serial_getcl
 			continue;
 
 		rate = clk_get_rate(clk);
-		if (!rate)
+		if (!rate) {
+			dev_err(ourport->port.dev,
+				"Failed to get clock rate for %s.\n", clkname);
+			clk_put(clk);
 			continue;
+		}
 
 		if (ourport->info->has_divslot) {
 			unsigned long div = rate / req_baud;


