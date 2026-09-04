Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BD940F754;
	Fri,  4 Sep 2026 06:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502880; cv=none; b=Zcrw5boUvvNcdSs3mlJCU6mL939Fcm0BQ0sFUvENX3M31NAVh4Cj/CbNn/ZJS+LdPGXBbhgiNsNNWKvIk176pCMzHDwrcFhsmpc9xS1cE3GCVRYoF/J1gLbKjxgIqmSBrqnlJF8uUqxUW1FBbkhpHSkEVtFzEf5Eu4XkaDm6JYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502880; c=relaxed/simple;
	bh=Sbn/IrO3bs5a15HaU+voKIjv6h5d5Libuypw895G+V4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bg6PlJWR8sOvjBL/RsAJi2T9LmlehtTi9xXMzmel6FEGDZlcprknkjhH2qewfJZmMk559P0nrYyONBx6B8C/Yjo4/dr0ggYfUDpU4JDXOig41B1Aksg4LpfIE9IicWIJ/fX2MZmrFVsntXkS+KdUAdxTbzPhnHC3zV4x3SNxHjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y6GUOCE4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y6GUOCE4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C3E1F00A3D;
	Fri,  4 Sep 2026 06:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502879;
	bh=NGbabwNwPUwyL7F5Q5cwWjDwaiF/RM1X3RyfW5A1EL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y6GUOCE4DKXnOKpkK7Aw0aupSHCb1YZsyDpi0TD6SXx2qlKWI5T4EIyyP/hUmxDlx
	 LlK1qsgtriLiatdulDFOEZHW+435V9Ff1YbPCK3cUQY90JLoClIWgIzx2C5ViZSh8j
	 XBXPPjLrDYGdk5yHj0NBgjxU87Kj47rjaIuf+3LY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.12 360/403] mfd: sm501: Fix potential memory leaks during remove
Date: Fri,  4 Sep 2026 07:02:43 +0200
Message-ID: <20260904045742.998073456@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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
@@ -1667,6 +1667,7 @@ static void sm501_pci_remove(struct pci_
 	release_mem_region(sm->io_res->start, 0x100);
 
 	pci_disable_device(dev);
+	kfree(sm);
 }
 
 static void sm501_plat_remove(struct platform_device *dev)
@@ -1677,6 +1678,7 @@ static void sm501_plat_remove(struct pla
 	iounmap(sm->regs);
 
 	release_mem_region(sm->io_res->start, 0x100);
+	kfree(sm);
 }
 
 static const struct pci_device_id sm501_pci_tbl[] = {


