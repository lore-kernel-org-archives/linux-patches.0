Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB912A1D1;
	Thu, 13 Feb 2025 14:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458757; cv=none; b=IdptJD3FP5gcRHkcWI4z0+bjcrYA7Uhez/+/p6loeEayFJVz1oLBaYaHAxIP+wLK6gI0cqTc92Cxa3pumxc2cfx5wFcB8r81554+Wt0Rdy7JuLSmdxWq1ygf+Lw8PSJZgrcRQmRhtXAbic+kE9QFlxAF+L9rZhCsKxbx0o46aDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458757; c=relaxed/simple;
	bh=RMHNSb0Fish/76z8j58yFTs10uy5CjX7Jd5VKsFglAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KiHgikH/PKTgmHbnhNVGoSwBp/MfSxHl9ZmGw0YStCRvWMfg3j8UeFD49//njfGmKzEx3By1FkEt69mm8MyYavj+66s8skV/3uX57gVp7nU2HPJi//q2yxuBoArshtUnVrCjLaY/oqGIXo0hNOB+eGxKGh/YAi8I7k3Vp/D616U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GU01UIq/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GU01UIq/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D47C4CED1;
	Thu, 13 Feb 2025 14:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458756;
	bh=RMHNSb0Fish/76z8j58yFTs10uy5CjX7Jd5VKsFglAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GU01UIq/6HGZke0BZ6ASQQGjpOgaXsg5e3IYDFvVIFwheq4CJFdLhRLX673hmtDMT
	 60GWNHKBWLDzUaH+tpjeLpfhGAwKGRqLydvaxRXIOmyhOe15y2mJVvqZd5qr49yMTL
	 Vg3NT3kRtkiQsuBG1Gzl9tCdEPX5rfDriWTzjMXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 037/443] drm/msm/dp: use eld_mutex to protect access to connector->eld
Date: Thu, 13 Feb 2025 15:23:22 +0100
Message-ID: <20250213142442.057108288@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 9aad030dc64f6994dc5de7bb81ceca55dbc555c3 ]

Reading access to connector->eld can happen at the same time the
drm_edid_to_eld() updates the data. Take the newly added eld_mutex in
order to protect connector->eld from concurrent access.

Reviewed-by: Maxime Ripard <mripard@kernel.org>
Acked-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241206-drm-connector-eld-mutex-v2-7-c9bce1ee8bea@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_audio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/dp/dp_audio.c b/drivers/gpu/drm/msm/dp/dp_audio.c
index 5cbb11986460d..c179ed0e9e2bd 100644
--- a/drivers/gpu/drm/msm/dp/dp_audio.c
+++ b/drivers/gpu/drm/msm/dp/dp_audio.c
@@ -414,8 +414,10 @@ static int msm_dp_audio_get_eld(struct device *dev,
 		return -ENODEV;
 	}
 
+	mutex_lock(&msm_dp_display->connector->eld_mutex);
 	memcpy(buf, msm_dp_display->connector->eld,
 		min(sizeof(msm_dp_display->connector->eld), len));
+	mutex_unlock(&msm_dp_display->connector->eld_mutex);
 
 	return 0;
 }
-- 
2.39.5



