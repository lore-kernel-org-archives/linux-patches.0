Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3243395243;
	Tue, 21 Jul 2026 20:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667063; cv=none; b=VWAkGaJCuMkITjgeLBFN8MC6g0x5m+0YofyKDrlYXDxmDGLiiN+426u0w1dhXIT4o0A8bkdVDHetS/QIA0FRCqA3+2JsnoiXzEgEXZxBmBWsw2vshGXaSlE7ls5K/iPbvlNJfi/x1AeBtq7BL/PZN0DV25xTqzaj/UkXfdymZEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667063; c=relaxed/simple;
	bh=+sLdSl+81fUsjeT9B4WlBkl7AXRmyEcV8KrrA3W91HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BfIafsDvvjh/ECKw/ZUvO2XTUpTsz+EKmrudVnsOhgLOarGmJufPxtaZOM/7TzvSWOLVGfPWADlWWUDR7W2iY8AqxcuZ1PU3yQCvIsSh4kPjG3z4NyspyTEIEGRV4lXr7WK3LVpnGahUoaoWnLn5zYtJJdXDx8PQB/vGkWQSC7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tTOrXKjp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tTOrXKjp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF31F1F000E9;
	Tue, 21 Jul 2026 20:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667062;
	bh=IrbCvoPcWmt0J2B+YUgGaFKVEpVn9MMB/n4DILJLIkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tTOrXKjpmdhrvULrTmvoU0Nlu0m4an1qp4Ba9fL/VOQ1/mRd6kCwvVY3YHUcPNEwO
	 H0bRzb8rJzXu90NQh+pxXCH9qYXYik0RNLQY+gS2b+SvKYG5OseNoaHqFClW45Ltsb
	 iYbqCTMRP3+kassVTcGXaWDO+I8l02igSArzFwuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 0917/1266] fbdev: tridentfb: fix potential memory leak in trident_pci_probe()
Date: Tue, 21 Jul 2026 17:22:34 +0200
Message-ID: <20260721152502.360620190@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 7a35ec619d9af8ee128320975c1252b8ad65f1e8 upstream.

In trident_pci_probe(), the memory allocated for modelist using
fb_videomode_to_modelist() is not freed in subsequent error paths.
Fix that by calling fb_destroy_modelist().

Fixes: 6a5e3bd0c8bc ("tridentfb: Add DDC support")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/tridentfb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/fbdev/tridentfb.c
+++ b/drivers/video/fbdev/tridentfb.c
@@ -1705,6 +1705,7 @@ static int trident_pci_probe(struct pci_
 	return 0;
 
 out_unmap2:
+	fb_destroy_modelist(&info->modelist);
 	if (default_par->ddc_registered)
 		i2c_del_adapter(&default_par->ddc_adapter);
 	kfree(info->pixmap.addr);


