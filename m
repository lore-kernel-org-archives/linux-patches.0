Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60123430CE3;
	Tue, 21 Jul 2026 22:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674262; cv=none; b=Uz4Zhmh02vMsc3X1s0Qy0Bf/E2dQ0bfL97FrvxGf68zgbZa94+xEc/GjWNyVL3Ef4lCDpcwh1Ei28mbcrIXsb7FoMM511Dh4Rz/YLTEIaM0US+slk+zuMhUjg54gjLz/GfLY8p2GgfVvrHuCCW845FxDt1I5a1bFOyQYCgc0lms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674262; c=relaxed/simple;
	bh=vpkeLe36PdJDAb9hkp3Jaxkl/PpvokruxawNOqND2Xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H6pza9AKzbjcYovOeaMEJnseXPV9lVus8nEmWtScssQ31g3K67E8OgrD0bwwpdRs48E/NNzBBC146iwMY6CrK5KbtbIN/16gWN8xFEpXNHGdZvfboYRzCPRYbADaJLMp8PmtCdRlL8ObbJ5uJEECGYbqeJjNjl+1t6Va2ex3cas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7HapTht; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7HapTht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B1C1F000E9;
	Tue, 21 Jul 2026 22:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674260;
	bh=OlTiTDf6sjPBKPVApodez9I8bA/US52kz5r1b4qGFBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N7HapThtTuP7/yXmiE87j+X7uydpdfJAIDqxOzwsOMDNMpnSTC6z74RzrEKVw9rM+
	 xKXk2baxW5bBgLziIbUgwYNVHCY+J4FNQwkivADQd1QMVOGFHnPFw2JPDJMRbFNwmi
	 di33V5Xn+V9KjGZhuTX/s+MaATL3bRFUtBzDzHuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 474/699] lockd: Plug nlm_file refcount leak on cached nlm_do_fopen() failure
Date: Tue, 21 Jul 2026 17:23:53 +0200
Message-ID: <20260721152406.390283062@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


