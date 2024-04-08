Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBA66A342;
	Mon,  8 Apr 2024 13:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584218; cv=none; b=n3L1IRzBTp/pce8HQpw4BfDKSpntwI7d8fdWyNYvnMbKMlxslBYWn5q6Y/AL34zT4AcPs8Ha0+D3UFS6CwT118h0cFzERgvQcysIyJAvG1DCjS8fzgScoDxCerERwzLeex2UbiBS2eQkvbx9E1PCKM84psSnBVkfFu1GJwxLUwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584218; c=relaxed/simple;
	bh=E427AouPRaGnE1v4KmZQNUJhv2GLoDl168/0JpzDQx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QsXGketnYaEFywnjzvlEPrSSMcMRRUFphAlY+lUl4hGynVR8hVjaiRFv6uqogz7IJdy+WDl/11k0uIteXMiS4bMZcJUn+jmM/4UzicvgMJrj8Bv/Z8qeshWNbRdjoLb+aLXit/yWmus3s6O7YZEmvuS/3eeq1FbIxa+iyPNYpj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oNX3uIWl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oNX3uIWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AE6C433F1;
	Mon,  8 Apr 2024 13:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584218;
	bh=E427AouPRaGnE1v4KmZQNUJhv2GLoDl168/0JpzDQx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oNX3uIWlJQSojInB/tlmAT0fTSGdFFvDBX/U603uI4/c2QYqFBk94hPxkCb51hDMV
	 0DprRRokdZSE/0Pv4hzR8Afnmd9NzYU1ODRewR4DDd8wJJAGS9/KC4TCiWWoqp5upb
	 Kg2Q95hpaGh+bjjBHGiOPXtiN5kdfrt4nPPlDSZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 363/690] NFSD: Remove lockdep assertion from unhash_and_release_locked()
Date: Mon,  8 Apr 2024 14:53:49 +0200
Message-ID: <20240408125412.734551256@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit f53cef15dddec7203df702cdc62e554190385450 ]

IIUC, holding the hash bucket lock is needed only in
nfsd_file_unhash, and there is already a lockdep assertion there.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 2d013a88e3565..6a01de8677959 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -299,8 +299,6 @@ nfsd_file_unhash(struct nfsd_file *nf)
 static bool
 nfsd_file_unhash_and_release_locked(struct nfsd_file *nf, struct list_head *dispose)
 {
-	lockdep_assert_held(&nfsd_file_hashtbl[nf->nf_hashval].nfb_lock);
-
 	trace_nfsd_file_unhash_and_release_locked(nf);
 	if (!nfsd_file_unhash(nf))
 		return false;
-- 
2.43.0



