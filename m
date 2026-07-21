Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FF137DE97;
	Tue, 21 Jul 2026 18:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658459; cv=none; b=S27nI1zp6pWaqv2tqSiBsEbhdOCkocUw5UDwI5AhVHffdr61hR3GgoVseUugWNAa9DYwmyqcEwYaNKyjJA53gLykrW4wJvdbo800F2Vs4s26TTWzter51yogpyi8MUPOC90ffLFwBqSrubV2675/niQTUcMt5vIr2gt9RQdKBY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658459; c=relaxed/simple;
	bh=vVLnnx8aMXCKVMJwhK88SHm6c9ZeJ+Y3A4gNMCHUhZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AEbVw7YuaaJey2Yh94Hlf4EYUTW40qNyEkgkQlVCUimyGEwovCQEAvdKBIE8x26820lPCG49/RwsOQgFOThzX7MJuCVHu7qbhW4SQmUPf+ExNtwG+5/6rZvNTFrGesbN1Q5LMnxnGgoaMgOTIs9lPwOf5zx62Ze+2Of5Afeqzwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lFvZ/kXN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lFvZ/kXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6651F000E9;
	Tue, 21 Jul 2026 18:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658457;
	bh=02hWvdA9efVryj6UDqOTwcbEPU6F2sgmGNoHNyULMaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lFvZ/kXNgLf1JbfvQ9DzX50YhPBUYQrCGUk99RGWZAZvaBtxz8vpJ5llzpV7THNcV
	 clw8f8VVbpzOSEJmtwyrZwUurQD3KvstNb7/mTUWcdV8ReeTJKdBVYRstdiGiWPm7T
	 +LyEwdpvKTed19PoyCfDzltkEiv5ORD28diZPSP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 1150/1611] fbdev: i740fb: fix potential memory leak in i740fb_probe()
Date: Tue, 21 Jul 2026 17:21:06 +0200
Message-ID: <20260721152541.285224062@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 5936063409af230a2c88b8700c47b89a19fd70b5 upstream.

In i740fb_probe(), the memory allocated in fb_videomode_to_modelist()
for modelist is not freed in the error paths. Fix that by calling
fb_destroy_modelist().

Fixes: 5350c65f4f15 ("Resurrect Intel740 driver: i740fb")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/i740fb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/fbdev/i740fb.c
+++ b/drivers/video/fbdev/i740fb.c
@@ -1152,6 +1152,7 @@ err_reg_framebuffer:
 	fb_dealloc_cmap(&info->cmap);
 err_alloc_cmap:
 err_find_mode:
+	fb_destroy_modelist(&info->modelist);
 	if (par->ddc_registered)
 		i2c_del_adapter(&par->ddc_adapter);
 	pci_iounmap(dev, par->regs);


