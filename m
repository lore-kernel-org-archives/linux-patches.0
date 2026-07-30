Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825C537F8D7;
	Thu, 30 Jul 2026 15:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426313; cv=none; b=Zm/SaAwE9cTSqDVUD4nY9HW7xDaI7008dFKZsu0uNr+VvsfMTnez3ZSkhwzLgzao469RdsmUaE7WzzQvwfRZQqc0JOlGP9epuTmJW4zsc2u4+DzDqXiIcaoxh90Hiy+dB+v4B0osd4Ao6+6ygqg6AV0AbNf/3lVyf5MKr3z6t/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426313; c=relaxed/simple;
	bh=QBQqU9pUdrD6RLIAUNtIl0jZAT6Ollm95IeIeyTS1Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGdn2k0mibYPFh7rj1u6WLU7w4QnyiQ7g7MZYN5H20K97+ws4M3NlDU8HD/4i+sFi4P4IZReeMvNxdnoTrONf3tuD8OvLIXFSOKSLaPbMN094n7uOUUetrNvxOgPjZJe16++/MMWHSpgN7WPbbenAEuVcKKmQGLri9eXZ2fAvRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UkUCLkG4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UkUCLkG4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D419D1F000E9;
	Thu, 30 Jul 2026 15:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426312;
	bh=e/8qmB7w2/d9hGNMq6VvQe8bqfQNqaiDfk3pD88aGpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UkUCLkG48KyhV9KE9Voat69w6CQGucVEL9XXKqBMfgyXYIRw+vniBwCzpZxVZj+oi
	 HDxUEea+qAQG7BRtB9afSKjJ70R7+fofMx7MFM9+T+jAsvj03tA5Hv7ZQObRvJp5Zh
	 GG/FBivio7IhYpgwEUpMwZhlxXykFUJ9hR69dz7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Hungyu Lin <dennylin0707@gmail.com>
Subject: [PATCH 6.12 330/602] media: tegra-video: vi: fix invalid u32 return value in format lookup
Date: Thu, 30 Jul 2026 16:12:02 +0200
Message-ID: <20260730141442.897936449@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -80,8 +80,8 @@ static int tegra_get_format_idx_by_code(
 static u32 tegra_get_format_fourcc_by_idx(struct tegra_vi *vi,
 					  unsigned int index)
 {
-	if (index >= vi->soc->nformats)
-		return -EINVAL;
+	if (WARN_ON_ONCE(index >= vi->soc->nformats))
+		return vi->soc->video_formats[0].fourcc;
 
 	return vi->soc->video_formats[index].fourcc;
 }


