Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216029;
	b=Dr6tZTwGVEaCRb/GFN+ZGhQf0Kvzx2PFcicetBd6I4iyAdxXUH4T36WYH17fcX3OMeRV
	 la8CdIy3JgrVb6zgigWwiJJwpMv292+WCBvdVdJCRf2XyKh2itv6nogpDZJRz90578r6N
	 XDiyARWe0uj+jzoqiKZ7qEAmgmYfqNIzR6Hij8LOCsupq4PL/LpytpvOyof3Im48H2Aif
	 AriCxUvpTiUUlt6tNNUHSsRgaDlzMu3duY1W6Ns7HwMFW+zDTAYPe1WetzEJNnkUQQUlY
	 GhmkPkozJTwpfeTnCU4d1NCvZGCBvETFJZc3timZsNVK4A5J9AAyQNtq1GOO7N+DvUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216029;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ea1+ROxpqcckK/O1PkgKn7EAD5X6Bz8XII22LAHQXHY=;
	b=xtwU7/nJDW4QLQ3KTGRPdGKQqMx1gm9aOjozY4ZiirCw/EBSqUk6EQmPaRCRQZ9Kb27R
	 M3Ytyh88wrsGdQe8mkjj+GzsXsS7Ttr9pZ5cB1S/Uh8d7IidUssqmQjeXJlXKLx5v7amd
	 MRvWsTUujEGm0wgsvkuH7+J0dshgTWjJFVzyWMsiH49UCwLs54KUnz0+FdHKekgG4URgW
	 hKV8uENBbGhZTpX0NDh481btoFEwNXdLnGWP9q2cP2jXRmanaICHGjjsp9ayGTJ/X6NWt
	 Lt/96JNeTbFN/Pp9FSKFJJ/qXwy4lTUFwVYpKidPYI9G1qgu09fTOf9/D6JE3/oFk/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ztIAVpMy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37360606A31C;
	Wed, 28 Oct 2026 19:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ztIAVpMy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854841F01825;
	Wed, 28 Oct 2026 19:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216029;
	bh=Ea1+ROxpqcckK/O1PkgKn7EAD5X6Bz8XII22LAHQXHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ztIAVpMycLApTpbZtDrwtZhApH7okGpAYZB75fHZ1JZ+gRtoSwLWd2srymAdI5MSh
	 ffxx/XDhSOqvhfeFWzS5LPCGg/+He1l/WVvLjvXAOKxr/nbtdaU5WluXnyKinmv+os
	 PZYUwfj8RiWZaKrmin3B44dCXOgA6JBWA6aSX7K0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1372/1887] mfd: sm501: Fix potential memory leaks during remove
Date: Wed, 28 Oct 2026 17:57:48 +0100
Message-ID: <20261028170530.673355858@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit 83feedd9d83c0c5199f98c72df0a6196b4aefb4d ]

The memory allocated for struct sm501_devdata in sm501_pci_probe() and
sm501_plat_probe() is not freed by the corresponding remove functions
sm501_pci_remove() and sm501_plat_remove(). Fix that by adding a call to
kfree().

Fixes: b6d6454fdb66 ("[PATCH] mfd: SM501 core driver")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Link: https://patch.msgid.link/20260720113836.73133-1-nihaal@cse.iitm.ac.in
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/sm501.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index 06e796883189e..5752099683eb4 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -1667,6 +1667,7 @@ static void sm501_pci_remove(struct pci_dev *dev)
 	release_mem_region(sm->io_res->start, 0x100);
 
 	pci_disable_device(dev);
+	kfree(sm);
 }
 
 static void sm501_plat_remove(struct platform_device *dev)
@@ -1677,6 +1678,7 @@ static void sm501_plat_remove(struct platform_device *dev)
 	iounmap(sm->regs);
 
 	release_mem_region(sm->io_res->start, 0x100);
+	kfree(sm);
 }
 
 static const struct pci_device_id sm501_pci_tbl[] = {
-- 
2.53.0



