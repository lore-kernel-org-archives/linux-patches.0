Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CF2311597;
	Sat, 12 Sep 2026 08:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202693; cv=none; b=EolOxEO0r8cdpxri/kj9Y+CIFaX1cKAe1lhCI+4DDIg/B4D64+YkCq+brjTD9z9JMJh7I6qJNGIfXlzZ5hKlvvLZl2A+E33I5AegmVRRCxj1iTLpdl7BBd/f2fqifQeNXThq4i3x4HH0yEIGGQLYgqyOq9jfy/amqbQtmNoeVxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202693; c=relaxed/simple;
	bh=mRU5RDMFvx67HkNpq35F3GzAr4b1pjCGbdp8w4wAT04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqtY1E/6D9+zbr2oJjTsmtTlcNtyQISwojoDxDnLU4jWBjJe1HB1xIj+pi8YyIpKaO1K9NEVkhnmmWNO+QDDatcctx5zC9I+gwjzbVajARNQRHtlSr4y2gzV/7+TOoCYduO1kX0yCo2VFwt9ZrDXzCXpKMCkf5UZbIubWS8jg1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kKUizGBL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kKUizGBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D581F00893;
	Sat, 12 Sep 2026 08:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202691;
	bh=Dpih3DBnUC59BbeUvGy1CeqYFQlsLL9ztn4N78qZjHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kKUizGBL7bbAdihbbj01LMhDr6XR7s25jGtYHPD8rR3Js+nWgNLEhRSxpihaAZZkl
	 KX+GstOlmqmi7w143p+qyz6vB4zeSUxUT3N62G4FSDmoQSWWAzYL+rzNIhefjioSvI
	 9Cn04wIwIFuX2MVl3oevetj6rQFqoEczhYF7Pk24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1255/1815] Bluetooth: btmtksdio: fix usage_count leak when autosuspend_delay is negative
Date: Sat, 12 Sep 2026 08:50:05 +0200
Message-ID: <20260912065718.475530420@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit b0c0b37940115383e7ea65d4d988f9b9e613ab92 ]

btmtksdio_setup() calls pm_runtime_use_autosuspend() when runtime PM
is supported, but btmtksdio_remove() does not call the matching
pm_runtime_dont_use_autosuspend() when removing the device.

If the autosuspend delay is set to a negative value while autosuspend
is enabled, the runtime PM core increments usage_count to prevent
runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
during driver teardown, this reference is not dropped and usage_count
remains unbalanced.

Add the missing pm_runtime_dont_use_autosuspend() call in the remove
path before restoring the runtime PM usage reference.

This issue was found by manual code inspection.

Fixes: 7f3c563c575e ("Bluetooth: btmtksdio: Add runtime PM support to SDIO based Bluetooth")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtksdio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/btmtksdio.c b/drivers/bluetooth/btmtksdio.c
index c6f80c419e901..4e1012e90979d 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -1480,6 +1480,9 @@ static void btmtksdio_remove(struct sdio_func *func)
 	if (test_bit(BTMTKSDIO_FUNC_ENABLED, &bdev->tx_state))
 		btmtksdio_close(hdev);
 
+	if (bdev->data->pm_runtime_supported)
+		pm_runtime_dont_use_autosuspend(bdev->dev);
+
 	/* Be consistent the state in btmtksdio_probe */
 	pm_runtime_get_noresume(bdev->dev);
 
-- 
2.53.0



