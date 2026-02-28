Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD36A4BC018;
	Sat, 28 Feb 2026 17:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301344; cv=none; b=QPsCrIjyHs6o682pJ2YxeEjmexIVDD0+FL1MZqwP90PR/z84VAPDw2sgzZ2aTir8xuoCy0bF4PycrRnzxyoSdfOHdeTHWHqC3Gj1/H56HTntqCL929I9jGy+J+fvTXOKr4lLkFhXzE6ov74TfqrVBwHK0tvTy1CSWXUZYdGAv4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301344; c=relaxed/simple;
	bh=mHbcm3efLdr7ht2qO4sssYcb9ZspIVB/JiuwDFBdiAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XaMyFH15LMgfQ1niFkF0HgWb3CMO2cb/Cb1N7wh3AxVIchXhCq6ep/Fy3F/qMc5vEfc+UIEIkfcjMyT1pUckb8lc4Ul3q2Upe9DV8G3Z/w3RURrN4KqfQcpK/QVwRdxGMBnMTnmu7mhSLn7ShLpXHqq92R7FsxPhokqriWbsBoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zv98+G5w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zv98+G5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAABBC116D0;
	Sat, 28 Feb 2026 17:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301344;
	bh=mHbcm3efLdr7ht2qO4sssYcb9ZspIVB/JiuwDFBdiAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zv98+G5wIRZns+V0IiLn2UkTy54FH1uAVnVOGzLYj5Juar+Gub3yw1+Z3G9tiV91Z
	 qg+chtYIlCG0TwRQKk4M9aXk48XsqjC+8EVquZc4XnTLgbLZXfLjfJ0Y2QZz5Cn93s
	 MdRdsDWVIIyc8VhA4YXMU462WwzOfBBpfzTHsHqPeKYqdlHRElc7r5gaTtVFdRP24e
	 cdq//xr2+MplovnRH8YfzQ3AYEtteoJdLlzYBqQxIA6p4DsAQ50UBkcqtWR+q0/Qow
	 VGoRLhSMdZN5engP4Yq1sZFM7+BmdypPapxsvPb/CiBJw+2Y7AVCoNmL7GPmvPWlrn
	 1yUpnpX/KmiHA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ricardo Ribalda <ribalda@chromium.org>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Neil Sun <neil.sun@lcfuturecenter.com>,
	Naomi Huang <naomi.huang@lcfuturecenter.com>,
	stable@vger.kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 531/752] media: dw9714: Fix powerup sequence
Date: Sat, 28 Feb 2026 12:44:02 -0500
Message-ID: <20260228174750.1542406-531-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 401aec35ac7bd04b4018a519257b945abb88e26c ]

We have experienced seen multiple I2C errors while doing stress test on
the module:

dw9714 i2c-PRP0001:01: dw9714_vcm_resume I2C failure: -5
dw9714 i2c-PRP0001:01: I2C write fail

Inspecting the powerup sequence we found that it does not match the
documentation at:
https://blog.arducam.com/downloads/DW9714A-DONGWOON(Autofocus_motor_manual).pdf

"""
(2) DW9714A requires waiting time of 12ms after power on. During this
waiting time, the offset calibration of internal amplifier is
operating for minimization of output offset current .
"""

This patch increases the powerup delay to follow the documentation.

Fixes: 9d00ccabfbb5 ("media: i2c: dw9714: Fix occasional probe errors")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Tested-by: Neil Sun <neil.sun@lcfuturecenter.com>
Reported-by: Naomi Huang <naomi.huang@lcfuturecenter.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/dw9714.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/dw9714.c b/drivers/media/i2c/dw9714.c
index 1e7ad355a388c..3288de539452e 100644
--- a/drivers/media/i2c/dw9714.c
+++ b/drivers/media/i2c/dw9714.c
@@ -149,7 +149,7 @@ static int dw9714_power_up(struct dw9714_device *dw9714_dev)
 
 	gpiod_set_value_cansleep(dw9714_dev->powerdown_gpio, 0);
 
-	usleep_range(1000, 2000);
+	usleep_range(12000, 14000);
 
 	return 0;
 }
-- 
2.51.0

