Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208349;
	b=bdRmQDmkiocwx/zWk9r+Ri8UgMgbJsLu8xwmkovPyGZEgTe+AXbaeOxYJLmweL0Sim+P
	 GhpammURIwX7WsGw5X8TfSrrpVcz/JJm9ks1Zu2f31x1bqwLLt9tqXvFKbUgHPSRUcRaJ
	 mP7gM/nViUE3XKd6ZrlAOcUHwNlSp2i0PsN0CJD+ikFWUrmFyLfnB0x6QkkHA5L/q8ydd
	 wZPNBAu1XsBt64MGIplyjhBKto3uBiulK41rmiC0XPswY1PbRGeBq8ILG5kskxO9j93Bk
	 vMNr9zsZxsWowGsnx+5QQVjbeF5ItDNS7z+2xIS1t6mEluNdgv1q2AzLbDBmg2Ot4KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208349;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VoEA32LreVSBBWJ8Jkqu7Bvx+FchH2W9PJG/6mrZLlE=;
	b=UI/EltK0gq+SObe7RBHz0z8HGuOZ4d7Ip4O5lvRkcqYazSFYHM+QN21yc9mt7tXTKaTi
	 gsPKYugLcKutcsamg0mzjb7Mj3NNACNrvKvEa27UWOOAO9l5p7PfB+lnZGjAlzBCwveVt
	 5aLXdWIING4QWfWYylO40HpkpuWM4h4EIfWkLlDDiwM5to81rbxhtDlEHQZOAhPHZT04I
	 g+FdOc4efE9tHrPyvJPXeR+4xr1leCDTh41qZuAFkNJarViV2xxVIbda1Le10vHf49mvq
	 aAjNmmhx+YNulK6Q58NEVtcngO8Rr1HvAjVESzjMJo+0DTYgjRP+AnCMhDlmtF50TBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fHpCv+5Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE02606A31F;
	Wed, 28 Oct 2026 17:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fHpCv+5Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391F91F01825;
	Wed, 28 Oct 2026 17:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208348;
	bh=VoEA32LreVSBBWJ8Jkqu7Bvx+FchH2W9PJG/6mrZLlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fHpCv+5QhM6PeFXLfykQ9/mV4dphAALBDhdqXgEx53u0boqGFDe8zd6dtc3z72Iyh
	 Tdn9JqVf50Bh4p2hrKabuauR38V5EWh3P7nf+o8AuYNXI8bDSg2bEyL+xmc5qnfNDJ
	 ufoEmMs2lEG5TlG90wmOiHpA0CvKK/14hDHOmjsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/516] media: saa7164: fix cleanup on resource allocation failure
Date: Wed, 28 Oct 2026 17:53:59 +0100
Message-ID: <20261028170005.579165291@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 28e84c6e2e6753ed238ea097b2842a32a6a6879b ]

saa7164_dev_setup() adds the device to the global saa7164_devlist before
requesting the PCI BAR memory regions.

If get_resources() fails, saa7164_dev_setup() decrements the device count
and returns an error, but leaves the device on saa7164_devlist. The probe
error path then frees the device, leaving a dangling entry on the global
list.

Reuse the existing MMIO mapping error path to remove the device from
saa7164_devlist and decrement the device count before returning.

Also release BAR0 if it was successfully requested but the BAR2 request
fails.

Fixes: 443c1228d505 ("V4L/DVB (12923): SAA7164: Add support for the NXP SAA7164 silicon")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ Inlined err_devlist cleanup with explicit mutex locking because the shared MMIO cleanup path is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/saa7164/saa7164-core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
index 3cadfbe60fe6e..791bf4259b1d6 100644
--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -880,6 +880,9 @@ static int get_resources(struct saa7164_dev *dev)
 		if (request_mem_region(pci_resource_start(dev->pci, 2),
 			pci_resource_len(dev->pci, 2), dev->name))
 			return 0;
+
+		release_mem_region(pci_resource_start(dev->pci, 0),
+				   pci_resource_len(dev->pci, 0));
 	}
 
 	printk(KERN_ERR "%s: can't get MMIO memory @ 0x%llx or 0x%llx\n",
@@ -993,6 +996,9 @@ static int saa7164_dev_setup(struct saa7164_dev *dev)
 		       dev->name, dev->pci->subsystem_vendor,
 		       dev->pci->subsystem_device);
 
+		mutex_lock(&devlist);
+		list_del(&dev->devlist);
+		mutex_unlock(&devlist);
 		saa7164_devcount--;
 		return -ENODEV;
 	}
-- 
2.53.0



