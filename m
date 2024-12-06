Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0886D1465AB;
	Fri,  6 Dec 2024 15:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498665; cv=none; b=KkdJd4kp0OPCs1hRmtTxVSJ4IrQqZ68K4K3i6mPHLiNK2Y5MnZ+3Gn+amg70hIpVTU2imDSTK7EfBKeO+HPX08lKiJlaNORBlKHWXWcNM9H82TepPyhFh8pQCRcKvdd191XtrsR5b5LfqCGi5OM6YFvlmXiKttgi4z/jfvvqRfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498665; c=relaxed/simple;
	bh=TdxCD/ciqSl2Yg9sgFTIc5t/b/11u3vcOte/nmLEh6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lj8bHYSU5sjSufuKzjIuLMBs6LjHljeqZNS1IkgtlmrcqBwseE+o2V7CYzDb+i00r9jPmq9bonErm0UEnbzPkp498ogf0fEMXQWPx7YxcfjL5dDWjgbbvaO7SovTwKEIMqeZ0pJsJ5ZhW2kYx6BtZJ65D5Nwkzn4X7PO9uR/wxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aR/goTnH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aR/goTnH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B35FC4CED1;
	Fri,  6 Dec 2024 15:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498664;
	bh=TdxCD/ciqSl2Yg9sgFTIc5t/b/11u3vcOte/nmLEh6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aR/goTnHjy5IDArXJU8KRA4ow1lC05nxSDfFotUAsZOZ8bF7DsoDa3HJjqOe564zP
	 EUybiRio6vbX1tvK1xU3BDDWX1REk2qaoIUVsJ+Ui1X5VPf8KKQAR7dEulttZyEyUn
	 0zMrvFGKih759pwPzWOqaONHKOwXpH7C+MkVkLew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 650/676] leds: flash: mt6360: Fix device_for_each_child_node() refcounting in error paths
Date: Fri,  6 Dec 2024 15:37:49 +0100
Message-ID: <20241206143718.758836450@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -774,7 +774,6 @@ static void mt6360_v4l2_flash_release(st
 static int mt6360_led_probe(struct platform_device *pdev)
 {
 	struct mt6360_priv *priv;
-	struct fwnode_handle *child;
 	size_t count;
 	int i = 0, ret;
 
@@ -801,7 +800,7 @@ static int mt6360_led_probe(struct platf
 		return -ENODEV;
 	}
 
-	device_for_each_child_node(&pdev->dev, child) {
+	device_for_each_child_node_scoped(&pdev->dev, child) {
 		struct mt6360_led *led = priv->leds + i;
 		struct led_init_data init_data = { .fwnode = child, };
 		u32 reg, led_color;


