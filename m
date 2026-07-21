Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D333C1400;
	Tue, 21 Jul 2026 22:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674166; cv=none; b=SWN/iMKzp5LRM0mH8RFQJDZocppsTRr+xWv+KqKG8L6V/CA5Spb9al6h+5I64A5xWbiBfBS62hQB28WT1xUTD3jELmf9psxXPtQ3584/JY213/3n0sDvHBUYO6pRLXDm3RcfHF9pxJCrDpSpvAUesJ0C47UPsbVZjkRn47C3TfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674166; c=relaxed/simple;
	bh=nQUDiH5JX6t5NOvWTh1k+OOI0tfq4Tez75QYD7Q8CbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+aD0e0CEgv8prfRcCimYgSRV78zZmbt5IrhBpM7Q3fZsTEkp7WTGq4JoLu1KQO/OgbSJntZW64OMgU6EJ67d44kloWUk7k4IeZg3P6an+wf2wYHzZgKfZ27tg2bca9ZK60qjlmsX3ZZ1SaAnnNmkiB0hs0GSkxA44YuquF9Yo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jqYP0SBC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jqYP0SBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D7F1F000E9;
	Tue, 21 Jul 2026 22:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674165;
	bh=fl9GUQlJQ/mrUTu2jt0a9WwQ79MhsKQUufeTfV27XEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jqYP0SBCFPJ15WWy9j5kSNKj3g6OTqLaG20ZdM+MeJK30kNwTTGFTtn1slj9VqG32
	 6N/vZgGtIdIu2XEe6dOQ36S4uUTKwAF3tE8KkUgI3SPhPox3g539/1liSpmcZek1nD
	 Tz3PS3yspLycBUq6kLeqaEeY/RW41uCHYx21VEBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 437/699] fbdev: i740fb: fix potential memory leak in i740fb_probe()
Date: Tue, 21 Jul 2026 17:23:16 +0200
Message-ID: <20260721152405.552990735@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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
@@ -1150,6 +1150,7 @@ err_reg_framebuffer:
 	fb_dealloc_cmap(&info->cmap);
 err_alloc_cmap:
 err_find_mode:
+	fb_destroy_modelist(&info->modelist);
 	if (par->ddc_registered)
 		i2c_del_adapter(&par->ddc_adapter);
 	pci_iounmap(dev, par->regs);


