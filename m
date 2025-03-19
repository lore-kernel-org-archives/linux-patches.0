Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C5B1DEFD8;
	Wed, 19 Mar 2025 14:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394989; cv=none; b=dBWdlyKcJNuDzDeAL3ITM4SamCq8XPqOQN4R+onEkWO+40jaGDrQ62tkwgwI2GqcueEjbWZBzelDdm9VrXSfzJ4LJpuEK1jyM7QoVoqnvf28erIlqZSVM/O7IJC+pUFT/ZOF/6xfJkCYpghGzb568U2yZB56ksRBbjc3N/mAhek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394989; c=relaxed/simple;
	bh=oyBET26Uhyd/dQy4PEPX48X+OlwnwBLjhytLMb+Fc+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iyl6pxiIo/GrkgWek44H0VSa+GF1eKhmolCWOojZ1KDXpoFZ/X73zpHL89b9VE7kldlwpOz+aLKC8sJ/QulSCIiWwPaKx9pzr2mZ+oQ6GZGIEUCqaaiCTKGEYpClssFmWSq7OS0DdOT5t3OSK2Iq7BM56+euGttJ3hmRi97zrWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nvb5wj6K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nvb5wj6K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E83EC4CEEE;
	Wed, 19 Mar 2025 14:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394989;
	bh=oyBET26Uhyd/dQy4PEPX48X+OlwnwBLjhytLMb+Fc+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nvb5wj6KhDhxKyBEeq7Z3qzScPD6HcC4mfjfLeiN0G7Wio1i3gCuAwy2PL3TCVP2D
	 kL9yNzncLVGXLF+87YCB/Q5Q0cftBKY+STW27YjFnxYTS/aaGuQAgy7j9D4SDcFHt1
	 og2Kvg3lBqzD3TbNFA6U0WcpobuIDpdYd23COO+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 230/241] i2c: ali15x3: Fix an error handling path in ali15x3_probe()
Date: Wed, 19 Mar 2025 07:31:40 -0700
Message-ID: <20250319143033.431672404@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 6e55caaf30c88209d097e575a169b1dface1ab69 ]

If i2c_add_adapter() fails, the request_region() call in ali15x3_setup()
must be undone by a corresponding release_region() call, as done in the
remove function.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/9b2090cbcc02659f425188ea05f2e02745c4e67b.1741031878.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-ali15x3.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-ali15x3.c b/drivers/i2c/busses/i2c-ali15x3.c
index 4761c72081022..418d11266671e 100644
--- a/drivers/i2c/busses/i2c-ali15x3.c
+++ b/drivers/i2c/busses/i2c-ali15x3.c
@@ -472,6 +472,8 @@ MODULE_DEVICE_TABLE (pci, ali15x3_ids);
 
 static int ali15x3_probe(struct pci_dev *dev, const struct pci_device_id *id)
 {
+	int ret;
+
 	if (ali15x3_setup(dev)) {
 		dev_err(&dev->dev,
 			"ALI15X3 not detected, module not inserted.\n");
@@ -483,7 +485,15 @@ static int ali15x3_probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 	snprintf(ali15x3_adapter.name, sizeof(ali15x3_adapter.name),
 		"SMBus ALI15X3 adapter at %04x", ali15x3_smba);
-	return i2c_add_adapter(&ali15x3_adapter);
+	ret = i2c_add_adapter(&ali15x3_adapter);
+	if (ret)
+		goto release_region;
+
+	return 0;
+
+release_region:
+	release_region(ali15x3_smba, ALI15X3_SMB_IOSIZE);
+	return ret;
 }
 
 static void ali15x3_remove(struct pci_dev *dev)
-- 
2.39.5



