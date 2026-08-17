Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E8A3033E7;
	Mon, 17 Aug 2026 14:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975758; cv=none; b=Z4tLTpoV0omMXsTwXOzE29ViLWO+HN2078Xd+zB0sUdg9dgI24gPhu0r5zFGyoiAWSNUXKvkXXAA15chLsPnY74AHURFa8To6cuMfL0IDSa2CBAvufEe9upHRr3S9Nh5x42axJqn7V4fqB8JXGTttV1KiMShE6ry39L4Rl9unVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975758; c=relaxed/simple;
	bh=bPwCtZWeXW7eGvvHj9hmNIujZx1urMF1a7ijUcjTYAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZv7c5dyA2lvPHP7WTvFHUuTMcFXsmaa2b3Enma7aTj52CCbchjVQ84uOhghit2Q2QZMztn3Luvq0fqc8ElHCf+iCOON+oCg1j3X33H/P4l4aH+EBI0qtmVCwBxdNpsOdtZKCg2SZhjtgRz4Y1xYW8rYOWM9ABXo4E3gxy5+Qy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OdMMzh9Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OdMMzh9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500BE1F000E9;
	Mon, 17 Aug 2026 14:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975756;
	bh=buLbWsLjL1vXS7W3lzgfSoQcnikx8WPdIjUmBGw4Ozc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OdMMzh9Z3nmv2DZbcBZdaz74ne478EOz+i0qnRnjdY9BfafZ0cdlD+J69SsMsBXVr
	 wlMb1n45kj/Z59/ZIrP+C1KOQqiDZlqTk28W3gmpqr369iBg3ooi1ZJZTEQh1/y1Cx
	 6N+tYX7DTlT4bcyuFt1DN7AQbF6bdiKV4fVdYPig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Hungyu Lin <dennylin0707@gmail.com>
Subject: [PATCH 5.10 137/389] media: tegra-video: vi: fix invalid u32 return value in format lookup
Date: Mon, 17 Aug 2026 15:29:36 +0200
Message-ID: <20260817132544.495928469@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hungyu Lin <dennylin0707@gmail.com>

commit d5b50055338e131a1a99f923ebb0361974a00f36 upstream.

tegra_get_format_fourcc_by_idx() returns a u32 but uses -EINVAL to
signal an out-of-bounds index. This results in a large unsigned
value being returned, which may be interpreted as a valid fourcc.

Returning 0 is not a valid fourcc either. This condition should
never happen, so use WARN_ON_ONCE() to catch unexpected out-of-bounds
access and return a valid fallback format instead.

Suggested-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Fixes: 3d8a97eabef0 ("media: tegra-video: Add Tegra210 Video input driver")
Cc: stable@vger.kernel.org
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/tegra-video/vi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/media/tegra-video/vi.c
+++ b/drivers/staging/media/tegra-video/vi.c
@@ -76,8 +76,8 @@ static int tegra_get_format_idx_by_code(
 static u32 tegra_get_format_fourcc_by_idx(struct tegra_vi *vi,
 					  unsigned int index)
 {
-	if (index >= vi->soc->nformats)
-		return -EINVAL;
+	if (WARN_ON_ONCE(index >= vi->soc->nformats))
+		return vi->soc->video_formats[0].fourcc;
 
 	return vi->soc->video_formats[index].fourcc;
 }


