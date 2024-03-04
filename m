Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FEC78B47;
	Mon,  4 Mar 2024 21:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589374; cv=none; b=geGnV8wB08G9vo8IVQjeoRJV07n2UjGdWInD23uMsSqQgbD8V5YAxVINbL17NWbGO9NCkGtCf1Tgm6mzTXPywuqMTXTXIN54VsH11nr30szmlXrtqJzzVsQT2m5thvjfxcFmBvOFl2xNk7j/9+FNECy/6g1VoxfWursW039oYxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589374; c=relaxed/simple;
	bh=o6OGygAO/6kYeSEVfnqlEViuTJHMLepE4v1X6u+J6wE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5RO9lIttp0WLb8uD/2XJf98xUHJxexdlr5U+Mt7W+b1mChbOIfTdIJ7EWGkpLcB1hTlRGPbcwIN9oIBe3O7FwlcHs/6S/Ghyv97nzvmPakux1nXA75RqpkJmQ0A6xgyFrVSPnRhOKeV3/+7Ek4fMPjb0fwavpyn17FndC3FrzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kRKweIuJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kRKweIuJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE38C433F1;
	Mon,  4 Mar 2024 21:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589373;
	bh=o6OGygAO/6kYeSEVfnqlEViuTJHMLepE4v1X6u+J6wE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kRKweIuJ3KmuTcxuDCeD3EKD4s799rTzX+DcLd1hf4lrfDMAHxmVMOv3o2i7y7EDB
	 RcB77zkoGMkfkuR69PQVkmLXvqICrbaesJnv1jPAIwcDStjsD4zM4URfi4P0R26BGQ
	 sfnCwl9q0kwyz8wzcaVBbNq3RWHCxLnet9AqFXg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Krummenacher <max.krummenacher@toradex.com>
Subject: [PATCH 5.15 72/84] Revert "drm/bridge: lt8912b: Register and attach our DSI device at probe"
Date: Mon,  4 Mar 2024 21:24:45 +0000
Message-ID: <20240304211544.794957575@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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

From: Max Krummenacher <max.krummenacher@toradex.com>

This reverts commit ef4a40953c8076626875ff91c41e210fcee7a6fd which is
commit d89078c37b10f05fa4f4791b71db2572db361b68 upstream.

The commit was applied to make further commits apply cleanly, but the
commit depends on other commits in the same patchset. I.e. the
controlling DSI host would need a change too. Thus one would need to
backport the full patchset changing the DSI hosts and all downstream
DSI device drivers.

Revert the commit and fix up the conflicts with the backported fixes
to the lt8912b driver.

Signed-off-by: Max Krummenacher <max.krummenacher@toradex.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/lontium-lt8912b.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/bridge/lontium-lt8912b.c
+++ b/drivers/gpu/drm/bridge/lontium-lt8912b.c
@@ -571,6 +571,10 @@ static int lt8912_bridge_attach(struct d
 	if (ret)
 		goto error;
 
+	ret = lt8912_attach_dsi(lt);
+	if (ret)
+		goto error;
+
 	return 0;
 
 error:
@@ -726,15 +730,8 @@ static int lt8912_probe(struct i2c_clien
 
 	drm_bridge_add(&lt->bridge);
 
-	ret = lt8912_attach_dsi(lt);
-	if (ret)
-		goto err_attach;
-
 	return 0;
 
-err_attach:
-	drm_bridge_remove(&lt->bridge);
-	lt8912_free_i2c(lt);
 err_i2c:
 	lt8912_put_dt(lt);
 err_dt_parse:


