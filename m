Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF17DF6D;
	Sat, 13 Jan 2024 10:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aK97KINq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2286C433F1;
	Sat, 13 Jan 2024 10:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705140011;
	bh=Hg4RMJI8NV/u+SIghLYYjKPITTGUIoc+/bMq31dSJXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aK97KINqh5IbaEbN2FGBlHTx5hryKNZsVCoO5XkVmsXbl71GSCMbjjm0WZeV5wbGK
	 P7QqkalfRH6awTx0F7p8OQo97ndX6NHRL8mvdz6bj2RofDIZAGzVzBpAF7/rm8QnlV
	 TAfJVvd0Q04tnNe39kFxAnZALXKtzgRBxNdarcrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Boyd <swboyd@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 06/59] drm/bridge: ti-sn65dsi86: Never store more than msg->size bytes in AUX xfer
Date: Sat, 13 Jan 2024 10:49:37 +0100
Message-ID: <20240113094209.499233342@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094209.301672391@linuxfoundation.org>
References: <20240113094209.301672391@linuxfoundation.org>
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

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit aca58eac52b88138ab98c814afb389a381725cd7 ]

For aux reads, the value `msg->size` indicates the size of the buffer
provided by `msg->buffer`. We should never in any circumstances write
more bytes to the buffer since it may overflow the buffer.

In the ti-sn65dsi86 driver there is one code path that reads the
transfer length from hardware. Even though it's never been seen to be
a problem, we should make extra sure that the hardware isn't
increasing the length since doing so would cause us to overrun the
buffer.

Fixes: 982f589bde7a ("drm/bridge: ti-sn65dsi86: Update reply on aux failures")
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20231214123752.v3.2.I7b83c0f31aeedc6b1dc98c7c741d3e1f94f040f8@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi86.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi86.c b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
index 22c2ff5272c60..b488c6cb8f106 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi86.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
@@ -471,6 +471,7 @@ static ssize_t ti_sn_aux_transfer(struct drm_dp_aux *aux,
 	u32 request_val = AUX_CMD_REQ(msg->request);
 	u8 *buf = msg->buffer;
 	unsigned int len = msg->size;
+	unsigned int short_len;
 	unsigned int val;
 	int ret;
 	u8 addr_len[SN_AUX_LENGTH_REG + 1 - SN_AUX_ADDR_19_16_REG];
@@ -544,7 +545,8 @@ static ssize_t ti_sn_aux_transfer(struct drm_dp_aux *aux,
 	}
 
 	if (val & AUX_IRQ_STATUS_AUX_SHORT) {
-		ret = regmap_read(pdata->regmap, SN_AUX_LENGTH_REG, &len);
+		ret = regmap_read(pdata->regmap, SN_AUX_LENGTH_REG, &short_len);
+		len = min(len, short_len);
 		if (ret)
 			goto exit;
 	} else if (val & AUX_IRQ_STATUS_NAT_I2C_FAIL) {
-- 
2.43.0



