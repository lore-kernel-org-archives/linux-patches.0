Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D9835C6BA;
	Tue, 21 Jul 2026 21:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667743; cv=none; b=fiOWlTglKSllB95YXzMUTZhLqmLRBxJucXjsvuH+XYmGU9fzmmBbzOhqSIg3UMV0VcaoYLLzCtkPJ5svFY5aGZ6uy0OcGu+CFHwJ23NeAc/1SIfFm4qW/AOPVkjxT9MOeMWqdgE5rD37prM/vHVHzvDg+RB0lLG6Nw/FvPvdtko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667743; c=relaxed/simple;
	bh=Kx2n0YR4l6b/La+MEbORq0LDfSaTItCSWhlv+GGACkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HiKtMDQg/zQ3UbJQoFPdeSKVrdWQmn19gjSWdbGEUh2LRhTKMjcv8MUEPob80TV9nwBr0FFtRUzmhlIZ1hCas/cUlK8DQOXHQVhSDJqGfZ9DXNudKuSGpCtksSqc12yiAOlIEIFFMslEavhWs27mFLZ3e6YCXkggO+1iDxedEC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wgPzGGcL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wgPzGGcL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96661F00A3A;
	Tue, 21 Jul 2026 21:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667734;
	bh=NHc3TFm46JTynsEmy/BtAU0EXf2Y4u5nSJWk77q8MKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wgPzGGcLH2GJVcmXyX2EBMDJSZdzIh8qJuzPMHzEAqA/mwZJtoiu3vmuo6+wZVIBL
	 bVz0v01gG9eLiRYyTrO3u0enA1hBLMGFArh9ZoFwIZf7MQ2n+YqwX0wmcGPnrkgZCP
	 4kKfA9kVMwfrCIid+NOxwUjtxfGYuYQsfAuL9ASM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH 6.6 1173/1266] PCI: Free saved list without holding pci_bus_sem
Date: Tue, 21 Jul 2026 17:26:50 +0200
Message-ID: <20260721152508.035205923@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 1d8a0506f69895b7cfd9d5c4546761c508231a8a ]

Freeing the saved list does not require holding pci_bus_sem, so the
critical section can be made shorter.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Alex Bennée <alex.bennee@linaro.org> # AVA, AMD GPU
Link: https://patch.msgid.link/20251113162628.5946-6-ilpo.jarvinen@linux.intel.com
Stable-dep-of: ee7471fe968d ("PCI: Skip Resizable BAR restore on read error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/setup-bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -2324,8 +2324,8 @@ cleanup:
 		pci_claim_resource(bridge, i);
 		pci_setup_bridge(bridge->subordinate);
 	}
-	free_list(&saved);
 	up_read(&pci_bus_sem);
+	free_list(&saved);
 
 	return ret;
 }


