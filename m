Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39E81FA246;
	Tue, 15 Oct 2024 13:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998482; cv=none; b=Pik737B6ebduELIYpfPc0uxd8CSGGB4ha+hsHLXenJxbxK5eVS32rFHK9DJ6ou7c3jzNoDZS+zoNp3XKwZtB9Hds96LajGbYz9zlB5i0a5csxiw/mD6M/j02jEmh4kU68/h80Wcsp6OpIPJtaSN3ATjmXJd+j5URXsaGY0nj99A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998482; c=relaxed/simple;
	bh=7CFEXZtcgX7PqF9/7YXvzNgwN24MUXwV8Ug2OVgoAmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WBf7yCiK6Xb9oSd8y3wiR5ppueCIeB/ND6z+Gg4K/uwGBaPfn6c9nCex+5dVubW+aYSvRSGiSsoHpoDBa0qZBJduobkFtwQnGkf8k1535PmJBvqj7XS9otgARjJvgNog8AJ9MFeM9hd6AZrD/MYkp/p4TblcmjO3W8cccjulNwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1pnS0D9H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1pnS0D9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AAB2C4CED0;
	Tue, 15 Oct 2024 13:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998481;
	bh=7CFEXZtcgX7PqF9/7YXvzNgwN24MUXwV8Ug2OVgoAmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1pnS0D9HyivQxVOthTbNUtiBwIGJ5MUFVHs1aGLDC7d4Y2zStNP5rR8ffSVKN+vKB
	 ypQjhSEHy7M5XeaSYKOFpeB37tI+ftfl2p6bNfd6qYRH0kGkIpHjCtyirytUHoPOya
	 6wJlDm+owurshlcqhDNgPjGOn4Nf+EI/aoRkvbaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 472/518] NFSD: Mark filecache "down" if init fails
Date: Tue, 15 Oct 2024 14:46:16 +0200
Message-ID: <20241015123935.221837724@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 31169f0cc3d74..585163b4e11ce 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -717,7 +717,7 @@ nfsd_file_cache_init(void)
 
 	ret = rhltable_init(&nfsd_file_rhltable, &nfsd_file_rhash_params);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = -ENOMEM;
 	nfsd_filecache_wq = alloc_workqueue("nfsd_filecache", 0, 0);
@@ -769,6 +769,8 @@ nfsd_file_cache_init(void)
 
 	INIT_DELAYED_WORK(&nfsd_filecache_laundrette, nfsd_file_gc_worker);
 out:
+	if (ret)
+		clear_bit(NFSD_FILE_CACHE_UP, &nfsd_file_flags);
 	return ret;
 out_notifier:
 	lease_unregister_notifier(&nfsd_file_lease_notifier);
-- 
2.43.0



