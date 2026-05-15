Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D08720297C;
	Fri, 15 May 2026 16:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862222; cv=none; b=k1pZcOD1sXkUqGd8Qj3WEV2etmSnwv6GuklTdlzkcIGzE8wdGdFSrFdBMH+BHi36us2UplCZkVJkHcBu9kTtHDHUrKcjuP7+bxIISgXJ8SbJzG/XBpaDxjm0CnNJ6BUIKOhuLtl+fporJQa2wjIHVtP7D351o/Q8kQ2f7fRSKAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862222; c=relaxed/simple;
	bh=N+KNjdhU7abRwoQOV4SpYvqCuDqnrHCQyHeJnD8zzL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LASruufr6SFe6NuZ6NQQbQcgPyKldNwlOOKTGGtjHGoRU11GCxIS3Hd1vgEgJ4U0MtpL7tgopla4lyizifdN4Q3SQ9fNlEoc5HSeyaRwbqoswGQLWsjpuRFVfpXW2FD7xU34mhEp2fjdHsj6juM/F66iUMJubvDmCIxWEVv9TTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j3g7fl4U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j3g7fl4U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82CFC2BCB0;
	Fri, 15 May 2026 16:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862222;
	bh=N+KNjdhU7abRwoQOV4SpYvqCuDqnrHCQyHeJnD8zzL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j3g7fl4UgXwSBPA3oqTF5iZRr6V1IJv3X1H5GSY+u4YB7xvStqkvnnpJaz1N2XF3S
	 38J000NEmweHYwRBnXdPfb5KPNYpvf3nyaseIG5tOiM16xN1tg1KPDtWYLHigZDYk/
	 +Oqfldt+wjAEa01rWUjMqv9EcGwMtvjKBo4mXhX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	soopyc <cassie@soopy.moe>,
	Sasha Finkelstein <k@chaosmail.tech>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Aditya Garg <gargaditya08@live.com>
Subject: [PATCH 6.18 113/188] drm/appletbdrm: Use kvzalloc for big allocations
Date: Fri, 15 May 2026 17:48:50 +0200
Message-ID: <20260515154659.781487940@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Finkelstein <k@chaosmail.tech>

commit aaaa684bab1f6d9ecfc49db328facb1771fd0eb2 upstream.

This driver is attached to a ~2000x80 screen, which is a lot more than
a single page. This causes out of memory errors in some rare cases.

Reported-by: soopyc <cassie@soopy.moe>
Closes: https://github.com/t2linux/fedora/issues/51
Signed-off-by: Sasha Finkelstein <k@chaosmail.tech>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Aditya Garg <gargaditya08@live.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 0670c2f56e45 ("drm/tiny: add driver for Apple Touch Bars in x86 Macs")
Cc: <stable@vger.kernel.org> # v6.15+
Link: https://patch.msgid.link/20260420-x86-tb-vmalloc-v1-1-7757ff657223@chaosmail.tech
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tiny/appletbdrm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/tiny/appletbdrm.c
+++ b/drivers/gpu/drm/tiny/appletbdrm.c
@@ -353,7 +353,7 @@ static int appletbdrm_primary_plane_help
 		       frames_size +
 		       sizeof(struct appletbdrm_fb_request_footer), 16);
 
-	appletbdrm_state->request = kzalloc(request_size, GFP_KERNEL);
+	appletbdrm_state->request = kvzalloc(request_size, GFP_KERNEL);
 
 	if (!appletbdrm_state->request)
 		return -ENOMEM;
@@ -543,7 +543,7 @@ static void appletbdrm_primary_plane_des
 {
 	struct appletbdrm_plane_state *appletbdrm_state = to_appletbdrm_plane_state(state);
 
-	kfree(appletbdrm_state->request);
+	kvfree(appletbdrm_state->request);
 	kfree(appletbdrm_state->response);
 
 	__drm_gem_destroy_shadow_plane_state(&appletbdrm_state->base);


