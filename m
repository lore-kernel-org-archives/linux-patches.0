Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3453B6C06;
	Tue, 21 Jul 2026 20:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667235; cv=none; b=sqsRhTX2IQNUJRSEl20ggGivX3RXaBJjumeumA0zr/fSsywW1mqHT3Kmgti0hVCVfXCH4ymjWuiX3U3FJ2gMLJBAYBj+rQC8ha5wOzvkwqi5fkG60QI563F++R05gViibBVj5uMhtLTssHnbWbnS/U0Xg9EvYne8uzv9kHRYLGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667235; c=relaxed/simple;
	bh=WsidEa4J/UyyEzYtoHnfwj6UfkxHasb0WX5m1d99t+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ka5/U4Srt6tqQz6aVEwLXUjEVgvqbYuwX1NrTpTJGkkYz6s1RqOj01w6UrfgkvMtcHTVsCAKW+AhDWEXSJvIosC8XLcCytCTkc1dNJ3TlvjC8Djzwud2vLG18xdFQgSo/X0B7RIXFCoQ6Iv0xi89pHwzvdb4YTyq/yiYkZZJBD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vYxcNuKn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vYxcNuKn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F541F000E9;
	Tue, 21 Jul 2026 20:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667234;
	bh=7NfPKK8jmCjRewrgNf1y8Tg+uBaH+4ILIde2ipdgcYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vYxcNuKnW/44zUggyaz4Xj13DmYR9OfErIA6WaJ+kINKX4L1oXDSHTBXpJS3xI/6T
	 HyQh9/lCUE6laXUWfGYO9mGVw9Mk9sC79AQ0pk39kwbqON1kiK/pVeObklq7tO+Oz4
	 i/hU+2fL5/aYqsgP508MEKKiZplTcfam/4cfkJ24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 0967/1266] lockd: Plug nlm_file refcount leak on cached nlm_do_fopen() failure
Date: Tue, 21 Jul 2026 17:23:24 +0200
Message-ID: <20260721152503.470316946@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


