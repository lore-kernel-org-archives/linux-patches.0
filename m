Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5644E3876A0;
	Fri,  7 Aug 2026 14:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113771; cv=none; b=Xyon4OevOd9W1frebBa5oNKcC0fhmBGJ89fjZty/vdRQDg5/A/fvSRqLTUUiCX5iElDLx1CeMAMUsiVQbYDT4/UB7RzKr/EyKL4epzMne4RkT6QnT5MI39BmN526OrILdDfNiEaVBD4iN/JTkbx1OyejO5/Al2hbBnOf0koNt04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113771; c=relaxed/simple;
	bh=swBjMgN8rFBm9MLLQWn12IbETLKLXCJ92ZpZlwCucX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UuldIoEElabe6qzcuLSiDQiORMpPQh1E+x0zVf+qX995GIkhE6Sn6Vg685YgIQ/IwAeGKJTZcOJHTKjiFF9GvojRhFLTXH9MHznYOiccDLE/ttbP6leN0pP4UofqYngTlsAT8cRzYfsmE9TFLXGhJf51YAHeNYWdA2udiEAwa/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=soS9MRCP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="soS9MRCP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA211F00ADF;
	Fri,  7 Aug 2026 14:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113756;
	bh=ZUGjHX6dMgAUsTDUyeU6JPsH3aEP1KFv9XT79TUIUuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=soS9MRCPDXgw3KB9IH2DKWAvfAov+eGbPTSCxXn61Cb0dLdUSAlDLeRmTGuGSZQEK
	 hti0xm2mk9Fl8r8XbEL66HrQPlhxIPHq6lvoVyn8C6v3TDRWAYl3DMwy5/kMp2WRp+
	 ZRq8KdnhZP+l+PFO/kwtZUaoc/JvtoPzgsSs5zdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 024/337] gpio: sloppy-logic-analyzer: Fix memory leak in gpio_la_poll_probe()
Date: Fri,  7 Aug 2026 16:33:47 +0200
Message-ID: <20260807143419.041992130@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

[ Upstream commit 7a7baebd9f23ba4f24796775472b2fd00dcd95d9 ]

The memory allocated for priv->blob.data is not freed in the error paths
that follow the fops_buf_size_set() call in gpio_la_poll_probe(), as
well as in the remove function. Fix that by using device managed action
to free the memory on remove.

Fixes: 7828b7bbbf20 ("gpio: add sloppy logic analyzer using polling")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://patch.msgid.link/20260715075311.527753-1-nihaal@cse.iitm.ac.in
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-sloppy-logic-analyzer.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpio/gpio-sloppy-logic-analyzer.c b/drivers/gpio/gpio-sloppy-logic-analyzer.c
index 59a8f3a5c4e48..9c526aeadeba5 100644
--- a/drivers/gpio/gpio-sloppy-logic-analyzer.c
+++ b/drivers/gpio/gpio-sloppy-logic-analyzer.c
@@ -161,6 +161,13 @@ static int fops_buf_size_get(void *data, u64 *val)
 	return 0;
 }
 
+static void fops_buf_release(void *data)
+{
+	struct gpio_la_poll_priv *priv = data;
+
+	vfree(priv->blob.data);
+}
+
 static int fops_buf_size_set(void *data, u64 val)
 {
 	struct gpio_la_poll_priv *priv = data;
@@ -239,6 +246,9 @@ static int gpio_la_poll_probe(struct platform_device *pdev)
 		return ret;
 
 	fops_buf_size_set(priv, GPIO_LA_DEFAULT_BUF_SIZE);
+	ret = devm_add_action_or_reset(dev, fops_buf_release, priv);
+	if (ret)
+		return ret;
 
 	priv->descs = devm_gpiod_get_array(dev, "probe", GPIOD_IN);
 	if (IS_ERR(priv->descs))
-- 
2.53.0



