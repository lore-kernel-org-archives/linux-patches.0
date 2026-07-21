Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331293C10A7;
	Tue, 21 Jul 2026 21:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669932; cv=none; b=hSIpjrOTy0PKNG3E5swrujktSoC1vTDVBeZZhpaeEwqnT3MZmVhJx0T/WnLF2nTbITxib4mkMRvtMgliaevt+yodTNqAabUhuDtTbBZ8sm/YBUcXu3gEMRJ248VIpVctUP1kMBA+laCAS0fUIaFDERLRupUNdSPf/bRkM70RJY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669932; c=relaxed/simple;
	bh=/psduJMh1uXi0rpMXk3xx8btNaHnXe1B7FrGz2yDncM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lTkjACFDuAddFVjwxusOCoZwiHCALUKMUIhxCmCuLnHDpgRQjL9Fsl5aBaiUfeMim5R1cF5qLohZ/Qvpwxsybp92OSl60DZf3MfLUNB+mn6okP3ILqavJeSJMBrwr3sQkOlxbFOVg6hsCkNDgonTeNPnduef149Uz+gXqPuXGF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U4bsJy5T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U4bsJy5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 968191F000E9;
	Tue, 21 Jul 2026 21:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669931;
	bh=R6xhJRZbghEe3/ehWhmx9cjswf2OkMlknfRzIXJ4+/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U4bsJy5TSpvQvnEVd6wIrIg6q8g6TFbQGpP6I50iFfXbVPou1FcKl8hSOQrPECM1L
	 brmsSPEFFw1lx0KShjwjm1LIfTwHSVHzTpK6PN3IkCdAFtYzjJTjGMPIyEwNFG62DW
	 fyZiGaskvd4sa3iVmG95JA+CEsqpBmMwt29BpiMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 0739/1067] fbdev: tridentfb: fix potential memory leak in trident_pci_probe()
Date: Tue, 21 Jul 2026 17:22:20 +0200
Message-ID: <20260721152441.112738059@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 7a35ec619d9af8ee128320975c1252b8ad65f1e8 upstream.

In trident_pci_probe(), the memory allocated for modelist using
fb_videomode_to_modelist() is not freed in subsequent error paths.
Fix that by calling fb_destroy_modelist().

Fixes: 6a5e3bd0c8bc ("tridentfb: Add DDC support")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/tridentfb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/fbdev/tridentfb.c
+++ b/drivers/video/fbdev/tridentfb.c
@@ -1705,6 +1705,7 @@ static int trident_pci_probe(struct pci_
 	return 0;
 
 out_unmap2:
+	fb_destroy_modelist(&info->modelist);
 	if (default_par->ddc_registered)
 		i2c_del_adapter(&default_par->ddc_adapter);
 	kfree(info->pixmap.addr);


