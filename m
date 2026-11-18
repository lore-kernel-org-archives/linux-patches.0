Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025734;
	b=5rd6MCfAPg7xVT2vE+o6FfWJQ5IvjJKUAOcDlPBFKEFw7sSDE6ojvrkzT9Ch9NtiRfVE
	 EFOlGInDLIyaHOsczkia1mrrxjbU6SatLdLvpO1fJAV+WFRDs3mAgaRzaAx0N1YHQ7+at
	 kSRKG+E/cPVz6ZyutLpBNtcGe8Wop9dlaJ9sWzBRlb0jYuCzRUTKXw1icmd56RChN9E5S
	 RAGSlUow/cANW2I+ozN6U11BWxEwDgpX8sEBxuREsm+fpyFnBDnllhndjy4zC09vRQdKG
	 fkZHI8jnlmNMrECClcH+CtfzzumApswrgp1ufEq6WTHxphREMHwQmfNKlj69r+BiKCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025734;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=94glszPGBvzUB0v8bv+ixrPAk/yvDa0rV6JY1qzGliI=;
	b=bnbHdzXd/uugFRHPdSaHi+nONcnio9eFDUy4/BgmfgwbBIiIIrxSaIqn5XjilTASH6QL
	 MqLspO0oNzd6DLBHfQlDjAHpVQgkPScStZbjGQfKkdknlrVRDhI27+ytr3OP8p+faszzk
	 qQio0xTrZlu/C0UUN4A5V8AWbCoeWGF4rQVo4s3ar1L0ilQeLSLSdyfHVatoToJg9j/9u
	 y0Y98X67H3R+XWmWazFMv1AkOxjwiQdgaOkW7ZZJDlpa8qjUzHZ9me3iqmuYM8gjNyX07
	 EiL/MvQZSNC0NWqCqVxUGPxu25NJa9qgwBL3ZLuggoTdah84gjyX6WA+uouIgC1xafQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MuN7bQtd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF07606A320;
	Wed, 18 Nov 2026 18:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MuN7bQtd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0077F1F000C5;
	Wed, 18 Nov 2026 18:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025734;
	bh=94glszPGBvzUB0v8bv+ixrPAk/yvDa0rV6JY1qzGliI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MuN7bQtd7bboTWhpkO5c1e8XCYiix7sh2EiaZ/5eQj2ajKk7mn1x7m8fBlIGNmBfJ
	 fhFDFO0qxhq+m9ZDuIwThDrSrz5wIKcV1hKJ7+t2H6rMFtuvx9Kf/psxtJSo6C69Ae
	 rrXfFIU7Th9fiRG5ohNUgJV1TqyWte0ZEGyi8SPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Priyank Rathod <rathodpriyank@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1183/2151] PCI/AER: Fix struct pci_dev reference leak in aer_process_err_devices()
Date: Wed, 18 Nov 2026 15:48:38 +0100
Message-ID: <20261118150205.224551014@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c6a0e8969927e..95906ca84ec0f 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -1304,7 +1304,6 @@ static void handle_error_source(struct pci_dev *dev, struct aer_err_info *info)
 {
 	cxl_rch_handle_error(dev, info);
 	pci_aer_handle_error(dev, info);
-	pci_dev_put(dev);
 }
 
 #ifdef CONFIG_ACPI_APEI_PCIEAER
@@ -1471,6 +1470,7 @@ static inline void aer_process_err_devices(struct aer_err_info *e_info)
 	for (i = 0; i < e_info->error_dev_num && e_info->dev[i]; i++) {
 		if (aer_get_device_error_info(e_info, i))
 			handle_error_source(e_info->dev[i], e_info);
+		pci_dev_put(e_info->dev[i]);
 	}
 }
 
-- 
2.53.0



