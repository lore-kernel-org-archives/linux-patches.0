Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C03846EC7B;
	Tue, 21 Jul 2026 19:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663513; cv=none; b=dQG447Ig54ogmIs3SqqjdAsDi/PDLe/08N8+teu9kd2PsA4YAdtohmAGT3YYDQNCYrG+uJBB+la6prGDMvND90ATyQTanvsMDk6khcfuXyuZ4m9fOIKpmcK2VsSnmjl9cmbc7H/1YZ6v5riZpqe2yM6wwAq0dqBw06P4HlcnLQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663513; c=relaxed/simple;
	bh=39BvAzz6lpUcKFNcMjEP1t31H7N/naaCe4/KRx1XVnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SklwtLd3guXTN5/pWGAxuY6u/GMDHBI1e1qk6UHMvVuapKBQwau3GyIQV11RHU+MNpetqfp0xtubXeZJbj/Fczdi9GUUmMrou7VuqpYgZApTmOdnFp+mus7ZJFvkwbxAVbk5GNDfC9qUwn9u/5nAw12RbRoNe/aXWENgDymM++s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hy8Ckw/E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hy8Ckw/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D001F000E9;
	Tue, 21 Jul 2026 19:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663512;
	bh=ZPiobn5Y7YdNLGcvQpjCdqCryMr3PRTXP4A+9ieXr7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hy8Ckw/EDRsBYARBEfTwm3PGaMKwxO41JtWPhRuOYzc0MZFWgSa4Q6ECdgebut4wU
	 kW91imKqSGqUzgi9gXvLHTstqH+ntYDDbxrzLSxwusxI56Cr2p9pBMLD63V22jIU8H
	 Tf7SiNk2fNTnB+G/djaW1vh4vY4F4eQuoT/zc9Ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 0851/1276] fbdev: tridentfb: fix potential memory leak in trident_pci_probe()
Date: Tue, 21 Jul 2026 17:21:34 +0200
Message-ID: <20260721152505.096229133@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


