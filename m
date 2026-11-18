Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061352;
	b=BpRW5wvqmU7kEZJ9Bek+JVYZneWdVMUupzL0p9II6nYGIP/bBAb34+vTfws4vg8gUOMR
	 H6M6ffM9vs5Q6HJpMgUGIOYdL3lJCGWm4/Vh5Wl2umcRfCU3oN1V+z5b2zwnwozq5a/zX
	 qP3sYoUQPBmXqBuWXzq0405U7SRcgpH+2r++Ll0X/PQojEss4pBFQhzeUpKqxWEllYzLQ
	 XCdG6coo0tU47AGCfA4fBUZng7Ow/r1Y+3k/+177H0BxqzMOsYY5hKUJ4CcF7eQShgxBs
	 yN98i33zFgbUa9buWsgJw1K8ODGlfyTnhunHIVkSCl1unsWMOjJeOFAlZ2q3vl6boiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061352;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X/3vbWyYaEqGd0GbXqNm/SJoTBOrZ4NQUiK+gihf33U=;
	b=n8EY3p2N0QjF/bEiTv+hDMlcTZ4kg+txzVsWadL+CRrdYoPJqx3Gd/rGm8WAze6gUtzN
	 gAv396kp5y2SSnS5xv5HT4Fu0oTvigwgM7fuF9Vsokze3b1ZIFW9rJ7IwpkfEShtKJ98y
	 eY7qgIkaEIpC3pIy3aQB6xsooD7AseFyq+dVSIsVUwRcVhBR0Rvh4uWG9X5FOSNLwf/Li
	 MtnIKAVKVL42ll7T5urI3pCDMkqt3HYslLUZlHz6nP/Si6z97SXOX3UG/cyXgXkl9cPHr
	 YR748mm/rOtUNvmoHdKjDV/xrDk5+DTWC6BLiGsIOdP7Y4XeZSPHpl6RP+V/ubg1Ddw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pqWDhJ+R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E5B606A334;
	Thu, 19 Nov 2026 04:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pqWDhJ+R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD4E1F000C5;
	Thu, 19 Nov 2026 04:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061352;
	bh=X/3vbWyYaEqGd0GbXqNm/SJoTBOrZ4NQUiK+gihf33U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pqWDhJ+RDxwd8ed7AG4/EavbEQH0fMHynzUskXMrlmJj5PQK/33VcKAhiCxfUbQe2
	 pDg7G/tXdRo8rzGtJZTJcYlDfT95ajey/2TIB3/VGBmGhMz0kFPWaxkDv3FGDthK0F
	 x7LKzHAHe/CHEZahZ1EM3pZdZ6EkqrYWTQJzQ4OA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Priyank Rathod <rathodpriyank@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1523/1848] PCI/AER: Fix struct pci_dev reference leak in aer_process_err_devices()
Date: Wed, 18 Nov 2026 15:59:21 +0100
Message-ID: <20261118150023.120893077@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
index c46ad6e868f27..885320857ac2d 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -1055,7 +1055,6 @@ static void handle_error_source(struct pci_dev *dev, struct aer_err_info *info)
 {
 	cxl_rch_handle_error(dev, info);
 	pci_aer_handle_error(dev, info);
-	pci_dev_put(dev);
 }
 
 #ifdef CONFIG_ACPI_APEI_PCIEAER
@@ -1202,6 +1201,7 @@ static inline void aer_process_err_devices(struct aer_err_info *e_info)
 	for (i = 0; i < e_info->error_dev_num && e_info->dev[i]; i++) {
 		if (aer_get_device_error_info(e_info->dev[i], e_info))
 			handle_error_source(e_info->dev[i], e_info);
+		pci_dev_put(e_info->dev[i]);
 	}
 }
 
-- 
2.53.0



