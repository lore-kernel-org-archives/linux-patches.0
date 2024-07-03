Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A948A19B5A3;
	Wed,  3 Jul 2024 10:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004095; cv=none; b=jTJ3CBUdBm2WI0xxHqC6n9rAd4DTHY8/oX4NfNc5Nil4Ua3cLnyI9HWHS7dFoLwU99VnpTsFutAOssNhocgejzeaPs7uuwf7ZkgLEujnR+t8IUvFdfdXpth98bYeApblnIUeE1Aitps+LJKJy3USc8N6IKQu9yuyeYXRpwkEC5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004095; c=relaxed/simple;
	bh=hh/OdoEMIfuwLROH5Y8FDWzNc1ucT7aBrG5WEfzTAkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIpwtkhN1hrLWEkhzwP8iEx5XCZLORL+8KTABCQU4zHALQVpnCkbie4dejC/LoJMd1paoiXLs5iimFwzDbrZDCG88rXUDkCGs6hWvRuyfdUR4CBakKKR0ARnC4UT0v47c7Kku+X3slLMfBBTAvlIPUN8IQK6xQgx9++O5XdaNLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rGYxhygh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rGYxhygh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC47DC2BD10;
	Wed,  3 Jul 2024 10:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004095;
	bh=hh/OdoEMIfuwLROH5Y8FDWzNc1ucT7aBrG5WEfzTAkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rGYxhyghXNBu8WnwghJfS2EoGfZxhYK03a54MHNaSlPdV+6c6muXOVQWQMhvK6gwr
	 YUB4WPGvbo2FvWKO8gsGAwbSsvRO7jWGG8shsRJEDPCkTNoDcE2yaK0qsiIJ4MFNep
	 vPqYNV8ZCzJIj+RwipBx6ptEjdLakJTe82I4hJkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grygorii Tertychnyi <grygorii.tertychnyi@leica-geosystems.com>,
	Peter Korsgaard <peter@korsgaard.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.4 119/189] i2c: ocores: set IACK bit after core is enabled
Date: Wed,  3 Jul 2024 12:39:40 +0200
Message-ID: <20240703102845.988985085@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Grygorii Tertychnyi <grembeter@gmail.com>

commit 5a72477273066b5b357801ab2d315ef14949d402 upstream.

Setting IACK bit when core is disabled does not clear the "Interrupt Flag"
bit in the status register, and the interrupt remains pending.

Sometimes it causes failure for the very first message transfer, that is
usually a device probe.

Hence, set IACK bit after core is enabled to clear pending interrupt.

Fixes: 18f98b1e3147 ("[PATCH] i2c: New bus driver for the OpenCores I2C controller")
Signed-off-by: Grygorii Tertychnyi <grygorii.tertychnyi@leica-geosystems.com>
Acked-by: Peter Korsgaard <peter@korsgaard.com>
Cc: stable@vger.kernel.org
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-ocores.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -443,8 +443,8 @@ static int ocores_init(struct device *de
 	oc_setreg(i2c, OCI2C_PREHIGH, prescale >> 8);
 
 	/* Init the device */
-	oc_setreg(i2c, OCI2C_CMD, OCI2C_CMD_IACK);
 	oc_setreg(i2c, OCI2C_CONTROL, ctrl | OCI2C_CTRL_EN);
+	oc_setreg(i2c, OCI2C_CMD, OCI2C_CMD_IACK);
 
 	return 0;
 }


