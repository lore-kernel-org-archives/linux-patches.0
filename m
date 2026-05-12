Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA793EDE46;
	Tue, 12 May 2026 17:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608175; cv=none; b=QJy5s4ybYTWTa0FcgNFZm0IpqyhrH3Vf3+ADzsufkmv/PNDWa2UcjgcvpqiqF82g2bRMn4ySWXQ27NnuBpkFpb1ntsio/npR/bIJaoQHp6yJJyMHSvYxtDUiiSqG7yVNSTXDNsfku1KIozxv5dHEMhMMFOTmn/aDglqCMD1FmRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608175; c=relaxed/simple;
	bh=InBOl4qVCdo3s/gqxq0zTs4/8wuy1nxo5/EtunvUE1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qBUTYIZHhAyLYz5Q0m0emco5k71o+4uc2QL8dPysIAQyXEsICKhnS+Z/Nnac9pzE0mt6j0ZRvsUR6UjJ6U8basqZtAEVsoszCiFhO8nynAPubflLL4rbREl0yta7PER1Zwt46s898IUszGL4XgwaVTGg/gh0CytxiUlLFmtqz4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r9IBDLw0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r9IBDLw0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A38C2BCF6;
	Tue, 12 May 2026 17:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608175;
	bh=InBOl4qVCdo3s/gqxq0zTs4/8wuy1nxo5/EtunvUE1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r9IBDLw0GByvykpTcNPiE+Vjqi5rD1bgvQ/uDpdgDCYwf6Hf1FAb/0b0iQCZu9Hhm
	 ArQiTy8I7u+CjLPgJQQflctikW7aXyKuV5RBtfmh5ZYeQcrQ+uas86OM/bUQ4W6BWs
	 +ZxipzUwgBc4oJDn3wNTqzY6TcKT00Hzw9fYtMpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 183/206] hwmon: (powerz) Avoid cacheline sharing for DMA buffer
Date: Tue, 12 May 2026 19:40:35 +0200
Message-ID: <20260512173936.737676152@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 3023c050af3600bf451153335dea5e073c9a3088 ]

Depending on the architecture the transfer buffer may share a cacheline
with the following mutex. As the buffer may be used for DMA, that is
problematic.

Use the high-level DMA helpers to make sure that cacheline sharing can
not happen.

Also drop the comment, as the helpers are documentation enough.

https://sashiko.dev/#/message/20260408175814.934BFC19421%40smtp.kernel.org

Fixes: 4381a36abdf1c ("hwmon: add POWER-Z driver")
Cc: stable@vger.kernel.org # ca085faabb42: dma-mapping: add __dma_from_device_group_begin()/end()
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20260408-powerz-cacheline-alias-v1-1-1254891be0dd@weissschuh.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/powerz.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/powerz.c
+++ b/drivers/hwmon/powerz.c
@@ -6,6 +6,7 @@
 
 #include <linux/completion.h>
 #include <linux/device.h>
+#include <linux/dma-mapping.h>
 #include <linux/hwmon.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
@@ -33,7 +34,9 @@ struct powerz_sensor_data {
 } __packed;
 
 struct powerz_priv {
-	char transfer_buffer[64];	/* first member to satisfy DMA alignment */
+	__dma_from_device_group_begin();
+	char transfer_buffer[64];
+	__dma_from_device_group_end();
 	struct mutex mutex;
 	struct completion completion;
 	struct urb *urb;


