Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C737543DA38;
	Tue, 21 Jul 2026 21:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669921; cv=none; b=MpLBLxFrCrpKmQz2bv35sSlVLnt1zCk/ZiFw4TsvwKu4fH68svm1XY0wKxdzImEv9fLekeMhQkNfS3sKqJk6G9oW1SYQMO9X3z7b43+Rk/TlplmQyQjk3uydf74fMQMg6sHo7/N1wyUiBC2Xg0cDVxhWHrx061FIN+ct60Mwuzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669921; c=relaxed/simple;
	bh=z16NDGsbnGEy3qS8Gfk5oMF1hzSAJ97Vi8dfkPVgD3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tau/sAD2jXbYYKJFQGyAn+Rsp8FIp12VmincxeA/rnlVcpEh42ZewFxILdizEuf27ZVbsj0AlD8ib/9aOoFHddVApjFB7zCSGwIuCrAoxvVQi2pYrJo+MXMhyJ7rZAPrNNZM3tuZ+SbH5CM27oiJYdq48BbQCeRdcabj/dKz8XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VfdlgmkK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VfdlgmkK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074551F000E9;
	Tue, 21 Jul 2026 21:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669920;
	bh=dslOH7dkz/JzLNgng7n/1Od8TW7xE5pUYNgjQLyytcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VfdlgmkKA9Em/EKrLcDibI1Z6tGmwEQ4eze97PQafES2hsDB9pQDR0tbxIUPa3bcr
	 rHxJnvkAjhKdZJakeIAsaT6OP+4hEaCbWu6lJp9r2PSBQ6QLGXIsG47YURGdyTbae1
	 BPoEXbKBODmMfCwAGkBlnIzpviKMyIuFsKmyR298=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 0736/1067] fbdev: tdfxfb: fix potential memory leak in tdfxfb_probe()
Date: Tue, 21 Jul 2026 17:22:17 +0200
Message-ID: <20260721152441.047997269@linuxfoundation.org>
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

commit bb019d755366cc3e777a12d4bf457ff289837370 upstream.

In tdfxfb_probe(), the memory allocated for modelist using
fb_videomode_to_modelist() when CONFIG_FB_3DFX_I2C is defined, is not
freed in the subsequent error paths.
Fix that by calling fb_destroy_modelist().

Fixes: 215059d2421f ("tdfxfb: make use of DDC information about connected monitor")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/tdfxfb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/fbdev/tdfxfb.c
+++ b/drivers/video/fbdev/tdfxfb.c
@@ -1551,6 +1551,7 @@ static int tdfxfb_probe(struct pci_dev *
 
 out_err_iobase:
 #ifdef CONFIG_FB_3DFX_I2C
+	fb_destroy_modelist(&info->modelist);
 	tdfxfb_delete_i2c_busses(default_par);
 #endif
 	arch_phys_wc_del(default_par->wc_cookie);


