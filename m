Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB2326B083;
	Thu, 13 Feb 2025 14:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458651; cv=none; b=Z6F6YoSupS61x9HQdJgmA9wux21vzBNqD3rrHgwad6hXyqtp304KTS/F+9DuEQi1k9iCostsFJO3ZLS1IgKVjgDv0l8/jr/AuFixv5EDXbSxla2CrcazYPS/XIJlk02MLJmcfJK3amSFQQfpjA2aWcnpoQpQ/b0jRPR+Su0A9BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458651; c=relaxed/simple;
	bh=+sVJ3gv0aCWc37QVNQuXOiaFFt4xZHJw12jXeUeC7cE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQy+JsRw59BHhXpswuymec57nIA5XCEPVzKjKrYevqZC7P+Uc87lKmuoFvOaClUSESegqo8GCGtFuHHK2+KI2NWnOA3n2TI3vV4m0Cv/frzNteUfDW9VX3Ef99RixesAKixg7qtE9XShs/W1EEPhF74LmXshjvM7NFPDwuSiwh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lkRa9yen; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lkRa9yen"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C51C4CED1;
	Thu, 13 Feb 2025 14:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458650;
	bh=+sVJ3gv0aCWc37QVNQuXOiaFFt4xZHJw12jXeUeC7cE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lkRa9yeny/8tPHqXIBwJjFxjq6aBSqxEO5ZXlw5a+D3cnbs/hVlgxNL6lzpbCnMjv
	 RBlj42xsAhUbtFN+hkc8YzkI69LA3hh68CfnQPiQZNnW6U5TMnAV/00gVs6tIj0JIN
	 jkAtt1Nt+mtfcy39HebqusOWpxVHh9Ag4WWO2Dmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 040/443] drm/vc4: hdmi: use eld_mutex to protect access to connector->eld
Date: Thu, 13 Feb 2025 15:23:25 +0100
Message-ID: <20250213142442.172606920@linuxfoundation.org>
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
index e3818c48c9b8c..e86123009c905 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -2193,9 +2193,9 @@ static int vc4_hdmi_audio_get_eld(struct device *dev, void *data,
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



