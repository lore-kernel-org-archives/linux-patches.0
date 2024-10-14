Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9413519E802;
	Mon, 14 Oct 2024 14:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916089; cv=none; b=sQrMPvkXeLDZ216asUZOguEyVYZmAQxQfhVnv3kv4Xw8VBc1RZSZ4BYs3v79PJGmG/YAJC0ugUcgGOoxD+s8sLSfUQ2dhj1rSVHuqCE7/IZ6FIVCtu1OzSnF6upgCLUGE7v+4o6e4r5KWuvOHXhHgNhMIjzfBYpzPkSf+MoFhyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916089; c=relaxed/simple;
	bh=bVsk3ubx1J/UhyuS7YD88tOiyTbtAy8YKE1ckOwTCJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUUwC1/P59ZVPgQ3t4ZJ0jvkSiA0AY877EPKGLBHhRrcvYQM2VVzLF9M5WBnYbNpEFjY7bbwoqOFx0xJreI1YMEKDUrHI3e969k46hm9/tBvRS/EZCgvnQJkgou2jby+WRMHXlgkA8Cg9Pw2ZHjOm31tQkLZ5i2kiIeQF0y23M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NPvmRyMm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NPvmRyMm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05005C4CEC3;
	Mon, 14 Oct 2024 14:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916089;
	bh=bVsk3ubx1J/UhyuS7YD88tOiyTbtAy8YKE1ckOwTCJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NPvmRyMmIG5lRiz7QUGgs8Iq8jankzoTVBt4HlGUK0pyPaziF9EGVEWTS74N63r52
	 vhTZWulK3I4HWa5O3aHoHGD5k0AL1e6bgBeSrQKjkKXB57pnMYKC8VOqtJRJxk22ym
	 eRLlSMahDtoFXoxCxFxdpD0k1fx71eH0uJ9H0PNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 081/214] NFSD: Mark filecache "down" if init fails
Date: Mon, 14 Oct 2024 16:19:04 +0200
Message-ID: <20241014141048.152603628@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit dc0d0f885aa422f621bc1c2124133eff566b0bc8 ]

NeilBrown says:
> The handling of NFSD_FILE_CACHE_UP is strange.  nfsd_file_cache_init()
> sets it, but doesn't clear it on failure.  So if nfsd_file_cache_init()
> fails for some reason, nfsd_file_cache_shutdown() would still try to
> clean up if it was called.

Reported-by: NeilBrown <neilb@suse.de>
Fixes: c7b824c3d06c ("NFSD: Replace the "init once" mechanism")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index e2e248032bfd0..5583db806b0bc 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -719,7 +719,7 @@ nfsd_file_cache_init(void)
 
 	ret = rhltable_init(&nfsd_file_rhltable, &nfsd_file_rhash_params);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = -ENOMEM;
 	nfsd_file_slab = KMEM_CACHE(nfsd_file, 0);
@@ -771,6 +771,8 @@ nfsd_file_cache_init(void)
 
 	INIT_DELAYED_WORK(&nfsd_filecache_laundrette, nfsd_file_gc_worker);
 out:
+	if (ret)
+		clear_bit(NFSD_FILE_CACHE_UP, &nfsd_file_flags);
 	return ret;
 out_notifier:
 	lease_unregister_notifier(&nfsd_file_lease_notifier);
-- 
2.43.0



