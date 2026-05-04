Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1469F3DEFF6;
	Mon,  4 May 2026 14:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904494; cv=none; b=ohgx2IGtpMDZUHTbyj6og5+cJJKHA49kz+Qnj7O16tAdJE9tHh3wzHvnS/xERr1vGlF4uQ2Vrd1xRPRxxSyLfJS5l4tEuXnJ0nC7VYS24WSoURvyXN9gT0MxUsAKpqAPQBufzAJ0OiASe2eDis9D0MGU9m2dkGNrBhlrsLNc+bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904494; c=relaxed/simple;
	bh=8LUwWvbm1RwuVIv24bTBFVKuV6+/U5BE0rSw/NwU958=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TcLPI3Ixwg1s4NIq2uZRii6XKg5H5g8rwSKsEOJzkLdFGOEcWkX7/NWqNALXH3LqIv/vfhC+xGFJ95CWoTLwvkxclENL1Duefw7SmRBQZQXRmwdjHFkEuvdp+qCRcNoxm3Def+dXNO3LgcDpjH5rsRsrbxUNyWsaS3/Xy6IABM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xnb7wJ0m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xnb7wJ0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E950C2BCB8;
	Mon,  4 May 2026 14:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904494;
	bh=8LUwWvbm1RwuVIv24bTBFVKuV6+/U5BE0rSw/NwU958=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xnb7wJ0mZHSry7kpzIX2KdF9hEGluo+WC4IFiDo8PvNFCkMYoom2++99zM7IuXL8L
	 z6Wa4Ce/VQ418mv7+8bylx3nbs8Z0OPMv01l2d9f/zPQBzUxylC6avfMF00/gOWmlK
	 uQ3XTCQZjQZPolMHMs1d48rtdickyrTz8zaiLUU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@nabladev.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.12 059/215] mfd: stpmic1: Attempt system shutdown twice in case PMIC is confused
Date: Mon,  4 May 2026 15:51:18 +0200
Message-ID: <20260504135132.331248321@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@nabladev.com>

commit ffdc5c51f8bcd0e5e8255ca275a0a3b958475d99 upstream.

Attempt to shut down again, in case the first attempt failed.
The STPMIC1 might get confused and the first regmap_update_bits()
returns with -ETIMEDOUT / -110 . If that or similar transient
failure occurs, try to shut down again. If the second attempt
fails, there is some bigger problem, report it to user.

Cc: stable@vger.kernel.org
Fixes: 6e9df38f359a ("mfd: stpmic1: Add PMIC poweroff via sys-off handler")
Signed-off-by: Marek Vasut <marex@nabladev.com>
Link: https://patch.msgid.link/20260122111423.62591-1-marex@nabladev.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/stpmic1.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/drivers/mfd/stpmic1.c
+++ b/drivers/mfd/stpmic1.c
@@ -16,6 +16,8 @@
 
 #include <dt-bindings/mfd/st,stpmic1.h>
 
+#define STPMIC1_MAX_RETRIES 2
+
 #define STPMIC1_MAIN_IRQ 0
 
 static const struct regmap_range stpmic1_readable_ranges[] = {
@@ -121,9 +123,23 @@ static const struct regmap_irq_chip stpm
 static int stpmic1_power_off(struct sys_off_data *data)
 {
 	struct stpmic1 *ddata = data->cb_data;
+	int ret;
+
+	/*
+	 * Attempt to shut down again, in case the first attempt failed.
+	 * The STPMIC1 might get confused and the first regmap_update_bits()
+	 * returns with -ETIMEDOUT / -110 . If that or similar transient
+	 * failure occurs, try to shut down again. If the second attempt
+	 * fails, there is some bigger problem, report it to user.
+	 */
+	for (int retries = 0; retries < STPMIC1_MAX_RETRIES; retries++) {
+		ret = regmap_update_bits(ddata->regmap, MAIN_CR, SOFTWARE_SWITCH_OFF,
+					 SOFTWARE_SWITCH_OFF);
+		if (!ret)
+			return NOTIFY_DONE;
+	}
 
-	regmap_update_bits(ddata->regmap, MAIN_CR,
-			   SOFTWARE_SWITCH_OFF, SOFTWARE_SWITCH_OFF);
+	dev_err(ddata->dev, "Failed to access PMIC I2C bus (%d)\n", ret);
 
 	return NOTIFY_DONE;
 }


