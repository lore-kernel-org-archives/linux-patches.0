Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210678;
	b=IJlNAssjqRXSUjI97aZ9cnGwB7KBqw72Hcutl88isrVhjsFqMXd/7qrmVGMSxjRxng5h
	 T2xUysiIKQXzMmmSyBlSL0skJ4Db8QDyvAMUXfGxrI2VIvjPa2K5ttFVOfg145LVLaZ5r
	 JRElKxGQWPlZ2Sd/+IdOwAuoTkDLN+2FLU5v8AFRGfeYNUhAecw04vR3ph1MeINuIouPG
	 KVzTpg/b2sJLkfT8zfnx3NK/IKfNLMlJYvG7E0sSpWia/W2sMwfq3L6LIXLRLbtr+uk7P
	 /8OB5mk3v2KUPSjMYTs1lv8jdjB6Cj5JDqZVez5eIuk50A234gvSyS1+zdzIkKLCIkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210678;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lzttua87wOq9DZ/fVKZMxGG3Jhih1DYpzWkawtCdzoU=;
	b=sA8CGBpAqIYNCke2upn+qiYs8cvtu4jQnyic5xTH/BUmU6Be2tR+MK6CylhAMGsFpFH6
	 9oUJobOwMhYwL9ZkFm5JVCYJDPwNda52dDKgKGfa2ORu6VR2IKG5MQFOrQGoYR6HSr9/b
	 5CKfE1FqvaTeEFHavKU5exXR3qjGImm1cufot4ORRxmuXpfsNzHZtql0M63sqKEiNfoNe
	 CrM+af0RbE3QdJtv5gL3orj5HSA8/II9KodWhLkqIWO0URQjZsTM5X/DzVo5lgvyScGgo
	 xILi9hYp/qQ6eorXf/YL+4yGb+JF2EOxI4GzrpUMgn7ixlN2UUNcSDePvnutQOzxgtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OLFBRlVa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1AC606A31C;
	Wed, 28 Oct 2026 18:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OLFBRlVa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 286811F01825;
	Wed, 28 Oct 2026 18:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210677;
	bh=lzttua87wOq9DZ/fVKZMxGG3Jhih1DYpzWkawtCdzoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OLFBRlVa3yNGjSlBWDEoUB58PGLDwYoE19uu+erv5o4UTxbL2I4eYIUMEmlN4V3Zx
	 S8ZKz2eWVDM4PZFH5kd8q3uar+oo6fLxXxd5N+Lnht/K3kJX6FOeAWHGcHRmEOlW0f
	 +2XevoyJbjlTPo/vUasB+0MWWSHyhwWT3aDM3wO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 083/571] media: saa7164: fix cleanup on resource allocation failure
Date: Wed, 28 Oct 2026 17:53:50 +0100
Message-ID: <20261028170009.997412088@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c10997e2271d2..6691042cc4211 100644
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



