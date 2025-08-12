Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EDA6BB5B;
	Tue, 12 Aug 2025 18:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023508; cv=none; b=TnIfNI/h++5VOZH42MqevjKwzE9iEiRXj6cH98eoUPbL9sghL8M/qJ1/FdlfQFH5xXJBSIKRQjyXvB7/CmWEgGd6Btc8fAN1SgGmgzqKmCjD2quif1iYryDU1zuY2wm13or3qTjL+aZFFuxkDqUAduIikYefQSmbpG81bENzY+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023508; c=relaxed/simple;
	bh=H8q/TCpakDbHNbxz/VkFwU1B7T9IDop+MA6AAHk1iGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZcDNEVsQ7dXn1ZhFfdDJe4FHIJoGGjwiYsbHn5y57a1igcp9ynR8Ka3HhCyFmuy4dsYWXR8eXtVxFfrDtq7Cjz2sFEcVb1pewDKhfmlG/ndoke0N+7qsMOdXRRN5mWV/0gqcGb8sKu2LMToaBek5sQv1npPuqDFBx58LzAq4PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GodT9rOM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GodT9rOM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F19C4CEF0;
	Tue, 12 Aug 2025 18:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023507;
	bh=H8q/TCpakDbHNbxz/VkFwU1B7T9IDop+MA6AAHk1iGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GodT9rOMQR/UZ3KMQvV8t8mzrQcK+XL8r5gtkx+4JeFMxO6A24cy4VUKt61Q1txzc
	 PV+8o4WP+siu1t5vrScOC2TjOS2QBda2165kH5uRwYG1tt3taixgtgkEfA4jWaaL8w
	 M7hmj/S08v39KCVe2FL5Q7OIv1Ytl4WGT0kB/KBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 067/627] mei: vsc: Destroy mutex after freeing the IRQ
Date: Tue, 12 Aug 2025 19:26:02 +0200
Message-ID: <20250812173421.866590376@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hansg@kernel.org>

[ Upstream commit 35b7f3525fe0a7283de7116e3c75ee3ccb3b14c9 ]

The event_notify callback which runs from vsc_tp_thread_isr may call
vsc_tp_xfer() which locks the mutex. So the ISR depends on the mutex.

Move the mutex_destroy() call to after free_irq() to ensure that the ISR
is not running while the mutex is destroyed.

Fixes: 566f5ca97680 ("mei: Add transport driver for IVSC device")
Signed-off-by: Hans de Goede <hansg@kernel.org>
Link: https://lore.kernel.org/r/20250623085052.12347-6-hansg@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/vsc-tp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/mei/vsc-tp.c b/drivers/misc/mei/vsc-tp.c
index 267d0de5fade..66b41b86ea7d 100644
--- a/drivers/misc/mei/vsc-tp.c
+++ b/drivers/misc/mei/vsc-tp.c
@@ -552,10 +552,10 @@ static int vsc_tp_probe(struct spi_device *spi)
 	return 0;
 
 err_destroy_lock:
-	mutex_destroy(&tp->mutex);
-
 	free_irq(spi->irq, tp);
 
+	mutex_destroy(&tp->mutex);
+
 	return ret;
 }
 
@@ -565,9 +565,9 @@ static void vsc_tp_remove(struct spi_device *spi)
 
 	platform_device_unregister(tp->pdev);
 
-	mutex_destroy(&tp->mutex);
-
 	free_irq(spi->irq, tp);
+
+	mutex_destroy(&tp->mutex);
 }
 
 static void vsc_tp_shutdown(struct spi_device *spi)
-- 
2.39.5



