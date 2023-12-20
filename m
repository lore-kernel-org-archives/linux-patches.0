Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B43F482F2;
	Wed, 20 Dec 2023 16:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L1kBd2Qg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110B3C433C7;
	Wed, 20 Dec 2023 16:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703089083;
	bh=OURaTkUf6hEr5BV8uFaNbZk69glBc7D5GRX4e9IoIGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L1kBd2Qg9iOE/g2fwNMW69Xx7zzo8TlJGjrtLAGBtjt4qq8HENzkZf1PSE0i3LI8V
	 GXv8TNDj5IYjYAQy9S6t98gs/vUbgAJfMbjGq5Gv+H0jyXOmnWH3NyzowmMw0EzN9J
	 36MgRNewDtsZ21yl0V5x3ZhquNfjIfd2yagMCxRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Pundir <amit.pundir@linaro.org>
Subject: [PATCH 5.15 156/159] Revert "drm/bridge: lt9611uxc: Register and attach our DSI device at probe"
Date: Wed, 20 Dec 2023 17:10:21 +0100
Message-ID: <20231220160938.590467072@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Pundir <amit.pundir@linaro.org>

This reverts commit 29aba28ea195182f547cd8dac1b80eed51b6b73d.

This and the dependent fixes broke display on RB5.

Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/lontium-lt9611uxc.c |   31 +++++++++++------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

--- a/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
+++ b/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
@@ -367,6 +367,18 @@ static int lt9611uxc_bridge_attach(struc
 			return ret;
 	}
 
+	/* Attach primary DSI */
+	lt9611uxc->dsi0 = lt9611uxc_attach_dsi(lt9611uxc, lt9611uxc->dsi0_node);
+	if (IS_ERR(lt9611uxc->dsi0))
+		return PTR_ERR(lt9611uxc->dsi0);
+
+	/* Attach secondary DSI, if specified */
+	if (lt9611uxc->dsi1_node) {
+		lt9611uxc->dsi1 = lt9611uxc_attach_dsi(lt9611uxc, lt9611uxc->dsi1_node);
+		if (IS_ERR(lt9611uxc->dsi1))
+			return PTR_ERR(lt9611uxc->dsi1);
+	}
+
 	return 0;
 }
 
@@ -946,27 +958,8 @@ retry:
 
 	drm_bridge_add(&lt9611uxc->bridge);
 
-	/* Attach primary DSI */
-	lt9611uxc->dsi0 = lt9611uxc_attach_dsi(lt9611uxc, lt9611uxc->dsi0_node);
-	if (IS_ERR(lt9611uxc->dsi0)) {
-		ret = PTR_ERR(lt9611uxc->dsi0);
-		goto err_remove_bridge;
-	}
-
-	/* Attach secondary DSI, if specified */
-	if (lt9611uxc->dsi1_node) {
-		lt9611uxc->dsi1 = lt9611uxc_attach_dsi(lt9611uxc, lt9611uxc->dsi1_node);
-		if (IS_ERR(lt9611uxc->dsi1)) {
-			ret = PTR_ERR(lt9611uxc->dsi1);
-			goto err_remove_bridge;
-		}
-	}
-
 	return lt9611uxc_audio_init(dev, lt9611uxc);
 
-err_remove_bridge:
-	drm_bridge_remove(&lt9611uxc->bridge);
-
 err_disable_regulators:
 	regulator_bulk_disable(ARRAY_SIZE(lt9611uxc->supplies), lt9611uxc->supplies);
 


