Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F89A223335;
	Mon, 23 Jun 2025 21:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713373; cv=none; b=i/b97RU+NE4UplrwGp7ojcdvG8APgKIEmaNq47YyFlKyW7HdylkV+HIJWRoclsrYzB7z4qdeiU46J3mndnowUkju7KhXrCk4bF/ElldQ+pqETvef+6LIvmZcPk0MbUHfyKuTZkuqyqmu2wrrd0NP3QyeRoE/Wbuko2pwHsxqxR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713373; c=relaxed/simple;
	bh=Gja8w+ntt8tAoshszK5eYegeiTzXt+zv3cfPgUHXe1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IKQrOnVkb3PRX31w7mRY37oKv/xbvgAjbAzvykLtZl1h3KEIKoAjousNhlhVHnZ2aQFrRAmnl424CRx5o00Fjj0gQ3RThFm+/EIfsW1fIfPKcR/BxEh4U8RBq3bsTsDwpqLvSJ1FQeNv4I3m97367EvCPXWT5xkr0O0ae5t6ONc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ARjzQPRH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ARjzQPRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9ABEC4CEF4;
	Mon, 23 Jun 2025 21:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713373;
	bh=Gja8w+ntt8tAoshszK5eYegeiTzXt+zv3cfPgUHXe1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ARjzQPRHFYyUR+pQX4HnkUqU2rcUh4Qac2Mn6wN9u+G3SNOTSoY5JRGSBj9qpp9xS
	 ezPbviQG0sZXkZTbRwDR41AnfXnfsrooKE2mTK5GVX2vpVLvcMAfZ8sQusmY+tpQkF
	 HhG5yqr0VCEybczvhMDs+xgnS16KCYSX8kSVxtd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 323/592] Bluetooth: btmtksdio: Fix wakeup source leaks on device unbind
Date: Mon, 23 Jun 2025 15:04:41 +0200
Message-ID: <20250623130708.129183024@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

[ Upstream commit ee3e4209e66d44180a41d5ca7271361a2a28fccf ]

Device can be unbound or probe can fail, so driver must also release
memory for the wakeup source.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtksdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btmtksdio.c b/drivers/bluetooth/btmtksdio.c
index 1d26207b2ba70..c16a3518b8ffa 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -1414,7 +1414,7 @@ static int btmtksdio_probe(struct sdio_func *func,
 	 */
 	pm_runtime_put_noidle(bdev->dev);
 
-	err = device_init_wakeup(bdev->dev, true);
+	err = devm_device_init_wakeup(bdev->dev);
 	if (err)
 		bt_dev_err(hdev, "failed to initialize device wakeup");
 
-- 
2.39.5



