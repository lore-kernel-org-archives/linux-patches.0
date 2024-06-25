Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEDC13C90B;
	Tue, 25 Jun 2024 10:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309721; cv=none; b=T4xraZ8AFS5WY0VD5K9NYlyH1It/Q949lmSMT4ynGZnDTBaly7L68O6CQg/m/n/27e25Ji39igaoI96XieBNwXl4tuOcRAmEDTh72K8cwvrYlj4TfN0x00sdH8AJPJmrmyYd7GBmFj/1h3btFUHX5t5Rcsq/FW+Okv0zTFnCtmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309721; c=relaxed/simple;
	bh=bWOE2PWYYE1sNsVjQ/zawOfhcBQ7SXXjGIaI4Au329Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=puwnV8sHUAIoeF26z4l6GWrzsR7hjXLaBccesxNCJxex0bF6pEAv4uvfbhqF7OFF1DgdlnRIhlLXcabZlg3KX9S+96k3LCf+WfOvnjTQ0IGPD6AP9cfDKw2+hbfZnFeK1RlGwMzZGKgEaPchKyRgt/4orojihaI1NSu11gKsfVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yrJSzTb6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yrJSzTb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12DC9C32781;
	Tue, 25 Jun 2024 10:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309721;
	bh=bWOE2PWYYE1sNsVjQ/zawOfhcBQ7SXXjGIaI4Au329Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yrJSzTb6GADBKzDCcDH0e643axZg7l9CWyErzrxvlTEFr6EqJETOZb4P97fh7xApK
	 tf2j5lZ6xTsp3BnXDq+ZtAKRs4A6lAL87+buWcyKfnFaBW6CL9osdBZ/RrNU4bROqY
	 Mp7nOGxdyJGcaLVcEiD68zR5RTDWVA0GdqpGS2ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grygorii Tertychnyi <grygorii.tertychnyi@leica-geosystems.com>,
	Peter Korsgaard <peter@korsgaard.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.1 112/131] i2c: ocores: set IACK bit after core is enabled
Date: Tue, 25 Jun 2024 11:34:27 +0200
Message-ID: <20240625085530.194261169@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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
@@ -442,8 +442,8 @@ static int ocores_init(struct device *de
 	oc_setreg(i2c, OCI2C_PREHIGH, prescale >> 8);
 
 	/* Init the device */
-	oc_setreg(i2c, OCI2C_CMD, OCI2C_CMD_IACK);
 	oc_setreg(i2c, OCI2C_CONTROL, ctrl | OCI2C_CTRL_EN);
+	oc_setreg(i2c, OCI2C_CMD, OCI2C_CMD_IACK);
 
 	return 0;
 }


