Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63ECC2EDD7D;
	Thu, 25 Jun 2026 13:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392994; cv=none; b=E+S6JKh8Ajccby+ULN4h/IMx3lcSFrgQ8LTJT5k8CTDGXEO4WR1M+O875ZSofPrJjQnBQgkDIHi5rvUHXDsa1ikwV0DqxCC5NHo7OkT1td3MSAi647eu2S1oPZa5iIzeIjrWVN4VKsrsPvX66mSJxhnDqOZxcdXjNLU6/sPMTg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392994; c=relaxed/simple;
	bh=m8qUzYLItjkvt9z/kmyNhCpy8lF1CXAZ3cPG+IaHaOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fTN+gmlJfl7TWLgJdnx8e9XEo6/RAFXv+/TTON+sVmxZ53hytvyMQQHfp5rSnAxiSagnyHyiih1bC8k4Wmu2zokHSIy8hoqRFKvsiynk49LrOzdJ/xw5Sj3g6NT6yjmoW1tn8qYOjckBe4kUa2SyOa/q9OkgMB5sB1rz0XFBz7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GwQ/2+SR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GwQ/2+SR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108441F000E9;
	Thu, 25 Jun 2026 13:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392991;
	bh=1AIzNGT3WzZhr5iBlOT0p2KL9kgQ+L7moLJUsg4oW6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GwQ/2+SR9Qv6F+a1DBYlWiLin4shB4Vz7vR7Ptypf2KAmYWkblLUuZenQPYHmdVUB
	 Fshm25/HQzTZ8sTvzuqUqCDMl9gd4hvXz1ufY6nkCQgq22/Bmlqefz8JdOXsRgD7ab
	 HzrPw4Y4gsBdNK1YBiraSIlda98yOBCnfWZ+6Pk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lei Lu <llfamsec@gmail.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 7.0 09/49] fuse: re-lock request before replacing page cache folio
Date: Thu, 25 Jun 2026 14:03:21 +0100
Message-ID: <20260625125638.806582985@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
References: <20260625125637.527552689@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joanne Koong <joannelkoong@gmail.com>

commit a078484921052d0badd827fcc2770b5cfc1d4120 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1037,6 +1037,10 @@ static int fuse_try_move_folio(struct fu
 	if (WARN_ON(folio_test_mlocked(oldfolio)))
 		goto out_fallback_unlock;
 
+	err = lock_request(cs->req);
+	if (err)
+		goto out_fallback_unlock;
+
 	replace_page_cache_folio(oldfolio, newfolio);
 
 	folio_get(newfolio);
@@ -1050,20 +1054,7 @@ static int fuse_try_move_folio(struct fu
 	 */
 	pipe_buf_release(cs->pipe, buf);
 
-	err = 0;
-	spin_lock(&cs->req->waitq.lock);
-	if (test_bit(FR_ABORTED, &cs->req->flags))
-		err = -ENOENT;
-	else
-		*foliop = newfolio;
-	spin_unlock(&cs->req->waitq.lock);
-
-	if (err) {
-		folio_unlock(newfolio);
-		folio_put(newfolio);
-		goto out_put_old;
-	}
-
+	*foliop = newfolio;
 	folio_unlock(oldfolio);
 	/* Drop ref for ap->pages[] array */
 	folio_put(oldfolio);


