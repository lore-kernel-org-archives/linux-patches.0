Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A6A41CB4D;
	Sat, 12 Sep 2026 08:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202707; cv=none; b=McaxKRKi+E/CdUu+RjQniOnbEaz/eIPDbJsVLUn+tL2kPEPH6OIEabJ9DSuFC1utidlRv8KwB5w6LumYUb7xOlPs3r/pp+oai9WlXT8T5PmRfesSXcWU6FYmdgS6EhapadvzFwrzGOzU8ZzHJktNs2lesZdLnMUnyOWENOwVYhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202707; c=relaxed/simple;
	bh=DiJJpmxvfHBKp8M9PQBaWSRWCWHFgZkxqM2juvjrP0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VWjltzE1RCpVw+qI80As3LT2RQR233si2rSe+uTzfDcZd5YitaM1svcG3CBUUtF9NRPZKtHuNQ3HEYcAni0xZaXIe60yzDDqvn6i5ru1PFT4L2oy34jQeIlEbSuIhuM3ogAY79VTQx5iSYQTGRNRLuf7umC/UMP4INzcGdAjJL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TPv8Drdq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TPv8Drdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006B41F000FF;
	Sat, 12 Sep 2026 08:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202701;
	bh=9Nfjnm/9gyDkyMZNedT5nEMUfvjrZsoCiX4LCiwG+38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TPv8DrdqiiHI8kO0LMijkLMJbkJozKATBAE67hhQK635PdpktLwYb7b3LxWNzlnEx
	 JGohFViKxHzentRXaCPNNlSD7YYobmZvXFlcwg2i8mU3m81ITYI/uO42Y06zr4bqkC
	 dUI804XCmRCbkaJY5Yxh7krDok9tWMEyCEMPhEHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin.sipraga@analog.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1257/1815] pinctrl: fix PINCTRL_GENERIC_MUX not always being selectable
Date: Sat, 12 Sep 2026 08:50:07 +0200
Message-ID: <20260912065718.525271178@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alvin Šipraga <alvin.sipraga@analog.com>

[ Upstream commit 465f276bb928093685c2a2b98bf0a7ccc4283b8d ]

CONFIG_MULTIPLEXER can only be enabled indirectly. If it's not already
enabled, then CONFIG_PINCTRL_GENERIC_MUX cannot be selected at all in
menuconfig. That's because it depends on MULTIPLEXER.

Follow similar consumers of the multiplexer core and select MULTIPLEXER
instead. This way the driver will be visible in menuconfig as long as
PINCTRL is selected.

Fixes: 34acc5a8adfb ("pinctrl: add generic board-level pinctrl driver using mux framework")
Signed-off-by: Alvin Šipraga <alvin.sipraga@analog.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index e5618b51ac144..bf73bc709c181 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -275,8 +275,8 @@ config PINCTRL_GEMINI
 
 config PINCTRL_GENERIC_MUX
 	tristate "Generic Pinctrl driver by using multiplexer"
-	depends on MULTIPLEXER
 	depends on OF
+	select MULTIPLEXER
 	select PINMUX
 	select GENERIC_PINCTRL
 	help
-- 
2.53.0



