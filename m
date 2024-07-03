Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA45174ED0;
	Wed,  3 Jul 2024 10:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003641; cv=none; b=JLPo5sQRE1mhmtwd6saShivA7bswpqKfpe1Fld/wthOlCIqcG2aXAiX3xcsIbtWgFJg9gbpnirRTBkq7W3SUYykoP/Fbbl2cZjABJ3MRRaJnaXUcNsmg2hlksvNT+pB4ctJMKeRgjWBbkZHCOODZq0wUtYlZEWptrQyRF/6lke8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003641; c=relaxed/simple;
	bh=++pK8zjeE88/IrUKOHPTRm1Vz9/ZCLnQnuJgQwgp5KQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kt9/Ya54gpiQv+URC3CynNB5lR1EkLSaXkQuQYKILgo4tctZsz4NN1vlGGEvm8uvcUtG+seG5sXjmuedGfRlABLOobMmt/tbDqoQcSOU2K7PKR+j9ctN5kMWh8yFzjWyr/atOHq8M5/cU75ou/1RbpDCUXNBHejWa5vZ84ZK5rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qjX2jH/1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qjX2jH/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF22C2BD10;
	Wed,  3 Jul 2024 10:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003641;
	bh=++pK8zjeE88/IrUKOHPTRm1Vz9/ZCLnQnuJgQwgp5KQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qjX2jH/1zlTL45j2xKfhjWXBEzfFXUvRU5WFto9lfC+YRVv7ASbGDXqMmbZalru+P
	 Wokl9l8rkzLX3ZPwIq+49ZcZX2TT4jsNT/WkdBxQKyb/jmvbTd5F+wubYjuSmlwY5l
	 JpK3bN4IwsK39+KReKtKFdtcvfCdQ4nNCUBSVPNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grygorii Tertychnyi <grygorii.tertychnyi@leica-geosystems.com>,
	Peter Korsgaard <peter@korsgaard.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 115/139] i2c: ocores: set IACK bit after core is enabled
Date: Wed,  3 Jul 2024 12:40:12 +0200
Message-ID: <20240703102834.782862712@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Grygorii Tertychnyi <grembeter@gmail.com>

[ Upstream commit 5a72477273066b5b357801ab2d315ef14949d402 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-ocores.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index aa852028d8c15..7646d6c99179b 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -290,8 +290,8 @@ static int ocores_init(struct device *dev, struct ocores_i2c *i2c)
 	oc_setreg(i2c, OCI2C_PREHIGH, prescale >> 8);
 
 	/* Init the device */
-	oc_setreg(i2c, OCI2C_CMD, OCI2C_CMD_IACK);
 	oc_setreg(i2c, OCI2C_CONTROL, ctrl | OCI2C_CTRL_IEN | OCI2C_CTRL_EN);
+	oc_setreg(i2c, OCI2C_CMD, OCI2C_CMD_IACK);
 
 	return 0;
 }
-- 
2.43.0



