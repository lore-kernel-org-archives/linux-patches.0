Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D941D137;
	Mon, 18 Dec 2023 14:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OuXq4oN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2F0C433C7;
	Mon, 18 Dec 2023 14:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908248;
	bh=0nCuLDes+MM7CLZ2OwszjSyoYu4jjOJ9oMAVMyVQk68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OuXq4oN0+sEOUDJis0CtnD0cQtqAurBbwBCn8mzVlxdSzJUSADPK/1y3oISvetJqF
	 EZ6yh1rjtqIX8aSBUO49ycrhg2eX5PjLop+UwXFCgM+8qAoSUXTBG40wja/Lo9VA8e
	 xQJO8JPscfwexqo1uWn4OHN9EU5wLbMVF1vM+wmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hamish Martin <hamish.martin@alliedtelesis.co.nz>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 107/166] HID: mcp2221: Set driver data before I2C adapter add
Date: Mon, 18 Dec 2023 14:51:13 +0100
Message-ID: <20231218135109.810276930@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hamish Martin <hamish.martin@alliedtelesis.co.nz>

[ Upstream commit f2d4a5834638bbc967371b9168c0b481519f7c5e ]

The process of adding an I2C adapter can invoke I2C accesses on that new
adapter (see i2c_detect()).

Ensure we have set the adapter's driver data to avoid null pointer
dereferences in the xfer functions during the adapter add.

This has been noted in the past and the same fix proposed but not
completed. See:
https://lore.kernel.org/lkml/ef597e73-ed71-168e-52af-0d19b03734ac@vigem.de/

Signed-off-by: Hamish Martin <hamish.martin@alliedtelesis.co.nz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-mcp2221.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-mcp2221.c b/drivers/hid/hid-mcp2221.c
index 72883e0ce7575..b95f31cf0fa21 100644
--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -1157,12 +1157,12 @@ static int mcp2221_probe(struct hid_device *hdev,
 	snprintf(mcp->adapter.name, sizeof(mcp->adapter.name),
 			"MCP2221 usb-i2c bridge");
 
+	i2c_set_adapdata(&mcp->adapter, mcp);
 	ret = devm_i2c_add_adapter(&hdev->dev, &mcp->adapter);
 	if (ret) {
 		hid_err(hdev, "can't add usb-i2c adapter: %d\n", ret);
 		return ret;
 	}
-	i2c_set_adapdata(&mcp->adapter, mcp);
 
 #if IS_REACHABLE(CONFIG_GPIOLIB)
 	/* Setup GPIO chip */
-- 
2.43.0



