Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DB61474A9;
	Fri,  6 Dec 2024 14:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496230; cv=none; b=enxrnVCulFi8B/hdOhbnkZT3ISlj1fEz/T2WZ2lYJbLhgvO/G7f7vDZkhFiFNbBd0gztgbh3TuBSOOVo3ztgxgGDKOH5Ff30JgzssqWCERDrmYCccFkMukCLM+r43tAo1RFcXVv48KFCvYu+BUESEkNh9SqWj1bBEzN4tJ4XMHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496230; c=relaxed/simple;
	bh=XZdQDbv00LXqjSH8GSWuwg2p6isgrCJNWZbhnpeEgkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dgOeh2E/zEiJZcBNv+1Vh6vvyN04yg2TxgceLqEIpK+pd+epXQOPjqxBIp8kR0lP08el2uiDoA+CxrMsNRPXaUEVzzOq9T86CylI28e9RlFYS1OXSO33Q5g6z2OVoI1NLolwNpAEvgEwvVuVRFiCEcoYPFEpf6Vku8QGIxnzcp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ib3K1+zH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ib3K1+zH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28416C4CED1;
	Fri,  6 Dec 2024 14:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496230;
	bh=XZdQDbv00LXqjSH8GSWuwg2p6isgrCJNWZbhnpeEgkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ib3K1+zHmPHzYX1//xqi8QnJSJqAtMQNUVptgaw47YKYnmG3p6Z/W04g9PmdlnxWt
	 I/B1bqf7oE6ysNQf3ma1vGoN6/hAeDDYdk9XpH3fe9phMWw5wz9ijBFlA8UovKpFF7
	 +8M2wXQxnMnjMvv8HOgRJAQ5vqVJ63+82eno7pNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.12 091/146] leds: flash: mt6360: Fix device_for_each_child_node() refcounting in error paths
Date: Fri,  6 Dec 2024 15:37:02 +0100
Message-ID: <20241206143531.159974370@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 73b03b27736e440e3009fe1319cbc82d2cd1290c upstream.

The device_for_each_child_node() macro requires explicit calls to
fwnode_handle_put() upon early exits to avoid memory leaks, and in
this case the error paths are handled after jumping to
'out_flash_realease', which misses that required call to
to decrement the refcount of the child node.

A more elegant and robust solution is using the scoped variant of the
loop, which automatically handles such early exits.

Fix the child node refcounting in the error paths by using
device_for_each_child_node_scoped().

Cc: stable@vger.kernel.org
Fixes: 679f8652064b ("leds: Add mt6360 driver")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://lore.kernel.org/r/20240927-leds_device_for_each_child_node_scoped-v1-1-95c0614b38c8@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/flash/leds-mt6360.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/leds/flash/leds-mt6360.c
+++ b/drivers/leds/flash/leds-mt6360.c
@@ -784,7 +784,6 @@ static void mt6360_v4l2_flash_release(st
 static int mt6360_led_probe(struct platform_device *pdev)
 {
 	struct mt6360_priv *priv;
-	struct fwnode_handle *child;
 	size_t count;
 	int i = 0, ret;
 
@@ -811,7 +810,7 @@ static int mt6360_led_probe(struct platf
 		return -ENODEV;
 	}
 
-	device_for_each_child_node(&pdev->dev, child) {
+	device_for_each_child_node_scoped(&pdev->dev, child) {
 		struct mt6360_led *led = priv->leds + i;
 		struct led_init_data init_data = { .fwnode = child, };
 		u32 reg, led_color;


