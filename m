Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659DC5646A;
	Tue, 23 Jan 2024 01:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974017; cv=none; b=AFX/t/12P3zJARMF9n/Wz/JVoYVOpsQlHMyI82yX6GzPl0bOUo8FyV9qdj8KmJb7SKc0qk6mr3/J0/ESJj1SP/EM7syalPZoU9EHKS2VedxYn9LlK5IVRH9p3K4z2EiYD+RMOXziAWNCBOI+Pko5Dtre7EflqIcN82kIoiUJ+cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974017; c=relaxed/simple;
	bh=65osVdXnBJ6YkG+wSb2g9yWQM4fxP91nZuc6lQlsJ5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dctfqIuxW86twoERn3F3WZHT0eygm2ZSdVFCfnRBZlA55l4arGHXEv+mpYpUToyh1ro8CL2rY0uqvTV29rpjbsG5RyJvgy124i0jT+Mvw8xs97p89zNRWbCP5E3WlzNZWGiGvdelxmi8lXmRYwvSknazNT8+O48IvX/8/yV4mAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kkTOMkcc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kkTOMkcc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1999C433C7;
	Tue, 23 Jan 2024 01:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974017;
	bh=65osVdXnBJ6YkG+wSb2g9yWQM4fxP91nZuc6lQlsJ5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kkTOMkccArEXNPb9XZK3tXuCgE3feflfwS27sIYZKq3wINM+O8VpfjDKzY6bTA7g7
	 7uO2zdSjPJHLzeLbndx4YhsG6UmKYiOuqk5WETREJzqT1eaAUzfwkkGpUYE7JOZp2v
	 6/hJRGrxDsi9jSU3o/oiHqTWn+Mm2eWnprctugOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/583] EDAC/thunderx: Fix possible out-of-bounds string access
Date: Mon, 22 Jan 2024 15:50:54 -0800
Message-ID: <20240122235812.340095632@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b9c5772da959..90d46e5c4ff0 100644
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



