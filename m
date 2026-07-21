Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3424F435A98;
	Tue, 21 Jul 2026 22:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672387; cv=none; b=pndPxMh7s61uigRCxMuQgyWwCclv1xm7mamjHr91Vap+kHfglU9m61t6Dp/jIK0xi16UjBWyJWadfv9tvnv1qHdi4lEarN0l9+3915pH50mH76azLHKqDGHgXNTDNe8yYJrXqR6mXZCZ3N2zbhY4tDcvb6m7fxyfaZdWcswA6/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672387; c=relaxed/simple;
	bh=4IcVypS4Mrg4d8dkkdYrTbJZ9nKe4oFw1s8/PJdF7gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CdiCJBlrDk4QAbJih/fER44nR5TQMokH0vW9q1HjDlfk+yFRY5dD5Oeg1u0UENTpbrbmccllwgdRRalzE8VcS7fO2I+tMhaLZhcBbpMbRjC1G/vFUHg4P7ux54ZJf90bzSXFs7l7mMF7JowpvdBpz2bj+tCm3vzsjCYT0EZZpEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gg4CnxVf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gg4CnxVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98CF51F000E9;
	Tue, 21 Jul 2026 22:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672386;
	bh=R0Oxkasz84FiBlAyk/h9I/3p8a7ZQT52FgVNsKCzkDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gg4CnxVfg83xYwWegU48rKaDatJ/+PLDZZq1QzKcoHSVjqAgQ2qJw2mbDNoOzymxs
	 hGNnVQerbwHGtaLNMpZ9gdld5FFuTTL6f7JgDdqDIVrZJXzWE0M7FTHN0raudJ/VI4
	 +Mlw06KSnMm3IFus85RakcLbrX5n8MPZxKN2MeCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 605/843] lockd: Plug nlm_file refcount leak on cached nlm_do_fopen() failure
Date: Tue, 21 Jul 2026 17:24:00 +0200
Message-ID: <20260721152419.660547090@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit 70a38f87bed7f0694fd07988b47b2db1e10d8df3 upstream.

The cached-file path in nlm_lookup_file() reaches the found: label
unconditionally, even when nlm_do_fopen() fails. At that label
*result and file->f_count are updated before the error is returned.
The wrappers nlm3svc_lookup_file() and nlm4svc_lookup_file() then
bail out of their switch without copying *result back to their
caller, so the proc handler's local nlm_file pointer remains NULL
and the cleanup path skips nlm_release_file(). The f_count
increment is never released, and nlm_traverse_files() can no
longer reap the file because its refcount never returns to zero
between requests.

Short-circuit the cached path so neither *result nor f_count is
touched when nlm_do_fopen() fails on a hashed nlm_file.

Fixes: 7f024fcd5c97 ("Keep read and write fds with each nlm_file")
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/lockd/svcsubs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -123,6 +123,8 @@ nlm_lookup_file(struct svc_rqst *rqstp,
 			mutex_lock(&file->f_mutex);
 			nfserr = nlm_do_fopen(rqstp, file, mode);
 			mutex_unlock(&file->f_mutex);
+			if (nfserr)
+				goto out_unlock;
 			goto found;
 		}
 	nlm_debug_print_fh("creating file for", &lock->fh);


