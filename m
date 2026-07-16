Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67283F482E;
	Thu, 16 Jul 2026 13:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210273; cv=none; b=IO36ncY8jH+zIBk+ZCrOEi5wdcErE/z9IVR8yCcSivLIB0Xei2ywOVRc8HJL2lYSN6chA0BmBOKmCsrTqlm5duc/Dzs632/KIcxLMhwyoB42Q5v2YuTia0NlRomHsi6V1rfoyTm6soaVwRR2QtK1jfscMT+S4FusW18yJGH8wzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210273; c=relaxed/simple;
	bh=bv00j21iesOYEmifb2JUpYTJ3M2eH1/VMGnzd2tEwNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EF9pbOle7AzgkWHQH3uztxxHOYnG+CFVlz/JIvkocspWX1pgr8soAPEhFHKc2s+CI7prf6SMqLC7W9Xtw+EfxgMsYBI0LtvPcocO2sjCS9bFTBiDrbyzFFlzGPB8iGSN1M92pHu1IABVsI8LHa0SWHjWAu7v/fSQp6ePKqGdR8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JXiy7ZyA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JXiy7ZyA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575FF1F000E9;
	Thu, 16 Jul 2026 13:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210271;
	bh=nxxxZSuNcN+QvjZ61o27JB4/xql1pEwIiWLb7CDWQpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JXiy7ZyAcx1J5pne30bWagX1ZlfORopYEOAgHhc5JvTC4xH+1QAYNzrmU38cjLHkr
	 kMrPUp/MdfRQapSzipObTPsm0zZuMOAqgjOmbQFAwjlKqFGUMbR5aaHSkRH8FFx34B
	 1SnBE2Xu317E0NRxWOj8jrOvygrzhQ7l60CQlCrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 7.1 504/518] fuse: re-lock request before returning from fuse_ref_folio()
Date: Thu, 16 Jul 2026 15:32:52 +0200
Message-ID: <20260716133058.868354887@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

From: Joanne Koong <joannelkoong@gmail.com>

commit b5befa80fdbe287a98480effed9564712924add5 upstream.

fuse_ref_folio() unlocks the request but does not re-lock it before
returning. fuse_chan_abort() can end the request and the async end
callback (eg fuse_writepage_free()) can free the args while the
subsequent copy chain logic after fuse_ref_folio() accesses them,
leading to use-after-free issues.

Fix this by locking the request in fuse_ref_folio() before returning.

Fixes: c3021629a0d8 ("fuse: support splice() reading from fuse device")
Cc: stable@vger.kernel.org
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1106,7 +1106,7 @@ static int fuse_ref_folio(struct fuse_co
 	cs->nr_segs++;
 	cs->len = 0;
 
-	return 0;
+	return lock_request(cs->req);
 }
 
 /*


