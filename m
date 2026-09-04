Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001253876CC;
	Fri,  4 Sep 2026 05:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500690; cv=none; b=HiPRUmeVo2NvTiVjb/nPvMKSOvlyEsoXr9LedvoyyCxOFhGl0SL7i69MRwjshEPoIIMnxyeI60gE52B8YDlFUAeNOIBaoS1P0vhVbYeiBtEwvriplDwX2FLkxV51vAZl71omdq+wJbivsvn61UJhIUaKvRGdnDC9DR0HfkC9ss4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500690; c=relaxed/simple;
	bh=9Y2OU21neEO2maVTrmWTzQWiPG3GT2T1TOEGpuEKOVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q+cSYkPvfghjzC819Lw7puM5umtBpGQj/ddl+buO5DidLPHqNxjcTFvXKTsf8fS6laaAZ7NnqwV/hsnXYXryXz146rHn6e7T3dvZJSk8J7PQA7rdewoE6DIKVN2Rh3RDurwyjfmhu/OeD4L0TuDN1ZON5n3CJVjeVS8gSKSSsAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vjm7SLUp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vjm7SLUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7EE1F00A3D;
	Fri,  4 Sep 2026 05:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500688;
	bh=WhCNCOXyc13JQdLDd49nx/VG9jQmTr+Hx/T2d2nLK7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vjm7SLUpR+TeIKhIhagplGxZIx4EckokBsf8GrLkwPLnWhtnFYgGtl8lDtht5CZRc
	 5sywuYB43zVca5S75bMF9+LjuW22QQqNWs1/yLRHLFNadqFeE9HxbqoVPOURPggeNA
	 M55YYQhOlndxAMh2AxDKCURiCFz3UVF3AwoUX5Y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 145/552] nfsd: initialize DRC hash table before registering shrinker
Date: Fri,  4 Sep 2026 06:55:02 +0200
Message-ID: <20260904045751.875799373@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


