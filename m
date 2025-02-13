Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE801DC745;
	Thu, 13 Feb 2025 14:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458760; cv=none; b=OxKmcKW4iJDrPoiEEykRB79GgHFfXbSijXhQLXssCCTzHdPAvNbsPMAzR4Pp+XhnAlPezxJSGW3TGvutHZxtySWime6xzJR00dI2MdicWowIz1C0GoWMTPg6HkH+wZbFMMwFFH8Ko3Qk6J5cjCH9Yr+DUYciVXQNHlN69wdZUFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458760; c=relaxed/simple;
	bh=7qbuS69QT15SggxA1omcC0YRpPNiASTdQXsw+7mo6fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N62Kc9PgfCStjntWgn8LYWb1oddnkTVKizryVJ8n62xYvCxsyD9ZGx/YoDvTwlZ7e4/R+ov6KARP1KRnb6USNlupdqI3YY5UBRKntYEv3I+XdgPWvdzoHJ4MmJF+ukAPIP2IXszQt1/5uUf3ZcNI7khaplVVOd3sHeYE8gkAKmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yn4w0T0R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yn4w0T0R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92EAC4CED1;
	Thu, 13 Feb 2025 14:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458760;
	bh=7qbuS69QT15SggxA1omcC0YRpPNiASTdQXsw+7mo6fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yn4w0T0RfhX9HlzTnL9DRU42YaAhsGPNOqWMkNWOU/IwEc43EQep4ZvXHI5zdbDB4
	 ObeXR9Q0RkLWBKOTGRk5nk8Wmx1/uNdMdiatIUO6yv4Pomnt1T/6AaC6TDsexWwAQf
	 x1iZqNITYpnEOnWItI6iyvu9R8i1mNgtuQ0oYlRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 038/443] drm/radeon: use eld_mutex to protect access to connector->eld
Date: Thu, 13 Feb 2025 15:23:23 +0100
Message-ID: <20250213142442.095839263@linuxfoundation.org>
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



