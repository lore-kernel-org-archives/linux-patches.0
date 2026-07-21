Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620B440587A;
	Tue, 21 Jul 2026 18:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658472; cv=none; b=SXQn+aj/n73D3y66IdvPwQK9qgYkbZ2DJ98aQEKG9BPd7rtAN13pYXOVpZMF3M9VqLs5G8mbj5MAqDFx9If4j6siv6xItLCEo7zkc5EAN/tvxVnH+OqlV45dAid3U7F0zlyZJuThkaJZEqb/+POiccceO87ZGelTYKL5q6mzwK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658472; c=relaxed/simple;
	bh=IFKCL/6kWBoNoKP9+48VwXw7uvMkEN/aGdcTbAXLq+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6UHwYcL924CoW7YnYSAnD8aMqqYMLkCQUkpQmbKqwe9K95rg1pQFxxBAb3NsiR2OGU3HECihwfF94298QtjJqrYQ61jAteAtpc3IUv4JLGTEfu6/3SjZo3vFvJndHYcKKsdOCzf5qxQzOYqwEY07lR0u2KeADCQl4qhHZb7K8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=It4JO6lt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="It4JO6lt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74E11F00A3A;
	Tue, 21 Jul 2026 18:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658471;
	bh=kLfUIdKPNIwj8pYli3rLyPxFLY4opPBUhgF30S+PqGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=It4JO6ltTqJGy0Ip54kJd50EDxcOjScqmUyBNcj8bWe3IaG6a9J48tvFToun/zRS1
	 el+MTORFbamKtP3q9gJfJtmgDYRoVlaueVgODQkaSh9l1AIlm3e183Ns07X0hDc7Tn
	 /U7XPZiJAXrBB3x/FD4ftS5SUlOY6TClsGwGUoIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 1154/1611] fbdev: carminefb: fix potential memory leak in alloc_carmine_fb()
Date: Tue, 21 Jul 2026 17:21:10 +0200
Message-ID: <20260721152541.379095707@linuxfoundation.org>
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

commit 6fcca16a2b19c37f60693c56cbc0c923364ff3ef upstream.

The memory allocated for modelist in fb_videomode_to_modelist() is not
freed in the subsequent error path.
Fix that by calling fb_destroy_modelist()

Fixes: 2ece5f43b041 ("fbdev: add the carmine FB driver")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/carminefb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/fbdev/carminefb.c
+++ b/drivers/video/fbdev/carminefb.c
@@ -589,6 +589,7 @@ static int alloc_carmine_fb(void __iomem
 	return 0;
 
 err_dealloc_cmap:
+	fb_destroy_modelist(&info->modelist);
 	fb_dealloc_cmap(&info->cmap);
 err_free_fb:
 	framebuffer_release(info);


