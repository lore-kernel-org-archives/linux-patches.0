Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2672314AD0A;
	Thu, 15 Aug 2024 13:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729782; cv=none; b=XpHOENuJNElOtxedZfTVe88o6nOkOWcqQmrYIn2/q+aidVVPbW4cwxeBtcwOd+jrKiHd+lePuVvUdgfs8SkxQlFI598sSL+5suds4qyIVyOwhZ9l83A3FefrL9tzSMw9Km9YynABiYMSq0dXL1KnXRAP1x+DTotOzb3FvCDSVds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729782; c=relaxed/simple;
	bh=XWmTSw2l2YI61Iu+4Wk3PEk4UJ0gH8F2gY5MNbLjBTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gEhSW7VwEbo096k2ZNSacsiR7jEcv5Sftv0jTOUmbgbBUPFQP+tl5+cqoVTsQJj5iVMJlIvNHWd0wMzBzuz54492TpVWXHklyqlKqIn8Hx3YAiBw9h3G7NFQjSRKAFsYyMJ+0IROlwN76zTP8SK6BmJUntjK00SwDrKFaP+Ztiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iVffYFhV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iVffYFhV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67185C32786;
	Thu, 15 Aug 2024 13:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729781;
	bh=XWmTSw2l2YI61Iu+4Wk3PEk4UJ0gH8F2gY5MNbLjBTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iVffYFhVQm31vwFy9jUKDNSqu03Cum6QwxPyNvDQFzQ5UuOyaYasiCghphpzvU2Hh
	 XcGGmWCW0ovnfb93nblOn0n6vx16URoVzvfBdAy5yVqZWGODI0U0iPMLEGN6/pss+Z
	 YDFuAJGw2PLFd5HTBrRZvMpAnLeZ3BTAVURHEZ/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Liu <wei.liu@kernel.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Michael Kelley <mhklinux@outlook.com>,
	stable@kernel.org
Subject: [PATCH 5.15 206/484] PCI: hv: Return zero, not garbage, when reading PCI_INTERRUPT_PIN
Date: Thu, 15 Aug 2024 15:21:04 +0200
Message-ID: <20240815131949.369816432@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Liu <wei.liu@kernel.org>

commit fea93a3e5d5e6a09eb153866d2ce60ea3287a70d upstream.

The intent of the code snippet is to always return 0 for both
PCI_INTERRUPT_LINE and PCI_INTERRUPT_PIN.

The check misses PCI_INTERRUPT_PIN. This patch fixes that.

This is discovered by this call in VFIO:

    pci_read_config_byte(vdev->pdev, PCI_INTERRUPT_PIN, &pin);

The old code does not set *val to 0 because it misses the check for
PCI_INTERRUPT_PIN. Garbage is returned in that case.

Fixes: 4daace0d8ce8 ("PCI: hv: Add paravirtual PCI front-end for Microsoft Hyper-V VMs")
Link: https://lore.kernel.org/linux-pci/20240701202606.129606-1-wei.liu@kernel.org
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-hyperv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -707,8 +707,8 @@ static void _hv_pcifront_read_config(str
 		   PCI_CAPABILITY_LIST) {
 		/* ROM BARs are unimplemented */
 		*val = 0;
-	} else if (where >= PCI_INTERRUPT_LINE && where + size <=
-		   PCI_INTERRUPT_PIN) {
+	} else if ((where >= PCI_INTERRUPT_LINE && where + size <= PCI_INTERRUPT_PIN) ||
+		   (where >= PCI_INTERRUPT_PIN && where + size <= PCI_MIN_GNT)) {
 		/*
 		 * Interrupt Line and Interrupt PIN are hard-wired to zero
 		 * because this front-end only supports message-signaled


