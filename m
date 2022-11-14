Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E98D4C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5357C433D6;
	Mon, 14 Nov 2022 13:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668431219;
	bh=SduOTHmJ5cDLFORcw6jRYxtlpm4W4ETIHCZNrbXPr4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQ+VkADohfZ8g3XbbJyzPI9qtj1G8xb71PTpJMeE/BkziaCwVctpFv+ew+Ru9KxgZ
	 H+RC1Io6H09YYKMWkYkFBzLL0z3WYoUiO6Ll4Bl178mtzTiZANsHdAnr3jFfhPEBkt
	 CF6Si0vfsAIEin/F+iYVrJeIHrONwCQjBEpdSDGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Li <Roman.Li@amd.com>,
	Alan Liu <HaoPing.Liu@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 137/190] drm/amd/display: Fix reg timeout in enc314_enable_fifo
Date: Mon, 14 Nov 2022 13:46:01 +0100
Message-Id: <20221114124504.786238611@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

commit ce62198d8b62734a985d22652e75a649be052390 upstream.

[Why]
The link enablement sequence can end up resetting the encoder while
the PHY symclk isn't yet on.

This means that waiting for symclk on will timeout, along with the reset
bit never asserting high.

This causes unnecessary delay when enabling the link and produces a
warning affecting multiple IGT tests.

[How]
Don't wait for the symclk to be on here because firmware already does.

Don't wait for reset if we know the symclk isn't on.

Split the reset into a helper function that checks the bit and decides
whether or not a delay is sufficient.

Reviewed-by: Roman Li <Roman.Li@amd.com>
Acked-by: Alan Liu <HaoPing.Liu@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../dc/dcn314/dcn314_dio_stream_encoder.c     | 24 ++++++++++++++-----
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_dio_stream_encoder.c b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_dio_stream_encoder.c
index 7e773bf7b895..38842f938bed 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_dio_stream_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_dio_stream_encoder.c
@@ -49,18 +49,30 @@
 #define CTX \
 	enc1->base.ctx
 
+static void enc314_reset_fifo(struct stream_encoder *enc, bool reset)
+{
+	struct dcn10_stream_encoder *enc1 = DCN10STRENC_FROM_STRENC(enc);
+	uint32_t reset_val = reset ? 1 : 0;
+	uint32_t is_symclk_on;
+
+	REG_UPDATE(DIG_FIFO_CTRL0, DIG_FIFO_RESET, reset_val);
+	REG_GET(DIG_FE_CNTL, DIG_SYMCLK_FE_ON, &is_symclk_on);
+
+	if (is_symclk_on)
+		REG_WAIT(DIG_FIFO_CTRL0, DIG_FIFO_RESET_DONE, reset_val, 10, 5000);
+	else
+		udelay(10);
+}
 
 static void enc314_enable_fifo(struct stream_encoder *enc)
 {
 	struct dcn10_stream_encoder *enc1 = DCN10STRENC_FROM_STRENC(enc);
 
-	/* TODO: Confirm if we need to wait for DIG_SYMCLK_FE_ON */
-	REG_WAIT(DIG_FE_CNTL, DIG_SYMCLK_FE_ON, 1, 10, 5000);
 	REG_UPDATE(DIG_FIFO_CTRL0, DIG_FIFO_READ_START_LEVEL, 0x7);
-	REG_UPDATE(DIG_FIFO_CTRL0, DIG_FIFO_RESET, 1);
-	REG_WAIT(DIG_FIFO_CTRL0, DIG_FIFO_RESET_DONE, 1, 10, 5000);
-	REG_UPDATE(DIG_FIFO_CTRL0, DIG_FIFO_RESET, 0);
-	REG_WAIT(DIG_FIFO_CTRL0, DIG_FIFO_RESET_DONE, 0, 10, 5000);
+
+	enc314_reset_fifo(enc, true);
+	enc314_reset_fifo(enc, false);
+
 	REG_UPDATE(DIG_FIFO_CTRL0, DIG_FIFO_ENABLE, 1);
 }
 
-- 
2.38.1



