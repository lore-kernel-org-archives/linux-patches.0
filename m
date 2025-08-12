Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987AB3F9D2;
	Tue, 12 Aug 2025 18:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022151; cv=none; b=H9whQ0lGGPKQNYSReUZ/jjTqR5jgviUR+4nFBSVCB1uNgv69LI+Edo1K53dStIwuK1StY2T3MOExDBMWWIDq4uJkWDGZu7kupiA4GuzH65WOGlhth27D2dkhtD1wr3+Ne7C+0FzVI1imeaw3KOJw4dOyx9K9MzvLGNHEWU5Npjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022151; c=relaxed/simple;
	bh=OU/td6Vq67BGNI9heZlWNqri8dJBXV7UfE/BvHlNinA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GhHRPtY5G2sP5U3XHsTTn7geKscZr9dtOi2EQCBg6PxQU8z1MJ+n/ngtJWncQSe2C40lAAA6ZFiGyAKaqo0+rrnbiAIhuv9QBLuv7sfsfnMy6r233xJ0GjXaLmcKH6BYftPkynqjjr4I8DSTY2d5eByh0yZLzj2/kM2N7awt5aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RdlWOz92; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RdlWOz92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0499AC4CEF0;
	Tue, 12 Aug 2025 18:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022151;
	bh=OU/td6Vq67BGNI9heZlWNqri8dJBXV7UfE/BvHlNinA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RdlWOz92WlUKR0nxAlSrPyJP22FbbwjgtXUhcmPBFQhp/GMCq76xqNBOjs8h+0HXk
	 HNroj4NhHYUgilXcBELuDUT3hS4cvvnYeB9idJb8KYMsoMjPpW/TDzYQ65/FqT4wxG
	 FkxSKDtBQYFooFp0ZbH/Mcssdvm4llIIT6dukhuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/369] mei: vsc: Destroy mutex after freeing the IRQ
Date: Tue, 12 Aug 2025 19:25:34 +0200
Message-ID: <20250812173016.159446601@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5e44b518f36c..f8e622caec34 100644
--- a/drivers/misc/mei/vsc-tp.c
+++ b/drivers/misc/mei/vsc-tp.c
@@ -554,10 +554,10 @@ static int vsc_tp_probe(struct spi_device *spi)
 	return 0;
 
 err_destroy_lock:
-	mutex_destroy(&tp->mutex);
-
 	free_irq(spi->irq, tp);
 
+	mutex_destroy(&tp->mutex);
+
 	return ret;
 }
 
@@ -567,9 +567,9 @@ static void vsc_tp_remove(struct spi_device *spi)
 
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



