Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB80439322;
	Tue, 21 Jul 2026 21:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669919; cv=none; b=oOR7c4s7QUYmNRUWasC2FS+nQAkOnVWzo0ZPN6PaY9j0xrG2fMZbOlUc5hJjcs8L9LV0kyknEW9vI/YTrsUgaxBs1f2N/OU/vNrYX2HBHB82NXXYvKlLgIJ0g4bnfSekSP1+y9PmC8NEWOLNNLj4PzOjClQTQtaTPHK/ucZ51eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669919; c=relaxed/simple;
	bh=BJt5t3zWASkxYSpkEyGyOlxWlDiH7z46uHFkLUR565g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHkpyJ3VG8UJCsTyCFIHIr34D6+0dPQsafYsW7PTgtcp84xrS9ZUmI2qrFoHnHU6g9dkj01MHVMDKbpa/l60Wu/gof9KMCfeZKefmWffANyhJ7TRriS+D4HcEMbhoY679zL1fEVlj8J1fSlsPhjomAWMBS75D1EwihNhPNy4fjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sY//6rBe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sY//6rBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7561F000E9;
	Tue, 21 Jul 2026 21:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669917;
	bh=QpO8LS2G4me3ORUf7Hn7urLkzIyeYGkJAUc7igj7jn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sY//6rBeFKnVuDuFI2a4+22roARjit6BJeBtmmaTe+1TLtR2dRieniMbSfzMjeiqM
	 lCfjASiCtmPPUJ6gLUQ//RDFMuB+vJfVBwnLKR3C9VnKQV3uIq+ujRB2zQYne4MpG2
	 3ZcvArQqPFTBVyExp+HOLO6rbr9a5vu4/dhlDP0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 0735/1067] fbdev: uvesafb: fix potential memory leak in uvesafb_probe()
Date: Tue, 21 Jul 2026 17:22:16 +0200
Message-ID: <20260721152441.025936849@linuxfoundation.org>
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

commit 033e56fed09047ee63072e9f58789f40c1c7079d upstream.

Due to an incorrect goto label, memory allocated for modedb and modelist
in uvesafb_vbe_init() is not freed in some error paths. Fix this by
updating the goto label.

Fixes: 8bdb3a2d7df4 ("uvesafb: the driver core")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/uvesafb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/video/fbdev/uvesafb.c
+++ b/drivers/video/fbdev/uvesafb.c
@@ -1700,14 +1700,14 @@ static int uvesafb_probe(struct platform
 	i = uvesafb_vbe_init_mode(info);
 	if (i < 0) {
 		err = -EINVAL;
-		goto out;
+		goto out_mode;
 	} else {
 		mode = &par->vbe_modes[i];
 	}
 
 	if (fb_alloc_cmap(&info->cmap, 256, 0) < 0) {
 		err = -ENXIO;
-		goto out;
+		goto out_mode;
 	}
 
 	uvesafb_init_info(info, mode);


