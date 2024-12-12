Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4847E216E2D;
	Thu, 12 Dec 2024 16:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021015; cv=none; b=fmXveS4v+imqiFscSGGDu6CGCemqnxCBKeP5DfmY5jih1X+ZnGBLeuDqMVcInaCkT19C2fnX/X5twLauB5DztQ7IJHVOYqH4Ag4xwI8U/775g2/sFYX+BwwLuG0KsKt/bYX84gzqHiEK4O50gtuVJtaAU2A8s3UneW44gZt5K+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021015; c=relaxed/simple;
	bh=cR4liVtNITZ15wBkoXPriSxvpBWbfdIrmLrxc9+SpYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QcdrsK1EQm2aNqGe6SYUrbj+NM5/x9n79P0NF9+oYXkX/sdCzf7rS9Yoc2T/yJ79PcNrB++OfjPy+QnvFzutXq4pGHVykhTcQ1iKhuiLBy3OIiDCHco3uPQsiabvxftd4kOIdQx4dQp30o9WolAUMZzDM1pZRthcrOk27dQszhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a4xJJR8j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a4xJJR8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57224C4CECE;
	Thu, 12 Dec 2024 16:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021014;
	bh=cR4liVtNITZ15wBkoXPriSxvpBWbfdIrmLrxc9+SpYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a4xJJR8juEmsmU4kFoqt7gjyUGsLyO/yLMXob1/OOk/mhGLHj5RR2h2cG/B3yahtY
	 vtG5lBCRK10kty4oYRmUdYq4ze5E2QxLtS8OQ44Qk8yR4VXO4ALUeJh1TLMfXIbsx0
	 AscLDFw/UVTqg4Omiu+/whdRRtHXRsLdTezhmDT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 582/772] leds: flash: mt6360: Fix device_for_each_child_node() refcounting in error paths
Date: Thu, 12 Dec 2024 15:58:47 +0100
Message-ID: <20241212144413.990703504@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit 73b03b27736e440e3009fe1319cbc82d2cd1290c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/flash/leds-mt6360.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/leds/flash/leds-mt6360.c b/drivers/leds/flash/leds-mt6360.c
index 2fab335a64252..71c1ddd71f8ea 100644
--- a/drivers/leds/flash/leds-mt6360.c
+++ b/drivers/leds/flash/leds-mt6360.c
@@ -797,7 +797,6 @@ static void mt6360_v4l2_flash_release(struct mt6360_priv *priv)
 static int mt6360_led_probe(struct platform_device *pdev)
 {
 	struct mt6360_priv *priv;
-	struct fwnode_handle *child;
 	size_t count;
 	int i = 0, ret;
 
@@ -824,7 +823,7 @@ static int mt6360_led_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	device_for_each_child_node(&pdev->dev, child) {
+	device_for_each_child_node_scoped(&pdev->dev, child) {
 		struct mt6360_led *led = priv->leds + i;
 		struct led_init_data init_data = { .fwnode = child, };
 		u32 reg, led_color;
-- 
2.43.0



