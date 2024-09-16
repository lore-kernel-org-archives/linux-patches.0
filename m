Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C3C156991;
	Mon, 16 Sep 2024 12:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488167; cv=none; b=ON2i6F4npvC3vHxqaBTwBfxCcJHPkiag9ykGJdr52CkkiertbXXDK3T80uAqRQVu99N4SgXr4E8SV20cMvvF8o1Dga+rBFrsdiHNFrR94FyoX9ZiY6WiCnw2DfrzE5q0S8upBxzTGd4zqOyODYLEdx0Kn1MwW9QQvzYlIH2bHew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488167; c=relaxed/simple;
	bh=VK9j/gis8MKa58q1zWTZ+lxeWzCCYR8LtcB2vj+eMd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipyqDtcawlsQKcfz2DStLw4PwBoGy3CZ84hhs8BZgtoSHnD14CM1nxeIgUOlmI11g+PGE5IQkLd+QHfp0sydY89VqoX35dCo+GXCOkwQLolGMV+BzLVhA+/qoXHr7yN28NpqLX0eAcitMxsUsaHj/eCMtOQgqN81QjHK3LiKG3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qxNeiJZz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qxNeiJZz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D450C4CECF;
	Mon, 16 Sep 2024 12:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488167;
	bh=VK9j/gis8MKa58q1zWTZ+lxeWzCCYR8LtcB2vj+eMd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qxNeiJZzoxoSWZkr78hXG/hHLUrC+Su/1+EYjNWIeIfdmf8h7R8qcLXQCUaCP8kRh
	 WTpoCX685wwpnBXy82Vw3MBNFU2quEXyXlQnFxWY8SQxeRLhfvWeRS0ZclOdmW3zXO
	 b0FrBMZwXWUlsKDmJ8VXeHIZO6cNJXUwoQeTWbhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 019/121] Input: ads7846 - ratelimit the spi_sync error message
Date: Mon, 16 Sep 2024 13:43:13 +0200
Message-ID: <20240916114229.564883324@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit ccbfea78adf75d3d9e87aa739dab83254f5333fa ]

In case the touch controller is not connected, this message keeps scrolling
on the console indefinitelly. Ratelimit it to avoid filling kernel logs.

"
ads7846 spi2.1: spi_sync --> -22
"

Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://lore.kernel.org/r/20240708211913.171243-1-marex@denx.de
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/ads7846.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index 4d13db13b9e5..b42096c797bf 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -805,7 +805,7 @@ static void ads7846_read_state(struct ads7846 *ts)
 		m = &ts->msg[msg_idx];
 		error = spi_sync(ts->spi, m);
 		if (error) {
-			dev_err(&ts->spi->dev, "spi_sync --> %d\n", error);
+			dev_err_ratelimited(&ts->spi->dev, "spi_sync --> %d\n", error);
 			packet->ignore = true;
 			return;
 		}
-- 
2.43.0



