Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B412EDD62;
	Mon, 27 Oct 2025 18:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590407; cv=none; b=X9olm7xje0Njwn/Axz7wX7lrdDUaIEWZibgv3RGMx7nTelMLLTPtSC49uG0GhPhcUVhTvp66KV6UVeL5M6rtM5Iia9hMWiJ9Fig2mMGBqNw8Zm88kED6SPZJpnwjPHi1KtjBZlTSyJnHpL/C4Lgzkke72Z7H4g+CQKFkcI2RYxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590407; c=relaxed/simple;
	bh=pjyyoAS8/r1n094quXNclhWktytgON5vWS8DN5O8R3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sm2B1HBVDArDx4wozVsL/kuE2cfkSNfHyCrMhzxPQ3Eq1ozP+gVHhATNgb/ahP2MZoVjAtfMysx9qRl2QP5reGzmXnS0z66o/MtzcEl6ic+ko6ODXzHQPWtwTwIi0VzKttpwuYXZc/FyAUv0Qg324f1rLpKkjQwSdPCpK3YcoUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wGNYIAu3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wGNYIAu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9459BC4CEF1;
	Mon, 27 Oct 2025 18:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590406;
	bh=pjyyoAS8/r1n094quXNclhWktytgON5vWS8DN5O8R3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wGNYIAu3W8xx9q4hBVGmlwzzC9RekE4HbjZz1CsvZVKlrWd4wW7QE0Jy63a5x+ZFD
	 olt1qzle9B06ET3HgrxeoHxJ6jogMZlZpxzfUs49bAxM0eui67IBSuE25qKXAK5FYF
	 XEOlnP0D86/xEVMyyjvJXlaJZTsvBvH/RngWjcQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 032/224] usb: host: max3421-hcd: Fix error pointer dereference in probe cleanup
Date: Mon, 27 Oct 2025 19:32:58 +0100
Message-ID: <20251027183509.864788796@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 186e8f2bdba551f3ae23396caccd452d985c23e3 ]

The kthread_run() function returns error pointers so the
max3421_hcd->spi_thread pointer can be either error pointers or NULL.
Check for both before dereferencing it.

Fixes: 05dfa5c9bc37 ("usb: host: max3421-hcd: fix "spi_rd8" uses dynamic stack allocation warning")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/aJTMVAPtRe5H6jug@stanley.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/max3421-hcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/max3421-hcd.c b/drivers/usb/host/max3421-hcd.c
index 5a21777197e95..cfdbe90f867e0 100644
--- a/drivers/usb/host/max3421-hcd.c
+++ b/drivers/usb/host/max3421-hcd.c
@@ -1925,7 +1925,7 @@ max3421_probe(struct spi_device *spi)
 	if (hcd) {
 		kfree(max3421_hcd->tx);
 		kfree(max3421_hcd->rx);
-		if (max3421_hcd->spi_thread)
+		if (!IS_ERR_OR_NULL(max3421_hcd->spi_thread))
 			kthread_stop(max3421_hcd->spi_thread);
 		usb_put_hcd(hcd);
 	}
-- 
2.51.0



