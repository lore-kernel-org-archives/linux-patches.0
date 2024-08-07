Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519F880BF8;
	Wed,  7 Aug 2024 15:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043030; cv=none; b=DAPe/vXNRl8XvcNcM2IXIBaCBZsPZbgsQK5XlLNMDDXYD0TW00iDeKhYUOHUZL/YP2uVq06jZwrpB4HaYg3vvRODgl8LohfT+b7S/F4OPwpl5GRvXeQb3qO77xso2lOrW5lKaUpXAVIfGx+skQNhKg+inkx7q+odevoXt6ShtcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043030; c=relaxed/simple;
	bh=sKnt/4lHOU1qGI3gONEPgjBcLPaTBZO05aWoPczsQg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GIUXkKQ7bajr9KZ3lj1HLlKwtDRi+ZCZam9xcnFErSvIg2rV/C67T4pqEYzRFjyboOm/4mLMUfHdUdXsaQMZetbZrx9ShjE+sqNWZgbvQ3h8P6C/YeH4Kf9cA+Rh/KfeQApLhPgiTxToFVL5emvCkGBkYeZwtipfhK9mST2cE5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l5UM0ONf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l5UM0ONf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A203C32781;
	Wed,  7 Aug 2024 15:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043030;
	bh=sKnt/4lHOU1qGI3gONEPgjBcLPaTBZO05aWoPczsQg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l5UM0ONf3f1cHoB+KP1HG04+oWbq9wcl3TkkpHhYyVzg8O9y3AKVm1oIFFkj1y4NQ
	 fireUZ3ciITioFiBCOPdOiTUsUxwbW6CuOL9++EoeqAVg2WQihcpzi4M2U99qWJxf2
	 0SR52Jdw+vQpSeFD8Wlim2INh0WUwUB73bxcKCLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 035/123] drm/client: Fix error code in drm_client_buffer_vmap_local()
Date: Wed,  7 Aug 2024 16:59:14 +0200
Message-ID: <20240807150021.961640018@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit b5fbf924f125ba3638cfdc21c0515eb7e76264ca ]

This function accidentally returns zero/success on the failure path.
It leads to locking issues and an uninitialized *map_copy in the
caller.

Fixes: b4b0193e83cb ("drm/fbdev-generic: Fix locking with drm_client_buffer_vmap_local()")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/89d13df3-747c-4c5d-b122-d081aef5110a@stanley.mountain
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_client.c b/drivers/gpu/drm/drm_client.c
index 2803ac111bbd8..bfedcbf516dbe 100644
--- a/drivers/gpu/drm/drm_client.c
+++ b/drivers/gpu/drm/drm_client.c
@@ -355,7 +355,7 @@ int drm_client_buffer_vmap_local(struct drm_client_buffer *buffer,
 
 err_drm_gem_vmap_unlocked:
 	drm_gem_unlock(gem);
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(drm_client_buffer_vmap_local);
 
-- 
2.43.0



