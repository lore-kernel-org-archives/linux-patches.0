Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED7515B974;
	Mon, 29 Jan 2024 17:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548612; cv=none; b=R0HE2zcjV+vIfoigrBArQEz6jgF1nEtRbZB5QH4faChmP2nwtVCLg+q5LcztWEpd2YRDTzpZ7gyTjyfk9C8ntkhUiwz+wUlGvU+yvv4QsBzQd+meV6P1ioXeMbV/WRTxTX6LKJz05dM3TUc5QpH4Wpid6GE5uE0z1Q5zCFTkd0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548612; c=relaxed/simple;
	bh=bYxXDj7S1FmjMk1BWlSuCanWSO4C1Nb1YzzYMC/Dmfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CkOHVp7O5gOHeZQiInUlmUX1+t+eAWfyhFqRZCDOvlX7kGY/yI5bJUXrx8UrgDczJ7UNZ+InksuN14Ipf0MaAqQXZHpju3TOW7KisQZ8fMFOWSgomrDkyKGCMom9MBp5+dAVnppPBxaLYlrzlxO2JX225Gq5DIML6ohUYSOrScM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zSX3mWm7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zSX3mWm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86BE3C43390;
	Mon, 29 Jan 2024 17:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548612;
	bh=bYxXDj7S1FmjMk1BWlSuCanWSO4C1Nb1YzzYMC/Dmfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zSX3mWm7ElwjfUt8vctXEWTOgjsCGSxiJBGuy4/8g0oD2Vj9p6fUh6ZYEhgOLmOa9
	 qB1gxEZ4pTs9EWCuTB3aleXfBQpAdwQjav8tvmjnItLh6aH9K548usU25j+g/o3syC
	 gOVc3TSR8NagFeJTfhJUM2/ZevZ1Pg+++MuHHDA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Javier Martinez Canillas <javierm@redhat.com>
Subject: [PATCH 6.6 255/331] drm: Dont unref the same fb many times by mistake due to deadlock handling
Date: Mon, 29 Jan 2024 09:05:19 -0800
Message-ID: <20240129170022.351080707@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit cb4daf271302d71a6b9a7c01bd0b6d76febd8f0c upstream.

If we get a deadlock after the fb lookup in drm_mode_page_flip_ioctl()
we proceed to unref the fb and then retry the whole thing from the top.
But we forget to reset the fb pointer back to NULL, and so if we then
get another error during the retry, before the fb lookup, we proceed
the unref the same fb again without having gotten another reference.
The end result is that the fb will (eventually) end up being freed
while it's still in use.

Reset fb to NULL once we've unreffed it to avoid doing it again
until we've done another fb lookup.

This turned out to be pretty easy to hit on a DG2 when doing async
flips (and CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y). The first symptom I
saw that drm_closefb() simply got stuck in a busy loop while walking
the framebuffer list. Fortunately I was able to convince it to oops
instead, and from there it was easier to track down the culprit.

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231211081625.25704-1-ville.syrjala@linux.intel.com
Acked-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_plane.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/drm_plane.c
+++ b/drivers/gpu/drm/drm_plane.c
@@ -1387,6 +1387,7 @@ retry:
 out:
 	if (fb)
 		drm_framebuffer_put(fb);
+	fb = NULL;
 	if (plane->old_fb)
 		drm_framebuffer_put(plane->old_fb);
 	plane->old_fb = NULL;


