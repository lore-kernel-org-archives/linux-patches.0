Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA73047013F;
	Sat, 12 Sep 2026 10:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210783; cv=none; b=GE5ytDw3Y1HbDZpqa3rSVFTDtBc32XIr681pdWLM3aKeMWe4IwlahkXCB7jFsoSWQnmTItyfr5ptioDyarZzimsHVYdKky6n4h4Gky/LDHQmFvlEplaqHt4beMULcN3ZOWSLSZ2YSvIflIau5JrxDGeeWuW4Ple3VKKieBGXe9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210783; c=relaxed/simple;
	bh=epX0L/Aa71ftrcn03h4CWf/2Y0iFau4Qsy4RskN6sTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=seSRmbl5nqEBieTrTYZZtpwMmXJRC8afqiLAnZcaGp83KTJtGJckB5mc7VjwFd/VvMpt73uMSblWL8gle5TOCSB7b64S7LPt67VDnwZLci/9aE1z7vsRJyyoExTT4MzkC/373fWBMpcbC5soy5d2fHDdxCUXKwqR1dNRHVnFlQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EWOvtCct; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EWOvtCct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E66D1F00898;
	Sat, 12 Sep 2026 10:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210779;
	bh=RXSzMVh5OMwDyXx1vtHWo7Z+3PpgWpO1TmaDPqF3x5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EWOvtCct0e2xzDievtH4/T9uU63WQy624b8RnIqsNPPRoNsSHK6IjstF+V7jw5UN5
	 R+cfZ049gTMYo1bi6ODX82pOo9+6ZU0bMlgR8wAFoFsm44g9C5PAaJ+pA1cTebHRBk
	 V2mhV/a4vMx24Y5Cg14jLhJqv7WyLDXiEyg6tZxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1059/1518] fbdev: tdfxfb: fix PCI enable cleanup with pcim_enable_device()
Date: Sat, 12 Sep 2026 08:53:48 +0200
Message-ID: <20260912065647.407511691@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 95a627143a696f70e17be5ed3b1e733bb6724b46 ]

tdfxfb_probe() enables the PCI device with pci_enable_device(), but
several failure paths after that point return without disabling it. The
framebuffer_alloc() failure path returns -ENOMEM directly, and the later
shared out_err path releases the framebuffer and returns -ENXIO without
balancing the PCI enable state.

The successful probe path has the same imbalance because tdfxfb_remove()
releases the framebuffer, mappings and regions, but never calls
pci_disable_device().

Use pcim_enable_device() so the PCI device is disabled automatically on
probe failure and driver detach.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/tdfxfb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/tdfxfb.c b/drivers/video/fbdev/tdfxfb.c
index c5095358209e1..eb8f33ae94e77 100644
--- a/drivers/video/fbdev/tdfxfb.c
+++ b/drivers/video/fbdev/tdfxfb.c
@@ -1383,7 +1383,7 @@ static int tdfxfb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		return err;
 
-	err = pci_enable_device(pdev);
+	err = pcim_enable_device(pdev);
 	if (err) {
 		printk(KERN_ERR "tdfxfb: Can't enable pdev: %d\n", err);
 		return err;
-- 
2.53.0



