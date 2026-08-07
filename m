Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09523A3E7A;
	Fri,  7 Aug 2026 15:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116569; cv=none; b=YtmG4q2Bh+cIYLG9y87Odi//IoDS/MrQbT8wSvH1YeY8bwLgbd7LbFRhU0bZNSGyEUdQ/9du7UyWRXBOtnz6PpeiIpe8OeCDzZ3dWfTtUXgCBiU/hHQisD0672K3HXknHktiS+2+VNcqEjkJrk80TGwVuxMPTzC7GcdrPO774Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116569; c=relaxed/simple;
	bh=4j8rVa/9gQRAz0KYDHXFjxX+K4yx404LNTbWiEHLr5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rrOoCzaAcyi2LyO+BGLN6ntWHMb8H/v3bsJgEkxL4z7Vxpm7tO5cjSWW1ylyRhBgtVtWlK3N4Uecf/39TIkKmwLxC3IwhaKuzq93oQx3/Xa0wlfLY+QjVk6RA8lelYaTzOYXZ9YiUsfjiSSGi5khLDItc0vFRE/psX2fPU0FW/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MKxdPHQi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MKxdPHQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F4E1F000E9;
	Fri,  7 Aug 2026 15:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116568;
	bh=UT4/iUTy4UsEBXbo8fatYjhL4UuQY3B0RohdYxauhZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MKxdPHQiaMVXk95PbkS3IjqA3X9qBpr1GDY/hmcqftM729HXohX5jG55WnCA87X5B
	 Ri6hBMNpoh+m9nT602woImRDjRMF5a9Fv7IdhClNrXIEtkUZ3Eb/zmgTrvio2KQzdb
	 U8bzhNx8uMOEQ6B8oNTh+HpOK0U7WFXALtFcLORg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 015/438] gpio: sloppy-logic-analyzer: Fix memory leak in gpio_la_poll_probe()
Date: Fri,  7 Aug 2026 16:33:31 +0200
Message-ID: <20260807143428.334179413@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 969dddd3d6faf..0f4a6228a7488 100644
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



