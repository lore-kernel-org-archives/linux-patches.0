Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F9E23E32B;
	Tue, 29 Apr 2025 18:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949737; cv=none; b=SHaGHToit2xZyuMWpX3N+BtXjHC5MYV7v2cad9TRsMkWH27M51mwddViMQP+j7PfabiKcgSSxZF0SQP6vs1z0HT8+3z/ziWaOYUq33gBFjowH5Ccpi8DqtGh7WExgdWnsmmTPn2xmivuE5gNzZHDIPNUJ1hqqmYe51NBIwXrvJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949737; c=relaxed/simple;
	bh=wQwpJIthJMXeUV1WE2Y8d3K9MyZ2bjbY2fVtaS5d0iA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOrDz+ofIBnF/KiIiQL3Kn9cUCGJwl/5Kfn6lb9znLcAfIUBatPZQib0inFsp4yxOzmaykCuqDXNoovicWe14THuGuiyN7qWRR8xPlfAK1vgr2yQU7LVvRz2tv8nkgvOEZq8ll7KlqWFQqFgUHsmNb3CHItQCPgIhjc62+/hUzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+DU6var; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+DU6var"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889B4C4CEE9;
	Tue, 29 Apr 2025 18:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949737;
	bh=wQwpJIthJMXeUV1WE2Y8d3K9MyZ2bjbY2fVtaS5d0iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z+DU6varJhWmGuzSG8FMv6sL4oxJqF8WtNM0/rBAPimlkrvUuwc51Igp+jwv+u2b+
	 3/BszZLdJq9tO8qksWRAU4+qp6xdDN2L74ifA3PPpkKeZaxx0kAMIJeU1vq/B33MEn
	 46w8cBJcOrwkk5FcncWYCwuE1zZ/plP0G0gAGDBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kobuk <m.kobuk@ispras.ru>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Evgeny Pimenov <pimenoveu12@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/167] ASoC: qcom: Fix sc7280 lpass potential buffer overflow
Date: Tue, 29 Apr 2025 18:42:29 +0200
Message-ID: <20250429161053.418379416@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Evgeny Pimenov <pimenoveu12@gmail.com>

[ Upstream commit a31a4934b31faea76e735bab17e63d02fcd8e029 ]

Case values introduced in commit
5f78e1fb7a3e ("ASoC: qcom: Add driver support for audioreach solution")
cause out of bounds access in arrays of sc7280 driver data (e.g. in case
of RX_CODEC_DMA_RX_0 in sc7280_snd_hw_params()).

Redefine LPASS_MAX_PORTS to consider the maximum possible port id for
q6dsp as sc7280 driver utilizes some of those values.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 77d0ffef793d ("ASoC: qcom: Add macro for lpass DAI id's max limit")
Cc: stable@vger.kernel.org # v6.0+
Suggested-by: Mikhail Kobuk <m.kobuk@ispras.ru>
Suggested-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Evgeny Pimenov <pimenoveu12@gmail.com>
Link: https://patch.msgid.link/20250401204058.32261-1-pimenoveu12@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/lpass.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/qcom/lpass.h b/sound/soc/qcom/lpass.h
index dd78600fc7b01..b96116ea81167 100644
--- a/sound/soc/qcom/lpass.h
+++ b/sound/soc/qcom/lpass.h
@@ -13,10 +13,11 @@
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <dt-bindings/sound/qcom,lpass.h>
+#include <dt-bindings/sound/qcom,q6afe.h>
 #include "lpass-hdmi.h"
 
 #define LPASS_AHBIX_CLOCK_FREQUENCY		131072000
-#define LPASS_MAX_PORTS			(LPASS_CDC_DMA_VA_TX8 + 1)
+#define LPASS_MAX_PORTS			(DISPLAY_PORT_RX_7 + 1)
 #define LPASS_MAX_MI2S_PORTS			(8)
 #define LPASS_MAX_DMA_CHANNELS			(8)
 #define LPASS_MAX_HDMI_DMA_CHANNELS		(4)
-- 
2.39.5



