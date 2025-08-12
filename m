Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64E12FA0DB;
	Tue, 12 Aug 2025 18:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022045; cv=none; b=lwDN3/KSV2dU7MLTKsaxJaDzDVBqRonicgY4LzMix8VpvKfV0VboaSfMRW8oTmfUX0fKnepya5fGfmLXtuxo9ae7CnoXhpf1Y9c0oESPrW/+nyGTnnPfew6DPyo4bYk7LUIGdnvBT/tCoKm5qEZQLx194X3Fw3hMy/080QDo+T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022045; c=relaxed/simple;
	bh=FE12ykrhB2ClcI0y9q5hqcgJLvS29rzUND5C8JkaUrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lhHxvlSADTmMezDz4IbFmLRUmqRIMMM+8lYsK/Ih8U2JCzlki7XkAlbV93lU/cbppkRCxgFaVlCvQvWKxL08YivU2ZNW33Z9RBrghwCZ4BzXrpRAHJ2MHYfhFiiyoY9cGIYKH007BUg3bqlgjo4XXCWvtZsPa/z+8zoLsR1N57M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IwFf7dp/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IwFf7dp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C140C4CEF0;
	Tue, 12 Aug 2025 18:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022045;
	bh=FE12ykrhB2ClcI0y9q5hqcgJLvS29rzUND5C8JkaUrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IwFf7dp/juYVP70e6R80DVYq930ZhN7k3x3aEA+MqNbvhI/T6PCvfG7yzL28rJNSs
	 et8yh/oJaFH9/x8B9ZIYWYS6dxhRtdES8Q56fzROBE95tNss0zX0eHDhayIDQE5KGv
	 rR6QDeeSo7pQQ4rj3QxifZxln7uR9EdbaagOMjqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20Le=20Goffic?= <clement.legoffic@foss.st.com>,
	kernel test robot <lkp@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/369] spi: stm32: Check for cfg availability in stm32_spi_probe
Date: Tue, 12 Aug 2025 19:25:37 +0200
Message-ID: <20250812173016.267724811@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clément Le Goffic <clement.legoffic@foss.st.com>

[ Upstream commit 21f1c800f6620e43f31dfd76709dbac8ebaa5a16 ]

The stm32_spi_probe function now includes a check to ensure that the
pointer returned by of_device_get_match_data is not NULL before
accessing its members. This resolves a warning where a potential NULL
pointer dereference could occur when accessing cfg->has_device_mode.

Before accessing the 'has_device_mode' member, we verify that 'cfg' is
not NULL. If 'cfg' is NULL, an error message is logged.

This change ensures that the driver does not attempt to access
configuration data if it is not available, thus preventing a potential
system crash due to a NULL pointer dereference.

Signed-off-by: Clément Le Goffic <clement.legoffic@foss.st.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202310191831.MLwx1c6x-lkp@intel.com/
Fixes: fee681646fc8 ("spi: stm32: disable device mode with st,stm32f4-spi compatible")
Link: https://patch.msgid.link/20250616-spi-upstream-v1-2-7e8593f3f75d@foss.st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-stm32.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-stm32.c b/drivers/spi/spi-stm32.c
index fc72a89fb3a7..3b1b810f33bf 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -2069,9 +2069,15 @@ static int stm32_spi_probe(struct platform_device *pdev)
 	struct resource *res;
 	struct reset_control *rst;
 	struct device_node *np = pdev->dev.of_node;
+	const struct stm32_spi_cfg *cfg;
 	bool device_mode;
 	int ret;
-	const struct stm32_spi_cfg *cfg = of_device_get_match_data(&pdev->dev);
+
+	cfg = of_device_get_match_data(&pdev->dev);
+	if (!cfg) {
+		dev_err(&pdev->dev, "Failed to get match data for platform\n");
+		return -ENODEV;
+	}
 
 	device_mode = of_property_read_bool(np, "spi-slave");
 	if (!cfg->has_device_mode && device_mode) {
-- 
2.39.5



