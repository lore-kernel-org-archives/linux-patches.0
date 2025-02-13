Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2344924168F;
	Thu, 13 Feb 2025 14:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458288; cv=none; b=PHfnItQz8bdxr2yLbTOiidmNNHaoasC/5I0zA+gU6w+UH80S4do+mgjrJX1btMDHEjQYCKyK00moLlml3zcooLqxSsIRD1kF64y1E7wq6YRbjuGtTDcoffJuFxzywzhYRg4qTizdc4/nUiWjmgYDg+diKw6nnpwoJYSKOcxj+Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458288; c=relaxed/simple;
	bh=vA34+ZP4SVq3xWBq8SUXnxHICym5uhg9akrdZxD/fOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HaUnhsOaYfbwI3K4Vn8pPfUzD/nNWv/dS1q1inkNCqIOoSPZsrIz9DsnqGV0jeVhOD4JC8vOlgtOOy7zGWoyj4mW7jYRRhthQeaap5COmrlj4dPZnd9rdsiAB6JolnnYb3UaRGMbaCRiCIzMW4XnAZRv0MMPeI7EMd+OdVXVoo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D62aPMix; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D62aPMix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23014C4CED1;
	Thu, 13 Feb 2025 14:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458287;
	bh=vA34+ZP4SVq3xWBq8SUXnxHICym5uhg9akrdZxD/fOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D62aPMix8XSxL02IJsj41vZnXhI57PP/nXvD0vG97bKrvWm8dXZOGYCxuEVJjzu83
	 TANXPK2DKhF1gCdc70gqf7OSF/ABaY68sfwvNYNWDzczwvbR9HG4guN3ZbGqp/C6cT
	 SmlPbp+mZcZqcMuffED7cq+qHs6pty5I7sHSJs2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	stable <stable@kernel.org>,
	Peng Fan <peng.fan@nxp.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.12 355/422] nvmem: imx-ocotp-ele: fix reading from non zero offset
Date: Thu, 13 Feb 2025 15:28:24 +0100
Message-ID: <20250213142450.252629358@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


