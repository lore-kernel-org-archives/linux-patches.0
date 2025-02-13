Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CE926B087;
	Thu, 13 Feb 2025 15:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460829; cv=none; b=U+afCfZS/PRfoGmoSICS5EjGZD8iUyRbnFnA/jpeqh8xUfN/PGVg8l+XozKPrKkoMJ/pK2VimRSGyWv1ndghjiiUFAZRNaaKMPlsZaBVJSfUOKqhEWEI9TBlludJhzZKUGDvyUrCg45p0ezt0Nljg3V95lPnZuXXSwspqcmU0o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460829; c=relaxed/simple;
	bh=2jwgQT6ywu4Sog/0D8YD3TDgRX6sObmdr1j25gtep3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z36rDAioxVm1NFT6CtBN+OMiPofh3bILY7PiSQp6vEWSbEH/wUMxHHbJZn9d4ueDA0EdkGd1ZYip7EVCevG5XLvmM23TupDehCvHfrh+wNdYsOcYtpDHQfRi0DjVK5bSWLbePfVBhLdHoGDqlBoHj5FUe7LkszI4A/IFJgR8KyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1TL1T4WK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1TL1T4WK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822A2C4CED1;
	Thu, 13 Feb 2025 15:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460829;
	bh=2jwgQT6ywu4Sog/0D8YD3TDgRX6sObmdr1j25gtep3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1TL1T4WKaN6kX0X/yS7f08LdWPh3LdSoS7SYd3R3r9dIC+0BQwlp+MbsJaFWKgZIB
	 cARJGHVxvuIemnjIDZ2GGL976EQyQiGl+PDz/NYzSQH6pSvylTJRCanChsTEhHGsxg
	 t/cWfqvYZPNQyEhtfw6IpEEg8gOv8pB0GVXyCu8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	stable <stable@kernel.org>,
	Peng Fan <peng.fan@nxp.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.6 224/273] nvmem: imx-ocotp-ele: fix reading from non zero offset
Date: Thu, 13 Feb 2025 15:29:56 +0100
Message-ID: <20250213142416.165307372@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sascha Hauer <s.hauer@pengutronix.de>

commit 3c9e2cb6cecf65f7501004038c5d1ed85fb7db84 upstream.

In imx_ocotp_reg_read() the offset comes in as bytes and not as words.
This means we have to divide offset by 4 to get to the correct word
offset.

Also the incoming offset might not be word aligned. In order to read
from the OCOTP the driver aligns down the previous word boundary and
reads from there. This means we have to skip this alignment offset from
the temporary buffer when copying the data to the output buffer.

Fixes: 22e9e6fcfb50 ("nvmem: imx: support i.MX93 OCOTP")
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Cc: stable <stable@kernel.org>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20241230141901.263976-3-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/imx-ocotp-ele.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/nvmem/imx-ocotp-ele.c
+++ b/drivers/nvmem/imx-ocotp-ele.c
@@ -70,12 +70,14 @@ static int imx_ocotp_reg_read(void *cont
 	u32 *buf;
 	void *p;
 	int i;
+	u8 skipbytes;
 
 	if (offset + bytes > priv->data->size)
 		bytes = priv->data->size - offset;
 
-	index = offset;
-	num_bytes = round_up(bytes, 4);
+	index = offset >> 2;
+	skipbytes = offset - (index << 2);
+	num_bytes = round_up(bytes + skipbytes, 4);
 	count = num_bytes >> 2;
 
 	p = kzalloc(num_bytes, GFP_KERNEL);
@@ -96,7 +98,7 @@ static int imx_ocotp_reg_read(void *cont
 		*buf++ = readl_relaxed(reg + (i << 2));
 	}
 
-	memcpy(val, (u8 *)p, bytes);
+	memcpy(val, ((u8 *)p) + skipbytes, bytes);
 
 	mutex_unlock(&priv->lock);
 


