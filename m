Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C568E333A81;
	Wed, 17 Sep 2025 12:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113714; cv=none; b=rXAERc7D0HI1BYGN+2cbmPlK7XCy2/EV5sWFLZdjonrs59bjish00E4KJ7RokJkuaGLCN0iFVQLwwmPawoEP7CcOL3u5mfC38kK1THrymGSmLoU1yFSFF807uHvDjcrdy1HJ70hRCVtgTYZzA4cdlE4M7C6ZDKMuOkC2l5tu6bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113714; c=relaxed/simple;
	bh=Pp/68j77Dh6TlY5KhJs9/o/NpJuyLZQSfLs2aJdQGWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bul49uyeJ6x6NbeMNtxncVTA7yPyak0VRxH6zzVSiBl2fhiAvF01iV0vTsfABjupab7BgQIG/gmXl3ZsOV9+wq1Hppimp/5Ua12wTcgb07NUBjEiD+8wgKzLT51v8oaEfIzv6Ws31IlA+63DVM5eZKxZi/KH1AHvgKYLs3zJ9e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2GvGlx5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2GvGlx5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34DCC4CEF0;
	Wed, 17 Sep 2025 12:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113714;
	bh=Pp/68j77Dh6TlY5KhJs9/o/NpJuyLZQSfLs2aJdQGWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2GvGlx5iz/6lVR7OuySYVjZpkp5CLP7ecLxse+ZWo9LDP8LNFAKjhd/2GUN9ZG65L
	 M96bo1WEMb/iwgcjudtSqT1TjbQHh2v3BLhj8alVwZjGITt+1SsyAfIxaZ+V2vGrZh
	 2unO1hwi8cKx415IYU17vDjs+hlE/oWPY5/OSigs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 6.6 031/101] EDAC/altera: Delete an inappropriate dma_free_coherent() call
Date: Wed, 17 Sep 2025 14:34:14 +0200
Message-ID: <20250917123337.603745157@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


