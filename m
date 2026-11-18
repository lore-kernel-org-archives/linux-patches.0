Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038518;
	b=aQphlMGSHS7bL0OL9epNkok7TICCXJVioB1PYvd40zOToIQPDqZhl8sgpFsGIcK6O0Ln
	 6g2yclk0Rw9tQpr4LcUfnbaKsCGwPP3cR8gHtp/+dtY4Np28mm0p7lwlD/k/fxeTh3JcY
	 hb0R9XiR8y8HBr0LcV3xkgL+DNhRFpR7VIIWgbQ2AWBZfeVPTeZr6RF3v3DH7+A5TYFDi
	 86jXWEdyitiN9tKdsWDy8Jo9jb/b0OYoI+PFdlLXbeNq7LsMLoPmtV7GeWX2iBPI0wIWz
	 Y6D9CAUTo5dkNbhx6Yr7PbHLUh5hrKepj1NMGLuBgAzXOlNTvhgKe9ilDijNOeW9ysQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038518;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3R7U91neYDjkllpQBhMWM1GdbwbZdOPfFiu3+1h/TvU=;
	b=rSpmoieeSaZinAZ3FvMWe5EKkoiLAOnJKBuavtahg8VvsVdnonHRv6sgyWZBR25pQ4N8
	 ESZUzeBTM1YgvnrnwYXSlEzGnTcB8rb/i/0Tz7ttxv7pT6AEXv0jbRnU6WvKVeGHBsIm5
	 OFhG4ENO0OLGOimGsEKF8MdBNcKAGJ5YdEOIiDDe2I9bmJPOdf3Zu/F8vELYuCutqNoa0
	 ezIdUA5FCW/P/pv2/jOzPStBH3x/oQ9G4u2c/lgDl328lYhY9jUdjXUdmdoiIxtIFMZt2
	 Zb3W9C1VSeBgcmXqdVbQgBlZ2r2XhFTOShqvTx1Qj+QnMhrB/DbYOa3NxlmMVD8/ikg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NJ8VOVI9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E860606A334;
	Wed, 18 Nov 2026 21:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NJ8VOVI9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F74A1F000C7;
	Wed, 18 Nov 2026 21:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038518;
	bh=3R7U91neYDjkllpQBhMWM1GdbwbZdOPfFiu3+1h/TvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NJ8VOVI92xfFu/ET0jfRJhW0r732FnnucNpGEKLhGn6rC/DJ+hwRqV669ME1DxBwu
	 uikvX4Dy5O4BIA2TWx47woBKeJmi2TJKtyc4cvcbn73Z4J1I4fAB8etFsYgwVb/QT5
	 v8wcvwdeWMghjnEsoR14TCrUt7vAFNMILaxJuGaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexey Charkov <alchark@flipper.net>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1770/3318] nvmem: rockchip-otp: Serialize reads
Date: Wed, 18 Nov 2026 15:39:52 +0100
Message-ID: <20261118150414.954857706@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f5b7d3f6986b5..e5a24283ced76 100644
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
 
@@ -333,6 +341,11 @@ static int rockchip_otp_probe(struct platform_device *pdev)
 
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



