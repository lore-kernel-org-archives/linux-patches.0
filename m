Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793ED3DD86C;
	Sat, 12 Sep 2026 07:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197383; cv=none; b=QOjyq3x/zX6nulqXZOnlK5RcMDGMl5aIFZmBqIrok9EE0vyYDdlNkXcZzMsQNVbdip2Bpxaaj182E7musRFBQpIhmO+YTelHvgbh5Fh0QcshXGktQY1VZipZLK2pTwP5i32zJ6tW5f/NwgZ5kl0PeZa+UsZvNzwrL5eVxvYGgqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197383; c=relaxed/simple;
	bh=4BNBPX5+A083Zv+7GzUc6GWvywXnLdmok4A6c70mA7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AP8EIrloYwQ3ETxJ+bW0hW0FmYt+jUy3T4XKQQ1URAyrwDD3xmzI+Y0L5ntZsaKU266CilTJJ+TLkSd6T72o0GTVRar7etJ2tb/SMg0relyXCfwyuvkjWe5ouTynGMGltnNse/vzXSNO662MCzAHJhfWLQI2VgiERr9KfwgBXFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JCcMiQwo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JCcMiQwo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A2F1F000FF;
	Sat, 12 Sep 2026 07:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197382;
	bh=c87UN0zwtNtdKcmIYL8fJlMNTZmUZCWikBcFMD07UVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JCcMiQwo4gAfvHI4NSWJqmo8FOBVdPGwRTIEYGV1KvAAymti5QwAU3oL1g3PxZcY6
	 88eqBFHOls94ntKlvJXtx5R2yeAqPJhI4+ZoDxXYjS+WeWhzIMpLh6SREakIs7CDzi
	 xfqyU7tTCS6GKn0sovgattFX2ty9Ztlyi5qx7asY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0163/1815] soundwire: qcom: Fix port exhaustion check in stream_alloc_ports
Date: Sat, 12 Sep 2026 08:31:53 +0200
Message-ID: <20260912065652.835406761@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

[ Upstream commit 6ccec91c3535b07310e12d32fe9c67ff8d31d965 ]

find_first_zero_bit(mask, n) returns n (not n+1) when all bits are set,
so the guard `pn > maxport` is never true on exhaustion.  The driver
would silently call set_bit(maxport, port_mask) and assign the
out-of-range port instead of returning -EBUSY.  Fix the comparison to
`pn >= maxport`.

Fixes: 02efb49aa805 ("soundwire: qcom: add support for SoundWire controller")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Assisted-by: Claude Sonnet 4.6
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260701193006.4113-2-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soundwire/qcom.c b/drivers/soundwire/qcom.c
index 3d8f5a81eff19..b288218f64b42 100644
--- a/drivers/soundwire/qcom.c
+++ b/drivers/soundwire/qcom.c
@@ -1271,7 +1271,7 @@ static int qcom_swrm_stream_alloc_ports(struct qcom_swrm_ctrl *ctrl,
 				else
 					pn = find_first_zero_bit(port_mask, maxport);
 
-				if (pn > maxport) {
+				if (pn >= maxport) {
 					dev_err(ctrl->dev, "All ports busy\n");
 					return -EBUSY;
 				}
-- 
2.53.0



