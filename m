Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCD445DF61;
	Tue, 21 Jul 2026 22:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672300; cv=none; b=NgTrKSVcs6hH0c85IsTWLoeD7g76Oly8ClsNFcsglwt4v7BdzT/hxGS1gHESjHe/R09d3846J4k6o69VtRuTih6+7iZR5H/g5/hnlIQbasILhzmTz1ZFcA806C1ShewCs4ygW4MrzM3bhJK2nkfldQPdySyDfOL7YkNaNN3Swpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672300; c=relaxed/simple;
	bh=58Kdckoi0vnWVZr/Sx4GTWj7dMaVp+QmeepT9OWupFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJsmqfUpMncaUFSmDiXXaXYidAZrlJs2KJI/aUxYLI1i1SMf746F0lkhip83fD9E2hnSaJqecib1w42RGBPODNiPYmFW2vjkTBU5PmUKn7JbKlEinZ0qvQkVKq9AMMhmEWQ6JfV3FR6p7R+wkjSIryKG/wmLqaD98AJoTD6Mdsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VDPU1uC4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VDPU1uC4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF7D1F000E9;
	Tue, 21 Jul 2026 22:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672298;
	bh=mgJT/ZbDDLHh/QMCPtSvJqG4Rihur4r2dedsuf9LnBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VDPU1uC4CXOC2FGxlGnTikLRUsVvnI8KJx9TgsTHHjkUCxo+Pi4jV1BDXAmmiFWgF
	 wqvcxMSmpCpJReeb7WjvMQ9qhaF8s57N5dWTmVt/gd59LMg4q3S4kng0U7A4o8chPA
	 ABOSk5GYXRFxnaMiuVdY/2sBs22XMa6y7klehvOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 571/843] fbdev: tridentfb: fix potential memory leak in trident_pci_probe()
Date: Tue, 21 Jul 2026 17:23:26 +0200
Message-ID: <20260721152418.890046989@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1702,6 +1702,7 @@ static int trident_pci_probe(struct pci_
 	return 0;
 
 out_unmap2:
+	fb_destroy_modelist(&info->modelist);
 	if (default_par->ddc_registered)
 		i2c_del_adapter(&default_par->ddc_adapter);
 	kfree(info->pixmap.addr);


