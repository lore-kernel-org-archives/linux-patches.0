Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3CF36212F;
	Tue, 21 Jul 2026 21:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668631; cv=none; b=p3UkHcWnKbzmamkA/3fXlVdG/ylYUX1xZKrRtKSvBSqxyxNUGEwi17xoN5x7+rp/A8GkaS4ssHJIbnvkqdajxg6Nfd+EjtY6Qd74JdP2Q9Tl6gBt+5UcmUeWBD4jfa7KndTp/w1l9uPb2UiRjNnoXmOdIhwSN8Q/7RjTEZDfs+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668631; c=relaxed/simple;
	bh=udgjFbfMSB3X9/ze6i1sSpJpRWgvMC2uXSIzj/7atPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTBn6kAXscnZD/G9QV3+7RMaLIXYyYRDrUck9EnvdPxNonXHQJP5FGVCDkS1v3t9W8GUpZCFVfPdu4QEPMZXsNOzXf5rLg9s7/rpI6RMbswXmSS4oKLlOYg2OCls6HdLWb+SZzNWfrbbAKLvnYRBqkAELdGfl1odMUQBXtEptZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JFfJ5FKt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JFfJ5FKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B341F00A3D;
	Tue, 21 Jul 2026 21:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668628;
	bh=vPTr7f2tL55rjwDl6Jcq7uqATWhpj65lvtOgtnZbAZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JFfJ5FKtXH+doOSqEDlcr9H0zuj+kX7SPnypdAbbZFIiHW0qJV++RA11c6PCCzVDi
	 0hGYqC0fi3/m58+x8A23hVMoEpE7/mr/lb+FUhX/WFoGxtnHwQwhWfBdaIgHSuDwSY
	 DBomuxJkipwecfEHYX5JNAHJGi0Z5SZ8+z9vd7iU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.1 0249/1067] fuse: re-lock request before returning from fuse_ref_folio()
Date: Tue, 21 Jul 2026 17:14:10 +0200
Message-ID: <20260721152430.167592600@linuxfoundation.org>
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
@@ -908,7 +908,7 @@ static int fuse_ref_page(struct fuse_cop
 	cs->nr_segs++;
 	cs->len = 0;
 
-	return 0;
+	return lock_request(cs->req);
 }
 
 /*


