Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C143A3054C5;
	Tue, 30 Sep 2025 14:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244083; cv=none; b=GDbxISuJRWXcKeUpHxQ7vJHXn2JfthfKNnG4+vExCHf6gNWZ1iBHWiZ4EEdOYiWCy9NWycj05vdrS5h5fQJT9oQN2s0JgbUDBGGmv2r94d/DJUkcz6bDiijiheAPNjDNLxTwaDPXBQPp0z7QvQvd+EQrjZ5ZAaUZP6f0hBW3Qe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244083; c=relaxed/simple;
	bh=aFMfQjF1UppqHhbkmR6OvVWPpiKbk3fEAi2DI8a062s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldAGXQoxlAYFtL28uteESYWexDVCqdDsuyx+F3iy+/oiptUnhAjgGKfg70cBDUHoJrtXia4J8mNOZVrq6ywiZPEm8LOioaA3aJRMGCm1Fuw5o8Z0A0ADOwdbDEjBkfg0ILINJMDA/i8kjiM85ZW+0yBplde6uhGTW8sQYqFW0ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DrYI7TmO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DrYI7TmO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4841FC4CEF0;
	Tue, 30 Sep 2025 14:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244083;
	bh=aFMfQjF1UppqHhbkmR6OvVWPpiKbk3fEAi2DI8a062s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DrYI7TmOusqyWXmpKzdXGdE0f7szvhOt8P9HDnjRffdPmlPkANAc0dEAlJyu5eJrX
	 yIXWqHu7Lrl/UQoUvNzRaIGxkj12R9wunNvtN/VWaE4i08mVFr/hbc/wXhA82dl+7b
	 qZl4GhFKSmNEiMxuni4xHnoXIevZqD8vTYrpWlRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 5.10 015/122] EDAC/altera: Delete an inappropriate dma_free_coherent() call
Date: Tue, 30 Sep 2025 16:45:46 +0200
Message-ID: <20250930143823.614980087@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salah Triki <salah.triki@gmail.com>

commit ff2a66d21fd2364ed9396d151115eec59612b200 upstream.

dma_free_coherent() must only be called if the corresponding
dma_alloc_coherent() call has succeeded. Calling it when the allocation fails
leads to undefined behavior.

Delete the wrong call.

  [ bp: Massage commit message. ]

Fixes: 71bcada88b0f3 ("edac: altera: Add Altera SDRAM EDAC support")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Dinh Nguyen <dinguyen@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/aIrfzzqh4IzYtDVC@pc
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/altera_edac.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -126,7 +126,6 @@ static ssize_t altr_sdr_mc_err_inject_wr
 
 	ptemp = dma_alloc_coherent(mci->pdev, 16, &dma_handle, GFP_KERNEL);
 	if (!ptemp) {
-		dma_free_coherent(mci->pdev, 16, ptemp, dma_handle);
 		edac_printk(KERN_ERR, EDAC_MC,
 			    "Inject: Buffer Allocation error\n");
 		return -ENOMEM;


