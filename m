Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39534CCDC0;
	Fri,  9 Oct 2026 14:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556974; cv=none; b=Oebbig+BgSbsKhcvQ5qt5VI1POrDJUyPqG6gG3tUDnR79XwsxXE4t2YdSTo0oMs/G5GXXe9HLk2s+nzJpkcRz1Qz1ExDD0I8gqrnmprynXbelO4iW9qDMnlgW+b/nmB5ZsmV2Z/xit6ShlQ/G11fbOjT42LfRoRJsKRlRn40Aos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556974; c=relaxed/simple;
	bh=4C9KkHBppr6Kj4pDlZ5SDAzfOTE2xH9p9CuheCuDeHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OoNv6ptLHTasXBXG41P7EUXJpbrSgM55Yv4HdXzPFpPzA3n0xqMzfro1hpytNDVExBK/ppD2Org51gUG8tRtgwe4x9RT2uKIb3SDEd/s9QNF7Dp6aoRxfNBRjpEIcMtthJ3VEtjcb/uGybJmI3EWalxb2ywR/ynhhoFSFd+uWkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xPZDMtWk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xPZDMtWk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F361F000FF;
	Fri,  9 Oct 2026 14:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556973;
	bh=Qu+7PLHZKmdtsB63V9+QFvGpXgjz38myI6onHUC2Zf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xPZDMtWkyLB+u6PvxlSy+cHIIOGC73Kg7Q2JX2U/8ZlUDrfwiCrNuG6eLjBxkFL5x
	 01+dhDnMMEi4+ETi/vo0ImwaZUDJnnHyD+d+bv9+XD5ANkzJ1+wEiNDTt5/UkF03gO
	 L58zDeupnOTi5M3SInrvGaXm4F7/JFFxySbfWZo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinh Nguyen <dinguyen@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 7.2 276/428] EDAC/altera: Fix memory leak on dci allocation failure
Date: Fri,  9 Oct 2026 16:10:13 +0200
Message-ID: <20261009140952.156134677@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dinh Nguyen <dinguyen@kernel.org>

commit 3e4a10a4718e3d963ee4d6c5f26bc5ad57c1d2b1 upstream.

Sashiko reports:

"If devres_open_group() fails, the function returns -ENOMEM without freeing the
dci structure allocated earlier with edac_device_alloc_ctl_info()."

Free the dci structure if devres_open_group() fails.

Fixes: c3eea1942a16 ("EDAC, altera: Add Altera L2 cache and OCRAM support")
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org # 6.18+
Link: https://patch.msgid.link/20260911120627.2634225-4-dinguyen@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/altera_edac.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -1515,8 +1515,10 @@ static int altr_portb_setup(struct altr_
 	altdev = dci->pvt_info;
 	*altdev = *device;
 
-	if (!devres_open_group(device->edac->dev, altr_portb_setup, GFP_KERNEL))
+	if (!devres_open_group(device->edac->dev, altr_portb_setup, GFP_KERNEL)) {
+		edac_device_free_ctl_info(dci);
 		return -ENOMEM;
+	}
 
 	/* Update PortB specific values */
 	altdev->edac_dev_name = ecc_name;


