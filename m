Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF653F3265;
	Mon, 17 Aug 2026 14:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976276; cv=none; b=oJeTCCbEvxL1czm2hn64bfXRpK3JD8yg/dMHdUGqZHrt/mQc7GU6jiidxsfQ3MEsyqMkp7zAE2hxVtNc9OxD1ShOLX2/0JrddAvcsN2A+/A/8o6MNjzgmiMuPGYUOdU5Zu35iWpxHPQXhvL/5wEtwwV9EGHxXuxPjpO7YNw6MtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976276; c=relaxed/simple;
	bh=1S4oAWxTRDYs+QuYy/XyD8NX6yC9Osy8xE/yr9yO7vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWCBhiH+FkvttZyY8P3URSUEAHR9Un70hDGlu9pkrOyVY7r8y+SE/R3694YKB1ez5rHr7QNxrIEm0k57pVELwi81Ej63ql2AaogiJYmWSUEyA/RUAR3+ZJ63obdGQG3UwyCxKvEso2uQay/7D6g4suNekfKNMYf5/p0gcNCSOfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tGuFmchv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tGuFmchv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D901F000E9;
	Mon, 17 Aug 2026 14:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976275;
	bh=5tRaGwjUNx7boWCXmG5nOFyVsCUKM6yFxeWxAbJ30RI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tGuFmchvSkTYVFsUEKyAn5ZOhRpwP3nxmsrBIAttkr9wcL0qS8DHr4PH93/8NaGiS
	 y9nukualW9Ro0y6rQh/kgsSOHge3Hwx+R7nOlG4Z8Yhj+L6YBYADz6uDhoqPggYJTg
	 5/CXvg6elRZp6GGoccaaEafmXX5aKwiT7x1ZuHJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.10 280/389] i2c: amd-mp2: Unregister callback on adapter add failure
Date: Mon, 17 Aug 2026 15:31:59 +0200
Message-ID: <20260817132550.060399501@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit 82048795242f04275a3f49ffc66ad851b6120954 upstream.

amd_mp2_register_cb() stores the platform I2C context in the MP2 PCI
driver's callback table before the adapter is registered. If
i2c_add_adapter() fails, probe returns and devres frees the context,
but the PCI driver can still dereference the stale pointer from its IRQ
and system-sleep callbacks.

Unregister the callback before returning the adapter registration error.

Fixes: 529766e0a011 ("i2c: Add drivers for the AMD PCIe MP2 I2C controller")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Cc: <stable@vger.kernel.org> # v5.2+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260721144147.31150-1-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-amd-mp2-plat.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-amd-mp2-plat.c
+++ b/drivers/i2c/busses/i2c-amd-mp2-plat.c
@@ -327,8 +327,10 @@ static int i2c_amd_probe(struct platform
 
 	amd_mp2_pm_runtime_put(mp2_dev);
 
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(&pdev->dev, "i2c add adapter failed = %d\n", ret);
+		amd_mp2_unregister_cb(&i2c_dev->common);
+	}
 
 	return ret;
 }


