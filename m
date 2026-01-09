Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B4E359708;
	Fri,  9 Jan 2026 12:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960437; cv=none; b=fWGTGvwXZIvViGL+ZpzJHPf7mWnVN355gvMkCfo5qksy7o/GI1aa8GFaOWeVyb88GxNM34X2S3DJPge67lYKXOBexZpjyzWsdKVBqTuYid+9X+dEFcrNNI4MD8K5KX9SZVHMrRIJ5Wj6J1YsDA8WdOHsKV5768SRCxtqS/lubHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960437; c=relaxed/simple;
	bh=elZDWQWU/eNw0eJa0BkAhLtmxNY1OFuCq3jSpVuPP5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ukAyKl3/xy9FCZNVTeKTKHaJlXGDOUWtgQnKlElSKCVRH4QXhBHEm05LMzt9oGvSjhDrIAwpOaB8PCmuDlozkq6LGEvGfrMAGhUvTNpM3dSvRGM73FFj5A7yZ3gwqaFB4uGN/hZri2QWNBQy8h7WaCZ14g4fQzYvtHtEujXieD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YfvsrgNG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YfvsrgNG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4C4C4CEF1;
	Fri,  9 Jan 2026 12:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960437;
	bh=elZDWQWU/eNw0eJa0BkAhLtmxNY1OFuCq3jSpVuPP5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YfvsrgNG8YAUtLfZKhmM9Y+9IHKrauvxDbVOHUlpgQpo1Ap6m83VbptZRxX+UHFLu
	 CjQNYoIqGXCaod9M1ewksJd/bh9daED76f5aT1c7ST2SrCHc99Mlvc8TMMrtOXN3pa
	 s65PxDUeCty/F3fhUqfYK0QBFfemRkltqoScO8tI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenhua Lin <Wenhua.Lin@unisoc.com>,
	Cixi Geng <cixi.geng@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 404/737] serial: sprd: Return -EPROBE_DEFER when uart clock is not ready
Date: Fri,  9 Jan 2026 12:39:03 +0100
Message-ID: <20260109112149.196981072@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenhua Lin <Wenhua.Lin@unisoc.com>

[ Upstream commit 29e8a0c587e328ed458380a45d6028adf64d7487 ]

In sprd_clk_init(), when devm_clk_get() returns -EPROBE_DEFER
for either uart or source clock, we should propagate the
error instead of just warning and continuing with NULL clocks.

Currently the driver only emits a warning when clock acquisition
fails and proceeds with NULL clock pointers. This can lead to
issues later when the clocks are actually needed. More importantly,
when the clock provider is not ready yet and returns -EPROBE_DEFER,
we should return this error to allow deferred probing.

This change adds explicit checks for -EPROBE_DEFER after both:
1. devm_clk_get(uport->dev, uart)
2. devm_clk_get(uport->dev, source)

When -EPROBE_DEFER is encountered, the function now returns
-EPROBE_DEFER to let the driver framework retry probing
later when the clock dependencies are resolved.

Signed-off-by: Wenhua Lin <Wenhua.Lin@unisoc.com>
Link: https://patch.msgid.link/20251022030840.956589-1-Wenhua.Lin@unisoc.com
Reviewed-by: Cixi Geng <cixi.geng@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sprd_serial.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/tty/serial/sprd_serial.c b/drivers/tty/serial/sprd_serial.c
index f328fa57231f..c6d2258d719b 100644
--- a/drivers/tty/serial/sprd_serial.c
+++ b/drivers/tty/serial/sprd_serial.c
@@ -1111,6 +1111,9 @@ static int sprd_clk_init(struct uart_port *uport)
 
 	clk_uart = devm_clk_get(uport->dev, "uart");
 	if (IS_ERR(clk_uart)) {
+		if (PTR_ERR(clk_uart) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+
 		dev_warn(uport->dev, "uart%d can't get uart clock\n",
 			 uport->line);
 		clk_uart = NULL;
@@ -1118,6 +1121,9 @@ static int sprd_clk_init(struct uart_port *uport)
 
 	clk_parent = devm_clk_get(uport->dev, "source");
 	if (IS_ERR(clk_parent)) {
+		if (PTR_ERR(clk_parent) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+
 		dev_warn(uport->dev, "uart%d can't get source clock\n",
 			 uport->line);
 		clk_parent = NULL;
-- 
2.51.0



