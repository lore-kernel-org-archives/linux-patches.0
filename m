Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF78303CBF;
	Tue, 30 Sep 2025 15:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245053; cv=none; b=s018mWBBOfdsBYBqa8DcminlBZD8Xcc9sJQRdilBaSS8ymRgbiFJO5Ov62Uy17pktGHgEaifN4W8SA8pev6XizDNmowFikzEQ9XC+5iGwhTr5sY/RGx+tgkjdeaQHGGuGkCEnqp+puLlCGU01/AOnNnLouZn4kYIuchssVaSUMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245053; c=relaxed/simple;
	bh=XJnoq4S9cQsInFfceh8qtAH9OO2Y4ikoXmCYSYhj0uI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jarm2iXtlYTsu1tzNr0D5YDBIpRCV+rvka8+qfOiNP3cpJZHc7UVJfIgtanOZtB8tqNK8+1TjW9hX/LpoIfZEOO3ugQnGyxIHW+kDk0k+b0XSwxgyEGZ8NycjT4ZYRMF+A/sVMI02CpoxLUG0y+oOhSsP1BOA0F+rk0rT1IWNEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mUQUdyQ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mUQUdyQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B254FC4CEF0;
	Tue, 30 Sep 2025 15:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245053;
	bh=XJnoq4S9cQsInFfceh8qtAH9OO2Y4ikoXmCYSYhj0uI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUQUdyQ5YekQHzBin6H0+vGXdbApikUfanPiDFCSWBS5bOf9y2BVs2hYmODdT9SR1
	 QX2vA+DtJgvWHRfUN+BVGhv2G7EgzXUxyBKJPrt26PJDuA4+ZZ6XJ/Zo1Bik7QukR2
	 G3MITxyeufl3iLmEASmp+Sb+qBc7kKk/pz10+EBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 5.15 020/151] EDAC/altera: Delete an inappropriate dma_free_coherent() call
Date: Tue, 30 Sep 2025 16:45:50 +0200
Message-ID: <20250930143828.418262239@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -127,7 +127,6 @@ static ssize_t altr_sdr_mc_err_inject_wr
 
 	ptemp = dma_alloc_coherent(mci->pdev, 16, &dma_handle, GFP_KERNEL);
 	if (!ptemp) {
-		dma_free_coherent(mci->pdev, 16, ptemp, dma_handle);
 		edac_printk(KERN_ERR, EDAC_MC,
 			    "Inject: Buffer Allocation error\n");
 		return -ENOMEM;


