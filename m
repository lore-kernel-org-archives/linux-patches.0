Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578B16CDC9;
	Tue, 14 May 2024 10:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683945; cv=none; b=kb4vmKVPHFVAUkV0PSoQORzWzK3BLXlfprfTp4n+RO3ue/S8d5y/sy3m5HHO6A9f/aVq16jo9CTllX0F0buHmO2lVIWz/kvrl/I+MezAU9NyCCmXx3JSbew3C6LPltkmlsNftLlbf/xUOzzBfCsIbT/WK7NfpG1W76YKBw1tOEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683945; c=relaxed/simple;
	bh=HzymojR6eANGvMHbiOBc1AW1r5RLyDAKnqpjyv7pRuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZEoIabHc5ipf4BXmgaUxQ0zqw3xCrmaipHJNXCfWAqPngAy600wDxTG0BkpSrWEkfq2vS6NW9elYBzXHYk9Fg/mJ8EZXy19J0ZSJtsSAB8vV3wz1oPkhaunxntCeirEoQ/hMPPFy9/n5UCWgongvFSXeZpDxfQByWJYkDRQErmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dG7X0fjW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dG7X0fjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF74CC2BD10;
	Tue, 14 May 2024 10:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683945;
	bh=HzymojR6eANGvMHbiOBc1AW1r5RLyDAKnqpjyv7pRuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dG7X0fjWLIhkKP47Q7YVpSi0iPxjnDGHPo/swQyKWkZVbB11/p03gw0KxOIBR0pYx
	 6iawGyxnaviV5V1ok6U7F4i6T17TJw5h1WuLjVV79kYGGe/LtJzNR0EXceBigD4AGv
	 5AF9MzCatfHEgz7Ps7vxME6QyO1YOKDu+EYpyhME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	David Airlie <airlied@gmail.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	Maaz Mombasawala <maaz.mombasawala@broadcom.com>,
	Martin Krastev <martin.krastev@broadcom.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.8 298/336] drm/vmwgfx: Fix invalid reads in fence signaled events
Date: Tue, 14 May 2024 12:18:22 +0200
Message-ID: <20240514101049.868407347@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zack Rusin <zack.rusin@broadcom.com>

commit a37ef7613c00f2d72c8fc08bd83fb6cc76926c8c upstream.

Correctly set the length of the drm_event to the size of the structure
that's actually used.

The length of the drm_event was set to the parent structure instead of
to the drm_vmw_event_fence which is supposed to be read. drm_read
uses the length parameter to copy the event to the user space thus
resuling in oob reads.

Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Fixes: 8b7de6aa8468 ("vmwgfx: Rework fence event action")
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-23566
Cc: David Airlie <airlied@gmail.com>
CC: Daniel Vetter <daniel@ffwll.ch>
Cc: Zack Rusin <zack.rusin@broadcom.com>
Cc: Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Cc: <stable@vger.kernel.org> # v3.4+
Reviewed-by: Maaz Mombasawala <maaz.mombasawala@broadcom.com>
Reviewed-by: Martin Krastev <martin.krastev@broadcom.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240425192748.1761522-1-zack.rusin@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
@@ -991,7 +991,7 @@ static int vmw_event_fence_action_create
 	}
 
 	event->event.base.type = DRM_VMW_EVENT_FENCE_SIGNALED;
-	event->event.base.length = sizeof(*event);
+	event->event.base.length = sizeof(event->event);
 	event->event.user_data = user_data;
 
 	ret = drm_event_reserve_init(dev, file_priv, &event->base, &event->event.base);


