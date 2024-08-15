Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CA91A7060;
	Thu, 15 Aug 2024 14:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731816; cv=none; b=n1REjA7y6i0r8sc6paPYklpiGZe7zwO5/pYhwmdmAAGdSpCNjH4yxpDUksJpGTBzdj4GIUDw1kOGz3QxhdelAq3SceC2w+Mw9PgW6c3gbwZTI5RgR3Yiyqj2VRHQQJX4nVXfHogRPNU7lupNgDiQs96RWyJoOlWNvVvjA0JbLCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731816; c=relaxed/simple;
	bh=4LJejHPYGH2/eM5zjuYsyI63yRKqZoLTUTNLjUf6lNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unzdSCiKFG6gOhAlUEe0LhyHcPUeRO5sq1gmxZASGgxpclKFnCkd1A66ZP5fHKblD0KdTXihd8lD0+7LEoyS79pT2qGeT8/ZnKzkF348Wgdnc+IYpn3h1WNumASqpgM+y4kh4l2Dzm3kProoCFy1AePXVKWrzM1SqefcyG9nNtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pQlHwAT9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pQlHwAT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03CECC32786;
	Thu, 15 Aug 2024 14:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731815;
	bh=4LJejHPYGH2/eM5zjuYsyI63yRKqZoLTUTNLjUf6lNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pQlHwAT9kTq+yt7CmJR8lpvtmBXnvXc7pS8+kYjNVoy9/FKbv/b+tnv4Te6kmC0Gj
	 gFVHygxS2kHKQTZ/xLPaKKbPQvY4LkjRODDBsJ1LN5SFpVt7ebjNHv3wkUZI1bkYpz
	 KSglKz+Nt1pHmWwIALIpJqErzhD08N7GZ08SNqys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Robert Foss <rfoss@kernel.org>
Subject: [PATCH 5.4 247/259] drm/bridge: analogix_dp: properly handle zero sized AUX transactions
Date: Thu, 15 Aug 2024 15:26:20 +0200
Message-ID: <20240815131912.308486916@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1115,7 +1115,6 @@ ssize_t analogix_dp_transfer(struct anal
 	u32 status_reg;
 	u8 *buffer = msg->buffer;
 	unsigned int i;
-	int num_transferred = 0;
 	int ret;
 
 	/* Buffer size of AUX CH is 16 bytes */
@@ -1167,7 +1166,6 @@ ssize_t analogix_dp_transfer(struct anal
 			reg = buffer[i];
 			writel(reg, dp->reg_base + ANALOGIX_DP_BUF_DATA_0 +
 			       4 * i);
-			num_transferred++;
 		}
 	}
 
@@ -1215,7 +1213,6 @@ ssize_t analogix_dp_transfer(struct anal
 			reg = readl(dp->reg_base + ANALOGIX_DP_BUF_DATA_0 +
 				    4 * i);
 			buffer[i] = (unsigned char)reg;
-			num_transferred++;
 		}
 	}
 
@@ -1232,7 +1229,7 @@ ssize_t analogix_dp_transfer(struct anal
 		 (msg->request & ~DP_AUX_I2C_MOT) == DP_AUX_NATIVE_READ)
 		msg->reply = DP_AUX_NATIVE_REPLY_ACK;
 
-	return num_transferred > 0 ? num_transferred : -EBUSY;
+	return msg->size;
 
 aux_error:
 	/* if aux err happen, reset aux */


