Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981173DE443;
	Mon,  4 May 2026 14:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904190; cv=none; b=BQ3DFDdOBzMK4SzynT84/qPf3z5BjgdvzoJCqYQDPiUCQNhkQCYN0Fgjt8pr2lSvPAffJMdWI7rjn4QlIH2jse9pnKmTnFSLeHBMMRC3MNf85N8L/+dhxFOjPA7SIaf5lCKu1V+Gth5JeRefTSlIf0b2mNaLUxua8ESFfazwPBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904190; c=relaxed/simple;
	bh=x9npeH0x1iChFsUH8IpKGzFWbRHOCGzeYFD5DzOAhjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lrIDbV/oaIOy4YW/05W0bwVneoF58gWsodgHrti3PbZQVI4ST76V+oh0OF5PXoxs6bZZJTdCodx/1+d1l/WDAj6V4gCBFKTVk294Q1FPLVS/I7lDil58BFUiENbM9hfBg4SkvX3zZIRWUahLsWVd7tMUMQOEPCiBy+LYrFOkZj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G+b8CHc1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G+b8CHc1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FEB4C2BCB8;
	Mon,  4 May 2026 14:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904190;
	bh=x9npeH0x1iChFsUH8IpKGzFWbRHOCGzeYFD5DzOAhjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G+b8CHc1rbquRY8awbNRftK40HWanRvnbDQm89GQviUtGBWezHIG50YxDU6waZbNd
	 1wWwHQsBy8I04DgfAnW44wph3gniw6GYXH9xr3i80ZGIk4JVasG2Qlb7A2meeYsxrE
	 RqkX463/pbMefDv7jqolXkONRzqwGcBfePJQc2yQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Yu <qiang.yu@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Subject: [PATCH 6.18 218/275] bus: mhi: host: pci_generic: Switch to async power up to avoid boot delays
Date: Mon,  4 May 2026 15:52:38 +0200
Message-ID: <20260504135151.168818496@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1380,7 +1380,7 @@ static int mhi_pci_probe(struct pci_dev
 		goto err_unregister;
 	}
 
-	err = mhi_sync_power_up(mhi_cntrl);
+	err = mhi_async_power_up(mhi_cntrl);
 	if (err) {
 		dev_err(&pdev->dev, "failed to power up MHI controller\n");
 		goto err_unprepare;


