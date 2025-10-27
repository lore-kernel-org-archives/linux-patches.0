Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF9232AAB2;
	Mon, 27 Oct 2025 18:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591125; cv=none; b=EtS0mKWKEt/Om14dNkpUXbYfvLYQeCpG3y75L5TPRruJn2RGKFdWJySDrd47EvG4K3UtWo0enTQjVWMb/KY1ZrcWjXliUXGOANMRYz00zbsvD9Zm4JnDUXCm1rpy74+sy8+CsflPsPV1wZVHyMyMcT7ak9W+MSXva/+Nj1T4mLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591125; c=relaxed/simple;
	bh=FC82QBLXK2p/fCIJ08BRysjpbKpqrGpUf2EUJ8kgxRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4sZ3m3BbiktWyzTTRkbzXl7g607BvTZJsXRVdSfK5Q5lrzxh/6xIjNU4Zl2XDx4Dm7L11RnHCnTPy8lobQ/6557aXDYUnW8aA605T3TT+UdflN0McrKHJ8hBbn7O/EaItSwIewI9pdi+r/8g9tsBLK93dyD7GTuBYXVStuphKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=He6ikZHf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="He6ikZHf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7A0C4CEF1;
	Mon, 27 Oct 2025 18:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591125;
	bh=FC82QBLXK2p/fCIJ08BRysjpbKpqrGpUf2EUJ8kgxRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=He6ikZHfSKKyfcDUxOB4KkfZs/tSfT3naq3+g7CJ4ZdcUXnDZwRFxMKVqqolAkbRI
	 bob8WabmKEqx9PYFQfCxhK4DAAHQCOb13/yt9kXi94cCpC6TT4q/7aQ/elnUON0DM8
	 /mo9Ceozbwq2AO7LHsZY3L4Zxa3qosJ4KTKTjavM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/332] usb: host: max3421-hcd: Fix error pointer dereference in probe cleanup
Date: Mon, 27 Oct 2025 19:31:33 +0100
Message-ID: <20251027183525.679004553@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index db1b73486e90b..7ab8c518dfc2b 100644
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



