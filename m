Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A830232BF22;
	Tue, 16 Dec 2025 11:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884248; cv=none; b=nZjkK4ifiT0Ble4vVMwJMy6jZ2BeC3StdmlfWC9QRzmA3SdL/F4qXhh1HXMfADY49loDYjM8BnrRr3ppuu9O0zK4XSru6EOB3XIRHlNinmtqVX1Icbq4TBbDrQI4+TyDIwcR1KlpyE2BUbRdQ8zgv7vUHrcyCXUUjuFqDF7A4lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884248; c=relaxed/simple;
	bh=REe75RiLyAjE5TkeXT6ojpsyMS34Ub1qubO2gy7GWA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gV03s1/1UBOvReSGGR1YAbN7+DQer+vEzoSw7pyvGhQmXsDYOYLtRhRL5IiT8OuqrnhcqOBaEPX3lsZngtwCm2Y88jVpyrmX8xtABQdpLT2LGrd5AA85pu3cEVG/Bsz9xFhJfL2HNEH8B0QrELS36181GsTIQfkozDHcKidJppY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A5vDViJO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A5vDViJO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F17C4CEF1;
	Tue, 16 Dec 2025 11:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884248;
	bh=REe75RiLyAjE5TkeXT6ojpsyMS34Ub1qubO2gy7GWA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A5vDViJOMhhVHHDuDXKAwYGkI7pUFfA80YQ+57k/ZXWzURrB2iLMvINktvemA1/Fj
	 TpGGoVO7vwBMMz14MYrtYE5QqgoL6KRdxUqV5tu4AqZtAxJWEPLUWMjRyuYoxXgfJ7
	 E88WBAUq2UQKj5DLcBMM3yD7Nzik6r5D2SQyQj20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 103/354] power: supply: rt5033_charger: Fix device node reference leaks
Date: Tue, 16 Dec 2025 12:11:10 +0100
Message-ID: <20251216111324.651691165@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 6cdc4d488c2f3a61174bfba4e8cc4ac92c219258 ]

The device node pointers `np_conn` and `np_edev`, obtained from
of_parse_phandle() and of_get_parent() respectively, are not released.
This results in a reference count leak.

Add of_node_put() calls after the last use of these device nodes to
properly release their references and fix the leaks.

Fixes: 8242336dc8a8 ("power: supply: rt5033_charger: Add cable detection and USB OTG supply")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20250929113234.1726-1-vulab@iscas.ac.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/rt5033_charger.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/power/supply/rt5033_charger.c b/drivers/power/supply/rt5033_charger.c
index d19c7e80a92aa..c7d82a8065917 100644
--- a/drivers/power/supply/rt5033_charger.c
+++ b/drivers/power/supply/rt5033_charger.c
@@ -700,6 +700,8 @@ static int rt5033_charger_probe(struct platform_device *pdev)
 	np_conn = of_parse_phandle(pdev->dev.of_node, "richtek,usb-connector", 0);
 	np_edev = of_get_parent(np_conn);
 	charger->edev = extcon_find_edev_by_node(np_edev);
+	of_node_put(np_edev);
+	of_node_put(np_conn);
 	if (IS_ERR(charger->edev)) {
 		dev_warn(charger->dev, "no extcon device found in device-tree\n");
 		goto out;
-- 
2.51.0



