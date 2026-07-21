Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE893DDB03;
	Tue, 21 Jul 2026 22:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674164; cv=none; b=XhG4XsfxYEEhLST4OK7e05HMBTQgjgSG0HqUnQMw6kmYhpgyNQbNZqS+kornCb8C2LZDZEFL45pypHxvz7+nnLpXxBqteOZk1vMs2mtFs0Ne0T5sk/Wc/O+4/IncheMFx3tbtovOd6sazxKcWfnH5N8aWBYoLjhY6PvxOBtm0hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674164; c=relaxed/simple;
	bh=GAuLkphKCpr19saeaPFt/hvwZSNoc2mrWXKIU8OF3OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZfGlkawB/Sy8qoCczf0AMRYv95H1E+0fjI+4myTa3gTM+g/sqzrYyDn5JRMEsjnQDN1LEU74MHQQhivfCrIuPDO7gPJDqmt7uNHOvIEuOUl5QlxB23VW0N2MJJbN3cPofHehKiwZjxGZCKkighXlyF+tIu+3XibpSRtslCoSQSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W/nSk5NA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W/nSk5NA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39FEF1F00A3A;
	Tue, 21 Jul 2026 22:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674162;
	bh=iI4QkuoNVPvGoINwYw/55zl+cS1gkg13djrk8N9H8Ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W/nSk5NAbAbH5mCsGOVQPD/V7Z98BVqkRQ0SmrEYXCZ4ieM7acJe8mxqrtxNBaBFk
	 7FNRLoTTP/vo8N6r/goAh7bOSsr91ApKXVp8IxbWNJd/+QxBdh9ZHqCzGdSs47OquM
	 c3kDXnKG7+EQLE34M0ACr+BxPBcn8cfIMGMVZzf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 436/699] fbdev: radeon: fix potential memory leak in radeonfb_pci_register()
Date: Tue, 21 Jul 2026 17:23:15 +0200
Message-ID: <20260721152405.530706670@linuxfoundation.org>
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

commit df8c1101c9a08859da612b5d0a08d55d475522c6 upstream.

The function radeonfb_pci_register() allocates memory for modelist
(by calling radeon_check_modes() which calls fb_add_videomode()).
The memory is appended to info->modelist, but is not freed in subsequent
error paths. Fix this by calling fb_destroy_modelist().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/aty/radeon_base.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/fbdev/aty/radeon_base.c
+++ b/drivers/video/fbdev/aty/radeon_base.c
@@ -2492,6 +2492,7 @@ static int radeonfb_pci_register(struct
 	return 0;
 err_unmap_fb:
 	iounmap(rinfo->fb_base);
+	fb_destroy_modelist(&info->modelist);
 err_unmap_rom:
 	kfree(rinfo->mon1_EDID);
 	kfree(rinfo->mon2_EDID);


