Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE31C35DA67;
	Thu, 30 Jul 2026 15:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426130; cv=none; b=Xeu7i73bnDpKQxGcPhQdpfriU3VQZmy/D1FTNIRCJABpqrGX6aCxEueGmOs5WfC9krnPQJaij/ZhCPUK6pjL+HISAt3lltz4/6viwombb6pyTjKAS2CMCvPqrQeNJQWgKI/Yn3vVs3M5nUDsBB3hEXiSpZETus12GDDKl3AhzRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426130; c=relaxed/simple;
	bh=+M5Fbsl99lxio4b5j3YWSTyjv+Dd7bdXnp20k0mIzlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FlzXMJkw5oxFL4T8rsLW8oYIdL00GKyyycXiL9K2BgJLlO/IDDZdy+p+AVUKs0xD+AGxP1uyG1uZonnApuLshkydD/ngKh2A9RLDlhatBK+85sEPSlmIV2M+Ly1uyVxzROc9Yy/iaiUkJxOF1nnlh7BmQ2hBV//fH73Nqo8h09A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDQZ8eUq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDQZ8eUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027F91F000E9;
	Thu, 30 Jul 2026 15:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426129;
	bh=UTU+yTLIDf/6tstT3bZteCwBzuFTDEIBTUrIsTbsvi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LDQZ8eUqlq7SQ4S0ghmd+zyqFW78rrWIjgQHjPDQzjBAKYcB14iAEBx4cwStkTfWg
	 JbLqioIk/ABbGYkzQixNEoFtWHs1KIHL9MVmwOYN7VjVBlrwBilN6SSDVBF3hLWlzv
	 9pNlJJMMGpGg51Gf6ynGN59hhzFzU5SKvWI/t+xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 310/602] media: marvell-cam: fix missing pci_disable_device() on remove
Date: Thu, 30 Jul 2026 16:11:42 +0200
Message-ID: <20260730141442.482670320@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 033ff0420e4c9c240ae5523fff39770298efa964 upstream.

During manual code audit, we found that cafe_pci_probe() enables the
PCI device with pci_enable_device(), and its probe error path properly
calls pci_disable_device() on failure.

However, cafe_pci_remove() tears down the controller and frees the
driver data without disabling the PCI device, leaving the remove path
inconsistent with probe cleanup.

Add the missing pci_disable_device() call to cafe_pci_remove().

Fixes: abfa3df36c01 ("[media] marvell-cam: Separate out the Marvell camera core")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/marvell/cafe-driver.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/marvell/cafe-driver.c
+++ b/drivers/media/platform/marvell/cafe-driver.c
@@ -609,6 +609,7 @@ static void cafe_pci_remove(struct pci_d
 		return;
 	}
 	cafe_shutdown(cam);
+	pci_disable_device(pdev);
 	kfree(cam);
 }
 


