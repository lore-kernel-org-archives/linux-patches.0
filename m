Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28693AC17;
	Sat, 12 Sep 2026 15:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225380; cv=none; b=IFV5v1G7gFnGEHrW5zFn8XCy56bWz9BlF8MAMaDyFCuOPpi1NOxfKqXTthDwn8MYim59wf7h5UoA49SbUl0iD5fSoTdr3pxLbALgDg7YfFwFzAQULMJBPR21UvyB6jv8neK6MO1HE/E9X9YnrF7IhuurHlSBIfAneOEqo/9A3NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225380; c=relaxed/simple;
	bh=rHz1vu1gNsZa94mA/mLnPrIzHmrXKPTQbCYfRAHg3rQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VDzNJHlFlp2TYCkEPtS4DADsh6AH6sUmW463/6Z6RH7biuyYAh67L+ccFiFreBw2hvGlf1gKlfl/abfX9aazb6WqSMMHoZHRlSeKU03/+r0KIwagjYyA24uDYkoBIQVYJ2XXIujU8g2AYbee+Vy7nKVh2+Ge4lsrID6K6bWvMpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B3J++9Eu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B3J++9Eu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B391F000FF;
	Sat, 12 Sep 2026 15:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225379;
	bh=nlqnCghq/mkW4zlL4+tvDknVsWCtqzVxsZxqoRzxVsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B3J++9EuRmsnuz2YBsxWnR4BG0V0DOlAc9sqJJiI3PEmyqv3Z9NRcTMsQBSEsLKBN
	 /8aruGC+J78D1oVhRkuBwsELewJs72hLmMlw28A1MZnBRGlbKkKcNtszNYVAL+JeV9
	 thb1befxE0ayJnnIM0hLqD+8xRw0u+/vVFvw8KBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1143/1424] fbdev: tdfxfb: fix PCI enable cleanup with pcim_enable_device()
Date: Sat, 12 Sep 2026 08:59:35 +0200
Message-ID: <20260912065632.895243310@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 95a627143a696f70e17be5ed3b1e733bb6724b46 ]

tdfxfb_probe() enables the PCI device with pci_enable_device(), but
several failure paths after that point return without disabling it. The
framebuffer_alloc() failure path returns -ENOMEM directly, and the later
shared out_err path releases the framebuffer and returns -ENXIO without
balancing the PCI enable state.

The successful probe path has the same imbalance because tdfxfb_remove()
releases the framebuffer, mappings and regions, but never calls
pci_disable_device().

Use pcim_enable_device() so the PCI device is disabled automatically on
probe failure and driver detach.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/tdfxfb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/tdfxfb.c b/drivers/video/fbdev/tdfxfb.c
index 08721da003852..5668991beff39 100644
--- a/drivers/video/fbdev/tdfxfb.c
+++ b/drivers/video/fbdev/tdfxfb.c
@@ -1384,7 +1384,7 @@ static int tdfxfb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		return err;
 
-	err = pci_enable_device(pdev);
+	err = pcim_enable_device(pdev);
 	if (err) {
 		printk(KERN_ERR "tdfxfb: Can't enable pdev: %d\n", err);
 		return err;
-- 
2.53.0



