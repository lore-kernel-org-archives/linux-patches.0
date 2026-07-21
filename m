Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2AE43E066;
	Tue, 21 Jul 2026 22:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674177; cv=none; b=gCB43j5R27ivQPE6x/kpU7AfbnASrgWv3jx9Wm6ltswluejXK8eTet9fm8+8AZaS4hnETW+u4dC45n8F9kedtbRUeiEEp/ln6D6ZFoMGvUbL0KJe90UeLX3v7Fan4YD36GjKIZ2p7pnImazTz2VOaHse6MfF59tiGbzdmffBY1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674177; c=relaxed/simple;
	bh=TD0JXf14YSVJF1jKj1RnTi4bH8DnjmvdX1E/0KWdVNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0QICwyvkFvhOZi7v6LHJZcRzajqG8Wx23wN66pr8hhSvBwksPKudE0kxsskHd/uZG/sp0NWlI2bC8Wa+ig+IXeJbKfACjT3jpen8vnf2OhDoM9gBO8OuJwaLspicC+RmABLfFZd8Ds7pwFjx8d61lJoybweEySE6s27dXCBbps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DcRPDWyd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DcRPDWyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EEE31F000E9;
	Tue, 21 Jul 2026 22:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674175;
	bh=nmzANFVkgjAk1VjaxH+00j1mad4Y/zgCIkhhXpeul08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DcRPDWydjZTD6+fQgXmlKUDu9egtNzatO9jJ5rqiI27QsHKooLY7PUWONwbNnyVQB
	 KOJU2Eru6GP9P+w0rWCWLj2x9cRrOzwevNFeiVDAF0f9IyK0D9psa9KTZeHxZIYxxL
	 TKgc59GxM4jmF1UodZnMJDEx+giBc0lPlWO2oxio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 441/699] fbdev: carminefb: fix potential memory leak in alloc_carmine_fb()
Date: Tue, 21 Jul 2026 17:23:20 +0200
Message-ID: <20260721152405.646323692@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 6fcca16a2b19c37f60693c56cbc0c923364ff3ef upstream.

The memory allocated for modelist in fb_videomode_to_modelist() is not
freed in the subsequent error path.
Fix that by calling fb_destroy_modelist()

Fixes: 2ece5f43b041 ("fbdev: add the carmine FB driver")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/carminefb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/fbdev/carminefb.c
+++ b/drivers/video/fbdev/carminefb.c
@@ -592,6 +592,7 @@ static int alloc_carmine_fb(void __iomem
 	return 0;
 
 err_dealloc_cmap:
+	fb_destroy_modelist(&info->modelist);
 	fb_dealloc_cmap(&info->cmap);
 err_free_fb:
 	framebuffer_release(info);


