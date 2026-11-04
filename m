Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827060;
	b=40BaQgIdVSUFtKoXPRBW/xSRCNGHrYg7rzywLQm0+AZfRgf9FpvLiU2qmZmU5LAjF9F4
	 ORwcRhc/5bFsIqQTG4jNm1FVdTTKkgFmY9VbjQD77ta2HC6uP3dWe368OiE/t4XbIWrPV
	 t84/9T7pG6UqVY4n9WUOJohauCAcmiupj0jMhSSaz/359wJNT2xACqP8gLYtPOvOGyqbu
	 z65SWrQ2QBWr2iacOCo1UCBgQWaID7TFyrRK9ONXTPlQzhO0NUy5Jl7wYp8tKEfzvq+1z
	 inY+TPvA8NrpnT2v3O42ioUXiJZao13+2ZeS4RsCBocYuK3g+rQhGckckFlH1yB9iXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827060;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mUtkhUKXQv0fn8wVFxFcECUmtQBSRg1AwFTPq0UR794=;
	b=Jczz48TfBA3YHiPOS/084/1USjsyFX/RBIFvEgpkV98rGW7JqYyC9gJ6eUOp8OxlMpEE
	 QmBXH87ti6AVvkOjDCr/pze43OxE1NaCUuyylwxR/O+1gDRrn8ETTbQUgxbm22qd/g+3Z
	 zK/3Lg9ea5KuR813GLPl9bk2upSas65hNLamXU7GY8PU/JRUB15TtXPhw+e7/7ibwe0xD
	 tPOWdamp6g+chJ//R2MhXE0ay1VYdBPkNldOI01Vc1TUgxw4l7SWmrJrp8fJgUbmH09I1
	 59IzOqog7POfRKB89jd6Gvrsbf3H52EgcS8FVY9hHSVOzwHI3rcC4Ko680ONNT8drtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N6afW5ze;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D754D606A840;
	Wed,  4 Nov 2026 21:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N6afW5ze
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC7B1F000C1;
	Wed,  4 Nov 2026 21:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827059;
	bh=mUtkhUKXQv0fn8wVFxFcECUmtQBSRg1AwFTPq0UR794=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N6afW5zeDHF5pmFotnedZn2kOf/DfxR+TIxxP0VqER7ryFVMSdMPGHQgXzC9Np6xx
	 z16iS3fxTDfNqWqEHJL5sMUy9c3Q8CRZK1LzsB+L4itLaP9juDHJbqGufNvoXqprCA
	 ex4LM7aBVPLdrUtbL2/0HUSx/VEQ2Cb26kefwIuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Tobias Schumacher <ts@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 7.3 169/547] s390/pci: Fix double-free and NULL deref in zpci MSI domain cleanup
Date: Wed,  4 Nov 2026 16:05:53 -0500
Message-ID: <20261104211042.951032718@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Tobias Schumacher <ts@linux.ibm.com>

commit 31c66bd273303590fe69fad370e72a12faa0bf76 upstream.

zpci_remove_parent_msi_domain() dereferences zbus->msi_parent_domain
unconditionally and does not clear it afterwards.

zpci_bus_create_pci_bus() removes the domain when pci_create_root_bus()
fails, then zpci_bus_release() removes it again on the last kref_put(),
reading ->fwnode from the freed irq_domain and freeing it twice.

If zpci_alloc_domain() or zpci_create_parent_msi_domain() fails, no domain
is created at all; zbus is kzalloc'd, so the same release path dereferences
NULL.

Return early when there is no domain, and clear the pointer after removing
one.

Fixes: f770950a4709 ("s390/pci: Migrate s390 IRQ logic to IRQ domain API")
Cc: stable@vger.kernel.org
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Tobias Schumacher <ts@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci_irq.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/s390/pci/pci_irq.c
+++ b/arch/s390/pci/pci_irq.c
@@ -533,9 +533,13 @@ void zpci_remove_parent_msi_domain(struc
 {
 	struct fwnode_handle *fn;
 
+	if (!zbus->msi_parent_domain)
+		return;
+
 	fn = zbus->msi_parent_domain->fwnode;
 	irq_domain_remove(zbus->msi_parent_domain);
 	irq_domain_free_fwnode(fn);
+	zbus->msi_parent_domain = NULL;
 }
 
 static void __init cpu_enable_directed_irq(void *unused)


