Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DE22E62A9;
	Tue, 21 Jul 2026 17:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654119; cv=none; b=O4wy0T1GHXB6xHJbqX4vsof/3Z48VG0/ZyFu1J3NRPBcO7OCuXCmGqaOgwVzWr8px9QyTapce6ZrFZmt00Evz03Pq0WVAi5ejohclrg8Epx/Q53E0yO+Fjl0wtjP6B7th+aDpzMnOKz4MsP0+13M0KBiyVErf/nEREBnzOgSMjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654119; c=relaxed/simple;
	bh=9PMxTOAlVM+8KQhGYuzg8GMjycYUsWulPnzOJn5EBqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fq9+aOTLQOGbcMoDNcXlWZdqqJVKV99OnFbCSDU+29e+pHtxmFpQ/EENGwniriOGI+WV+IKfyxPUEKhxz0WcMkKGpENI7WD0BMYfrak5xeyvB/WVb3xO+hfrwkgIoTqPoCeeBymqTC3GgukvEy/7IDLWIQAzD1rHije6FTFAgvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JUMSElxt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JUMSElxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0789E1F000E9;
	Tue, 21 Jul 2026 17:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654118;
	bh=67ICudUq7MWt/+q9fIYuVJU826w0hYu+MIAHcAqhEc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JUMSElxt2rmzAq/LcoIQLqpRjSYjsAnw3VjHE0L2sGDOCnUL8WNrb6NDLxHfBp2Mw
	 euyfnqRrihw02eSu5qseLCsUsKpR70b7eVpDaJaP7NTUNH8idfW6r9bgH9rOr9iWIW
	 UiuhYFHAFIlTyyV/XzjTDFTU72RahcWnu1+golSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.1 1585/2077] fbdev: i740fb: fix potential memory leak in i740fb_probe()
Date: Tue, 21 Jul 2026 17:20:58 +0200
Message-ID: <20260721152630.157795121@linuxfoundation.org>
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


