Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8749B26988C;
	Tue,  8 Apr 2025 12:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116524; cv=none; b=OdPyRjMjwUfktK74fXiEtTp4tDODHlU446rfJpI0+wSO2/pU+/r98sR4QlMYPrbTW3YH/WWkWwHuBe7hidUoZmciQUDXsqdQQKTEekLkg1Wz64YSPz31lX+Q7z0PRePezWiGEl/BKjIyc0ZbwVpXqWDvZHomkuzH/2Hm4hPjdfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116524; c=relaxed/simple;
	bh=UThp65c8j7q+5Fr7+08K75EF94vE+J7THC7/3Zuj30E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZlDcCvKZB573jOqJwzyTEO2oefcGXmySuIIzsIxSRAlwlJVLnE6f0JF6D5xB2zWi1zeWzuTt08kVH2G609Xu0JRZMsMLsdYfWWMBxcDQwL4GPnqZo048nlfkiGaPi9MmX3iQIf6NF3H0BceYdtKffSEtoclccokj+TX2/3jSEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AxoZmXHR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AxoZmXHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1700EC4AF09;
	Tue,  8 Apr 2025 12:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116524;
	bh=UThp65c8j7q+5Fr7+08K75EF94vE+J7THC7/3Zuj30E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AxoZmXHR2qMuHb6PaBK6A/oRp9hh7OrIb+Sw3Hb0jM0SFxghVDbYHIGhzXaK7nCop
	 sq65WwAOK3IZ6+4r2GIjV+Tp0HZ5ZT2Crw94Cuyr+80pb6S6dgdadjVcYv80SgktEA
	 3xcjZ92t9HsHYvPw6cn1XrgC2PjEIZLyNFwqLtRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Ayush Singh <ayush@beagleboard.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 170/423] greybus: gb-beagleplay: Add error handling for gb_greybus_init
Date: Tue,  8 Apr 2025 12:48:16 +0200
Message-ID: <20250408104849.702531656@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit be382372d55d65b5c7e5a523793ca5e403f8c595 ]

Add error handling for the gb_greybus_init(bg) function call
during the firmware reflash process to maintain consistency
in error handling throughout the codebase. If initialization
fails, log an error and return FW_UPLOAD_ERR_RW_ERROR.

Fixes: 0cf7befa3ea2 ("greybus: gb-beagleplay: Add firmware upload API")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Ayush Singh <ayush@beagleboard.org>
Link: https://lore.kernel.org/r/20250120140547.1460-1-vulab@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/greybus/gb-beagleplay.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/greybus/gb-beagleplay.c b/drivers/greybus/gb-beagleplay.c
index 473ac3f2d3821..da31f1131afca 100644
--- a/drivers/greybus/gb-beagleplay.c
+++ b/drivers/greybus/gb-beagleplay.c
@@ -912,7 +912,9 @@ static enum fw_upload_err cc1352_prepare(struct fw_upload *fw_upload,
 		cc1352_bootloader_reset(bg);
 		WRITE_ONCE(bg->flashing_mode, false);
 		msleep(200);
-		gb_greybus_init(bg);
+		if (gb_greybus_init(bg) < 0)
+			return dev_err_probe(&bg->sd->dev, FW_UPLOAD_ERR_RW_ERROR,
+					     "Failed to initialize greybus");
 		gb_beagleplay_start_svc(bg);
 		return FW_UPLOAD_ERR_FW_INVALID;
 	}
-- 
2.39.5



