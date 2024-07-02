Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D931315B0FE;
	Tue,  2 Jul 2024 17:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940340; cv=none; b=V0NyAMQUJ5fhef+ynymnL+LMIwwzNJYoDIChGstwPn+vDsz0dEB8N7tWbc8xbjRpt3TnKe1BK4T4ptQaDBXLJlHci+wA4QH/2gfU2AUOq+ziNFua2jAGp67NmslQyiBSHJC9BinsiX2IDtdcyFRYlf4hMpq8YW21aJnMaD9Hiuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940340; c=relaxed/simple;
	bh=ffX5SkokPYxExM8L83WRqJrrAxeuaB4thLeYuO1V9i4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EBy9UobPkBBzFtYE86nBtXMfCTJu6nyP5ClWSeKO3Lnz2MtU6PYwK+/vPKevRLgBPAePbXVnm88rccIdlAfsBmsjKO73A3BZyQStejBYeI4T3PTpqACmSTVa7Vhei41n6ANU1cKgWwmwFdXJQdXYgPVvCjEwIJg74Ma1y5nl8uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2jFqvO4G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2jFqvO4G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AFBC116B1;
	Tue,  2 Jul 2024 17:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940340;
	bh=ffX5SkokPYxExM8L83WRqJrrAxeuaB4thLeYuO1V9i4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2jFqvO4G8WiRCTRggDoJN9Kxuy+IrxvjkYa7CnTyS86FNDri4qqAn7sa65Vb+q1jT
	 0UuxchqUf3NM3C845nXI943v7flJ7rFsYcoln3joZqw38utH/NI25NlCZ4Ro5nqr+c
	 PPzb3MUvlMN6K6hsvsr1uhe9XPNqkuPZCUOpmuz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 126/222] iio: xilinx-ams: Dont include ams_ctrl_channels in scan_mask
Date: Tue,  2 Jul 2024 19:02:44 +0200
Message-ID: <20240702170248.785007316@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index f0b71a1220e02..f52abf759260f 100644
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



