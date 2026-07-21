Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1384418DB;
	Tue, 21 Jul 2026 22:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672274; cv=none; b=l2m2Y+334DtmotgZkc60IbAYah2IrN8tsiCkmxTueRJRtwq1iU5F2j+lBnTl2RC051K+yXKHZhhrhRsaDaEqJdZhAOeqb5hWAM2n6X8O7MDAG8kXW+ID0RQqDAbG1AqM3xo+1U+q73OlFSKmyOFMvzeC8Le9aedzCpQFEYJoHaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672274; c=relaxed/simple;
	bh=BGrijnF1e2KASaK++Y6m+Zipetike/XepuTuNSPPMG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldTp4n1LKpLXHpHBCPwhN+gS+QAOWtYKHTy/NiLBrYj9HdN7hkAir3lmKOKofwFC1I4mSefhdIyxZi4T/XsT5eUMPsABBd3XIv4yCfl6IaqCP0yphePdwZxIp6idhpEEs6yf7o0TCM7v6RpYQDQzHxlR1R7kYHkCC6T5zwfIPmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0d7LCkE0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0d7LCkE0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34121F000E9;
	Tue, 21 Jul 2026 22:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672272;
	bh=V1MdHNVAOMfUg8cvnWBKjbgaIZGqQ5eSOP3SAgUuv58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0d7LCkE0/wLqzjcYrIlOIYYTVt6W5i1lWXEmBcUEnSCYHXA7OCd+UTwMo8P+M1lHU
	 CJRBLrGHbR9zBB37ocZzl6njLPxoSgk4fvMc9OJx0VOLN6U6gT4DNmREMSz64M2Cgg
	 SqhjCs0ylQroc8YFwLX81r+Nbu6sNWvSNc+UcSCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 562/843] fbdev: hecubafb: fix potential memory leak in hecubafb_probe()
Date: Tue, 21 Jul 2026 17:23:17 +0200
Message-ID: <20260721152418.692948286@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit cbef2a305a8a72969b86f96b7c07b86edde61aff upstream.

The memory allocated for pagerefs in fb_deferred_io_init() is not freed
on the error path. Fix it by calling fb_deferred_io_cleanup().

Fixes: 56c134f7f1b5 ("fbdev: Track deferred-I/O pages in pageref struct")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/hecubafb.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/video/fbdev/hecubafb.c
+++ b/drivers/video/fbdev/hecubafb.c
@@ -253,7 +253,9 @@ static int hecubafb_probe(struct platfor
 	info->flags = FBINFO_FLAG_DEFAULT | FBINFO_VIRTFB;
 
 	info->fbdefio = &hecubafb_defio;
-	fb_deferred_io_init(info);
+	retval = fb_deferred_io_init(info);
+	if (retval)
+		goto err_fbdefio;
 
 	retval = register_framebuffer(info);
 	if (retval < 0)
@@ -270,6 +272,8 @@ static int hecubafb_probe(struct platfor
 
 	return 0;
 err_fbreg:
+	fb_deferred_io_cleanup(info);
+err_fbdefio:
 	framebuffer_release(info);
 err_fballoc:
 	vfree(videomemory);


