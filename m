Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590716;
	b=37Z1vfm0uzhiYhYgAfPpkoGL326oXsrOO/ODdqONTbDTFcOm1GqiVL1zmE8uJ4sFEoBu
	 z08YQmH612QpTxQtve6GdPtzkTYD5OWBmDKIp/gvBxTc9Jp6t0QfATPFSXQ/xDWfFWMO5
	 rXYR8UxzMIG6WIycoI1+4cin/T6UaMEfcLSYjuwgf0hFqv8lqHl1ob00gic7C9Sp2q68X
	 nPfkJSddu7QdhHLhWc8erecJ6A8MCeks3Z+phzoRN+y3q7nFR2QNpWxQxVizcp6c88xL0
	 xEcaiTJQ/RLQh4tVogt3sgyTJqmJPR5bwsz+UmPvpkSpVZW8LFy5K3qcaTlqk5X8D1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590716;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=INzWOMEgpCqLU0OEKrKKw1daHj4Y0zJh6MAiS2NrVO8=;
	b=VPE1dHuhT5UqZw4oBt1ixsR7rsljIIefn0/ZdWlMO2aXtqg2ElOyOQsS/s4d5adpsVLJ
	 sPWK4jfR/hCJ3HzQt5nF//RNegS5izkdV0yccwLlshQ6dBbU9aHOZSqTHkId2PrENv1Hl
	 TTTp14tSkdhgXPw0Zhoqic7OuO1n/X8haluTDWrYvPonU18+fhcPyYvXIqdtiDwk0zdUp
	 9IIbc/fEWJeeVKet65WNgLSVRAxU/LSwiUCCLAg/SyqUdWPNzQy2U5jk6KaVsAGOhSfh9
	 sUmmUuWhDTFQpUb+9VoN32LsAj51WlMSEDuruCzSJ3JDeDBpcd37dCtEV9038NqilSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s9qWsjpx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A7B607A5E3;
	Fri, 13 Nov 2026 17:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s9qWsjpx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7DA41F000C5;
	Fri, 13 Nov 2026 17:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590715;
	bh=INzWOMEgpCqLU0OEKrKKw1daHj4Y0zJh6MAiS2NrVO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s9qWsjpxrW4lIfWKrxY7GGcVJoREogsWbvIZfbwO5OlouBJUMu325joeSsNFnhFXr
	 BYAFWTUgHuGzz+kEgiSY5iRBXrO7m1kwU2X+i8fcryFeia6gDl4IbeHG5zPrad55b4
	 Z2UQDW2ZZMu4YkP6Vzx7ZkEIgxl/p7JjxAKiKKP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexey Charkov <alchark@flipper.net>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 623/686] nvmem: rockchip-otp: Serialize reads
Date: Fri, 13 Nov 2026 10:52:36 -0500
Message-ID: <20261113153842.969332978@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Charkov <alchark@flipper.net>

[ Upstream commit 9fc6a1592d844c0397f115ee8cbd935169b9a71e ]

The OTP controller is driven through a single set of registers holding a
state machine which has to be stepped through for every word read, yet
nothing keeps two readers out of each other's way. Concurrent reads
interleave, and the outcome is either a reader bailing out:

  rockchip-otp 2a580000.otp: timeout during read setup

or, worse, one of them silently taking delivery of the other's data.

Reading two cells in parallel from userspace on RK3576 reproduces both
within 150 iterations - 53 read errors and 9 corrupted results, the latter
either losing their first word or, in one case, ending in the two bytes
which belong to the other reader's cell - whereas the same reads issued
sequentially never fail. Concurrency is not hypothetical here, as six
thermal sensors source their trim values from the OTP and reach the driver
straight from asynchronous driver probing.

Guard the read path with a mutex. Reads are the only way into the hardware,
as the driver registers no write callback, and they always run in process
context, so a plain mutex spanning the whole clock-enable, read,
clock-disable sequence is enough.

Fixes: 755864feb729 ("nvmem: add Rockchip OTP driver")
Cc: stable@vger.kernel.org
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Alexey Charkov <alchark@flipper.net>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20261002101329.1084348-2-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/rockchip-otp.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/nvmem/rockchip-otp.c b/drivers/nvmem/rockchip-otp.c
index 00921b9fe9aae..1475ce11a9c74 100644
--- a/drivers/nvmem/rockchip-otp.c
+++ b/drivers/nvmem/rockchip-otp.c
@@ -12,6 +12,7 @@
 #include <linux/io.h>
 #include <linux/iopoll.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/nvmem-provider.h>
 #include <linux/reset.h>
 #include <linux/slab.h>
@@ -79,6 +80,8 @@ struct rockchip_otp {
 	void __iomem *base;
 	struct reset_control *rst;
 	const struct rockchip_data *data;
+	/* Serializes access to the OTP controller state machine */
+	struct mutex mutex;
 	struct clk_bulk_data clks[];
 };
 
@@ -239,16 +242,21 @@ static int rockchip_otp_read(void *context, unsigned int offset,
 	if (!otp->data || !otp->data->reg_read)
 		return -EINVAL;
 
+	mutex_lock(&otp->mutex);
+
 	ret = clk_bulk_prepare_enable(otp->data->num_clks, otp->clks);
 	if (ret < 0) {
 		dev_err(otp->dev, "failed to prepare/enable clks\n");
-		return ret;
+		goto unlock;
 	}
 
 	ret = otp->data->reg_read(context, offset, val, bytes);
 
 	clk_bulk_disable_unprepare(otp->data->num_clks, otp->clks);
 
+unlock:
+	mutex_unlock(&otp->mutex);
+
 	return ret;
 }
 
@@ -334,6 +342,11 @@ static int rockchip_otp_probe(struct platform_device *pdev)
 
 	otp->data = data;
 	otp->dev = dev;
+
+	ret = devm_mutex_init(dev, &otp->mutex);
+	if (ret)
+		return ret;
+
 	otp->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(otp->base))
 		return dev_err_probe(dev, PTR_ERR(otp->base),
-- 
2.53.0



