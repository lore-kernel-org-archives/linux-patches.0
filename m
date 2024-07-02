Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF8663D;
	Tue,  2 Jul 2024 17:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941464; cv=none; b=PzccDsgBFcuqhj1UBVBYbDUwn7Dn2WzPVV06hf8+tG7KafHOfyrt8eN23v6CICFoSXHYfcyw7lG7SZksqu+24AC4LCEX+4fYMDPhbyBUYX/3wFBCTzwlcBrW1gMhCgMKiOhq4diSVJRszJfmmPKq78QIwNP5wE7A1aRe/vu3DwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941464; c=relaxed/simple;
	bh=afxChTBqLhdJm93GyRPCWhSpw5eWJ0308/7nmbozAAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYAKIJWpFYcY5iIYRezdmH6D6XY/44YoUl7O9WQBQ8qHrFPvcEAPpKJqf+frE79b80d6wpWlT2BxdRvVhE2tFOKzzdnZNZHkXGNTTXWi0z6wd4UT8K2esfGdT9inCeK/Q7AlqC2Px0wMTkzxyo//pUeLrC1W46mq81i7Uq9tb38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VA7CPXu6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VA7CPXu6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE4EC116B1;
	Tue,  2 Jul 2024 17:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941464;
	bh=afxChTBqLhdJm93GyRPCWhSpw5eWJ0308/7nmbozAAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VA7CPXu6F8n7ycKyBLvZXTXWnnqUiseAl0PwgKB5uRLh9ZkOxCI4QY0AuPsVybzbV
	 ySAeABAqOOlvppWrvIQ52tNqWHFhdknWlBAvczDHqsnsFR3LWQ9CTTK4essR9bzXs0
	 wMihK4cm8T0vpwdKFO6JkOBtbDl18UCVRr6sAg2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 072/128] iio: xilinx-ams: Dont include ams_ctrl_channels in scan_mask
Date: Tue,  2 Jul 2024 19:04:33 +0200
Message-ID: <20240702170228.956053122@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit 89b898c627a49b978a4c323ea6856eacfc21f6ba ]

ams_enable_channel_sequence constructs a "scan_mask" for all the PS and
PL channels. This works out fine, since scan_index for these channels is
less than 64. However, it also includes the ams_ctrl_channels, where
scan_index is greater than 64, triggering undefined behavior. Since we
don't need these channels anyway, just exclude them.

Fixes: d5c70627a794 ("iio: adc: Add Xilinx AMS driver")
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Link: https://lore.kernel.org/r/20240311162800.11074-1-sean.anderson@linux.dev
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/xilinx-ams.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/xilinx-ams.c b/drivers/iio/adc/xilinx-ams.c
index a507d2e170792..3db021b96ae9d 100644
--- a/drivers/iio/adc/xilinx-ams.c
+++ b/drivers/iio/adc/xilinx-ams.c
@@ -414,8 +414,12 @@ static void ams_enable_channel_sequence(struct iio_dev *indio_dev)
 
 	/* Run calibration of PS & PL as part of the sequence */
 	scan_mask = BIT(0) | BIT(AMS_PS_SEQ_MAX);
-	for (i = 0; i < indio_dev->num_channels; i++)
-		scan_mask |= BIT_ULL(indio_dev->channels[i].scan_index);
+	for (i = 0; i < indio_dev->num_channels; i++) {
+		const struct iio_chan_spec *chan = &indio_dev->channels[i];
+
+		if (chan->scan_index < AMS_CTRL_SEQ_BASE)
+			scan_mask |= BIT_ULL(chan->scan_index);
+	}
 
 	if (ams->ps_base) {
 		/* put sysmon in a soft reset to change the sequence */
-- 
2.43.0



