Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A924122FDFF;
	Tue, 22 Jul 2025 13:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192178; cv=none; b=gCUgGZqWjxTcpk05ty/s/T31WTk6tq0TUZRaz7KMnuEYPq0qjuexwdEyAb822iSrsW2napUzShiCSCkJnHU6x8oGc0R3R/W02txVqzeVPwr5Y8yOrBxbXj5gjsEfidRbiQdLfZr8vhLk67xU+atQvS8UsQtf6T+XPOIUQUO6dAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192178; c=relaxed/simple;
	bh=itYapIPGdserzMQEih0cR9pvQsuZphF1YG+dPVs7YnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qsAEnWUaTy1Ri1ONzTyy/1sd/K3ktU/7actXLJSxRkVIBgJzvIZpcHwafGWbBagyYgxdKUxc7LRhEwugmQxqCK+QGcD2MVTuqrtUjN3EWeO9aXN6JK7PICi1i3IqO/S+FDaB601rgwtYHXr/NKCOxWD8ZDoQuZpLT23XMF6wNd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A2fjlhVf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A2fjlhVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187E8C4CEEB;
	Tue, 22 Jul 2025 13:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192178;
	bh=itYapIPGdserzMQEih0cR9pvQsuZphF1YG+dPVs7YnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A2fjlhVfunfsV7Hz5sLs2b0CD4aCzk+L01VKOptuk0+MWYQ4BzFBmhDvcPmjhaawX
	 ML5dPYMBIm+lxHTofRHA/18Zck+vuVskLvL6ua15ndhDtd+WLsN4v+38zmNU99labZ
	 FLA+dw72q5FVZsqRETErMdNXfXzYbiWV5Ypo8bBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hamish Martin <hamish.martin@alliedtelesis.co.nz>,
	Jiri Kosina <jkosina@suse.cz>,
	Sumanth Gavini <sumanth.gavini@yahoo.com>
Subject: [PATCH 6.1 67/79] HID: mcp2221: Set driver data before I2C adapter add
Date: Tue, 22 Jul 2025 15:45:03 +0200
Message-ID: <20250722134330.838549046@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
References: <20250722134328.384139905@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Hamish Martin <hamish.martin@alliedtelesis.co.nz>

commit f2d4a5834638bbc967371b9168c0b481519f7c5e upstream.

The process of adding an I2C adapter can invoke I2C accesses on that new
adapter (see i2c_detect()).

Ensure we have set the adapter's driver data to avoid null pointer
dereferences in the xfer functions during the adapter add.

This has been noted in the past and the same fix proposed but not
completed. See:
https://lore.kernel.org/lkml/ef597e73-ed71-168e-52af-0d19b03734ac@vigem.de/

Signed-off-by: Hamish Martin <hamish.martin@alliedtelesis.co.nz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sumanth Gavini <sumanth.gavini@yahoo.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-mcp2221.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -879,12 +879,12 @@ static int mcp2221_probe(struct hid_devi
 	snprintf(mcp->adapter.name, sizeof(mcp->adapter.name),
 			"MCP2221 usb-i2c bridge");
 
+	i2c_set_adapdata(&mcp->adapter, mcp);
 	ret = i2c_add_adapter(&mcp->adapter);
 	if (ret) {
 		hid_err(hdev, "can't add usb-i2c adapter: %d\n", ret);
 		goto err_i2c;
 	}
-	i2c_set_adapdata(&mcp->adapter, mcp);
 
 	/* Setup GPIO chip */
 	mcp->gc = devm_kzalloc(&hdev->dev, sizeof(*mcp->gc), GFP_KERNEL);


