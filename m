Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B217361DDC;
	Sat, 12 Sep 2026 09:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204655; cv=none; b=Or/76zZ0bPxe3Nf6QebSwxa2eJXfQlf9rVdkNW0cob0y7zdZipk4eWZY4NEtzZ8zn+6pN7FYI5VPMClQYkln3e1ZYuhpWh5uP/3OShz++TxKU6Xof6TkQUIxnjGXxayTSiJEEe1TEjZIpS2NS6GH2/Q6qrvlce31VsjRiySoEBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204655; c=relaxed/simple;
	bh=Uq872dvaEsKANAJGwR5VrCva4t0YPS4b18u6/4TE2nE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IsqJDnm/tjEUb11LdGcwjGh4ycmI2EeOq4P/9tSaGK2Ho/Q/B1EZA16gZ61TNCzJuNnm3dVr6/P+l/vmuoBtC7ahRNaQpMwzxS4NoaRHKHaknCXBk128BhmPNWoH37ARk6CAVY+n1C3TUYn/UOypHqEZCD6T8YDBk71HotLWbUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=opqUjS68; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opqUjS68"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2F21F00893;
	Sat, 12 Sep 2026 09:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204653;
	bh=6bqgshncv6rkvD2nRTIagiTGXsp888kMs6GkVyfRUzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=opqUjS68jraypqOHIyOS5sx2XIiZscKTzTF1zWmA27qvn8nc+b4ej1IUF2PqW3OYk
	 B31Pb79pHln6FfFIU+wIoSK97+5boGjpXV4IvPlXzYOKCkiGk12lor/xQTLCbWvfCP
	 lcHvEZDEEu45RS0ymTvVzxexSlDXaBISSUVp41fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Brian Masney <bmasney@redhat.com>,
	Xianwei Zhao <xianwei.zhao@amlogic.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1658/1815] spi: amlogic-spisg: Make sure clk_init_data is fully initialized
Date: Sat, 12 Sep 2026 08:56:48 +0200
Message-ID: <20260912065727.915056954@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit b2702908ee23ef31bfcf241a2e07ace0eb76bd71 ]

The clk_init_data structure contains several mutually-exclusive members
for different methods to specify the possible parents of a clock,
prompting drivers to initialize only the members they need.  However,
not initializing all members may cause subtle issues, which are only
exposed when CONFIG_INIT_STACK_ALL_PATTERN or CONFIG_INIT_STACK_NONE is
enabled.

aml_spisg_clk_init() fills in init.parent_data, and assumes that
init.parent_names is NULL.  However, the latter in uninitialized, and
thus may cause a crash.

Make sure all members are fully initialized, to fix such bugs, and to
avoid future breakage when converting drivers to a different method for
specifying the parents.

Fixes: cef9991e04aed330 ("spi: Add Amlogic SPISG driver")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Xianwei Zhao <xianwei.zhao@amlogic.com>
Link: https://patch.msgid.link/9fb35ae0aedb7a6db0db6c78a8193c7602dd9d44.1787165329.git.geert+renesas@glider.be
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-amlogic-spisg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-amlogic-spisg.c b/drivers/spi/spi-amlogic-spisg.c
index afc8af04638d3..9049a87e9d0f2 100644
--- a/drivers/spi/spi-amlogic-spisg.c
+++ b/drivers/spi/spi-amlogic-spisg.c
@@ -636,7 +636,7 @@ static int aml_spisg_target_abort(struct spi_controller *ctlr)
 static int aml_spisg_clk_init(struct spisg_device *spisg, void __iomem *base)
 {
 	struct device *dev = &spisg->pdev->dev;
-	struct clk_init_data init;
+	struct clk_init_data init = {};
 	struct clk_divider *div;
 	struct clk_div_table *tbl;
 	char name[32];
-- 
2.53.0



