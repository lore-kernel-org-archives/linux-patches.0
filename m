Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA1D1E9B3D;
	Thu,  3 Jul 2025 15:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555207; cv=none; b=gATm0BicmIrxiDygTD6tM6AevLTh9zFpd7VZoOZWR//FrK0I5AwtgyphYZjA5Wl+6dOQr59N+fYRGnmxTyt0lMySTkmiyneY3eB1YSZ0H4VkQzmZD6pMnoWF+Jac6vEpbJrU7a2ohfLb2oT1KvlMQ4WyvLojqsiruH4vN8eus3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555207; c=relaxed/simple;
	bh=QRg0vNDGVIS/NgUMKmTD7FDbBuhJUiMhUkKBjZMx1uY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSKtPEyjwKLAbIoB1bS59+JhPuBHLyoGIDZCZzslt0KVtWWnGgsWrWq0qVOyAZiPcfLQhD3Fx1lB9n1LMjv5UpwupJiAR4aSFnyT3PgPGFIHGLxw5Kn0WrQDmjZifE3EqKlg0GEFzGTqprIg4CdBL40YITMZggS847ncIx5MgbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AO7qOxDJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AO7qOxDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA497C4CEE3;
	Thu,  3 Jul 2025 15:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555207;
	bh=QRg0vNDGVIS/NgUMKmTD7FDbBuhJUiMhUkKBjZMx1uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AO7qOxDJLShO1xeA2xpjCByX5VQPsotVj16uc9pyb6uFASYHoPRN6e91Iw/W8PWGw
	 g5svfZIC+NA2Gpuqm94/E9JMZGrXiQXvTX27ssnZEoPX8OpQHJMT+g5I/zuMoLzCRO
	 tHMI0Q3N1TpjYe5RlYsquvXoj63Dq2/RKIsDYyhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiu-ji Chen <chenqiuji666@gmail.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.15 208/263] drm/tegra: Fix a possible null pointer dereference
Date: Thu,  3 Jul 2025 16:42:08 +0200
Message-ID: <20250703144012.716960018@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiu-ji Chen <chenqiuji666@gmail.com>

commit 780351a5f61416ed2ba1199cc57e4a076fca644d upstream.

In tegra_crtc_reset(), new memory is allocated with kzalloc(), but
no check is performed. Before calling __drm_atomic_helper_crtc_reset,
state should be checked to prevent possible null pointer dereference.

Fixes: b7e0b04ae450 ("drm/tegra: Convert to using __drm_atomic_helper_crtc_reset() for reset.")
Cc: stable@vger.kernel.org
Signed-off-by: Qiu-ji Chen <chenqiuji666@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20241106095906.15247-1-chenqiuji666@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tegra/dc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -1393,7 +1393,10 @@ static void tegra_crtc_reset(struct drm_
 	if (crtc->state)
 		tegra_crtc_atomic_destroy_state(crtc, crtc->state);
 
-	__drm_atomic_helper_crtc_reset(crtc, &state->base);
+	if (state)
+		__drm_atomic_helper_crtc_reset(crtc, &state->base);
+	else
+		__drm_atomic_helper_crtc_reset(crtc, NULL);
 }
 
 static struct drm_crtc_state *


