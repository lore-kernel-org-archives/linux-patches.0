Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06273EF644;
	Tue, 21 Jul 2026 17:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654141; cv=none; b=mAG+o4q/471G6aQb/RZ2XQiNyhy5nz21ojeFtnRMTqx/GF88zuu1Uuv7/G2+Jg8sD+CJQiJL1Gt7cLTrofIUVP0s1GBj85SjfQPre5PFNL/RZmjn///TxL33zihQ0TDwA5VBGquvw+1E0LPz1I2HTciixwQklmXkMVGF7/hj4i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654141; c=relaxed/simple;
	bh=02WTMErrm5J2o6wVbGkASOaLr6wFYA++16B5kdvSxho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DbrBPTpWKh6mI18GP3msbig07/t3BUr1Z3qfz59IZsiwmo3L8CeElvp1T24AuwBfYHwMIJJWahZ6EEZYeubO0nRT4bydzTqEmu/2jpWu2cVFq4fPiKP2b7U7XRgudY9QU+Z8E3wLilnQFmoxX53YBC8B9jbC/rCF+zEC1GA0LII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k/Lf7RcV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k/Lf7RcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E07E1F000E9;
	Tue, 21 Jul 2026 17:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654139;
	bh=hJJt+aQUp4solBoqLdT1lnTpYi3JI59TAfYGJtX7jaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k/Lf7RcVB779ZPvUETFtZyNy6e6PARSfAvH1FOQnPIaxxgCmtr2vHvD090UTUUamp
	 XOaCjkv9bxv9qe3d0lYkaa6yHXvCZF0Miksz8wSHYdBOfQdRTLPHDpC/gnKMYpDlkv
	 wd7oOkGHYoogv3A2EQ4m0YIxHSzAhv/Pgw5jzG50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.1 1592/2077] fbdev: tridentfb: fix potential memory leak in trident_pci_probe()
Date: Tue, 21 Jul 2026 17:21:05 +0200
Message-ID: <20260721152630.320433074@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1706,6 +1706,7 @@ static int trident_pci_probe(struct pci_
 	return 0;
 
 out_unmap2:
+	fb_destroy_modelist(&info->modelist);
 	if (default_par->ddc_registered)
 		i2c_del_adapter(&default_par->ddc_adapter);
 	kfree(info->pixmap.addr);


