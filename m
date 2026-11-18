Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049280;
	b=uh5NFQuW5tVDj8SmVVQ2SAeJ5legiG9BbqlIBC6t+bid6hz/gvjUNBtMCt3NYmt9wZUX
	 hScr+rZF5k64oitzPTFQ5g+RzZNOi2M3rkEaM3fk2luFpqR4psiFL+qnqYRLtwGCcOxcr
	 kp94OFNUDCq2FHfGKaX/ORP6WyOzA2Zo+ZYsxEWsPc/lsF7JGqXu6PHAR1jnRSZ6Vs1w1
	 5V/GgWbH0Yb0a59+CYo8ZNJLvW8zzSUY1TMiNOrlELOUoNB5QdyUixHWdaMzCxmbtud8Q
	 XHK7yX7wcN4zgD2Mg38aUlsSsjx3QK0X/7FH1TPna2RuV0KF4hnNW2C0b0ocR20tQ8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049280;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qk4syS70ePjtJmCqBzB0YK9raSFAQl7lMF2cvuttLzE=;
	b=cnphUSbKGhgS4JfgFtRUVe+bBOlKh81/Z0y6rbt3466Qc+A9kFGsDWTfz/v+9dNtzRfV
	 A2MFpF0R3kBl4nGzgI++X4RTjnzALVTevHb9X5bcfQm4GZ9NMQsLXFpf9PjV6DyaZ3zUG
	 uVenC+h/UG3oGSFHvm/OwJcEMKex6SBstN1AC+kxav6U95NN/Zb7hFHJ1ZBu7c/na2vdn
	 9doTmfhaCk9ehVKy/fSuUzdre+GQ1CrgZK8vFhMPDwr5OWrPDXStDIsc/QIB+7dYNL2gJ
	 IzNXV3ycVu+sJ6hfLBh4Duk7wdTw1nxpvXpeNq119Bu0II22f3dH29THo5OeKEQ2Izw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VfX7B8BK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B72B606A32A;
	Thu, 19 Nov 2026 00:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VfX7B8BK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE661F000C5;
	Thu, 19 Nov 2026 00:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049279;
	bh=qk4syS70ePjtJmCqBzB0YK9raSFAQl7lMF2cvuttLzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VfX7B8BKhRS6kEJUoIfomxYsvzShX7HHBiHlQ2EOp9mnzSYrMzGgpAf6IoNq5QdKR
	 Wqogk8ibce4R7wWMXioE/rAQylOqnf0jhtqb013rP6oiDbnteNJNAMANqjKGi65tkX
	 nOpS35MRwV/KBMQvYZhhpGv4DTjI21lvZ2MWfYfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Priyank Rathod <rathodpriyank@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2295/2857] PCI/AER: Fix struct pci_dev reference leak in aer_process_err_devices()
Date: Wed, 18 Nov 2026 15:55:29 +0100
Message-ID: <20261118150324.115422820@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 49f825531b527..642d0e9d31b03 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -1062,7 +1062,6 @@ static void handle_error_source(struct pci_dev *dev, struct aer_err_info *info)
 {
 	cxl_rch_handle_error(dev, info);
 	pci_aer_handle_error(dev, info);
-	pci_dev_put(dev);
 }
 
 #ifdef CONFIG_ACPI_APEI_PCIEAER
@@ -1210,6 +1209,7 @@ static inline void aer_process_err_devices(struct aer_err_info *e_info)
 	for (i = 0; i < e_info->error_dev_num && e_info->dev[i]; i++) {
 		if (aer_get_device_error_info(e_info->dev[i], e_info))
 			handle_error_source(e_info->dev[i], e_info);
+		pci_dev_put(e_info->dev[i]);
 	}
 }
 
-- 
2.53.0



