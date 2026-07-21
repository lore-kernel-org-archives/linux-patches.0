Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A60402BA9;
	Tue, 21 Jul 2026 17:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654310; cv=none; b=TbgMQg5JHP/3JfQVUOCHv9hrM244ujtdu6Y8cogg0RIUq5pmPrIbW47GU+/6spBJj9NZe3kwVU6R85QmkhVkL5XNHRJQoMC0wgOPdB8qbZibovrEMMPyBSkhpJ2G4/Zmm162ddSHqyQVYCWcPeaxmW33hglmzf54Ni1drk+kEnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654310; c=relaxed/simple;
	bh=b1IagddmzDWoEjKMRaWprf4vPYNRtAl+F5bC8L4SgaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i6vFhQr0IbQYtIA70qBRs6HSYBrXzzLP4ABITww1y7+vJV91v53kpgNJphW8nZX3K7PagrhUR45ZY9MLOWW+anXwDM4DXMr0YHD5IPbhInmO2PnEZ/2/99Gl+ibGypL5P3RlIJ9oYF9/25w2WuSdWUgaKtROwxuQKM5EwW9MkRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H8k5DxlU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H8k5DxlU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7871F00A3A;
	Tue, 21 Jul 2026 17:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654309;
	bh=tSr6fg0C/8rCLGywQqHAiWQu4pZyqk0nSugvxIZMv6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H8k5DxlUzJmiRixrCspYLwTqYRsT1oqGz33PhEdPNhlVN/v/q+WL5U9S8RnTxxb9b
	 2SGLkEAb0UcDjtl+xOG0op4Puq/SR0auV6v05W3T7UZs2xEp9H0u3pN9timDFObicI
	 EiKyUu3PSJPIGYr9guE+QZgYx2DUwhlhTY9UuFNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 7.1 1654/2077] mfd: tps6586x: Fix OF node refcount
Date: Tue, 21 Jul 2026 17:22:07 +0200
Message-ID: <20260721152631.760251385@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit 3001ed2b4e06da2276c42ace6551617065a5b1f9 upstream.

Platform devices created with platform_device_alloc() call
platform_device_release() when the last reference to the device's
kobject is dropped. This function calls of_node_put() unconditionally.
This works fine for devices created with platform_device_register_full()
but users of the split approach (platform_device_alloc() +
platform_device_add()) must bump the reference of the of_node they
assign manually. Add the missing call to of_node_get().

Cc: stable@vger.kernel.org
Fixes: 62f6b0879304 ("tps6586x: Add device tree support")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260521-pdev-fwnode-ref-v1-1-88c324a1b8d2@oss.qualcomm.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/tps6586x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -397,7 +397,7 @@ static int tps6586x_add_subdevs(struct t
 
 		pdev->dev.parent = tps6586x->dev;
 		pdev->dev.platform_data = subdev->platform_data;
-		pdev->dev.of_node = subdev->of_node;
+		pdev->dev.of_node = of_node_get(subdev->of_node);
 
 		ret = platform_device_add(pdev);
 		if (ret) {


