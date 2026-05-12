Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FA23EDE48;
	Tue, 12 May 2026 18:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608889; cv=none; b=qeiDTlQODhN2+70fJLr+/AvzzKWVazGj6cAa0Wz82fP+Sc6l5es4O9sPrzNTgo7vnHI2md2cVDRbZuqj5n6xzdLmbmnLTBEVVnNoSX6CIanGbJjWj+6xNbT9qG/UBljgsR1INkaXuH72tLIZ7d94ZJdtZyRC599lkX2kTbDFGec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608889; c=relaxed/simple;
	bh=Bs11X0jCgq6oyH6sqXwezVOi6M3eS1Kgnv8rtgv+4yM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lFqt4hBPJWT+gjLoSvzUPedNnCOomhE+UHA9Mh1LMlMqvflFBt/bwdT+9i8Nh0A0aoWo5CbHVNTIp/KuXLsskeVAwz6OfnUx4EqrMIy1DFtnc5z41h3kVm8/Yq4HpygmKcfz0aDnPBfwB999NuPgmvsJaUml8aj719j3OFp83uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r61Eslgh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r61Eslgh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E9AC2BCB0;
	Tue, 12 May 2026 18:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608889;
	bh=Bs11X0jCgq6oyH6sqXwezVOi6M3eS1Kgnv8rtgv+4yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r61EslghmhBswK4Jpnr1JLi8W5hGgxk8ZB/NejM0ih/GIUS5u5JlH0ixvPQFcr6Eb
	 siMoaEmy8kvbl4IHvSnMLD4AtNWbUtWxt7omRcl58RuWNwRlgAuguPZvyrphCQn61M
	 ZWFtoJyiN7i8rz/oehIJur30G3FyiQi/SlzccofE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 252/270] hwmon: (powerz) Avoid cacheline sharing for DMA buffer
Date: Tue, 12 May 2026 19:40:53 +0200
Message-ID: <20260512173943.746936825@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


