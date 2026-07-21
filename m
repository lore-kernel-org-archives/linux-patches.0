Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA3529CE9;
	Tue, 21 Jul 2026 18:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658480; cv=none; b=S/CVPpLKALZ9OuOvO3LiAZg/OURfiOoPTps8YUvEjX/VitJmJiSIavGnqPsOnSg+2BByfYu6NJdRyBaPteLn4LVzHWArbgBdbn7IvXBc+VW2FhqviVLkmXEOIJPjVDSwIBOuxga5qPVCGW3GeK3XXM++ay8mjnOI/lAAkGo92Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658480; c=relaxed/simple;
	bh=m/rX9VA8iIht5sZK3WPxmImnr6119CBa4fA/0vWgSgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqohVKJ5OTuRSbbhPI5UW+tYL3cL5bnoi5kIVNXOBHXYHyVBQpTwTcPJK5Gk5vNmV9gIYB4KOJe39cF92Sn+wTGmR8lJrP4oszJOseSWyxe4DrhiP3tNp7DvT0n71MB3ROJ4+yE5okttH13UcNXbKTVf5DrkASRSU38DJWs+Njo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vj/nF/00; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vj/nF/00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32541F000E9;
	Tue, 21 Jul 2026 18:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658479;
	bh=yDWZqjSzkWiUvSN48sU9ASvzX01qR7PcefDO1y3RZX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vj/nF/00zSPeIyjHaCFtJ5FH7TwCCxjljLsb4/kkxm1+6LdlUj1cH8789tyiX/Vef
	 wcJBXEVK3cg0XJqsUW8vdpF3xZwCU5F/JXqWQ2LgY+Ql0OkjLmhvhO//8/sRiSQcvH
	 P+zIQRW0jEQaEE1tnMaisQkBMRIpY7i2o+FjwWbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 1157/1611] fbdev: tridentfb: fix potential memory leak in trident_pci_probe()
Date: Tue, 21 Jul 2026 17:21:13 +0200
Message-ID: <20260721152541.446796617@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
@@ -1706,6 +1706,7 @@ static int trident_pci_probe(struct pci_
 	return 0;
 
 out_unmap2:
+	fb_destroy_modelist(&info->modelist);
 	if (default_par->ddc_registered)
 		i2c_del_adapter(&default_par->ddc_adapter);
 	kfree(info->pixmap.addr);


