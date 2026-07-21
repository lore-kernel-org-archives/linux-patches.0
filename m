Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE7B415F10;
	Tue, 21 Jul 2026 22:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674251; cv=none; b=WuloHKK2FnxNUEXlk8iegD0sUhHm7srwmsKoHeEvT5bcw6ICTuUzSKry5VUQXxiQT85eHrzb97lsLnmcUM8QwNSJpNC3d58nrXN8Ag7e+/7yTuZM0NPJk9ZextZ1zyxYB8yfNleKW/6djqd/jhow8vVwPNTusiBzpU02JGJwMrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674251; c=relaxed/simple;
	bh=P95tZsWjILsIgfPS3wFTbSHE6bsM313URwehP3QGxDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VqG0/8s5sbrvZfWh7uCv0YWOgob2AZFoMpFXfaNcom/gj7R5umfHDdpb00ilgoo3X0NjDcumaJfPuJTiNEFiUv5UJXN+RvZ/PAphdP46c/LdWU6+1sCszz7MgdC2hC7ruvDn6EuIQ6Q58Gtsts/qcxsePQqg/eL3/pPkhnhAg8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q6czLJ9q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q6czLJ9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3B21F000E9;
	Tue, 21 Jul 2026 22:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674250;
	bh=24k/fI6sCT3iISezxYmO4bQS8FDu3HWyEqKdX917Y1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q6czLJ9qs6w3myVVbo3mh/hJFjD2tu1fQ9jBzUy7W8tP/DIpHlu8GQheWkOIA/9iK
	 cA7PTArwaQaTmaWdVmFkNLND/CSWtTzbdyT7HyIYCHjScG3mnHlhJCwaHA36AaBCXB
	 90yxxLD2sSYA+OEJVVEYdaz0CAVrV12HGC8CSZ+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.10 470/699] mfd: tps6586x: Fix OF node refcount
Date: Tue, 21 Jul 2026 17:23:49 +0200
Message-ID: <20260721152406.298832399@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit 3001ed2b4e06da2276c42ace6551617065a5b1f9 upstream.

Platform devices created with platform_device_alloc() call
platform_device_release() when the last reference to the device's
kobject is dropped. This function calls of_node_put() unconditionally.
This works fine for devices created with platform_device_register_full()
but users of the split approach (platform_device_alloc() +
platform_device_add()) must bump the reference of the of_node they
assign manually. Add the missing call to of_node_get().

Cc: stable@vger.kernel.org
Fixes: 62f6b0879304 ("tps6586x: Add device tree support")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260521-pdev-fwnode-ref-v1-1-88c324a1b8d2@oss.qualcomm.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/tps6586x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -399,7 +399,7 @@ static int tps6586x_add_subdevs(struct t
 
 		pdev->dev.parent = tps6586x->dev;
 		pdev->dev.platform_data = subdev->platform_data;
-		pdev->dev.of_node = subdev->of_node;
+		pdev->dev.of_node = of_node_get(subdev->of_node);
 
 		ret = platform_device_add(pdev);
 		if (ret) {


