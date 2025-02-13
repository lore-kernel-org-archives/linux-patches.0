Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D0413D8A4;
	Thu, 13 Feb 2025 15:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460120; cv=none; b=a4GLpmt9sJNLkPiyf+vGtNrEvnxIoZTGqgZyQvMSRSicIzFHRMrNUmkAKr4lAkkkt/+hjo0rcYdaXE5S0IhCiNywLdUsdjt8WELuo+sTgXrE0S8csd7KB267OHmdmImHs3vJpQnc/h1Q8HyH9upO4PykpBmTMAPEVdQI6Hn7dFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460120; c=relaxed/simple;
	bh=dF8L7tuSvu+aEzrwUkk2dHWpCzm1vcesyeDOPlRoCaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JAugNKdc81/0MHeZtZn+uTDnZSIFZQp0FsAw3uAMF5qKLxTW522rKW6cNDAzIDPHqBFeLUtrPKhwfWF3maewxa8d5nKcmTMD3dj878O39zM8y7kdFyyjHa0SOrG/Vsp8Ggg/0kvty9UluFHqpK/0AsGuYSlFWsgI6ibRqlHAP3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9oZLiaJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9oZLiaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D12EC4CEE4;
	Thu, 13 Feb 2025 15:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460120;
	bh=dF8L7tuSvu+aEzrwUkk2dHWpCzm1vcesyeDOPlRoCaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9oZLiaJovSOT4gAK6fOWNeQdrtzUnX0ii6TLj+ePLwYu/TpU7/6FXyEoaHEt/yQ/
	 /n9epUOH3Zx5mZxdlqxngAdjT6lqkkK5KtFluzQPL6fCYPn/dQGjuPRwL6o8A6YgGo
	 XVwyLRVv5h5O9dRDNP+O+mIFnpUHbloEEa+TYoOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/273] drm/vc4: hdmi: use eld_mutex to protect access to connector->eld
Date: Thu, 13 Feb 2025 15:26:32 +0100
Message-ID: <20250213142408.160581441@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1727d447786f1..541aba80c1449 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -2655,9 +2655,9 @@ static int vc4_hdmi_audio_get_eld(struct device *dev, void *data,
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



