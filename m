Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B415A19F49A;
	Thu, 15 Aug 2024 14:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730565; cv=none; b=uXn30/rpfK6FakqPUS3kvcZe1w62jqOiPud5rUX1S53K69DT52tdIkXz5g3ZDIsRepEhakdCZn8rCQmXQwh1DTjWtba/048bALmZaheyn7/2dGIEe9vINVCH/aCe6jJIy6dLKYfESskcxv/kOtpvRM8xBgpusWyrNJZSg8Spl24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730565; c=relaxed/simple;
	bh=IDFTU2iSid7MbSUwoj3UHn9NyxS0YghCbkBmkmxg4S4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffcO8fffPSHIqRgJQRizIygep5iygtMMTn4Y8OLea13HPxZCxzsgYA2WGHDtOMWlEArPlU6d3ZPK0R43jYZ0NPgsCpx+SxDzUK/SeZnplL6hW2ciocejJ+blmQUMdfaGH1D7EOu0fEaAZ1P/lxC5/BVxP2qrcXoLm4b/WUFwWsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TmIO6gU2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TmIO6gU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C962C32786;
	Thu, 15 Aug 2024 14:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730565;
	bh=IDFTU2iSid7MbSUwoj3UHn9NyxS0YghCbkBmkmxg4S4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TmIO6gU2PSWnSrW7zzSSDGwd7lrEq1jrhzRvrGg1wrjHu5PWuwyS5zchj2DsgEThL
	 cxQsHwxwBjyfRSqVK0jhFjZOZMRfCcyRjZgSqC+KrfVm6hUjUBTtWi2yqbMKY5t9YA
	 uVzcyayMhertZreOTbO2RaznBE54cYIkFcqiPnQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Robert Foss <rfoss@kernel.org>
Subject: [PATCH 5.15 449/484] drm/bridge: analogix_dp: properly handle zero sized AUX transactions
Date: Thu, 15 Aug 2024 15:25:07 +0200
Message-ID: <20240815131958.803395732@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


