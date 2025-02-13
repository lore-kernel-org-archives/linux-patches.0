Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B706E26B091;
	Thu, 13 Feb 2025 15:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459882; cv=none; b=raV0bse/grl/9tJ26KqzaEeBiUnJC8l98UHIuUxq6BAQ5a0qVS2N7tefq/nR6cfU/W5IGT1hC+YG4LmHMVjmIAfJr3O9Wyha78BQKUqDKxdAHCqhzzJUQeSOIkuXQjPcQn37vf5ASTL6U6q/fRrYDB8C4kxmXYBrEYL8KG3RTzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459882; c=relaxed/simple;
	bh=RAxSHT9MgwVo5SUHHKLiXoTXUL1a+K7R3YNkcq3Psvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PdpBGFwKOgsydi2IuB2L0brzm4lQtert6EE68kGjEcYN70gjhO2J09LNnAFWWnKObUOC79KjMHbVEgD77d7yCdiAqk9yzO4gwfbgYnniqhcy2OUwkDX28bVhfyx7jzgBcLWsr6IrwLjl0pP8vIwbYlWjl2jadjnTrsPvZOJ0HOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y6vA/lQF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y6vA/lQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CAB4C4CED1;
	Thu, 13 Feb 2025 15:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459882;
	bh=RAxSHT9MgwVo5SUHHKLiXoTXUL1a+K7R3YNkcq3Psvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y6vA/lQFXHOrFoHA4XLAgD2QXV1qtfT/xnkXjibYXfkOJwaPtg/zFDeVWoz7cKFJJ
	 8/f3kICng5I3NnuoF/FUv13IfOyPVM6LPA9ccKZ1lQVBNk7aYhcqMEKXwgP3GdIqEI
	 3uEWS3c2rCFeH01tAuK1mZvzmjwO/j5+n6+xAg7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	stable <stable@kernel.org>,
	Peng Fan <peng.fan@nxp.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.13 392/443] nvmem: imx-ocotp-ele: fix reading from non zero offset
Date: Thu, 13 Feb 2025 15:29:17 +0100
Message-ID: <20250213142455.735800474@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -71,12 +71,14 @@ static int imx_ocotp_reg_read(void *cont
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
@@ -100,7 +102,7 @@ static int imx_ocotp_reg_read(void *cont
 			*buf++ = readl_relaxed(reg + (i << 2));
 	}
 
-	memcpy(val, (u8 *)p, bytes);
+	memcpy(val, ((u8 *)p) + skipbytes, bytes);
 
 	mutex_unlock(&priv->lock);
 


