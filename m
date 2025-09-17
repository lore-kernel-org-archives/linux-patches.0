Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DFE309DDD;
	Wed, 17 Sep 2025 12:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113309; cv=none; b=JLPE1u8A1dfQILP7BKm4RZj7B6bFTKEgpKKoznfYes1Uls3/wsV2vyOu+qd7hEeXHQs/ixbd4YvYVemJOnf6qA7K7K/1B6194ZfO/iMpx9LIPO0u1ce/8N/Lynlb98fS2M2Vr8Wnm68jwguLROmnW3DnPRJcyLKYofhteZl9Fok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113309; c=relaxed/simple;
	bh=oilpdPs7Q+0auvYLeO/v09aU2hRo7DCF2zKBwgfspZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXJIAaNjX+kw8CV5j1UNX+pFPKmPl2sA6ufcxkYRwsoA1RIiE3636JNkc+LPYPaV4f/duM0lmbgLDxsZFtEun//7C9ONEchEDfPFf/djGHuc/YdPsikRXIgSBbYtz0b7xjIvKvPWCWhXX5efgFLYvdI8yi+Jt9aBE3Q4LNNcdeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L/lTVDcc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L/lTVDcc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F270AC4CEF0;
	Wed, 17 Sep 2025 12:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113308;
	bh=oilpdPs7Q+0auvYLeO/v09aU2hRo7DCF2zKBwgfspZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L/lTVDccg6P7TeOkdZue1dzNmQbd0rI0KB8R8x5MubnaiYo334Iaojy0H1vFf/UWv
	 hwz0tXrxTb5VGO85CG2BdKpu9aupLD0WqAdgOcna3gEZw2FCdoyLgsMK8bxxOxS+qv
	 JUw1U8E4Wqfv6E1CN10MmmfacSxGRKxmCahTaKTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 6.12 047/140] EDAC/altera: Delete an inappropriate dma_free_coherent() call
Date: Wed, 17 Sep 2025 14:33:39 +0200
Message-ID: <20250917123345.450970128@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -128,7 +128,6 @@ static ssize_t altr_sdr_mc_err_inject_wr
 
 	ptemp = dma_alloc_coherent(mci->pdev, 16, &dma_handle, GFP_KERNEL);
 	if (!ptemp) {
-		dma_free_coherent(mci->pdev, 16, ptemp, dma_handle);
 		edac_printk(KERN_ERR, EDAC_MC,
 			    "Inject: Buffer Allocation error\n");
 		return -ENOMEM;


