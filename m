Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035DD12A17F;
	Tue, 23 Jan 2024 00:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968770; cv=none; b=EXvsJ9wOtR8IR6W6MxjSptWm3S9Ry/GbpCVwsOiwNH5GDAsUFu439uewqo2+6pW7V3MEv2dMbsBpakzKp/Js8t/SIqDJIil2xu1bK7VygQMhM1buM8rNYZLDIMtfjyGbYldFY/5I3AN7VcA1jjbA7x2Gd1K41ZTbv6uhI9dHJnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968770; c=relaxed/simple;
	bh=3S39M37V09BusYrXno3FfIF2wKyiM2AjIFqMRqTcWB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqSTZftaRCoxOmfGB2Heb+xKbgLvCb8C7uNOu9HXAqT4FNlqOZB7QPh4IzeTonHc3Php1C15V791wq6tAqaGIrbEewoP8HVENPSwjc7MHzjF12s5eo38LlYtCKEs/RKhmcUcu5FvGYVIMp0O4/76hdwiExvFbLQ6UnAs86guDGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wUVzBHrt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wUVzBHrt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91269C433F1;
	Tue, 23 Jan 2024 00:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968769;
	bh=3S39M37V09BusYrXno3FfIF2wKyiM2AjIFqMRqTcWB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wUVzBHrtA9YRtbfh9L2T1CTMG2I3eGLF/UIDRK3Yx1rrs08CVqowBMzEDHQ86wM7O
	 CVkdv2kwQj4m56q+qpe5CRHqDKX+FkAwYOn5d4nCiCzOpZ9DnbjyFEi2f/pAJ9+VkH
	 SavQOaMkmg8jMxdW+V6KUbK0gzsHOb6hSAUJSvyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 041/194] EDAC/thunderx: Fix possible out-of-bounds string access
Date: Mon, 22 Jan 2024 15:56:11 -0800
Message-ID: <20240122235720.985972569@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 475c58e1a471e9b873e3e39958c64a2d278275c8 ]

Enabling -Wstringop-overflow globally exposes a warning for a common bug
in the usage of strncat():

  drivers/edac/thunderx_edac.c: In function 'thunderx_ocx_com_threaded_isr':
  drivers/edac/thunderx_edac.c:1136:17: error: 'strncat' specified bound 1024 equals destination size [-Werror=stringop-overflow=]
   1136 |                 strncat(msg, other, OCX_MESSAGE_SIZE);
        |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   ...
   1145 |                                 strncat(msg, other, OCX_MESSAGE_SIZE);
   ...
   1150 |                                 strncat(msg, other, OCX_MESSAGE_SIZE);

   ...

Apparently the author of this driver expected strncat() to behave the
way that strlcat() does, which uses the size of the destination buffer
as its third argument rather than the length of the source buffer. The
result is that there is no check on the size of the allocated buffer.

Change it to strlcat().

  [ bp: Trim compiler output, fixup commit message. ]

Fixes: 41003396f932 ("EDAC, thunderx: Add Cavium ThunderX EDAC driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/20231122222007.3199885-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/thunderx_edac.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/edac/thunderx_edac.c b/drivers/edac/thunderx_edac.c
index 34be60fe6892..0fffb393415b 100644
--- a/drivers/edac/thunderx_edac.c
+++ b/drivers/edac/thunderx_edac.c
@@ -1133,7 +1133,7 @@ static irqreturn_t thunderx_ocx_com_threaded_isr(int irq, void *irq_id)
 		decode_register(other, OCX_OTHER_SIZE,
 				ocx_com_errors, ctx->reg_com_int);
 
-		strncat(msg, other, OCX_MESSAGE_SIZE);
+		strlcat(msg, other, OCX_MESSAGE_SIZE);
 
 		for (lane = 0; lane < OCX_RX_LANES; lane++)
 			if (ctx->reg_com_int & BIT(lane)) {
@@ -1142,12 +1142,12 @@ static irqreturn_t thunderx_ocx_com_threaded_isr(int irq, void *irq_id)
 					 lane, ctx->reg_lane_int[lane],
 					 lane, ctx->reg_lane_stat11[lane]);
 
-				strncat(msg, other, OCX_MESSAGE_SIZE);
+				strlcat(msg, other, OCX_MESSAGE_SIZE);
 
 				decode_register(other, OCX_OTHER_SIZE,
 						ocx_lane_errors,
 						ctx->reg_lane_int[lane]);
-				strncat(msg, other, OCX_MESSAGE_SIZE);
+				strlcat(msg, other, OCX_MESSAGE_SIZE);
 			}
 
 		if (ctx->reg_com_int & OCX_COM_INT_CE)
@@ -1217,7 +1217,7 @@ static irqreturn_t thunderx_ocx_lnk_threaded_isr(int irq, void *irq_id)
 		decode_register(other, OCX_OTHER_SIZE,
 				ocx_com_link_errors, ctx->reg_com_link_int);
 
-		strncat(msg, other, OCX_MESSAGE_SIZE);
+		strlcat(msg, other, OCX_MESSAGE_SIZE);
 
 		if (ctx->reg_com_link_int & OCX_COM_LINK_INT_UE)
 			edac_device_handle_ue(ocx->edac_dev, 0, 0, msg);
@@ -1896,7 +1896,7 @@ static irqreturn_t thunderx_l2c_threaded_isr(int irq, void *irq_id)
 
 		decode_register(other, L2C_OTHER_SIZE, l2_errors, ctx->reg_int);
 
-		strncat(msg, other, L2C_MESSAGE_SIZE);
+		strlcat(msg, other, L2C_MESSAGE_SIZE);
 
 		if (ctx->reg_int & mask_ue)
 			edac_device_handle_ue(l2c->edac_dev, 0, 0, msg);
-- 
2.43.0



