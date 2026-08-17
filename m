Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B0C40F734;
	Mon, 17 Aug 2026 14:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975214; cv=none; b=i/T2KBXVNuDm1zUjGZIBOifwNuKbtS7wxOYJOZfeF2aNFzfQeeQsDboC2qhj32XBkkXk63xOBva2sqS3RX+KGm+DEBtLFA3cAsKfg49Olv1kRNO7x19kTEvgqzizK63sIMZSg8NaHFN/XDZJ1/GBo5DwK+kECgYyGVDfbxNek/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975214; c=relaxed/simple;
	bh=tv9xKZC2qfCX94h7un+IgvguJHP4Q7my/tRWkuQMOho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SecycSLoY2+UaiFsvYT/6NQEIc4imBKzaps2MTrCI+MS8cWJq+9rz35RSTHsdgWiqPimsDlhtazlMaPD7htpgKUxWrGXcqFD/MV5X6ZvM0/m4XdmMVMMioW5CJQqf2qm4eOsiuT1D6BPL4pbrqOxj84p57p/vQSDerxciU9xV0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZEdv/dw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZEdv/dw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8676A1F000E9;
	Mon, 17 Aug 2026 14:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975213;
	bh=rx7ANdMtXKsx/7hYCvNgEZqLZKPyAoOe70DoVW4MPWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MZEdv/dwpf0CXrICifltvYTuS9E9xAAqzK050ynH3wM/pL8oKhIsDdz8PHfbFGWkU
	 edSDKMQHQKZDDGP0ZX1m28x4KcDMONn90hLpGCINvn6zeSjNDHx5467/lIBH/jmUyL
	 UX8Yp++lHsYJW6gmeAxvhSJlnjfcZR7YnL2pL3ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aelin Reidel <aelin@mainlining.org>,
	Clayton Craft <craftyguy@postmarketos.org>,
	Sven Peter <sven@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.18 161/250] nvmem: apple-spmi-nvmem: wrap regmap calls to satisfy CFI
Date: Mon, 17 Aug 2026 15:32:02 +0200
Message-ID: <20260817132543.175847018@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/nvmem/apple-spmi-nvmem.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/nvmem/apple-spmi-nvmem.c b/drivers/nvmem/apple-spmi-nvmem.c
index 88614005d5ce..7acb0c07d6ab 100644
--- a/drivers/nvmem/apple-spmi-nvmem.c
+++ b/drivers/nvmem/apple-spmi-nvmem.c
@@ -18,6 +18,22 @@ static const struct regmap_config apple_spmi_regmap_config = {
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
@@ -28,8 +44,8 @@ static int apple_spmi_nvmem_probe(struct spmi_device *sdev)
 		.word_size = 1,
 		.stride = 1,
 		.size = 0xffff,
-		.reg_read = (void *)regmap_bulk_read,
-		.reg_write = (void *)regmap_bulk_write,
+		.reg_read = apple_spmi_nvmem_read,
+		.reg_write = apple_spmi_nvmem_write,
 	};
 
 	regmap = devm_regmap_init_spmi_ext(sdev, &apple_spmi_regmap_config);
-- 
2.55.0



