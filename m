Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7418A433BAC;
	Tue, 21 Jul 2026 19:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663660; cv=none; b=Pk91avIMUQ61s5hMpwyDEZRjE2rZiYNn26Hv40cw+MIvPyIcha0qpljxWiXFgmaDUl8sKBgOFn6LEHQw2UySUHCFVSnb9UxhgGgFuN6HxtpP8mHqDQMIsdLGKjhLKFOHS3SWGOsm1B6zZNzh5lOhAw1WNwFzaCIzKA6jTJS7iCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663660; c=relaxed/simple;
	bh=k6+v7oKF1R/1z3nGqy12fCfd92v1jt+Op7jgR4XdWqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snYXDGWWg2VsjsHCaa6vrINdyolGTxlv3Xhy73KUTA2q5YhUMkInjQG2iyQfNPi2TOIetpn9hzmd113cYN+XuTrAjPcnOXQN+kuIoXYBd720wljYwglO2CnIsJjGgcokiwvHvFILpf1T8SXk4pA7Xecd5sMOXLaLPT4svSiTYLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yQwQIsIz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yQwQIsIz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E191F000E9;
	Tue, 21 Jul 2026 19:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663658;
	bh=tG5pEeKWV55v9bxfmZLkGnryVQw1LGt/OIukZ38ks4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yQwQIsIzmCw/tgw8y+L34pKoeHg8gmELch49i6HopZIeYKu5VvU+0Agr3+haljkzi
	 q60Whm3qirOfU5E2r7MVrUaYKm87yU+CUr+r6mfzVxurfnq6OXzHT27Up0VAtzOnV0
	 atcr08adVYYh6Cthxp/N1GrjLGm2SPFyIdQlVlSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 0905/1276] lockd: Plug nlm_file refcount leak on cached nlm_do_fopen() failure
Date: Tue, 21 Jul 2026 17:22:28 +0200
Message-ID: <20260721152506.289727300@linuxfoundation.org>
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


