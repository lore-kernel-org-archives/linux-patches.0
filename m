Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703166F53E;
	Thu,  3 Jul 2025 15:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554841; cv=none; b=T2n9YDy7KuaPno9iBMRtIV9sE2hWeFuI5jt9hJZOJuZ8ZyBcqYS2Dz0HelrvbSHstVqJr7rdduXJXkQjTR+hK1gTLuHq0eYOcyv8Irv7JTkK65FHMjHCUruLcMeUwxAnv+EGFttbvdnDgypEJGftQjvkGQ+cpKial9wAnxsz0GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554841; c=relaxed/simple;
	bh=8QR/xSIPTsj7RMnid529MVivfTFCPXlXFOMNaDZikBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kieAl1uSlRBPXxGw3EJ5+cnw6b5YULk+DIYptLmLrJ4XHKstZIXSKNPh0ry6d7TrsY6RU4kY/izpaLXvQb7I3D89m8cq22DVv1ZS+6kc81J7o5evEbISE7vuSu5/ZKI8W3lBWMLGuCUi77WoMFT94YvyPyJZM18qcrzJLzy5nhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R4GRtMxO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R4GRtMxO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F8FC4CEE3;
	Thu,  3 Jul 2025 15:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554841;
	bh=8QR/xSIPTsj7RMnid529MVivfTFCPXlXFOMNaDZikBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R4GRtMxO6GppiWTNp1zrgb45xJcQ9oYYB2nE3VNwVMAmVv5Go1m8pC7FE8gww2JJT
	 9yOKDzLenNp1LSWso3lpdXY1VlRvOToX+DtzItXUJkC0jk6cSjLECq5dc6+Wxf3CKR
	 mXZ2DKbl69HDoWrk5ZvrVebQnSptYjIxGIbmdRj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 065/263] usb: typec: tipd: Fix wakeup source leaks on device unbind
Date: Thu,  3 Jul 2025 16:39:45 +0200
Message-ID: <20250703144006.909889623@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit aaa8f2e959341fd4a3ccf111500eb1e6176678e0 ]

Device can be unbound, so driver must also release memory for the wakeup
source.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250406204051.63446-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tipd/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tipd/core.c b/drivers/usb/typec/tipd/core.c
index 7ee721a877c12..dcf141ada0781 100644
--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -1431,7 +1431,7 @@ static int tps6598x_probe(struct i2c_client *client)
 
 	tps->wakeup = device_property_read_bool(tps->dev, "wakeup-source");
 	if (tps->wakeup && client->irq) {
-		device_init_wakeup(&client->dev, true);
+		devm_device_init_wakeup(&client->dev);
 		enable_irq_wake(client->irq);
 	}
 
-- 
2.39.5



