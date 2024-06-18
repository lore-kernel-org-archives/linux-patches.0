Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55338158D6C;
	Tue, 18 Jun 2024 13:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716373; cv=none; b=E7kcKCleZ0Oi9AOC9gZ2dLHIEzDVaWbt33ZYJ/i0Bgg7SPExh8bchgaLWN7VDWl3somjdKOjK2yLVzo7C1+cOixy6rlkHRFEWsgdQ9RIiRVhB1N793qa+Kink2UDKlTqFDYnxB92kzXTy2CJDkPebBzBzn+Nt9iRknGnJ2CCziE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716373; c=relaxed/simple;
	bh=ucnBeqWUntvP/oJN4reLYDlJD4xl95F5txTW7EDJVZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PwmFrEBnqARXKwXPPPH34GeY+3Fk5+n5B7TgOQWbtUvxVhxgbt+M7wSt3YcQxjtE5OgQKEjaOf6s+TVszL8k1e0h30fXhNpU93OQpo0lG4adGUpp7YZfdJUf25wfuSBM7nZ0+zYBUo2L3hRUiyutQzge9tenbBnVDBcjUhWD3uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KZGIN4xc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KZGIN4xc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09E0C3277B;
	Tue, 18 Jun 2024 13:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716373;
	bh=ucnBeqWUntvP/oJN4reLYDlJD4xl95F5txTW7EDJVZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KZGIN4xcOr0CYlRdy45kukRNoZ95CvuCYX7jwkTdBXtALStiIV1uHXx/FsiZesz75
	 QV5HdmoVJSl/wvNwa0UqA4U/DAMcVW8/oj2OkxHxRg+obrMhKrxEjNKHJteRG6WoHD
	 g54SGpHmKYvRPieiu9ZWl06Kd25fpxVIRERPtPeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 625/770] nfsd_splice_actor(): handle compound pages
Date: Tue, 18 Jun 2024 14:37:58 +0200
Message-ID: <20240618123431.411321945@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit bfbfb6182ad1d7d184b16f25165faad879147f79 ]

pipe_buffer might refer to a compound page (and contain more than a PAGE_SIZE
worth of data).  Theoretically it had been possible since way back, but
nfsd_splice_actor() hadn't run into that until copy_page_to_iter() change.
Fortunately, the only thing that changes for compound pages is that we
need to stuff each relevant subpage in and convert the offset into offset
in the first subpage.

Acked-by: Chuck Lever <chuck.lever@oracle.com>
Tested-by: Benjamin Coddington <bcodding@redhat.com>
Fixes: f0f6b614f83d "copy_page_to_iter(): don't split high-order page in case of ITER_PIPE"
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
[ cel: "‘for’ loop initial declarations are only allowed in C99 or C11 mode" ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 95f2e4549c034..bc377ee177171 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -862,10 +862,15 @@ nfsd_splice_actor(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 		  struct splice_desc *sd)
 {
 	struct svc_rqst *rqstp = sd->u.data;
-
-	svc_rqst_replace_page(rqstp, buf->page);
-	if (rqstp->rq_res.page_len == 0)
-		rqstp->rq_res.page_base = buf->offset;
+	struct page *page = buf->page;	// may be a compound one
+	unsigned offset = buf->offset;
+	int i;
+
+	page += offset / PAGE_SIZE;
+	for (i = sd->len; i > 0; i -= PAGE_SIZE)
+		svc_rqst_replace_page(rqstp, page++);
+	if (rqstp->rq_res.page_len == 0)	// first call
+		rqstp->rq_res.page_base = offset % PAGE_SIZE;
 	rqstp->rq_res.page_len += sd->len;
 	return sd->len;
 }
-- 
2.43.0



