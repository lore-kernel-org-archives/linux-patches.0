Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4233C73F6;
	Tue, 21 Jul 2026 22:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674185; cv=none; b=cuIBDzPu8tJblg5s1IqY5w82/NhaA+oa00yIOl01jH+5HScW0PvsDlfh5L7B92SPF/hZc4MIlpR4P6lIyUcCiuqepKtR3gEwQFzflq1gXk6ANBo+eyFqYZ04dI0+q4LA68jf5Ub+D8QmCMkUUKXt9Njpw4Qk3r1JrjkTuaLRfZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674185; c=relaxed/simple;
	bh=1hfW8Xy8zNPHYv4pBPe8nCgE/rIO0N0+KuHM9jdYWi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KWVnWSPJWmxk2OGb43EXHP3gmR0p5rp5Wu3oQJ/DvClYbOR6jAyA+Rv1xhVM51NZxkN6J8oO2H00O/jJ6P0YQ9jrOYtH39MrdyuqAPJAOK4754HQJEMDK/7PdqmPnPNRGJ/NjIOw2eQJtk7FgpQLz7eQivUGByh1++0txGrnMPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z2VlE1x4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z2VlE1x4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499D91F000E9;
	Tue, 21 Jul 2026 22:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674183;
	bh=pVass2edTdJ5fzNjxTSHzG6Y49CBQDW3Ktl8ko//ZK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z2VlE1x4r0sUNJnY8CBLhaNbe3n0fl6gZnCDkYk0V4G8yK2CzRjYU55Wnwn1sCVsC
	 CkV77vRuhj8G2P8zh4Cwb8bv0u0j4QwZSKiZUBF18cfgd1GqpdTkJVRRRJEHjF6g/s
	 qKYPkLcKlxOLWhn36vr+bjMVa3eo1Sx/jACKRrlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 443/699] fbdev: tridentfb: fix potential memory leak in trident_pci_probe()
Date: Tue, 21 Jul 2026 17:23:22 +0200
Message-ID: <20260721152405.693007777@linuxfoundation.org>
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
@@ -1702,6 +1702,7 @@ static int trident_pci_probe(struct pci_
 	return 0;
 
 out_unmap2:
+	fb_destroy_modelist(&info->modelist);
 	if (default_par->ddc_registered)
 		i2c_del_adapter(&default_par->ddc_adapter);
 	kfree(info->pixmap.addr);


