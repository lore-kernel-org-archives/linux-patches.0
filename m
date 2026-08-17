Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6293CB544;
	Mon, 17 Aug 2026 13:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974350; cv=none; b=HGuje0On71NH8Lt8es7JGAPJc2Rmc+da0dKoqADIrSF99vbVfKiE0Jn4x8fgNSz/mJHkMy2b/ZWLP7WV6NZ55vBlfsVW/u0YRfeMsqOKC46fdPqsGEUjPRgf7ASGz8n507LXAlHhKjbW+Bo+1L17vVpdyQ0pJTPU1CnOIZy6HpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974350; c=relaxed/simple;
	bh=B+MFvNrIXuBMRPxGvWSg54wgM44y5HcWRUs59PVq+9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z85FYpirKVO0vI6lJqaZ5AMt8wjsgcpTzVExQ3jJvClea8zU1hh7IuFL8S8X1Lb3JBBLBqURfstr7W2W6pFy7ssd6xuiKx/pHyS16KcWxIEbJuFvQ+s/v11H4tGiv3+JssBzvbNzNeC70vh04JG57PALck2t8Ub0w90jdzEtVZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qaCA6dke; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qaCA6dke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628EF1F000E9;
	Mon, 17 Aug 2026 13:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974343;
	bh=f+vJeIfCVqwpdXBFeWCoUDKZuMjPLK3XS2FEX3KBY24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qaCA6dkedWtqJPWhu6Q/RnL82PiX1gIoOqo/9daoKLFjdLeZp/1lZVSejZM3HrI45
	 R03Fudp0/S236/0SwzQl0XVUOrR8biuEc4Nx1/+fIwRAwec59hLsmM1kQQeEy5Mub7
	 t5+AwIBiZ9zB75CdbQHxvNX0hj/aMnaNvLSTAPA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aelin Reidel <aelin@mainlining.org>,
	Clayton Craft <craftyguy@postmarketos.org>,
	Sven Peter <sven@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 7.1 174/271] nvmem: apple-spmi-nvmem: wrap regmap calls to satisfy CFI
Date: Mon, 17 Aug 2026 15:31:39 +0200
Message-ID: <20260817132544.016878061@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aelin Reidel <aelin@mainlining.org>

commit ff10b6db0ab75b132aed69ab144ac04f63ef9bdb upstream.

The Apple SPMI NVMEM driver previously cast regmap_bulk_read/write to
void * when assigning them to nvmem_config's reg_read/reg_write
function pointers.

This cast breaks the expected function signature of nvmem_reg_read_t
and nvmem_reg_write_t. With CFI enabled, indirect calls through
these pointers fail:

  CFI failure at nvmem_reg_write+0x194/0x1e4 (target: regmap_bulk_write+0x0/0x2c8; expected type: 0x83a189c3)
  ...
  Call trace:
   nvmem_reg_write+0x194/0x1e4 (P)
   __nvmem_cell_entry_write+0x298/0x2e8
   nvmem_cell_write+0x24/0x34
   macsmc_reboot_probe+0x1dc/0x454 [macsmc_reboot]
  ...

Introduce thin wrapper functions with the correct nvmem function
pointer types to satisfy the CFI checks.

Fixes: fe91c24a551c ("nvmem: Add apple-spmi-nvmem driver")
Signed-off-by: Aelin Reidel <aelin@mainlining.org>
Reported-by: Clayton Craft <craftyguy@postmarketos.org>
Tested-by: Clayton Craft <craftyguy@postmarketos.org>
Reviewed-by: Sven Peter <sven@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260724223404.629248-2-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/apple-spmi-nvmem.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/drivers/nvmem/apple-spmi-nvmem.c
+++ b/drivers/nvmem/apple-spmi-nvmem.c
@@ -18,6 +18,22 @@ static const struct regmap_config apple_
 	.max_register	= 0xffff,
 };
 
+static int apple_spmi_nvmem_read(void *priv, unsigned int offset, void *val,
+				 size_t bytes)
+{
+	struct regmap *map = priv;
+
+	return regmap_bulk_read(map, offset, val, bytes);
+}
+
+static int apple_spmi_nvmem_write(void *priv, unsigned int offset, void *val,
+				  size_t bytes)
+{
+	struct regmap *map = priv;
+
+	return regmap_bulk_write(map, offset, val, bytes);
+}
+
 static int apple_spmi_nvmem_probe(struct spmi_device *sdev)
 {
 	struct regmap *regmap;
@@ -28,8 +44,8 @@ static int apple_spmi_nvmem_probe(struct
 		.word_size = 1,
 		.stride = 1,
 		.size = 0xffff,
-		.reg_read = (void *)regmap_bulk_read,
-		.reg_write = (void *)regmap_bulk_write,
+		.reg_read = apple_spmi_nvmem_read,
+		.reg_write = apple_spmi_nvmem_write,
 	};
 
 	regmap = devm_regmap_init_spmi_ext(sdev, &apple_spmi_regmap_config);


