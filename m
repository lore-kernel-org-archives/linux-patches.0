Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1910F43F4AD;
	Tue, 21 Jul 2026 21:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669912; cv=none; b=YqKGd4+XK1Z6F2fzEzL9nNyHSTxGopUGEzotaLIGNoG43aOERis4Buq83Q1qxX+KrfekyxoUQOWijRwgeqkAAKMqd7O42uJycpKwFpoywQollhEJ8kCq+NvF7KvB8pWId0Qph3wl4GVeNtrTKN74U89vCeZAgoF79QIlWlr3j6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669912; c=relaxed/simple;
	bh=BVOXX0XZ28GX6t0O1fzmQ6VOIU30wmm2/ikbNiHnJ3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TC7FBzTpu0M0kwFWXKOXyn1I/DD2KHQUjw/tpEMP0m2s5OaqBtNhZh0luPsKyJm0KnMHuGbUcm/aPIu9XF7eGH0q1lNTmRlMZkNDZfAQY/rWnRHa9Do6QhUaMRNamOFxTpaB3IrtCspqcvEQUAesp1kG9PyIwsP9d2PWi4r/rYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cAmUkSew; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cAmUkSew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE111F00A3A;
	Tue, 21 Jul 2026 21:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669910;
	bh=Sj1WsaCl9zgYmFPDS/8zZ8Q9AUTxtxZyQQta+K/OA1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cAmUkSewrW05rrE6+GNvvU84B9pLI4Gm8K75mTBXKfXtLW6DnBaAtdVZIzTddTIks
	 CdyfH79hEtsgJuZfhDht8lm4TuZKl+tfTLaqkFDGAfvb7yl0guFDoKnKigaEjZ8DxX
	 3ye7XZF3dJBObeOVhrh5Rj0+yP/HIKbBYSDxs3Bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 0732/1067] fbdev: radeon: fix potential memory leak in radeonfb_pci_register()
Date: Tue, 21 Jul 2026 17:22:13 +0200
Message-ID: <20260721152440.960509189@linuxfoundation.org>
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
@@ -2475,6 +2475,7 @@ static int radeonfb_pci_register(struct
 	return 0;
 err_unmap_fb:
 	iounmap(rinfo->fb_base);
+	fb_destroy_modelist(&info->modelist);
 err_unmap_rom:
 	kfree(rinfo->mon1_EDID);
 	kfree(rinfo->mon2_EDID);


