Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031115;
	b=xd0MZOO0LdHfUDh2oEYrdg73gO7g3h3BoWcl5xsSk4y3Kh+i3ZCnCxQmbMBGYpXaxuy+
	 JPORDNSN+Dz8a7G9eagWAzLyZ8Jz/SPQZHoVP1wqEYf2ymmK3HPKMs+Mtlhf4M+Kklmd5
	 PObxa3GUINXFX22iQobekFC3/f+5sHGlzILndvY8gq9v8/Jy797VmIe9XM1fnTOVcrShz
	 R6sxPRFuVpaUD23QKnPPzTomoL8VF0vj0s/fstKA37BufQqnTppfw83nbwKOVwR36YUZO
	 SoEZSU0x0NkVj3HOhlbj6L0vEdvckSJ+GNoo0Z8CxbZZoeyHMfLBsBchS/PRUQFKj0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031115;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YnOnzRzAPd2roTWQ7lDnx6SYoBkRjgF2z34zRgBu2lc=;
	b=KkJRPmHEo58w4OptSAG33Z76EQ4n5/osIliTPMZrFegSeagBcoDns/1nVswj4OR3IlwR
	 Z5x3VyGmXKTtPKScXyBtwTU5DF5eG30j/L98tmBOxX5vsFHKG/jISgoqSssop4Emlf4NW
	 /kSvKQQSafe/Opf7g7LLOi2QIE8tkTPiWP4xO5d8683KKHtp5u63/CKzI38wmsTIoWQ/q
	 sSRADA4L7Opc/krYcefn21kDDxbl7rXYhi1GzGbJep8IBW6vy+HSRVbKq94IZKOM9lWEH
	 p+zInV9ppiG55f48pNS9YSfIhh5cm3hr/WCjcq3Z4Nyfe//MQcgu9VkZcc/BuAFuE3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dqHELfqN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE26606A31C;
	Wed, 18 Nov 2026 19:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dqHELfqN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD111F000C5;
	Wed, 18 Nov 2026 19:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031115;
	bh=YnOnzRzAPd2roTWQ7lDnx6SYoBkRjgF2z34zRgBu2lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dqHELfqNWda7g9/ef5GasDQ7lGYneL11LdsZYpVjDXSq67Hb788whLe2d7btsErIB
	 qjMGTuTCeucaBg+JvdYXUKjz9G27WIiRPWyEBJ6z/Ya3cfRmZgMG9z+iQsdWs8o6kB
	 qCNihOuRklwz3m84f8o0aE5w2iw4LLMMJBgyRAbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Priyank Rathod <rathodpriyank@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0944/1756] PCI/AER: Fix struct pci_dev reference leak in aer_process_err_devices()
Date: Wed, 18 Nov 2026 15:51:11 +0100
Message-ID: <20261118150047.654196854@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 44fac6c2f437e..39b03f0945996 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -1124,7 +1124,6 @@ static void handle_error_source(struct pci_dev *dev, struct aer_err_info *info)
 {
 	cxl_rch_handle_error(dev, info);
 	pci_aer_handle_error(dev, info);
-	pci_dev_put(dev);
 }
 
 #ifdef CONFIG_ACPI_APEI_PCIEAER
@@ -1277,6 +1276,7 @@ static inline void aer_process_err_devices(struct aer_err_info *e_info)
 	for (i = 0; i < e_info->error_dev_num && e_info->dev[i]; i++) {
 		if (aer_get_device_error_info(e_info->dev[i], e_info))
 			handle_error_source(e_info->dev[i], e_info);
+		pci_dev_put(e_info->dev[i]);
 	}
 }
 
-- 
2.53.0



