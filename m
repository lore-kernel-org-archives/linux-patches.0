Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A442F37B036;
	Sat, 12 Sep 2026 10:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207656; cv=none; b=dDH5w5yEw4b1rYd2e3EFqieX3UK5heJiBNMxOJaafB90xkYAs9o6+TYR+PSnvOoz9dhw1czYpumotQvtK996hD87Rry7cTpBn4J9WO5YGhsAaVCYvW3ClfYkLmezPjQTRCsuU9hKzGZzNjqaFuRi42tXE+EhClE1fM14YJ9Crss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207656; c=relaxed/simple;
	bh=MjKGc7qr87a2tw8jD0nbpsccC9ki/uX51H9KMR5W1cE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZYsVNAvw8xkb3PAILUCBZqAhD7B/GhZOldTtlpNYQMAypiRN6uNoZGwNn4h+AC6cRre9xUPCdqFGAVTNFZwIqpRicraPFcaN06YrLCkTYYCvUmOoEIleQOMQBknlOfTCuUFgtRuz1yOVTbOmoWGJujnpmLjyQeBEmNslnTHx0nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NS9dEAiH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NS9dEAiH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B781F000FF;
	Sat, 12 Sep 2026 10:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207655;
	bh=qP+OjVud4pCEv2pUS6MiFKPuj9dMae8crHINsb24PpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NS9dEAiHJSTozbgUOKB+doA+uRt1+ZCzDSnvmc17/UzDFNxu2cpL2eIliiKpSZY//
	 l9mKWP1cZ+zq2bwVlTvMok9rDZIZWEfwsdslOswwkHa4IXfZesvsG+EcbeHseQAREo
	 z5bihmTHpf6TgoV7li2NjRyW+8/5SDpV7fAp/kCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0455/1518] misc: lan966x_pci: depopulate children on populate failure
Date: Sat, 12 Sep 2026 08:43:44 +0200
Message-ID: <20260912065633.743198194@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit f6e2ed54db95286d9512b1cff38264e2f6299814 ]

lan966x_pci_probe() applies a device-tree overlay and then populates
platform children from the overlaid node. If
of_platform_default_populate() creates some children and then fails, the
current error path only unloads the overlay.

Depopulate the children before unloading the overlay on that failure
path, matching the remove path order.

Fixes: 185686beb464 ("misc: Add support for LAN966x PCI device")
Reviewed-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260623015248.22721-1-pengpeng@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/lan966x_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/lan966x_pci.c b/drivers/misc/lan966x_pci.c
index 9c79b58137e52..f6e358389af77 100644
--- a/drivers/misc/lan966x_pci.c
+++ b/drivers/misc/lan966x_pci.c
@@ -183,6 +183,7 @@ static int lan966x_pci_probe(struct pci_dev *pdev, const struct pci_device_id *i
 	return 0;
 
 err_unload_overlay:
+	of_platform_depopulate(dev);
 	lan966x_pci_unload_overlay(data);
 	return ret;
 }
-- 
2.53.0



