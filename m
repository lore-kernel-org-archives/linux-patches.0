Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3832F35F5F7;
	Thu,  2 Jul 2026 16:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010131; cv=none; b=iz6CP77MapN4TZMEAd1XIIYQ9qrYf+NTJ1VxXgq7AvQyv0B31HnhvUmRdAcIzKWA63afbFaKzapJASfpKVYmMr2O1Vg/53uN81oCDl2Oc5KxwJNrsTl8Vy0MlNdvvxQMdVD8JQexTZ5i59yte3sgpBFbJy/sMbhO4kEVvVBFQ5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010131; c=relaxed/simple;
	bh=AOU+dHh6rsQ4P1g8DPFIJyrQzt2lD6S+X3xb3vn7/Fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJiwe+BxMcopvt/HIZBQgI2uV7hRmkiuynRMbz6yMvj5SnKsET5QNJPf7QYzmahPe+9LdaDmGl3WPgBW6LYmWDWacHXXtRne2XyMtl2vf+u117WlCfmVEdV++aZyBR1vqyhMchrlyzw8A1TEu2aqWKfbjwVgt59n596xelaALJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v8/rGbBl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v8/rGbBl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9CA1F000E9;
	Thu,  2 Jul 2026 16:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010130;
	bh=oGU5bMqJqfZ1lmEQFAkmRHvlyHu9TOpNEmwRIpOMK+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v8/rGbBlHBIA2ZF7ZebHd/AdwkXtH0M7SmvnX1qtqp6tZEZv1KzSuH7F3WkvYR7ZB
	 jvEbnOANdZ/PBJz9xO8DR5usjiKc44KdcZsR35e6DJTamgnhOVUhAo83M5VT0MhFgv
	 5cPUsW7l7ZsYKsV99Iek5NTfQf2nni4gtcDIfZao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lei Lu <llfamsec@gmail.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 123/129] fuse: re-lock request before replacing page cache folio
Date: Thu,  2 Jul 2026 18:20:42 +0200
Message-ID: <20260702155114.695053163@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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

[ Upstream commit a078484921052d0badd827fcc2770b5cfc1d4120 ]

fuse_try_move_folio() unlocks the request on entry but does not
re-lock it on the success path. This means fuse_chan_abort() can end the
request and free the fuse_io_args (eg fuse_readpages_end()) while the
subsequent copy chain logic after fuse_try_move_folio() accesses the
fuse_io_args, leading to use-after-free issues.

Fix this by calling lock_request() before replace_page_cache_folio().
This ensures the request is locked on the success path which will
prevent the fuse_io_args from being freed while the later copying logic
runs, and also ensures that the ap->folios[i]->mapping is never null
since ap->folios[i] will always point to the newfolio after
replace_page_cache_folio().

Fixes: ce534fb05292 ("fuse: allow splice to move pages")
Cc: stable@vger.kernel.org
Reported-by: Lei Lu <llfamsec@gmail.com>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -839,6 +839,10 @@ static int fuse_try_move_page(struct fus
 	if (WARN_ON(PageMlocked(oldpage)))
 		goto out_fallback_unlock;
 
+	err = lock_request(cs->req);
+	if (err)
+		goto out_fallback_unlock;
+
 	replace_page_cache_page(oldpage, newpage);
 
 	get_page(newpage);
@@ -852,20 +856,7 @@ static int fuse_try_move_page(struct fus
 	 */
 	pipe_buf_release(cs->pipe, buf);
 
-	err = 0;
-	spin_lock(&cs->req->waitq.lock);
-	if (test_bit(FR_ABORTED, &cs->req->flags))
-		err = -ENOENT;
-	else
-		*pagep = newpage;
-	spin_unlock(&cs->req->waitq.lock);
-
-	if (err) {
-		unlock_page(newpage);
-		put_page(newpage);
-		goto out_put_old;
-	}
-
+	*pagep = newpage;
 	unlock_page(oldpage);
 	/* Drop ref for ap->pages[] array */
 	put_page(oldpage);


