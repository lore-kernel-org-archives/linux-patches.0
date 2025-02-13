Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A12438389;
	Thu, 13 Feb 2025 14:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457167; cv=none; b=OatBtuB0szkmN/SuisuuDA8pCxnQ4eMeSWBWYjqBIqEzext4iSXV5HAKC41THGMb8wkc1X1uJAQJvYvNxSbqgjIDAQ85cntORmakD0v7zWYHGOyct1B+2P5/faN919hKgJJeiu7Q+a5dTC5LRQv0eQZrkxdwZzizL60Ii3Ohkdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457167; c=relaxed/simple;
	bh=UPQfTFvHRfRDV5FaJoXGSKFyZRz+594m9diK+MhRsss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+0Fm0NFBmO7mfXeJHbOfOwTLTQuQ9rJ6eMoC6EwKv0yhYJ4VkWdNHNvWHpPTROPSTaOel97fGOoP6wnLQAdkPdwIrBCngO202nSS0WhDVS8rHjatwUbsI1RA0d7k7vDnXPW0w7Rf0pq03f7NBTb/VRzPymSpm2BHGnwZLDd2BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RZuCIOMG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RZuCIOMG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 700B2C4CED1;
	Thu, 13 Feb 2025 14:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457166;
	bh=UPQfTFvHRfRDV5FaJoXGSKFyZRz+594m9diK+MhRsss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RZuCIOMG8NRzO4J9P1/UmpxBH3caaI47cNWpvIqU9wyeuPxZF3EBWHOTeVno2Yupa
	 wVZ1Cs/bVacvBRzCdXocX/qzyaLaVuA35UCvNmBIq5AD4Gu9/pSHPEyRFZ4QpkZp3h
	 oHv7poKTFSVZkWjUTnRz1cNrBdVNt21xixnI7tIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/422] drm/vc4: hdmi: use eld_mutex to protect access to connector->eld
Date: Thu, 13 Feb 2025 15:23:04 +0100
Message-ID: <20250213142437.911086068@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 81a9a93b169a273ccc4a9a1ee56f17e9981d3f98 ]

Reading access to connector->eld can happen at the same time the
drm_edid_to_eld() updates the data. Take the newly added eld_mutex in
order to protect connector->eld from concurrent access.

Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241206-drm-connector-eld-mutex-v2-10-c9bce1ee8bea@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 7e0a5ea7ab859..6b83d02b5d62a 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -2192,9 +2192,9 @@ static int vc4_hdmi_audio_get_eld(struct device *dev, void *data,
 	struct vc4_hdmi *vc4_hdmi = dev_get_drvdata(dev);
 	struct drm_connector *connector = &vc4_hdmi->connector;
 
-	mutex_lock(&vc4_hdmi->mutex);
+	mutex_lock(&connector->eld_mutex);
 	memcpy(buf, connector->eld, min(sizeof(connector->eld), len));
-	mutex_unlock(&vc4_hdmi->mutex);
+	mutex_unlock(&connector->eld_mutex);
 
 	return 0;
 }
-- 
2.39.5



