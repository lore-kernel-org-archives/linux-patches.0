Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87A63D9029;
	Mon,  4 May 2026 14:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903490; cv=none; b=gjfeG7S0o3zooUYLuLdy8TFmVDngA7dD8vOs+JI2klCn6pLdRHrCSWUhEraBfjdUG9qYTQr2KQwVGR6v29DVbu0CYWtYzeCmU232w4p6MsC2anZO3heb5l24tkTbIo2Crzlbus9Q8pQGNCWXpkHZFI9hzwIRK5ZbPohNPEsyJpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903490; c=relaxed/simple;
	bh=g6lRKWHY0Yb4Z0HKPXgnyoQgNZIpraq2is38ohic6UE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eteXuXWLcp0/KXoc6k6jhMnAwKHscJ5kWyhEYmWxYWk3l6WVTW6NOB1ADLws9Fc+Yq+0cslSgTDuZSylka52pkfo/rjlt8XT2laUnYr3sXK7dn2KQ1xqw/cnWalcZ38ajKF+9XE/BK01BCcJeBHyxTLaJgcTnxmsW3ERAfNc0po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xma4nG2Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xma4nG2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E69BC2BCB8;
	Mon,  4 May 2026 14:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903490;
	bh=g6lRKWHY0Yb4Z0HKPXgnyoQgNZIpraq2is38ohic6UE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xma4nG2Yjo+QQZFo2JHWkr6rdSU9VswAL8eAMgP4OkR+1CH+SIEOylLZihf3Mj7n9
	 lLig4GD4V2+KiwxngT2VPKrqSFZyhtri3edtLM3eeo5yQI6JQLrwHYZ6fOw/9m0qxi
	 hiw5sUvDeHgBm6P/6PUQmEQULFS5eNcKzikh+ydE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Yu <qiang.yu@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Subject: [PATCH 7.0 255/307] bus: mhi: host: pci_generic: Switch to async power up to avoid boot delays
Date: Mon,  4 May 2026 15:52:20 +0200
Message-ID: <20260504135152.413900292@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiang Yu <qiang.yu@oss.qualcomm.com>

commit cfdb41adf1c2822ad1b1791d4d11093edb5582b6 upstream.

Some modem devices can take significant time (up to 20 secs for sdx75) to
enter mission mode during initialization. Currently, mhi_sync_power_up()
waits for this entire process to complete, blocking other driver probes
and delaying system boot.

Switch to mhi_async_power_up() so probe can return immediately while MHI
initialization continues in the background. This eliminates lengthy boot
delays and allows other drivers to probe in parallel, improving overall
system boot performance.

Fixes: 5571519009d0 ("bus: mhi: host: pci_generic: Add SDX75 based modem support")
Signed-off-by: Qiang Yu <qiang.yu@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260303-b4-async_power_on-v2-1-d3db81eb457d@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/host/pci_generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bus/mhi/host/pci_generic.c
+++ b/drivers/bus/mhi/host/pci_generic.c
@@ -1393,7 +1393,7 @@ static int mhi_pci_probe(struct pci_dev
 		goto err_unregister;
 	}
 
-	err = mhi_sync_power_up(mhi_cntrl);
+	err = mhi_async_power_up(mhi_cntrl);
 	if (err) {
 		dev_err(&pdev->dev, "failed to power up MHI controller\n");
 		goto err_unprepare;


