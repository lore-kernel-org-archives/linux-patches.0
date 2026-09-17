Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9F94F3939;
	Thu, 17 Sep 2026 15:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660197; cv=none; b=sjMMmR+VZRyYJRS+BWDE0Z1pQLEY+ceu0P6y9u90BLhoMYix2+BzSleZdqZ85hNQ8ISPFOcLXho7zIB9dCIK34qhhc3o03KG2V25ID7f4a1Kq2BinvmAo1znvsZxiKmlbT4dSFENjqpOicZq5YAlx0F+NHjhEeN9vkCxsLPR/lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660197; c=relaxed/simple;
	bh=uGpeiYydOKuXmk5yu9vw5c1/PARTUtl5EFOrjZaw0Q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jOkrI8LYwAvwcMiUkF10oYGW+3GZ5kvxbSXtRfjMXtRaLo/3omcQfbUDEVhUwdJOeblFHJ0RTIbDc+FZpYlIOsXLmjF39IblLJQH6tRgo97n3RCpAqx4WWOlZVyC40p/VU4LNVDtcLAT7TlPR35Nb6r60cjKLxBXanYAitA56ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dLg+2K2y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dLg+2K2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B283A1F0089B;
	Thu, 17 Sep 2026 15:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660191;
	bh=VGwxxlY/+njpBi/Jg9LkAmuqCYOGbd3J0ovEHGMo+9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dLg+2K2yvmoDXbYpaGtn8MejRoyt2okXLp2rKUYetIUM23LyJSndcVtmJD0fnx77P
	 I6rhwv1ubx06/Si57jF0PWk0PYzvP5q8D73+TK9ljDKdFud3WQ1sMfHwvD4ErinEM7
	 jpvQe5USV4Ujgdyt1U+MEfwT0eGSxx1gdhGzyMhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 7.2 510/733] accel: ethosu: Ensure SRAM size is 0 on mapping failure
Date: Thu, 17 Sep 2026 16:13:38 +0100
Message-ID: <20260917151404.834300320@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Rob Herring (Arm) <robh@kernel.org>

commit f5376d7e0fb703876199d3b6f9f97e128fa2f8a4 upstream.

On a mapping failure of the SRAM, the SRAM size is left as non-zero. The
probe will succeed as the error return is not checked since having SRAM is
not a hard requirement. The non-zero size allows jobs to access SRAM which
is left pointing to physical base address 0x0.

Fixes: 5a5e9c0228e6 ("accel: Add Arm Ethos-U NPU driver")
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260827-ethosu-fixes-v1-4-346f9ea8791c@kernel.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ethosu/ethosu_drv.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/accel/ethosu/ethosu_drv.c
+++ b/drivers/accel/ethosu/ethosu_drv.c
@@ -274,8 +274,6 @@ static int ethosu_device_suspend(struct
 
 static int ethosu_sram_init(struct ethosu_device *ethosudev)
 {
-	ethosudev->npu_info.sram_size = 0;
-
 	ethosudev->srampool = of_gen_pool_get(ethosudev->base.dev->of_node, "sram", 0);
 	if (!ethosudev->srampool)
 		return 0;
@@ -286,6 +284,7 @@ static int ethosu_sram_init(struct ethos
 							     ethosudev->npu_info.sram_size,
 							     &ethosudev->sramphys);
 	if (!ethosudev->sram) {
+		ethosudev->npu_info.sram_size = 0;
 		dev_err(ethosudev->base.dev, "failed to allocate from SRAM pool\n");
 		return -ENOMEM;
 	}


