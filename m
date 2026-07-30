Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27A142F707;
	Thu, 30 Jul 2026 14:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423504; cv=none; b=o0p/oIcsGHflmnr1wdMri2IK8sCgr9PElYY3/GS+4Ci4D6aes8fszp445aABop+vSO002rJuge7d8iNRBsoliucCEl2H025ruMqTBm6b0NuskH3g2wDgnkwRlkir3adcAh6z++CM5jHfgx5scMOaMNKlcoMm0g/uzxVVVaxTIls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423504; c=relaxed/simple;
	bh=0/bpj/1UHMwCp4LgFMPWhD/FTTftGxeu+tBIukNAxCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXMkxrZkZsZdGL35+3g074kTIwXTTyrHqv2pGLBGK45dVfWVc+NoBvHkfb2RZzIzqlIkZqkaqrvNgJz7w/EQ3mv92hYnl5mAZvHDzWKFScZAcHnETmTTUZhDC4YeTtWGcaLrLgz1x7JI5Jn69YLLM2p14tkFsmO0LFiCsavPahg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Px/cBLLq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Px/cBLLq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A34E1F000E9;
	Thu, 30 Jul 2026 14:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423503;
	bh=Q/L6uXK3NrU3peJ6LcBipw6AFK48DMwvnrZk94MhhWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Px/cBLLquydnQM39xU1qFiI/K/odKvQeokKoe3DrofdwebkQupRy37AGyPMqyVcek
	 f+Ynbfena2GpSlHomsns5CZjPX58FWHMg3LmZz2jdfAih/j6Arh60WWSkvLwf03p+M
	 EXOloScMv37MCndX0nU+T755Gzis3GwGHjL5f0SE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 066/675] wifi: ipw2100: fix potential memory leak in ipw2100_pci_init_one()
Date: Thu, 30 Jul 2026 16:06:36 +0200
Message-ID: <20260730141446.528207152@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit 0d388f62031dbabcba0f44bb91b59f10e88cac17 ]

The memory allocated in the ipw2100_alloc_device() function is not freed
in some of the error paths in ipw2100_pci_init_one(). Fix that by
converting the direct return into a goto to the error path return.

The error path when pci_enable_device() fails cannot jump to fail, since
at this point priv is not set, so perform error handling inline.

Fixes: 2c86c275015c ("Add ipw2100 wireless driver.")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Link: https://patch.msgid.link/20260620065242.93798-1-nihaal@cse.iitm.ac.in
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/ipw2x00/ipw2100.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index 215814861cbda5..0808e69c3c1786 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -6162,6 +6162,8 @@ static int ipw2100_pci_init_one(struct pci_dev *pci_dev,
 	if (err) {
 		printk(KERN_WARNING DRV_NAME
 		       "Error calling pci_enable_device.\n");
+		free_libipw(dev, 0);
+		pci_iounmap(pci_dev, ioaddr);
 		return err;
 	}
 
@@ -6174,16 +6176,14 @@ static int ipw2100_pci_init_one(struct pci_dev *pci_dev,
 	if (err) {
 		printk(KERN_WARNING DRV_NAME
 		       "Error calling pci_set_dma_mask.\n");
-		pci_disable_device(pci_dev);
-		return err;
+		goto fail;
 	}
 
 	err = pci_request_regions(pci_dev, DRV_NAME);
 	if (err) {
 		printk(KERN_WARNING DRV_NAME
 		       "Error calling pci_request_regions.\n");
-		pci_disable_device(pci_dev);
-		return err;
+		goto fail;
 	}
 
 	/* We disable the RETRY_TIMEOUT register (0x41) to keep
-- 
2.53.0



