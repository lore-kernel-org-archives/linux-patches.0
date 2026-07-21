Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80A646EC83;
	Tue, 21 Jul 2026 18:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658640; cv=none; b=QAEU4CHAkdtTni6APDSDW71HvkugU9sw5yHiA1Z9GtE40Jk7XW0YyQUuzUYovJP3YYiqJqsc41SOhBVUc7ykpXJfbV6pOvAXQBM7GqvY+l2kcrp285WSODxFBRX+EpYJL0kkIubqzKOU/S0kYvlsc6qis3QsL+egclxMLL9zr0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658640; c=relaxed/simple;
	bh=BQBcvLvC5DPqRwhWzUNLTmSqeFAI7j/N9MZzfNuVUeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrGswpwoK2645RhZpdti5Pr00OrWKBbU644EWaIJfuifWmynwttqpc03/I0bdIn489G+NswN76y1wBV31eFn560c0oWZK9azR+WFh/VFUfynf9iq6V3QMn+wcgPhLpaUYjtYIU1fvDoVBqRWb95AXXAkfqfYhx2/SrE5BAriEa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OE4yeKbi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OE4yeKbi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 223A51F00A3F;
	Tue, 21 Jul 2026 18:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658638;
	bh=iDmzfqXuKz0QZ4GybtGpjWwbTl5dkwB9NRcUCuGVsd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OE4yeKbiG8+1XqV2fI+8Ecv4MKw6gfs9ccm/rEPxfb7AgKMtNcqoN2BJmy5d7n8Qn
	 X/3UE+h0/F2DAqj40RntS+d7LM4+lCJGVC80MxpW2omv3oFTU5lKAd5Vl2f/VwqQOY
	 FXBnDGiUD9uQJp9wEZHg3GlFn+WxNqhM/hHW9XH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 1220/1611] lockd: Plug nlm_file leak when nlm_do_fopen() fails
Date: Tue, 21 Jul 2026 17:22:16 +0200
Message-ID: <20260721152542.877177391@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

commit f16a1513452edb532fec81e591c64c320866719c upstream.

A client can repeatedly drive nlm_do_fopen() failures by presenting
file handles that the underlying export rejects. After kzalloc_obj()
succeeds in nlm_lookup_file(), the freshly allocated nlm_file is not
yet inserted into nlm_files[]. The nlm_do_fopen() failure path jumps
to out_unlock, which releases nlm_file_mutex and returns without
freeing the allocation, so each failure leaks one nlm_file.

Route the failure through out_free so kfree() runs before the
function returns.

Fixes: 7f024fcd5c97 ("Keep read and write fds with each nlm_file")
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/lockd/svcsubs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -154,7 +154,7 @@ nlm_lookup_file(struct svc_rqst *rqstp,
 
 	nfserr = nlm_do_fopen(rqstp, file, mode);
 	if (nfserr)
-		goto out_unlock;
+		goto out_free;
 
 	hlist_add_head(&file->f_list, &nlm_files[hash]);
 


