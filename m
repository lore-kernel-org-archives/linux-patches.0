Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39A17DA9E;
	Thu, 15 Aug 2024 13:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729077; cv=none; b=ZE2PW6YKEZJlDK65lmbB0odfPhoGGXvZtInDvUzipHGbldTlF8haprGGExV30FUtKgRcX2mouQNxjMQXFEv4IkgJrvYsE2B+xOekPTauie2b/dEgDK/QcYOcMK9PgKDtPZqH7FB9Zc/N1ly8rHcugW4qLfOEzck8R8KvcvgEIZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729077; c=relaxed/simple;
	bh=V6w8yhROoi+NDGF47CKFI5uBDn93drMbS5wjQ3nV4NI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RB5dR4orPIGvurqfiRJObkpOG5NAXLE0F5bzjK/CcRMvWzt6yCpZlDo3xQWQo1avmwr/Nr0+sxTZkym8OJ59W6WnfBPvX8jUNBXh34AjzLr6Lgr4rhZ3wF0rkZ4yH/b5w4gJff6o6jY2OoC+Jz1odocumi5m7izxKZwWaso3A18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CyZU9any; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CyZU9any"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4332DC32786;
	Thu, 15 Aug 2024 13:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729077;
	bh=V6w8yhROoi+NDGF47CKFI5uBDn93drMbS5wjQ3nV4NI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CyZU9anyrTO7Rp6z7rHOx1Y2VpdBP02owbWS+5/tbjcxLInJNeowfnHqNOcZvojlI
	 4ZzukQkF314uQhjQyt3kFUtrxzPLvj0yrytPYssqUGtwtcSbAQAkX3CYKBa1LkJK9i
	 NCrFXfq8IksEdVjUTx7zU3J6tTcgl9+hSlEY1FDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Robert Foss <rfoss@kernel.org>
Subject: [PATCH 4.19 186/196] drm/bridge: analogix_dp: properly handle zero sized AUX transactions
Date: Thu, 15 Aug 2024 15:25:03 +0200
Message-ID: <20240815131859.186266455@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1109,7 +1109,6 @@ ssize_t analogix_dp_transfer(struct anal
 	u32 status_reg;
 	u8 *buffer = msg->buffer;
 	unsigned int i;
-	int num_transferred = 0;
 	int ret;
 
 	/* Buffer size of AUX CH is 16 bytes */
@@ -1161,7 +1160,6 @@ ssize_t analogix_dp_transfer(struct anal
 			reg = buffer[i];
 			writel(reg, dp->reg_base + ANALOGIX_DP_BUF_DATA_0 +
 			       4 * i);
-			num_transferred++;
 		}
 	}
 
@@ -1209,7 +1207,6 @@ ssize_t analogix_dp_transfer(struct anal
 			reg = readl(dp->reg_base + ANALOGIX_DP_BUF_DATA_0 +
 				    4 * i);
 			buffer[i] = (unsigned char)reg;
-			num_transferred++;
 		}
 	}
 
@@ -1226,7 +1223,7 @@ ssize_t analogix_dp_transfer(struct anal
 		 (msg->request & ~DP_AUX_I2C_MOT) == DP_AUX_NATIVE_READ)
 		msg->reply = DP_AUX_NATIVE_REPLY_ACK;
 
-	return num_transferred > 0 ? num_transferred : -EBUSY;
+	return msg->size;
 
 aux_error:
 	/* if aux err happen, reset aux */


