Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6906B343D80;
	Mon, 18 Aug 2025 14:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525863; cv=none; b=ZU0hkRuuDhb8Lf1Fdx1x17grE17K8DlIXAmpP1+OjvSFoZNkEvuGL4YQA7tIe3rv36FxsayY10kHQtGqD0dWV35IXGIIdnCtto4XYviVTcn3RtYSD7fi9BXVc2SE67oLxDy5HQETvXN+iO9mPzx4FvqBS2NBj6Z69wjcC39yym0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525863; c=relaxed/simple;
	bh=qybBR+FG+SRgCP1evoBxMGj4DDHLQLh9BIT7jMD5Wy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fjTvquSe932yx2F2OJKCcmG6ihtn1qI6QpyjnCeH30S2YHpdvSri3G7I0KCxiqar0jnnJ7k+jErvNiXrRGPigJ9ZDABEpwUESKETXU9NRh4DCZojP0sLg/KOcRrnXaq+t2Vt+SPU/WOiolrCgB8Yt8erL121AAnRy2boJkokAS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=okPYKyE7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="okPYKyE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDED7C4CEEB;
	Mon, 18 Aug 2025 14:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525863;
	bh=qybBR+FG+SRgCP1evoBxMGj4DDHLQLh9BIT7jMD5Wy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=okPYKyE71jAYBE7YPGl/AoUn/rxf5RWgHvsCOQrg0QsxRCOgVS8WhDqYIxOtaMatI
	 OtK7SS5X9VjZgaeYIquVB3sFWbI2lnBloXVhjyyRs08x/2IHuhBE7bZytigyueUE6O
	 pcwENuhgFhXhMQJ7hAlzxHDsvZtuap+2ts68BDA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Mugnier <benjamin.mugnier@foss.st.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 389/570] media: i2c: vd55g1: Setup sensor external clock before patching
Date: Mon, 18 Aug 2025 14:46:16 +0200
Message-ID: <20250818124520.831180269@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Mugnier <benjamin.mugnier@foss.st.com>

[ Upstream commit df2f8fd91bde57d5d5aca6adddf7e988f2e8c60e ]

Proper clock configuration is required to advance through FSM states.
Prior than this having a different clock value than default sensor's
value was used (12 MHz) could prevent the sensor from booting.

Signed-off-by: Benjamin Mugnier <benjamin.mugnier@foss.st.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/vd55g1.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/vd55g1.c b/drivers/media/i2c/vd55g1.c
index 25e2fc88a036..8552ce75e1aa 100644
--- a/drivers/media/i2c/vd55g1.c
+++ b/drivers/media/i2c/vd55g1.c
@@ -1038,8 +1038,6 @@ static int vd55g1_enable_streams(struct v4l2_subdev *sd,
 	if (ret < 0)
 		return ret;
 
-	vd55g1_write(sensor, VD55G1_REG_EXT_CLOCK, sensor->xclk_freq, &ret);
-
 	/* Configure output */
 	vd55g1_write(sensor, VD55G1_REG_MIPI_DATA_RATE,
 		     sensor->mipi_rate, &ret);
@@ -1613,6 +1611,9 @@ static int vd55g1_power_on(struct device *dev)
 		goto disable_clock;
 	}
 
+	/* Setup clock now to advance through system FSM states */
+	vd55g1_write(sensor, VD55G1_REG_EXT_CLOCK, sensor->xclk_freq, &ret);
+
 	ret = vd55g1_patch(sensor);
 	if (ret) {
 		dev_err(dev, "Sensor patch failed %d\n", ret);
-- 
2.39.5



