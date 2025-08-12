Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56877260583;
	Tue, 12 Aug 2025 19:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025494; cv=none; b=jqloUuGOt2bZyEgn4tSq7ZgBDcvJrsyhFxDziZajUmAwaVX623xPF7GygMQ0xGwdeBPRywtyuq8lsyhisj0v+pIbAbqUmLDxY2ez4YmQofdkQCqZjWN0vy3Mn/sU/cYALKyj5SsLs8ZMKkJqJK3O54kT4EqvWKSaXyVUq31pwxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025494; c=relaxed/simple;
	bh=2XsH2JCYKN/VO2PTIlJUWamZwDeFJrNGVW78pBk3s3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PmRXDMGoywj9ZdHAQAuthY5jRCjWjvgwDr7hZRUzFp5Ty99HHKkudUXt0hj2F4AkpOLX8P+qQ3D5vGDfDSZMhsWFQpxYDUVeFJlnjrzgLJxA9cfUf8zFYIso9lrCAyPVrpCSlYw0GSvIm8cyb5dsBRTNs6yca52gs66i9bBrCoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ACoPGXnj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ACoPGXnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D52C4CEF0;
	Tue, 12 Aug 2025 19:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025492;
	bh=2XsH2JCYKN/VO2PTIlJUWamZwDeFJrNGVW78pBk3s3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ACoPGXnj9BHIb9wGWNWi7QVQr62GvIsyQ1g6pPnjbZ2OxjwFQQXG7T11MwrS08DAd
	 YMpBcilaVR5KoHn5paGZxBUzCBsVt5nBmw4rBTcKNyrkBUm3BK717U+JTJzyc19eKf
	 1ukzRD/OmNln6n8h3Fxy/BIjXV6mt0/4xbS7QDt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20Le=20Goffic?= <clement.legoffic@foss.st.com>,
	kernel test robot <lkp@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 058/480] spi: stm32: Check for cfg availability in stm32_spi_probe
Date: Tue, 12 Aug 2025 19:44:26 +0200
Message-ID: <20250812174359.811573801@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



