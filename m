Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE722823AF;
	Wed,  7 Aug 2024 15:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043415; cv=none; b=uNHc3xVlm4iV3U9Vtprp6VeNyF/8UOlKqKOZ8sv4figsS7VLJl1SywMHFaANJojQ+FnXGP5Tmg5N5HrSi+4iEyxUAyq5cUH5ibopaR0lxAsX4whwR2+a0AY0jXi/qYybhAhUHmYscn/vOnBO+FXni0zSCF6g4STvzJ82gy5cWSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043415; c=relaxed/simple;
	bh=H1Tm5BPT/ZK5ThrX6iS/9Hrk3QgSZsPBT0ZdVv8/5Ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jq0imgb/qZeQ2CeB8hT4PXp3GC+xSshPjJAWsLPwL4HoBm0LDnwGl4J7Yy26EVFqhUdNHJ8cYG8TOmq7VDerJlWE8nKCjRGSy1dkl6y49mRFuBRFQXLFJsd1GDAuz0Vt0V11YXpqLo7VBOdWr7eDEU1CUxySwRmCn92PhfDHVJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2kk78cSN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2kk78cSN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7EEC32781;
	Wed,  7 Aug 2024 15:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043415;
	bh=H1Tm5BPT/ZK5ThrX6iS/9Hrk3QgSZsPBT0ZdVv8/5Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2kk78cSNY/Cn1UilCzs3+I7jNYOR0qqrftGJDrtaVgbDDR/9aOSjaYlarNkAIbUwj
	 frk+dyCllKEwAn1FEvffZl1p5q3WDmnKLA+B//g/wvsctcij8tcCjKI+jY+5qdCOIB
	 zZeZ6GS7CMIESB5M5Zm1IBHTDZ39NZAHg87b/Gjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Brown <doug@schmorgal.com>,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/121] drm/vmwgfx: Fix overlay when using Screen Targets
Date: Wed,  7 Aug 2024 16:59:46 +0200
Message-ID: <20240807150021.178318563@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Forbes <ian.forbes@broadcom.com>

[ Upstream commit cb372a505a994cb39aa75acfb8b3bcf94787cf94 ]

This code was never updated to support Screen Targets.
Fixes a bug where Xv playback displays a green screen instead of actual
video contents when 3D acceleration is disabled in the guest.

Fixes: c8261a961ece ("vmwgfx: Major KMS refactoring / cleanup in preparation of screen targets")
Reported-by: Doug Brown <doug@schmorgal.com>
Closes: https://lore.kernel.org/all/bd9cb3c7-90e8-435d-bc28-0e38fee58977@schmorgal.com
Signed-off-by: Ian Forbes <ian.forbes@broadcom.com>
Tested-by: Doug Brown <doug@schmorgal.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240719163627.20888-1-ian.forbes@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c b/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
index c45b4724e4141..e20f64b67b266 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
@@ -92,7 +92,7 @@ static int vmw_overlay_send_put(struct vmw_private *dev_priv,
 {
 	struct vmw_escape_video_flush *flush;
 	size_t fifo_size;
-	bool have_so = (dev_priv->active_display_unit == vmw_du_screen_object);
+	bool have_so = (dev_priv->active_display_unit != vmw_du_legacy);
 	int i, num_items;
 	SVGAGuestPtr ptr;
 
-- 
2.43.0



