Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082B721257F;
	Fri, 10 Oct 2025 13:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102233; cv=none; b=rEjPAiWV4s8gQfIlqbL3/N9oXwz4V7sZB7QBYmp5j3ewNsEvUelYgYS5888mU1R+LaU3KpV3Lkvv9ovvF/4WBLGHdAiNGwpgRk58O8hxLoogv/AVcgnM2ivKtdIZ65JnceemyFhXouOyyP1FmlcsQ7kMkzG6svGcK8IuNV3FpwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102233; c=relaxed/simple;
	bh=OrYNtJdlxUFfCPEuw6QPru5vBBWlSPclK4I+8oXwg7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nAeGorTD5PKoZYiPHy6eMrS3jEXwBjapfXazaii4krx56jPiUDI12ogs08CJsRbIt62e9496tRl8qy8LwCkvbOXUwWyTzfK6x4z4u4w0vGNtDYEnz0wOkdB7JE2OnfIXkawTx0mIef+r7ZuJyI2nROtdtXigU6xAHV6bVRx7xdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zumNYNDM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zumNYNDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D89BC4CEF1;
	Fri, 10 Oct 2025 13:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102232;
	bh=OrYNtJdlxUFfCPEuw6QPru5vBBWlSPclK4I+8oXwg7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zumNYNDM2GUlrWKRgf+ZLltZ0H8sJh8pz+MpX0hb4Ab6U9YQlx9vrQIaNnKczhiJu
	 PGDNmV+Prt7MPTeAsn6EEcBUcR4wwwYqNaWj/Rfl5iVNhVHd2JRW2CFS2o24dy1Tkq
	 uljal9M6YthxD4YO3UFNjipudZB7Gigj6S+Y7jEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Akshay Gupta <Akshay.Gupta@amd.com>
Subject: [PATCH 6.17 12/26] drivers/misc/amd-sbi/Kconfig: select REGMAP_I2C
Date: Fri, 10 Oct 2025 15:16:07 +0200
Message-ID: <20251010131331.656998496@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.204964167@linuxfoundation.org>
References: <20251010131331.204964167@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

commit 5f8f84e286f11af4c954c14a57daffc80a1c3510 upstream.

Without CONFIG_REGMAP, rmi-i2c.c fails to build because struct
regmap_config is not defined:

 drivers/misc/amd-sbi/rmi-i2c.c: In function ‘sbrmi_i2c_probe’:
 drivers/misc/amd-sbi/rmi-i2c.c:57:16: error: variable ‘sbrmi_i2c_regmap_config’ has initializer but incomplete type
    57 |         struct regmap_config sbrmi_i2c_regmap_config = {
       |                ^~~~~~~~~~~~~

Additionally, CONFIG_REGMAP_I2C is needed for devm_regmap_init_i2c():

 ld: drivers/misc/amd-sbi/rmi-i2c.o: in function `sbrmi_i2c_probe':
 drivers/misc/amd-sbi/rmi-i2c.c:69:(.text+0x1c0): undefined reference to `__devm_regmap_init_i2c'

Fixes: 013f7e7131bd ("misc: amd-sbi: Use regmap subsystem")
Cc: stable@vger.kernel.org
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Tested-by: Akshay Gupta <Akshay.Gupta@amd.com>
Reviewed-by: Akshay Gupta <Akshay.Gupta@amd.com>
Link: https://lore.kernel.org/r/20250829091442.1112106-1-max.kellermann@ionos.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/amd-sbi/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/misc/amd-sbi/Kconfig
+++ b/drivers/misc/amd-sbi/Kconfig
@@ -2,6 +2,7 @@
 config AMD_SBRMI_I2C
 	tristate "AMD side band RMI support"
 	depends on I2C
+	select REGMAP_I2C
 	help
 	  Side band RMI over I2C support for AMD out of band management.
 


