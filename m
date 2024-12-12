Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C67922A7FE;
	Thu, 12 Dec 2024 16:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019258; cv=none; b=uquWa06d+nIaBx32e+qCZCir4/uuym4eEItW5UAtl4C+PHADnXbvMbaKpNrRm2+s0mgsjCDvbrg3OsudcpXmM2leHIw4Re6EfTkqLLSLueiIit3rmMPs+Z4rhMkGSOEgTa2uK1Y23H4tZcbKZ7/VKUoXB0nt7J7+y+ynjnZFwK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019258; c=relaxed/simple;
	bh=UTZl6puZ008IKTZrNmObWi1e0rj5Eg0OXoFzbmUU3kY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7zlgyzVrhPQQeYdzqTaTc8iZmPXKY1KkqfAi0jrJsJHVAl2zZUd2V+573N3BY8K2Lqw32i50N+LVVzhiSQIcBFgJUlzeE4xHC15gz48XEjlSFwTIudr2TIJLIRj5JUZjOt2KS/1ZCTQiQlQ5mwAHfRUBkfYXEXP9HA2FH7ErGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rgA2/twv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rgA2/twv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99CCC4CECE;
	Thu, 12 Dec 2024 16:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019258;
	bh=UTZl6puZ008IKTZrNmObWi1e0rj5Eg0OXoFzbmUU3kY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rgA2/twvjhUORSoVYkpFg7VoIzgEHpIok0GDFBqzVjDTseDS08p/yfNBFuNLe4azt
	 TjimnOVErHCoGWt983HKIjlvPH01m199Nxyx58KHeNDKGkczz2wJiwrXMVMcRYfH+a
	 sILqAWxyN6/U3uskVAeu4gJ7Sme77nrUvUOg0AVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 130/772] drm/vc4: hvs: Correct logic on stopping an HVS channel
Date: Thu, 12 Dec 2024 15:51:15 +0100
Message-ID: <20241212144355.304744444@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 7ab6512e7942889c0962588355cb92424a690be6 ]

When factoring out __vc4_hvs_stop_channel, the logic got inverted from
	if (condition)
	  // stop channel
to
	if (condition)
	  goto out
	//stop channel
	out:
and also changed the exact register writes used to stop the channel.

Correct the logic so that the channel is actually stopped, and revert
to the original register writes.

Fixes: 6d01a106b4c8 ("drm/vc4: crtc: Move HVS init and close to a function")
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240621152055.4180873-32-dave.stevenson@raspberrypi.com
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hvs.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hvs.c b/drivers/gpu/drm/vc4/vc4_hvs.c
index 44b31d02c8eef..82c8eda2d4358 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -418,13 +418,11 @@ void vc4_hvs_stop_channel(struct vc4_hvs *hvs, unsigned int chan)
 	if (!drm_dev_enter(drm, &idx))
 		return;
 
-	if (HVS_READ(SCALER_DISPCTRLX(chan)) & SCALER_DISPCTRLX_ENABLE)
+	if (!(HVS_READ(SCALER_DISPCTRLX(chan)) & SCALER_DISPCTRLX_ENABLE))
 		goto out;
 
-	HVS_WRITE(SCALER_DISPCTRLX(chan),
-		  HVS_READ(SCALER_DISPCTRLX(chan)) | SCALER_DISPCTRLX_RESET);
-	HVS_WRITE(SCALER_DISPCTRLX(chan),
-		  HVS_READ(SCALER_DISPCTRLX(chan)) & ~SCALER_DISPCTRLX_ENABLE);
+	HVS_WRITE(SCALER_DISPCTRLX(chan), SCALER_DISPCTRLX_RESET);
+	HVS_WRITE(SCALER_DISPCTRLX(chan), 0);
 
 	/* Once we leave, the scaler should be disabled and its fifo empty. */
 	WARN_ON_ONCE(HVS_READ(SCALER_DISPCTRLX(chan)) & SCALER_DISPCTRLX_RESET);
-- 
2.43.0



