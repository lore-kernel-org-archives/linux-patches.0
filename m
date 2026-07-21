Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F0A43C7DA;
	Tue, 21 Jul 2026 22:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672295; cv=none; b=V9cGm4VG4LxJDyFea/k85o/xYt8OQRm4Q/rkOObBhiJTUxinSMpnFuetDIAGj2N4Pb5ppkJSzNGbr7Dv/rkkiGv8upRnMkqqfXZZ0LFORJdAERXOS9CEyw5A5kOIHLzMfegoDQ1FnwcwTsuaB61M9DYkNc0HYRyqP1l0WmEAl8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672295; c=relaxed/simple;
	bh=WjWRIuAU/v52L+9K3jlr1/kaGC3D31fB/eDvIDOchl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdVwvfVzKsBKnUyvVakbZery9YLsNzQ2FdzfapOxy9nu3PvMvbPVD0Aj4LkCmRq7SHpcGwotpfUCaVdMuH8DrEltra/GJjHDs/ueorlWGJmkChlbf4PXKpEvKXzFe1z34P4DBqAZwxb9/vuJ0i5dV9FklSe2kgiXz64E3n4SSPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fFkjmR5g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fFkjmR5g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01DD61F000E9;
	Tue, 21 Jul 2026 22:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672293;
	bh=aklStJhYnaVzEA2woLo5r1iyq1jy59JKogS3bYL+gQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fFkjmR5gm8c31Jw/xGRCg7LF/S6fkVy6fQHrs7/fnf5sCivyGYw1hVSLRlKw/NWi0
	 /duT9OKsx3TzTyhrahKTmZvjV2H1M35Vzb9yQTr5OkvFEeuVfP+snFpHnM3qQzmgbU
	 0ysWXeEmiRRLTIxvHfXFZePJeYG4PUcj49tYvfe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 569/843] fbdev: carminefb: fix potential memory leak in alloc_carmine_fb()
Date: Tue, 21 Jul 2026 17:23:24 +0200
Message-ID: <20260721152418.847164987@linuxfoundation.org>
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


