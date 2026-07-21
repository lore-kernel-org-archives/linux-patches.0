Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B792F46E005;
	Tue, 21 Jul 2026 19:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663656; cv=none; b=c/uqCkf6ZMyEfePBt6egb5J0c3MGfq3BWNWzaAt/TkIMbsJ82U4g/U/mPphgjkH18veCGd0k2HwyjYqpwhGEwrYre03ZUhhC6bow2pgQ95IV0qnyrTtj8w0Buf0H5TYsAF/PPIgZ/2DKWj9rb7GftjtRFehL1YDsFpr4usiYhOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663656; c=relaxed/simple;
	bh=e5S/wKBk6VH1jCykITSQqgHZs4tRn4XcaksGqulLthA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBJ696oQp3uNA8pkol65ERHN1ndtRYfkyX2VVNEAFWOA9uxW5K8QYffoU62pfxtF4/OKfepPlX2a9sc5tGjjTJLc/LeqgRuQUDLvbCo4Xs+uDqhbGVfFISUCO9zoVTOKID5fMEi3RKLRqvpJBFomvpLFBR4po3QBW6x6ULdGLyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fd/Ql2TA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fd/Ql2TA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28CD41F000E9;
	Tue, 21 Jul 2026 19:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663655;
	bh=freidhvf9IVeScoT7KRjTzswrEGYPVd1YpD6cfnsvtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fd/Ql2TAX2/GF7nO5FhZdhIylzbySRyR5yA8gmJYApUY+CWOm89V9JjLpDhRtx8iJ
	 G0/nnvsktifNCydEm2y8FUfvWf6bhAOnfyRopjWjdo6If107SRNC2vgVee4p2NY5su
	 34CWCiFpUpMoHu4mLDfJgT+bwYZ9KTHa6TWXs7Ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 0904/1276] lockd: Plug nlm_file leak when nlm_do_fopen() fails
Date: Tue, 21 Jul 2026 17:22:27 +0200
Message-ID: <20260721152506.268433390@linuxfoundation.org>
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
@@ -139,7 +139,7 @@ nlm_lookup_file(struct svc_rqst *rqstp,
 
 	nfserr = nlm_do_fopen(rqstp, file, mode);
 	if (nfserr)
-		goto out_unlock;
+		goto out_free;
 
 	hlist_add_head(&file->f_list, &nlm_files[hash]);
 


