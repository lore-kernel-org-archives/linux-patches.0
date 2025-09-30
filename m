Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA00925D1F7;
	Tue, 30 Sep 2025 14:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243822; cv=none; b=eg5xDy7f6XJCsrsmLct2BEQ4S9LYRK7eFsNR8CAm8Ka0PIpkW3QB75aIIcnqwiAlZc2GW4vdRfokCiS+LSiLUhx3NB0Iy2pMRxsXHxGEksIyHCvMG5B++9DhADRhCItWkILsbBoyuEBsd3+cjASAoxI1s7Ix0k3LchBUFYOu5Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243822; c=relaxed/simple;
	bh=AIqmhS8zJvIU+7cfpmxekhBP3/TeGln9FDN6JOzpUFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dqWpl7DU7DB/HeS1AcGVf+rmPPnV+BYSnKyZ4LOHuvW3RYlfJHqvc8jzcjoqdaX+PFkkLdpzorp5LLYQMhmoMwHWiAVdQbsQoAGlIIoMpgwJPZMGOlnfddFrOBVeyteA0pWpcGPPb8WH/XLvdfvHvOr0i3ooFFbjX2SgSgl4N5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p9M9/t8N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p9M9/t8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F81AC4CEF0;
	Tue, 30 Sep 2025 14:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243822;
	bh=AIqmhS8zJvIU+7cfpmxekhBP3/TeGln9FDN6JOzpUFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p9M9/t8NhSkpQ2a01uUywuFBD3Hhu1fE+GJdnjT8HNaN3WkzPGZ5cKCwG8pU6hJqN
	 JntrzgaP30263ydgatFZxfFPMu33crGCdECkZn342NhC6cFc57sQ3Stbsp0zpfYHVQ
	 TWY0PwiFbw6bYglz60RrGiUtIippu/ziaRYL7H28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 5.4 05/81] EDAC/altera: Delete an inappropriate dma_free_coherent() call
Date: Tue, 30 Sep 2025 16:46:07 +0200
Message-ID: <20250930143819.882475094@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -125,7 +125,6 @@ static ssize_t altr_sdr_mc_err_inject_wr
 
 	ptemp = dma_alloc_coherent(mci->pdev, 16, &dma_handle, GFP_KERNEL);
 	if (!ptemp) {
-		dma_free_coherent(mci->pdev, 16, ptemp, dma_handle);
 		edac_printk(KERN_ERR, EDAC_MC,
 			    "Inject: Buffer Allocation error\n");
 		return -ENOMEM;


