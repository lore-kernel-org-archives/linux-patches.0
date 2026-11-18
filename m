Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018899;
	b=TtRyVcI8tbUYpeRWFjPKHYswKpOBmpSqLbIq4r3xTknq306OAxhpDT1xtCvZ7z0Rs/kn
	 dZx3yJ3bFexGonMPWUs8D6/lAnqaIaY2OdxTJuNoet81PmQu6BC6yrdDnevDGtOkonOJ7
	 kZFQ2Y20OSrF3W2K0sTWQVbmNDD9NJ6F/B8iJfXoTwFIbxt0ekHbS/I6T3GI6DjtY5lJ/
	 1dV4bTJM61PvaydeC/hzhnE0lLFWCsKH343geaw5xoZi4eMtudlUYCm/mtPVwlIvOnIUD
	 aVFTYuH6y59PrmweQV9a31tvpNpkGrJ3m0JoDvkVm0wXEl8c+Si1MvksmvXfQnk5SEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018899;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VIaC3Y/36dKjlJcASpM9EzNDYcltqzNHwdSQCAIOrMY=;
	b=eMWzt14xCSIRVPXk/kx3o1clUxjEq571QO+ff5HzNaZuMxpVhWAfEY4i7MI+IJJ5tdGc
	 Ep6RIpBdwIIysrmKv3+xukoVr9M6RQLiEsB5GSUquZV5pBl2eoRbLmJL2+HzLD+5d3qgy
	 RdH8MXT5cap99LKuEEMG9262gyxegqolfWaWMPM0fQ1JQ9FzA5CykrHdgw5+ZoTCTnaPX
	 hdiswGu8HZ8CQjA+8d0eaTjlBXSBoXig9dYqe2ZajL1/16CoEWZ14/JVUcbSC5rbLkcn4
	 QweF1ywaCbLupHlE/uq3Eq72uvqlf+d/u0oIqVodub0TteTcdHP4t3QbX3PPF/MVHkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q0tBs8nk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FAB606A31C;
	Wed, 18 Nov 2026 16:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q0tBs8nk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA9D1F000C4;
	Wed, 18 Nov 2026 16:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018898;
	bh=VIaC3Y/36dKjlJcASpM9EzNDYcltqzNHwdSQCAIOrMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q0tBs8nkCwO+iNHQKINE8ZXLIrFvaLq/JY48nukMpiG1K/8mo0ZPaV2Y4p4oUedM0
	 H1Op3wIV2Ugijs1P+9+H3wTUtpehD+jQ/uHYMgKfa5Dfwmk7/vLUrfxu3nwVsN2qCy
	 dYtKVO3O8IAwLF3EwNrHiiS9NLVX3eIJC8lQCPv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Priyank Rathod <rathodpriyank@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1405/2651] PCI/AER: Fix struct pci_dev reference leak in aer_process_err_devices()
Date: Wed, 18 Nov 2026 15:44:05 +0100
Message-ID: <20261118150338.595583121@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 6ab23318b4052..7f97e96de2a98 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -1341,7 +1341,6 @@ static void handle_error_source(struct pci_dev *dev, struct aer_err_info *info)
 {
 	cxl_rch_handle_error(dev, info);
 	pci_aer_handle_error(dev, info);
-	pci_dev_put(dev);
 }
 
 #ifdef CONFIG_ACPI_APEI_PCIEAER
@@ -1531,6 +1530,7 @@ static inline void aer_process_err_devices(struct aer_err_info *e_info)
 	for (i = 0; i < e_info->error_dev_num && e_info->dev[i]; i++) {
 		if (aer_get_device_error_info(e_info, i))
 			handle_error_source(e_info->dev[i], e_info);
+		pci_dev_put(e_info->dev[i]);
 	}
 }
 
-- 
2.53.0



