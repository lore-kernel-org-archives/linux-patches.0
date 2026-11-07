Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063417;
	b=Dgm8dFUJOYt1NpqUJaWUHAOZr1IHKiSJKNe5P2ozIhiMYxThOkE48J3SD6W/PxRhpoUS
	 MR3VOA++9X7z/3LE1nR0N8EvVNdNbh6WKiUZhdOJI1d7FC30EsMT3ynIMvzWOLEhBtRxL
	 VAgbo7seUF30QmQiBmdgoOkGd0o75FRU2E/VIglF8rJMNHb8AelrY0vbDPpyLX/3QOF0J
	 uXAQSWFTDWL0VviEqhQ2SGavdL4DZqV4g3HhFzzIVDULqE3wyOfQT6H1zOn3yKmln1Mlv
	 E79gaaw0fZlWO+P4ptf3slNU7xGNXzcG+Z6uqpJwZzA6DxHySQk9aftAJvl9Pbq6IyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063417;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K2Jr6F4eWLp98wxxWyO4q4PYAJtDVD9pIqHZTGUrc9c=;
	b=AvHuzjzwcenC/WlNb3g41PMfDdSJvbwXD8BnglNlpDQIWqwhWnvXidhcZM44C9kaW2tT
	 JXpojly7+PX0gLP2xdNGUUPBXisFS+FlxxBQzLepLLQMIxgm7ayaFHKP9WCPj1T4r4pf7
	 vtaGvMsPXXVQqNz6rYoY3tcQf56NjPzI4WWztFPaBYqo8+sxEd9qtv93+HeWr6cLS1Tq2
	 qVAzINrhrT5A2fnNQi7gbmz9tgCWVQAzbVw9Ul5f5eN0EJHBGiyo0CWtC+INujvmUr5Xw
	 rvNxaKRLHC0FVvZSPZCdmxc1rR03+G4pOvUhERljI0AuWcO8XDnYciCa1IJ6iirhesg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JRrx56nr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B775B606A339;
	Sat,  7 Nov 2026 14:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JRrx56nr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE561F0089F;
	Sat,  7 Nov 2026 14:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063416;
	bh=K2Jr6F4eWLp98wxxWyO4q4PYAJtDVD9pIqHZTGUrc9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JRrx56nrxqXzlPEwKmSOAjylk1vd/9Lu9E70z0s3uL/yzWiOumvi4NYIBGVVG1z4c
	 XnUy0D9eSA1tLTDAWnWFNrpsSpOQ4KiTSY/MTo1ROAgDsEmUT2W7MN46HnB6tkXCzg
	 xRDqFDCgD+Lrv8nKiMeYT/k362ybRz7FOtaWbIfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 584/869] efi/libstub: Dont replace an existing LINUX_EFI_MEMRESERVE table
Date: Sat,  7 Nov 2026 08:54:26 -0500
Message-ID: <20261107134912.959962791@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit aaf3ed0f46298e18ec8bc477cf0a37478e41f2ea ]

The LINUX_EFI_MEMRESERVE table is the root of a linked list of memory
reservations that need to persist across kexec, such as the GICv3 LPI
pending and property tables, which cannot be moved once the
redistributors have been enabled. Each kernel adds its own reservations
to the list that it finds via the EFI configuration table, and honours
the ones made by its predecessors.

The EFI stub installs a new, empty table unconditionally, replacing any
existing one. This is fine on a cold boot, but not if the stub is being
executed by a loader that passes on the configuration tables of an
earlier kernel, e.g., a kexec loader that runs the incoming kernel's EFI
stub, as the reservations made by earlier kernels would be lost.

So leave an existing table in place, and only install a new one if none
exists yet.

Cc: <stable@vger.kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/efi-stub.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/firmware/efi/libstub/efi-stub.c b/drivers/firmware/efi/libstub/efi-stub.c
index 874f63b4a3830..adc5d121a33c5 100644
--- a/drivers/firmware/efi/libstub/efi-stub.c
+++ b/drivers/firmware/efi/libstub/efi-stub.c
@@ -73,6 +73,14 @@ static void install_memreserve_table(void)
 	efi_guid_t memreserve_table_guid = LINUX_EFI_MEMRESERVE_TABLE_GUID;
 	efi_status_t status;
 
+	/*
+	 * If an earlier boot stage installed a memreserve table already, e.g.,
+	 * a kexec loader passing on the persistent reservations made by the
+	 * previous kernel, use it as is: installing a new one would replace it.
+	 */
+	if (get_efi_config_table(memreserve_table_guid))
+		return;
+
 	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA, sizeof(*rsv),
 			     (void **)&rsv);
 	if (status != EFI_SUCCESS) {
-- 
2.53.0



