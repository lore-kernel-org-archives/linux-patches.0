Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC0446D2C7;
	Tue, 21 Jul 2026 17:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654138; cv=none; b=gZ5nENNVaFXQAjhbiVS4FBlCqrweEC737ixLjytcmVOd0YjL3UqQcJgQH/zyEwC5SdC/iFHEt2IbRLZlG0irs5qeDv5uzYq8cOj6ZzxbOMD9dSktwewlg3QoWv4EYobZgt4KDoIxNltL+uCDisZD6CvbnbEbFkoZvSNGkJMshcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654138; c=relaxed/simple;
	bh=iJB8KROhr8juWQRFoWV+h7f0bRc2p+j0QsYvgdfayRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fwi5qSY3qN8L32Lokk3ssafb2ix50XEPUPnuBnhkBBMJTInd3PqMMk5AJNkm53bP9651jcAOLaoVP6Ihl8W67/P90H8nyA+8iLzaUAJTd8Cq4GLyr1ERYHu58JxpVNtNC/yuGn4ZHZbbA3Bf8hmocNWYnEg1GdBkVN6Wg3lZGxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P+04kuui; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+04kuui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A482F1F00A3A;
	Tue, 21 Jul 2026 17:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654137;
	bh=jt+g545F48PSNg2csd0aUAGnqKvKpMMT3TdduIE9PIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P+04kuuioavRZIJp5odcfTtI+tbAYLM7vTxdkjS/jbPUv7578GTcm8I92y3FrxLwq
	 HpCqQNCGeW3326F+nex3hd6OZ3/J7XF6rAxq3AjeHTgi3PlZOoidzazJzGFOEs1CVZ
	 shFHqN3HgBgAMV5FIFNteo47JnTCDr8aLpOUeVd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.1 1591/2077] fbdev: nvidia: fix potential memory leak in nvidiafb_probe()
Date: Tue, 21 Jul 2026 17:21:04 +0200
Message-ID: <20260721152630.298450401@linuxfoundation.org>
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

commit 85f5e38c162bdf9dbbe197275d416402712f3707 upstream.

In nvidiafb_probe(), the memory allocated for modelist in
nvidia_set_fbinfo() is not freed in the subsequent error paths.
Fix that by calling fb_destroy_modelist().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/nvidia/nvidia.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/fbdev/nvidia/nvidia.c
+++ b/drivers/video/fbdev/nvidia/nvidia.c
@@ -1421,6 +1421,7 @@ static int nvidiafb_probe(struct pci_dev
 
 err_out_iounmap_fb:
 	iounmap(info->screen_base);
+	fb_destroy_modelist(&info->modelist);
 err_out_free_base1:
 	fb_destroy_modedb(info->monspecs.modedb);
 	nvidia_delete_i2c_busses(par);


