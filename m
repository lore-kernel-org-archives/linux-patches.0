Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7432EC563;
	Wed, 17 Sep 2025 12:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112701; cv=none; b=RgVgIKGkEwA/6jYU+NEJtup2w7HAilUq8xWHG+/eUQJj+18TgEscYoa9FikYO2q380R5wvD+CRlq0r7e4+KKCe+J1u8Ry2MLj+NujTjv2fhqn1UtzAGPikdZhIgaZ97CyoU88J1N64wnqaGXbjqWaaPbE9GOAitTvkOZcUYbb9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112701; c=relaxed/simple;
	bh=/bX9QDrwK4jeNiYgSp2Z3x5Uda3r/uTDaBqh3183p+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WrIGuVWgKf0B7nn4nppSDVa0gjsB80DEIb4lVLzwOI4BU6Cr2hkUmfv7qNLydI/+dY8Gs/KQXqgDE22DHYwFfvKFsPg1QVXBhfE48Rv9faBW/OV7XtH05n4hL+y/zZnE6Fr7Y4DJabFOWpNL8WeG8PEIH5+8sH8ZPTLv6QM+v4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MIW1XJ7c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MIW1XJ7c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E310EC4CEF0;
	Wed, 17 Sep 2025 12:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112700;
	bh=/bX9QDrwK4jeNiYgSp2Z3x5Uda3r/uTDaBqh3183p+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MIW1XJ7cINDKInKhcQc9CVXhCpI5aP74joDaefJlebUfBXl579aNnoIFaRB8ePEJh
	 bJweRh7xjKWcQm8Qv007YV+crfDLPSggQ95UfrBxofVTRa2MxgtYkAWs4dXdDLmhYd
	 nR1hIbsgoZYV12nduFUSDtrhAHntm2G6osIq2kpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 6.16 048/189] EDAC/altera: Delete an inappropriate dma_free_coherent() call
Date: Wed, 17 Sep 2025 14:32:38 +0200
Message-ID: <20250917123353.036967587@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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


