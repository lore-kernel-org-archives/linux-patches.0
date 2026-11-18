Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040981;
	b=C3iHCCb+bECcnVS1U/YYEbew6RRb4B6/KsiD7CNtIJuavxewrwK2bySFY2ci540KqGO3
	 +l84rXBzg9Qb2+Tme8KGX+TioyNb3uh4GYUrDGu1QsJ9JPv7uTXtOQLyEEV01lmTLi4ga
	 GMp+yPdh2ydJT2VL+ld5PrljybHs8UJZRId+pTn6nEXJHDwrU7tjPywKBTFld+qHNly93
	 kEGRfb5Oe0AVg2nmJXUmTGJHVM0e5BeFON7YazufTpDg8jU26k0IpIQthNL6xbUSNUd1A
	 sA9Rkp1vW/up+HR217zNDXO0EGg64BXzmms6lgrK/x17CYXn8rWL60gruU0fF1hHC1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040981;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dQTu6+91DOxTAcumHcIo8t8+Me4Ua43XQRekvUihJh0=;
	b=Lvd4bmUVIpkKkfna9M+xidOhiPDthGizdOUqPq1hfDZXRCxLdOE9il2BkmHCjMhuKa/Z
	 ac7gvh+sIhWqiNqAjPlu4k9NuIYgy2wk1PMoBVX1ia2m0xggidkitEQOqFULhBnYsFRIy
	 sjTMjIX7xq3tNdTmjDHMbmchLB3eartBHYEQfjlDJbkmnl5/3BG7t3CD+jjGfxORDdvS4
	 3KyJFwar9KBBAhoxelZrdN4z8tDl0+n6GZAdzmZ+kWO2aV50EbeFPQPp+803HGa30Ia6J
	 Pct5ooX49JZHXWYJjtJ8yUbPOp72KnAdB9toPvEVDyxMIL6CPSKlaNMFctoMDeVvl6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wcj1d2ED;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36370606A333;
	Wed, 18 Nov 2026 22:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wcj1d2ED
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876921F000C5;
	Wed, 18 Nov 2026 22:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040981;
	bh=dQTu6+91DOxTAcumHcIo8t8+Me4Ua43XQRekvUihJh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wcj1d2EDew2RzcPwlWnrrv66PIbuZ74F1E+bQhhcksRLbkBTInxcppkzqpQPaSj4L
	 QEAibxLx0CCh3ftcLa9PAlQYvgrU3KqD+GRTdFlwBTjvkTyPgoE+QcIm5qFQhtERrc
	 uMvNcgPCjyTZ4q0kDHSmpr8GKTqff2PK2IWxjqOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Priyank Rathod <rathodpriyank@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2650/3318] PCI/AER: Fix struct pci_dev reference leak in aer_process_err_devices()
Date: Wed, 18 Nov 2026 15:54:32 +0100
Message-ID: <20261118150440.547199626@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Priyank Rathod <rathodpriyank@google.com>

[ Upstream commit e86ac10110d00e6c3801f38bde1863951315222b ]

When an AER error occurs, candidate error-source devices are added to
e_info->dev[] by add_error_device(), which takes a reference with
pci_dev_get().

A device can be recorded without any error status being present: the
Requester ID fast path in is_error_source(),

  if (e_info->id == pci_dev_id(dev))
    return true;

matches purely on the ID reported by the Root Port and returns true without
reading the device's AER status registers.

In aer_process_err_devices(), handle_error_source() is called only if
aer_get_device_error_info() returns non-zero, i.e. only if an unmasked
error status bit is actually set. It returns 0 if the device has become
inaccessible (status and mask both read as all ones, so
status & ~mask == 0) or if no unmasked status bit is set.

Because handle_error_source() was responsible for calling pci_dev_put(),
skipping it permanently leaks the reference taken in add_error_device().

Decouple reference lifetime from error handling by moving pci_dev_put() out
of handle_error_source() and into the aer_process_err_devices() loop, so
every recorded device is put exactly once.

handle_error_source() is static and aer_process_err_devices() is its only
caller, so no other path is affected.

Fixes: 60271ab044a5 ("PCI/AER: Take reference on error devices")
Signed-off-by: Priyank Rathod <rathodpriyank@google.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260918-fix-aer-refcount-leak-v2-1-bdd1ff1c35a9@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index 72283b0b8d596..cc03ace4fea24 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -1068,7 +1068,6 @@ static void handle_error_source(struct pci_dev *dev, struct aer_err_info *info)
 {
 	cxl_rch_handle_error(dev, info);
 	pci_aer_handle_error(dev, info);
-	pci_dev_put(dev);
 }
 
 #ifdef CONFIG_ACPI_APEI_PCIEAER
@@ -1228,6 +1227,7 @@ static inline void aer_process_err_devices(struct aer_err_info *e_info)
 	for (i = 0; i < e_info->error_dev_num && e_info->dev[i]; i++) {
 		if (aer_get_device_error_info(e_info->dev[i], e_info))
 			handle_error_source(e_info->dev[i], e_info);
+		pci_dev_put(e_info->dev[i]);
 	}
 }
 
-- 
2.53.0



