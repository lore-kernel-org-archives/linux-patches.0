Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BD02253EC;
	Thu, 12 Dec 2024 16:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019905; cv=none; b=ZQlFquA69UBxL4H3Vgf9LpCtYkhr0XhfZrtagI2uVsMut18en4HOOih0RM68DicT0DDoh1hJCNiFC1y/LVsmOqEYix3C203lUabEhroNjUTKEoq4TLeWQUcy/9ElxJQJ9Os5/4UPryD5B7SxvTCvsszWXZpXrLZODlSw24Z67Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019905; c=relaxed/simple;
	bh=7YCkHoY4EjxUhBRmvhXLL91yZib0uhOI7HawFP4FX7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MA6Wuba+/2a+1QkS1Oz/M1s0hpc/TQpOwrfpn2I7aA9iHtXMzr4AZxrJUVfmpJCiLZGHhr2zMraJEZJL7J8go8LwEV3l0VQrik0EiEJdM9NzqaipwQRW8Q6q/Tvn5Z8F27NhWRJGdlt3dJNuI+ZDgIX0Z9drXYPL5TPNvfPWz24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rUp41Llp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rUp41Llp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B647C4CECE;
	Thu, 12 Dec 2024 16:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019905;
	bh=7YCkHoY4EjxUhBRmvhXLL91yZib0uhOI7HawFP4FX7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rUp41Llp1hUU9pybxUCBYEX1rvj7gw0o40d4pM46RgfndGDY0Z4gREpO8RGD2tcSn
	 keFQtxl59VS1lYuXwpPfYoIwa05AG0JMoWEgRt8uOue7ZME3Oxm8NlfD6tYXvAlO/2
	 69oq9T3TrC62SIZNAntsMItT7WCZlX1eeVDg22KI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Marek <jonathan@marek.ca>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 288/772] rpmsg: glink: use only lower 16-bits of param2 for CMD_OPEN name length
Date: Thu, 12 Dec 2024 15:53:53 +0100
Message-ID: <20241212144401.805636296@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit 06c59d97f63c1b8af521fa5aef8a716fb988b285 ]

The name len field of the CMD_OPEN packet is only 16-bits and the upper
16-bits of "param2" are a different "prio" field, which can be nonzero in
certain situations, and CMD_OPEN packets can be unexpectedly dropped
because of this.

Fix this by masking out the upper 16 bits of param2.

Fixes: b4f8e52b89f6 ("rpmsg: Introduce Qualcomm RPM glink driver")
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241007235935.6216-1-jonathan@marek.ca
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/qcom_glink_native.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/rpmsg/qcom_glink_native.c b/drivers/rpmsg/qcom_glink_native.c
index 2c388426e4019..c838be098e865 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -1043,7 +1043,8 @@ static irqreturn_t qcom_glink_native_intr(int irq, void *data)
 			qcom_glink_rx_advance(glink, ALIGN(sizeof(msg), 8));
 			break;
 		case GLINK_CMD_OPEN:
-			ret = qcom_glink_rx_defer(glink, param2);
+			/* upper 16 bits of param2 are the "prio" field */
+			ret = qcom_glink_rx_defer(glink, param2 & 0xffff);
 			break;
 		case GLINK_CMD_TX_DATA:
 		case GLINK_CMD_TX_DATA_CONT:
-- 
2.43.0



