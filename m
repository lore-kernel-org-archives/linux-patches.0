Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34992877F7;
	Thu, 25 Jun 2026 13:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392747; cv=none; b=CDbf9Wv3enT4re2Zl9BHpdj696dwpzReCukEvURNJ5TpdD2CAlGURgDlWoDS2Vjry1vifOlHWZm190C3tw24zyUaH0AGzVI5UTyJQRtd4ckhB3jMJh96uYxLjxjMqP8FhO7tc1eSrKp3zg3iFAl4lZaNw6bW6yQi7RrcPVoCyxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392747; c=relaxed/simple;
	bh=VFHBkdHxIs8RoVsuBlcA8snB8ABBN6di6917ny5wxBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPMJ2ldSDKZveIOO7IP1DDymnEbTAupxFZ68kjjhNPSOqg+18LFLhyG4GiRjQO3EjiAAP2IloM7A5W1Jtz5NY3ORpHmbeXfPRvZCbaBImg1APlT/aYjf32lk+x4T0WBfxZbK8wSHoQTPHVleErQrZ/9NVNV1PkoPKMgI4JV0Ey0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Px7PSRyE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Px7PSRyE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328691F000E9;
	Thu, 25 Jun 2026 13:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392746;
	bh=2PmSprQEO3VDkwSp7qEPqk1vBJIdgR9CUfqL9TftCH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Px7PSRyE7RJHWegH/rhvg4VARjgTv3PADmYe3UMcjqZtJ5un+515eb0M2WatcGag0
	 oH4suDKDPjwjJLlGjI/MJOy9gj1yZSOu/29W2vXuHz1R8rWkjaGxLGgTbexGKuf1ZV
	 0fBP4Gc9A+Xu7+qWTLF5qBXXA+KBrymog2qMtfXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lei Lu <llfamsec@gmail.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.18 03/60] fuse: re-lock request before replacing page cache folio
Date: Thu, 25 Jun 2026 14:02:48 +0100
Message-ID: <20260625125646.062530598@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125645.554579168@linuxfoundation.org>
References: <20260625125645.554579168@linuxfoundation.org>
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


