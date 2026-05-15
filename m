Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08BA3E00BB;
	Fri, 15 May 2026 16:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862687; cv=none; b=iZeyUxt+T5mNGxvuA9XHuLrkEGBqfIbfq9jInrC0MbgfWrouUeJHuq+GhE9+DK4stOZczZn5yttfx1TyBFIeDFbbmwxD2cRyrxEXujdk5tXaUjTePGRo/ZLbJEMwCvrtOnljF5AX0DpPNLfmuuFea5XuZc6TqGQdraiovL5h3ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862687; c=relaxed/simple;
	bh=bapABjObCYKQsOgTZvKv10MBPPlHbLyfyYo5Y3fEQto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V60j+1sjatU7YLCOEGU3rS6tyos6bEYbdLcFdr3S0Gt0iV+blHnFJQYc65ZcMjG7EFHaErpud5RvNjGckNlC16Wd12tSUS2XHXZI2ggkmcM20rKm/l30GIzmHNVgG/hI1nQTKNc2hlJgNA4jw0Elp4Wt++Iw2rEmja4A0yR5KmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JSRg1o5Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JSRg1o5Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E69C2BCB0;
	Fri, 15 May 2026 16:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862686;
	bh=bapABjObCYKQsOgTZvKv10MBPPlHbLyfyYo5Y3fEQto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JSRg1o5YNZAXcraRXiDaUYsfpbQy8LoAp4KV2YhvPiQsYCCZB8FGJiHN7DqxrtilI
	 jo2MHaPGrysn7xuvPMaM1bzvlEsw1+202eRvJ6G97eWEIvOcLzQB2r6sYcSd1CDcL3
	 o2n0YAw9uZyyPga1qFyfLA0ClkRnQ/NUr0PGLlCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	soopyc <cassie@soopy.moe>,
	Sasha Finkelstein <k@chaosmail.tech>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Aditya Garg <gargaditya08@live.com>
Subject: [PATCH 7.0 145/201] drm/appletbdrm: Use kvzalloc for big allocations
Date: Fri, 15 May 2026 17:49:23 +0200
Message-ID: <20260515154701.708607738@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


