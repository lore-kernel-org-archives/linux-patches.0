Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999CB410D36;
	Fri,  4 Sep 2026 06:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501804; cv=none; b=BgNjDrsCVC/ae+Geeb/Vup39oezx1emQHONOkAoGo5JNwai1IZlrxrboCM6THBmSGbhDjqAhjOfpWby1iFVFEDzgkDwGbWSpsfoUvFZaJsL0OwVwe4Yccl+9TDQmJmb5u1G/Gz8xe6R77yOPhP+yVGTmXx1pBbW0PpWnr3Y8p3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501804; c=relaxed/simple;
	bh=y9hCQuZ9zZRqCaSZ7XPh1Dax44u78dl3zHZSZsENRZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S6pRWAU9MtD0q1AhUmZPBk48861CIu150UCCvNOJKnCuxpb34OOjN+GYeZkWumm/nPt5zyfa1rmO+xS7S5sdfuvoIvRLSsiLuCS3iENpKKaz5kH0RucwYO8KXvPMMsZE0qbjATj56d70EzPUTqlDuOh/xHdugjoLmnzi1HJUBrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PMWrSlLS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PMWrSlLS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F200C1F00A3D;
	Fri,  4 Sep 2026 06:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501803;
	bh=4Pyrqr6QpcKgxXLtFR87rcyrezgL52n5gzkMlSSpwcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PMWrSlLSXoBUtFQ8PRbXZdO3wA+Tt/XEvt77I5fQ5Yo+AMahgaDFuz71j1s2eaf0b
	 FxEg3fs7FnP7S2fZwO5GuDoaOY6tmrojE0o+buI3XadyImet/R+SiS54w2C+h7MC1i
	 erzNLQiHxgbn/OMHqCe/MrZfDMYea3RHbzXxwu3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.18 485/552] mfd: sm501: Fix potential memory leaks during remove
Date: Fri,  4 Sep 2026 07:00:42 +0200
Message-ID: <20260904045801.666606279@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

commit 83feedd9d83c0c5199f98c72df0a6196b4aefb4d upstream.

The memory allocated for struct sm501_devdata in sm501_pci_probe() and
sm501_plat_probe() is not freed by the corresponding remove functions
sm501_pci_remove() and sm501_plat_remove(). Fix that by adding a call to
kfree().

Fixes: b6d6454fdb66 ("[PATCH] mfd: SM501 core driver")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Link: https://patch.msgid.link/20260720113836.73133-1-nihaal@cse.iitm.ac.in
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/sm501.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -1627,6 +1627,7 @@ static void sm501_pci_remove(struct pci_
 	release_mem_region(sm->io_res->start, 0x100);
 
 	pci_disable_device(dev);
+	kfree(sm);
 }
 
 static void sm501_plat_remove(struct platform_device *dev)
@@ -1637,6 +1638,7 @@ static void sm501_plat_remove(struct pla
 	iounmap(sm->regs);
 
 	release_mem_region(sm->io_res->start, 0x100);
+	kfree(sm);
 }
 
 static const struct pci_device_id sm501_pci_tbl[] = {


