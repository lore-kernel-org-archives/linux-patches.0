Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578F21AAE08;
	Mon, 14 Oct 2024 14:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917058; cv=none; b=PqJCH89o9dv+F6gRSb2WXX3ijA+nAL2/QUQ7GU26nIxBi+41aAccLgAgTW0LhXX4zoqgIMF/YRMJTUBKNBuCNShHT2ZYrV+JHCK0H1xiX/iZ5APoZezNDCwIiFucdroz/ECdoz2+rPpd1rfca1q5IEKhVngDSTpyJ0s1KKrgJeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917058; c=relaxed/simple;
	bh=iddXsFuywpJIxq5IwW3UcN1cyUdPYnvWgQ4AwQ/8x+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eThrlH2Jf2V7a+x55ohURm9jsqowRuDDJPy8qM0l0xYWjMwnLBLDfwQI7yQG7NMDdbm0D3HgMWEE+w14PUifLCkoxq/FResrnP+F80Vx1uWLBY5yHhqbLjzVSBw6srO7Qvm+VN0CY3RarOIWR4Ak2MkAofgBLozSTHBPjEV5LT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HIzF0XiF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HIzF0XiF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A772AC4CEC3;
	Mon, 14 Oct 2024 14:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917058;
	bh=iddXsFuywpJIxq5IwW3UcN1cyUdPYnvWgQ4AwQ/8x+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HIzF0XiFWI/3XIJWZho0gBkwqv3HvtV5+GD7E++fYEaA5QLYsxpWD4GP38gViEHJt
	 uDxlW4OArhflZAiC3n14TaLWL+Y8+b31fSaS8CAmsex11C1f/N8kD+juYs0YhlszEq
	 9npOW+mBNbrCrCyyRMWUCUZDnkkIweazehGImVew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 109/213] NFSD: Mark filecache "down" if init fails
Date: Mon, 14 Oct 2024 16:20:15 +0200
Message-ID: <20241014141047.222152729@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5c9f8f8404d5b..6f2bcbfde45e6 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -718,7 +718,7 @@ nfsd_file_cache_init(void)
 
 	ret = rhltable_init(&nfsd_file_rhltable, &nfsd_file_rhash_params);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = -ENOMEM;
 	nfsd_filecache_wq = alloc_workqueue("nfsd_filecache", 0, 0);
@@ -770,6 +770,8 @@ nfsd_file_cache_init(void)
 
 	INIT_DELAYED_WORK(&nfsd_filecache_laundrette, nfsd_file_gc_worker);
 out:
+	if (ret)
+		clear_bit(NFSD_FILE_CACHE_UP, &nfsd_file_flags);
 	return ret;
 out_notifier:
 	lease_unregister_notifier(&nfsd_file_lease_notifier);
-- 
2.43.0



