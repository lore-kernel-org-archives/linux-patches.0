Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A06B30C160;
	Fri,  4 Sep 2026 06:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502135; cv=none; b=jRY9lfwLNlFoDq3sBP8GbrVHp9YnKOVN8dJbENezX5RbMBGxXJHhEG6Px63g29qXML4mvyGl2uGJjFtnlom3wZJdEMISX1HfDQSo6K9aJqiW6IKTZbzA3bPWAD0q/Z0XC3hPJ2/LBHexB0Ghy/OU8nEC00pYaSnIH6MWFt89t+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502135; c=relaxed/simple;
	bh=3ks0ZgqzGknuis8o5fS1JEsOE5dlGwjg3Q3uLleu14Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JAYtaIif7eSywjPAEY4SNAa+aMgtkvbf4co32VtiNRTDEN1iz4FiacpaF+ciLRd1lTnfczFAKJv+HRMo+HkfJi/2AHIfCrA/orUOUyAWkmLTrPRlS7TCVDz0xwheuvkFF9oilz04sEUmk4pmnjriZT4xep/0MMaUEDSXfw+G+Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FfG6ZXII; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FfG6ZXII"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787B21F00A3D;
	Fri,  4 Sep 2026 06:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502134;
	bh=LkJ+D1GTdvdjpHQUIedaXP29I/QV4lqtXb9/j/gAjbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FfG6ZXIIOSxDrOPN3PpS+HrnnKsW2e5yjBUHNYWH9qf7kmCh/OW7Cphk7RK7vTT95
	 2tNDy49D1AIGf6fQ5lgAbSmE4T6kdYriOsb1Jh8cL9R0zwBG/d0KHSPvudyXIZxWRV
	 Kdv7kzYHzKeIpgDHw9LeZjGaduxv0yAqsVSAX0Bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 102/403] nfsd: initialize DRC hash table before registering shrinker
Date: Fri,  4 Sep 2026 06:58:25 +0200
Message-ID: <20260904045737.150866700@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

commit b0c58934f5cc4f05b63ef6605dd10c1d0d489e88 upstream.

shrinker_register() precedes the INIT_LIST_HEAD loop and the
drc_hashsize store. On weakly-ordered architectures (arm64, ppc),
a shrinker scan can observe drc_hashsize before the bucket list
heads are initialized, causing a NULL deref in the DRC shrinker
callback.

Move bucket initialization and the drc_hashsize store before
shrinker_register() so the hash table is fully initialized before
it becomes visible to the shrinker.

Fixes: 8eea99a81c6f ("nfsd: dynamically allocate the nfsd-reply shrinker")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260611-nfsd-testing-v2-18-5b90e276f2d9@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfscache.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -200,14 +200,14 @@ int nfsd_reply_cache_init(struct nfsd_ne
 	nn->nfsd_reply_cache_shrinker->seeks = 1;
 	nn->nfsd_reply_cache_shrinker->private_data = nn;
 
-	shrinker_register(nn->nfsd_reply_cache_shrinker);
-
 	for (i = 0; i < hashsize; i++) {
 		INIT_LIST_HEAD(&nn->drc_hashtbl[i].lru_head);
 		spin_lock_init(&nn->drc_hashtbl[i].cache_lock);
 	}
 	nn->drc_hashsize = hashsize;
 
+	shrinker_register(nn->nfsd_reply_cache_shrinker);
+
 	return 0;
 out_shrinker:
 	kvfree(nn->drc_hashtbl);


