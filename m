Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FCB2EAB97;
	Tue, 12 Aug 2025 18:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023413; cv=none; b=rXnR7oKYBifgZJuKI2fHnx+MRRiUktow078n40vNcxR9tHHqYIIsImsZpVeYARVpqGd7zEAbrkB4TzX/vS1EBQONAoghnpo8ntIJDyoTd1c3jdNGactWPqO61M0Js7f5FnHIxCc+iaNChawu/HmTl5t0R/oMqg8Isg8zfdMS4ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023413; c=relaxed/simple;
	bh=3Ydwhwnr/l6MP1UILLSsF0WxsFQViTjI6V2spTjxo00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=in3mIa6PXAnmGOtcqpo5SL6BHgxjHCQ5F0vn8HwhU2YyrcGq5cx5/+DUNm0kK/Fl9YSg21JKfLXSWyrE7kR4bnvex5X7gHqtPZxVi6CI3p8kzMmNY67F2/NuQdYAXQ1WEXjbqRbGfWmsReQEn6nJvgSQji4mRmfHYLx06vQft0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D1eFMaLX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D1eFMaLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95815C4CEF0;
	Tue, 12 Aug 2025 18:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023413;
	bh=3Ydwhwnr/l6MP1UILLSsF0WxsFQViTjI6V2spTjxo00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D1eFMaLX5UbTvGApSchZ8yyQTp+qL5oiA2o/5D8B6WzdVSlBvDn6Hwa9uw/tfzdlf
	 YPVZmZtWWGnmB0PHmWq2BmgkQAXBZcKHjUm3Le713KI3q+KkWiRIiNG0/YOuPz+d9p
	 nszmBJZWMvkz0ccIdvgvO77LFARzQ+Osa7TpQgww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20Le=20Goffic?= <clement.legoffic@foss.st.com>,
	kernel test robot <lkp@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 073/627] spi: stm32: Check for cfg availability in stm32_spi_probe
Date: Tue, 12 Aug 2025 19:26:08 +0200
Message-ID: <20250812173422.086567891@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index da3517d7102d..dc22b98bdbcc 100644
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



