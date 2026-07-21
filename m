Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A1243D502;
	Tue, 21 Jul 2026 21:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669924; cv=none; b=hA0fVmvHo9AEEyJDvukvkWtuZqcZNutGJLgskuWWx9CH8wuYt6EYVv22VhBihiiHqC/mlFnzhaiGRx0OBWFUG3i1g9yVQ2jPamkzkKO+Pyh6O+asqtLjQ3982Gr8HtVen7DyNWwgrFMBKUATTNyuGa2qmx7/FgF0jzGaKxX5NiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669924; c=relaxed/simple;
	bh=QaDrtNDNTtSMIKG7DIMNud2DIN7wEkAzmvi7q11ulu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJZ5GcoMX8AmWCnbPUlBJUHZy8horeL9IdIx+mWppW0bV3alw7yy2xsHCQaQEcI0pJewQqHIk0jMy0mneeUdFE5m1ALqAMA+eeFTLvISsNRRlpevrDFGk0m5QDPeg4CYp/YO9Q+gO3b9MVoetwAXZFSYverAXH4+P01hx23gMj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qr8+xA71; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qr8+xA71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A714F1F000E9;
	Tue, 21 Jul 2026 21:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669923;
	bh=BhI3hDAyT756dNiOWeMlnV2zgKxrIY6Cg8gCxadaDW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qr8+xA71IZiwz4rmRa684Bj2Q2cdX5BD/y50VdPjpXqeZdLnR8GyysghDgWAQRDwm
	 RIyHJi7nwcJ3KMx6LBbJAbfik6MBaKnkD6fJl9evRrNFTeSzbR7VPw6DmtiNmY+EFX
	 74cPD2BsjhqnilJbK9NgevgQ+U+Ajl/iCyU/veDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 0737/1067] fbdev: carminefb: fix potential memory leak in alloc_carmine_fb()
Date: Tue, 21 Jul 2026 17:22:18 +0200
Message-ID: <20260721152441.069522466@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -593,6 +593,7 @@ static int alloc_carmine_fb(void __iomem
 	return 0;
 
 err_dealloc_cmap:
+	fb_destroy_modelist(&info->modelist);
 	fb_dealloc_cmap(&info->cmap);
 err_free_fb:
 	framebuffer_release(info);


