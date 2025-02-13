Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA69281343;
	Thu, 13 Feb 2025 14:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457158; cv=none; b=KcZ+wn+DXb+ZPNmHz83ejR7iIZUc+1+Tl8n6FYZKdyG2n640otD4bLaYsFkplpAA5ZDBWZQZsU2f59gYAywUVjqnXNeomHNoBr41GkErPX8TjZ8wXr2NpWjDCJdZpoXYmogppEdDNpBcl205eFztNzXksLsQabVs/m5T3vdq5rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457158; c=relaxed/simple;
	bh=zqBwQfg14n7niuNa3RVuy+mp14SqaiEgHyudJh0pYi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tYg7RJCU3QY8QUyBa5+hib4XfVnt34Dc2VWDLpwfr3uTMCZnk8L473PlO1/43Nm+xmMeLQF65YatkSnS30X9XUKh/c0Lm95XjDB19r746lPVLgNEudsyDeSevXoL9lv9hfoG/5VqfV2pJ2YU+b43mwMMIugjvTLXtTo21KlBZbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDUQipnd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDUQipnd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28861C4CED1;
	Thu, 13 Feb 2025 14:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457158;
	bh=zqBwQfg14n7niuNa3RVuy+mp14SqaiEgHyudJh0pYi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDUQipndOvTog2fRVLtVUhsMxb3tMhoR4wGzO4y2YY49Jq2MIjkwfsO1ltMMZHUA7
	 JMSo6iEvzD7SY48tzSlS421YPWy52qI+FD1LzBQOaf1StRgs3++jFdSopO1px+qHCZ
	 ghmdAdmsSO7MKdFhgjlmXhM2zRuusKHVpcz+ea9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 033/422] drm/radeon: use eld_mutex to protect access to connector->eld
Date: Thu, 13 Feb 2025 15:23:02 +0100
Message-ID: <20250213142437.833419828@linuxfoundation.org>
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

[ Upstream commit b54c14f82428c8a602392d4cae1958a71a578132 ]

Reading access to connector->eld can happen at the same time the
drm_edid_to_eld() updates the data. Take the newly added eld_mutex in
order to protect connector->eld from concurrent access.

Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241206-drm-connector-eld-mutex-v2-8-c9bce1ee8bea@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_audio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_audio.c b/drivers/gpu/drm/radeon/radeon_audio.c
index 5b69cc8011b42..8d64ba18572ec 100644
--- a/drivers/gpu/drm/radeon/radeon_audio.c
+++ b/drivers/gpu/drm/radeon/radeon_audio.c
@@ -775,8 +775,10 @@ static int radeon_audio_component_get_eld(struct device *kdev, int port,
 		if (!dig->pin || dig->pin->id != port)
 			continue;
 		*enabled = true;
+		mutex_lock(&connector->eld_mutex);
 		ret = drm_eld_size(connector->eld);
 		memcpy(buf, connector->eld, min(max_bytes, ret));
+		mutex_unlock(&connector->eld_mutex);
 		break;
 	}
 
-- 
2.39.5



