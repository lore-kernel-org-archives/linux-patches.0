Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF923AE69
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:30:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CBE5C433D2;
	Wed,  7 Jun 2023 20:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169855;
	bh=kC9LOLN41BDeUI089Se9e6y0RGWuDxlP7H0Whrq/qtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zs/DNTFxIm5Cv3KOT535lr+6c0SaVHwXItm5iNJL09+ro+Vy3EeXStu2UkdB74l4K
	 5HL11ufCqHns1Wy7DwN29xJXK+IBL1i9dNKkPRc7i1Y4HyaarpTXQITUYeC9L2F5Mm
	 7QHe6jbpo+R3wp/QnRx6DTnwo+bPsOjskm0FJ6Po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Rosin <peda@axentia.se>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.3 240/286] dmaengine: at_hdmac: Repair bitfield macros for peripheral ID handling
Date: Wed,  7 Jun 2023 22:15:39 +0200
Message-ID: <20230607200931.130982662@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Rosin <peda@axentia.se>

commit 2a6c7e8cc74e58ba94b8c897035a8ef7f7349f76 upstream.

The MSB part of the peripheral IDs need to go into the ATC_SRC_PER_MSB
and ATC_DST_PER_MSB fields. Not the LSB part.

This fixes a severe regression for TSE-850 devices (compatible
axentia,tse850v3) where output to the audio I2S codec (the main
purpose of the device) simply do not work.

Fixes: d8840a7edcf0 ("dmaengine: at_hdmac: Use bitfield access macros")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Rosin <peda@axentia.se>
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Link: https://lore.kernel.org/r/01e5dae1-d4b0-cf31-516b-423b11b077f1@axentia.se
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_hdmac.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 8858470246e1..6362013b90df 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -153,8 +153,6 @@
 #define ATC_AUTO		BIT(31)		/* Auto multiple buffer tx enable */
 
 /* Bitfields in CFG */
-#define ATC_PER_MSB(h)	((0x30U & (h)) >> 4)	/* Extract most significant bits of a handshaking identifier */
-
 #define ATC_SRC_PER		GENMASK(3, 0)	/* Channel src rq associated with periph handshaking ifc h */
 #define ATC_DST_PER		GENMASK(7, 4)	/* Channel dst rq associated with periph handshaking ifc h */
 #define ATC_SRC_REP		BIT(8)		/* Source Replay Mod */
@@ -181,10 +179,15 @@
 #define ATC_DPIP_HOLE		GENMASK(15, 0)
 #define ATC_DPIP_BOUNDARY	GENMASK(25, 16)
 
-#define ATC_SRC_PER_ID(id)	(FIELD_PREP(ATC_SRC_PER_MSB, (id)) |	\
-				 FIELD_PREP(ATC_SRC_PER, (id)))
-#define ATC_DST_PER_ID(id)	(FIELD_PREP(ATC_DST_PER_MSB, (id)) |	\
-				 FIELD_PREP(ATC_DST_PER, (id)))
+#define ATC_PER_MSB		GENMASK(5, 4)	/* Extract MSBs of a handshaking identifier */
+#define ATC_SRC_PER_ID(id)					       \
+	({ typeof(id) _id = (id);				       \
+	   FIELD_PREP(ATC_SRC_PER_MSB, FIELD_GET(ATC_PER_MSB, _id)) |  \
+	   FIELD_PREP(ATC_SRC_PER, _id); })
+#define ATC_DST_PER_ID(id)					       \
+	({ typeof(id) _id = (id);				       \
+	   FIELD_PREP(ATC_DST_PER_MSB, FIELD_GET(ATC_PER_MSB, _id)) |  \
+	   FIELD_PREP(ATC_DST_PER, _id); })
 
 
 
-- 
2.41.0



