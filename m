Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D15183CA6;
	Mon, 12 Aug 2024 16:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479095; cv=none; b=fu98xHK3tPwmEOTD1G0Fb6Hp8I4bqf/3LT3vsbMqtZ3PjDFcD2NSu3dScSVvFchsO4xmheQb4AEqxyYxr+tOvDaWACK8rxBFgovih3fX6F+ZFnm4EADQ7/87PkHYj7zvOO/2Gpg7lni/xuhsdyvkKNLCkwT60jptjP9vdc+inOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479095; c=relaxed/simple;
	bh=SMAIh/6SL78v5EYnjZSv6OpuzRNOXr5lxAtlnqWotCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qvg1x7mHsAnHgGldlb5zi6RE2dOHHvkuN/T3oJDVN7Qp3O6ng2LaMREJZB8m0Q8OjGjzpD3j93/2BFvT8Vj68W/mTcclubg8rTLvkcX7k4+4QG6eH3p3NLiXEo/+J7H4FFDFUT1hmLald7uCvbppWIq2zK/yKeOOVXGD8mOLZGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e70NzGOW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e70NzGOW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18472C32782;
	Mon, 12 Aug 2024 16:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479095;
	bh=SMAIh/6SL78v5EYnjZSv6OpuzRNOXr5lxAtlnqWotCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e70NzGOWLHmkeVMfKyu50eqvKe/Ect74oLyMhR7zYNkcKoROAEKV3vvxk4rREgltw
	 UXtx+giYng027E1GfmFIrYouFI+t79zGfT2inbMYnLEU1Ww+ic0u8hxqbQTADwMX3B
	 iWJj5zvlM3C5dTtoE8unPtsHaQlTUQl2yap79iAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Robert Foss <rfoss@kernel.org>
Subject: [PATCH 6.1 124/150] drm/bridge: analogix_dp: properly handle zero sized AUX transactions
Date: Mon, 12 Aug 2024 18:03:25 +0200
Message-ID: <20240812160129.946978069@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


