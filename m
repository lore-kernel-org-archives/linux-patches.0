Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE70616D9B8;
	Mon, 12 Aug 2024 16:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480591; cv=none; b=tl3w7f4RcUeV5NFeVz15WRsCFvjgIRJ8YQeRwxA5/lgfp5ddNTMk8XwOi9HMGBqfXB/bpHKg3xhbaUmPxepgE+27VfjEDq1XZI+K5JEfHE4HR5glPT31wl7KTYFhiPens4kjoJt9jEPyy6eNgGecvAsxBBzQZcZfTSZi7nYeUGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480591; c=relaxed/simple;
	bh=6Gi8N7p1GkhOlChPj4dvdf2oqkQZJzYJqNwfFh7JbfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W2QIxxzka3AQazie3k6FKXI96bswOtxp7bQhYJ553jWLHtNziuvezIkz/SQJY2ecsaz3YwjJxBlDeOvur0+xasj4ojkoAx76JIMN4F+K2hbo/JHb8cVpfhaLsIV2w8++k2zosYNG6r6PyE+X/qH6/j50VkISigWnmPur97ziHwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ypdR3KuL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ypdR3KuL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3145AC32782;
	Mon, 12 Aug 2024 16:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480590;
	bh=6Gi8N7p1GkhOlChPj4dvdf2oqkQZJzYJqNwfFh7JbfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ypdR3KuLKphAoOce+QUB6mASgPyBfc4r95OfcCehOlTY4Ut0qruh9gFCymxZ+FNBm
	 gXeBWhdwrqYUYQm6URTyt8UfixY+0UBvO6p5it+y3o5Vtbf/4k4N08Gry943nW1C6g
	 y6mCN/0KtCKv3v8nCrKanfMb+fvP9/8Eg7d9TWE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Robert Foss <rfoss@kernel.org>
Subject: [PATCH 6.10 242/263] drm/bridge: analogix_dp: properly handle zero sized AUX transactions
Date: Mon, 12 Aug 2024 18:04:03 +0200
Message-ID: <20240812160155.797893014@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas Stach <l.stach@pengutronix.de>

commit e82290a2e0e8ec5e836ecad1ca025021b3855c2d upstream.

Address only transactions without any data are valid and should not
be flagged as short transactions. Simply return the message size when
no transaction errors occured.

CC: stable@vger.kernel.org
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240318203925.2837689-1-l.stach@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/analogix/analogix_dp_reg.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/gpu/drm/bridge/analogix/analogix_dp_reg.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_reg.c
@@ -1027,7 +1027,6 @@ ssize_t analogix_dp_transfer(struct anal
 	u32 status_reg;
 	u8 *buffer = msg->buffer;
 	unsigned int i;
-	int num_transferred = 0;
 	int ret;
 
 	/* Buffer size of AUX CH is 16 bytes */
@@ -1079,7 +1078,6 @@ ssize_t analogix_dp_transfer(struct anal
 			reg = buffer[i];
 			writel(reg, dp->reg_base + ANALOGIX_DP_BUF_DATA_0 +
 			       4 * i);
-			num_transferred++;
 		}
 	}
 
@@ -1127,7 +1125,6 @@ ssize_t analogix_dp_transfer(struct anal
 			reg = readl(dp->reg_base + ANALOGIX_DP_BUF_DATA_0 +
 				    4 * i);
 			buffer[i] = (unsigned char)reg;
-			num_transferred++;
 		}
 	}
 
@@ -1144,7 +1141,7 @@ ssize_t analogix_dp_transfer(struct anal
 		 (msg->request & ~DP_AUX_I2C_MOT) == DP_AUX_NATIVE_READ)
 		msg->reply = DP_AUX_NATIVE_REPLY_ACK;
 
-	return num_transferred > 0 ? num_transferred : -EBUSY;
+	return msg->size;
 
 aux_error:
 	/* if aux err happen, reset aux */


