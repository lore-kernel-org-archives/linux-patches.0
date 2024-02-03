Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F7C18E0F;
	Sat,  3 Feb 2024 04:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933439; cv=none; b=eEpEegQ4NbUNt5R5oZ0OjttzeCtBwNLpgU8mMNuUz37D5Ydj4VpIB/Ir2JEtlX8pvKJETkldHj8PG5gJRASxkgEjryWIv+OAZ3sURCsqzK5ytromq2TonDlYhlb49P3AxgCRoToMzV10V8gqctdFpetvcBWaTVPWMdao4pVZVeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933439; c=relaxed/simple;
	bh=R8J8mUspFcl43KgbOcM8OrdtzZHrdiqkc+qTlbtjpy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tyGQRIgQITJaWGifFnHv3za78sc1aNvBRp72Da+aAEbx59ki7kG6CPOBD7Yaoe4nbbSRG3NkWbIKNeTwj1prJImoCFya065FThycvQBBVgpVRKXnGCQfmya6ur2jSuvKHF3A/nNFuK5GoNPIwLZxn00w3qsc3IsovJ2bdLxkrq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jbFR2kQ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jbFR2kQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA2CC43399;
	Sat,  3 Feb 2024 04:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933439;
	bh=R8J8mUspFcl43KgbOcM8OrdtzZHrdiqkc+qTlbtjpy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jbFR2kQ6kl/WxbFYo9w6aULNbP1DmCCrDHM+korhjGEA2ZtxqSE30hmpnUVKw+kqu
	 mojCc/5zLZzsHS54JuA8yQbRBWNpdwf2kUIoTNuX/rApjC3lDBz9HDWZXYFELksTrn
	 g91kgacbApjK0J1X7mONKZIdLdbQLrkl2SATDSZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 169/219] misc: lis3lv02d_i2c: Add missing setting of the reg_ctrl callback
Date: Fri,  2 Feb 2024 20:05:42 -0800
Message-ID: <20240203035340.354849038@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit b1b9f7a494400c0c39f8cd83de3aaa6111c55087 ]

The lis3lv02d_i2c driver was missing a line to set the lis3_dev's
reg_ctrl callback.

lis3_reg_ctrl(on) is called from the init callback, but due to
the missing reg_ctrl callback the regulators where never turned off
again leading to the following oops/backtrace when detaching the driver:

[   82.313527] ------------[ cut here ]------------
[   82.313546] WARNING: CPU: 1 PID: 1724 at drivers/regulator/core.c:2396 _regulator_put+0x219/0x230
...
[   82.313695] RIP: 0010:_regulator_put+0x219/0x230
...
[   82.314767] Call Trace:
[   82.314770]  <TASK>
[   82.314772]  ? _regulator_put+0x219/0x230
[   82.314777]  ? __warn+0x81/0x170
[   82.314784]  ? _regulator_put+0x219/0x230
[   82.314791]  ? report_bug+0x18d/0x1c0
[   82.314801]  ? handle_bug+0x3c/0x80
[   82.314806]  ? exc_invalid_op+0x13/0x60
[   82.314812]  ? asm_exc_invalid_op+0x16/0x20
[   82.314845]  ? _regulator_put+0x219/0x230
[   82.314857]  regulator_bulk_free+0x39/0x60
[   82.314865]  i2c_device_remove+0x22/0xb0

Add the missing setting of the callback so that the regulators
properly get turned off again when not used.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20231224183402.95640-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/lis3lv02d/lis3lv02d_i2c.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c b/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
index d7daa01fe7ca..fdec2c30eb16 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
@@ -151,6 +151,7 @@ static int lis3lv02d_i2c_probe(struct i2c_client *client,
 	lis3_dev.init	  = lis3_i2c_init;
 	lis3_dev.read	  = lis3_i2c_read;
 	lis3_dev.write	  = lis3_i2c_write;
+	lis3_dev.reg_ctrl = lis3_reg_ctrl;
 	lis3_dev.irq	  = client->irq;
 	lis3_dev.ac	  = lis3lv02d_axis_map;
 	lis3_dev.pm_dev	  = &client->dev;
-- 
2.43.0



