Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3611F3D56;
	Tue, 21 Jul 2026 17:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654133; cv=none; b=slmz8lyEZtUMZItlWKG3WRQ5GOXEy/EsZz5pQi/Cqr50ZHtNu0wn5cw+Y7ndN4DYeb58GNn9/JXNVcp7fnJpbvDtbJBMe/JOVTe6iy2KASLCsO6JWrYA0bHwKEU6Io5mCoDmVHo5gm5N3mELivatVBltYkGJ8K4foKhsoVpTA/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654133; c=relaxed/simple;
	bh=pmdtKWCTijun5EFes5MaeLZ5ZBQ16pRe2UkP4z259og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxROEM3qbNTJ0dosJdCZaEqE/RqX6lz9miZ3GUKYmj7tN45xh2lFvKz+6OPh3P+MK4VsYo1hSdXSkp2JGNTatJ5//4MAPuuOL5z1dFTG6zFXSk9b/fmymV89T43QugypCce3J+9KDNQ0vMWt90/r+cOQDVq16CaUbYIXZRdD3zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DF/vCSM7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DF/vCSM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683481F000E9;
	Tue, 21 Jul 2026 17:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654131;
	bh=AxvGeU+D2g6RPXtmFGYgPvAlJQkGVdYzZCC407JHbDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DF/vCSM7OrqEZGjW/2pHy5GpF97IT/G4JZkkMFUlMgGSD2rCj/stxXKgVlVNEqIY4
	 2pCZ+co/KeRzKbC9xsntkEbdqsWX5QXuxSU+3tSi8gUIMC7mZ+nFYbNuW7mHV1LEEu
	 OP1CjXblPT3IsGIyUo+aRs3HAj/qrUabV2Xh18FE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.1 1589/2077] fbdev: carminefb: fix potential memory leak in alloc_carmine_fb()
Date: Tue, 21 Jul 2026 17:21:02 +0200
Message-ID: <20260721152630.250767668@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -589,6 +589,7 @@ static int alloc_carmine_fb(void __iomem
 	return 0;
 
 err_dealloc_cmap:
+	fb_destroy_modelist(&info->modelist);
 	fb_dealloc_cmap(&info->cmap);
 err_free_fb:
 	framebuffer_release(info);


