Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4BC1494DB;
	Thu,  5 Sep 2024 10:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530683; cv=none; b=XlQKyPcZbAwsXZ9Urh1Rj+vcZ15xFEK4UzuvNAdUGeR9JxbHTk24+SygZP5RIAp51Y/rDfwfsE7+njYFDe5ep6k2NwJiAVy03yVJdRqZul58c4aZaPxgVk0gG5RmX1JMzcH132oEgtORNvQKn/+ZgCivPxpM0gEbdLAeQhDQGY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530683; c=relaxed/simple;
	bh=itC2OFMOYkCG5Qca6p5R2TH4GicBfWMfeUJvipf8kJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MwinUKzalL4gr3rGeU21oovxXhL///Tzn87YCCLELOPiMBrQbDt78AY6p6l3QK0gX+l+qldMbjYiNQ48lJ5tNasPRO2kNXVgiGCBkmXYwv73t8ysdHjk/RK3/k/msrjCOTz/SotUSHu8WwbPPpMYtzSptAj/SEzjMPZYRCZWYXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g2hUeheN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g2hUeheN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FD9C4CEC3;
	Thu,  5 Sep 2024 10:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530683;
	bh=itC2OFMOYkCG5Qca6p5R2TH4GicBfWMfeUJvipf8kJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g2hUeheNPmLIm3uKTNiMjFN4Wos3wdu9FWRXRWZM9obfLiSVfgKLWMvlDkExYEGkp
	 VOO9sSlZ2/Tp/EdS88FvJeCYtlirz99zAltltgt8mDsycL5fgsL6zl89cHLTKLxqPB
	 CTZynha9VW7YA8A67srD5kA4yRGm+9qk30MWzXkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	kernel test robot <lkp@intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH 6.1 101/101] i2c: Use IS_REACHABLE() for substituting empty ACPI functions
Date: Thu,  5 Sep 2024 11:42:13 +0200
Message-ID: <20240905093720.069139129@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

commit 71833e79a42178d8a50b5081c98c78ace9325628 upstream.

Replace IS_ENABLED() with IS_REACHABLE() to substitute empty stubs for:
    i2c_acpi_get_i2c_resource()
    i2c_acpi_client_count()
    i2c_acpi_find_bus_speed()
    i2c_acpi_new_device_by_fwnode()
    i2c_adapter *i2c_acpi_find_adapter_by_handle()
    i2c_acpi_waive_d0_probe()

commit f17c06c6608a ("i2c: Fix conditional for substituting empty ACPI
functions") partially fixed this conditional to depend on CONFIG_I2C,
but used IS_ENABLED(), which is wrong since CONFIG_I2C is tristate.

CONFIG_ACPI is boolean but let's also change it to use IS_REACHABLE()
to future-proof it against becoming tristate.

Somehow despite testing various combinations of CONFIG_I2C and CONFIG_ACPI
we missed the combination CONFIG_I2C=m, CONFIG_ACPI=y.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: f17c06c6608a ("i2c: Fix conditional for substituting empty ACPI functions")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202408141333.gYnaitcV-lkp@intel.com/
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/i2c.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -1035,7 +1035,7 @@ static inline int of_i2c_get_board_info(
 struct acpi_resource;
 struct acpi_resource_i2c_serialbus;
 
-#if IS_ENABLED(CONFIG_ACPI) && IS_ENABLED(CONFIG_I2C)
+#if IS_REACHABLE(CONFIG_ACPI) && IS_REACHABLE(CONFIG_I2C)
 bool i2c_acpi_get_i2c_resource(struct acpi_resource *ares,
 			       struct acpi_resource_i2c_serialbus **i2c);
 int i2c_acpi_client_count(struct acpi_device *adev);


