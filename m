Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1E846A5F7;
	Tue, 21 Jul 2026 19:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663497; cv=none; b=HcbcLMtm+ckGDckvFVxWIUMF/fOWGgrQZglxrCoqt1f8xpDjQMs+3nfgEl/NHFPikzrBtEoqlpA/X1eYkFGI2uuqlt0l2jzCuBjCVOPjy62eja03GhrRtr1OsA15DJZvm3S1VwvT0YXEpoHHCNoNCvQO9Az8zXLS4b/0CnDgiOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663497; c=relaxed/simple;
	bh=jq7mYGy/6RivQGjr0ZtfF3nrUSI5Qs5f2YxZjwgwYIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+s0pg3SJ/fy2HeNfSxy4LRL1KGqLJhvoA8tR4uowbGQBYpcUQ3gYkHuVTq663aTiegjOaoZDJhQl0qmlHxAb2y73Oj8A9zKmtncrnawEluv1QU0khw18nqrD8jTbG5YKolxIvw3LpFmIN10FTULnMTH47y6ErxNuXLojP+sNqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hHBvBrCE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hHBvBrCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F3F1F000E9;
	Tue, 21 Jul 2026 19:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663496;
	bh=iFsgwAJSMTHUdHF9BUJUuznA9BSzJTPMotbQPYJvvxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hHBvBrCEYHo8OJ+N1pjH11Jll0IleKrL+QKjlKOVpgMkrZ6OGV4Pw/l1b1v/Er5qJ
	 cTi5ES/IPgb7iPo0e2mGxC/MLFegZyZJYPMfXP2qVdhXF9zDUhOoa7bJjnPlh5Ns7i
	 4ntq5iWX7f5z2j4ALL5aytelNPvo+y7EYJDoAM5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 0846/1276] fbdev: uvesafb: fix potential memory leak in uvesafb_probe()
Date: Tue, 21 Jul 2026 17:21:29 +0200
Message-ID: <20260721152504.986054654@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1697,14 +1697,14 @@ static int uvesafb_probe(struct platform
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


