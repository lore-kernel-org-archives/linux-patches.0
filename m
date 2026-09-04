Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1347415B8F;
	Fri,  4 Sep 2026 05:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498825; cv=none; b=BL92CPSkPrJaDbEhhN71lhfpUJy2HmSKCPoZl2kYPqShnHvWZJIlcl3u8yb1Wt6t6XFOdMjv64q4gO9+248IMJwOFgy213tI/eUZpiuVkmjeINTNQl3ch6BomQlrJcMexKnG0Yaa2QWgtJuZo3Ewec+n/n9jZmz6RpAHziDpJDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498825; c=relaxed/simple;
	bh=HrivOHxmmKk2anPvjtm0JAGqytW0VA76q7MewL1g1Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtBiAUdncQ1xzsp5nI5vVF9nqSdiftqVlxj4pyiK5xc2e4VyBQTqTVE2PkgPWaE23V9M56LiCzUw0poZ5ZK8tJnmlXV4gh80EYqwe2b/Q/hkerMsBNph4xZojEM68wo4S8fayh7Nm9UL3DN+TPMC+MBWRHlMGBsbW+rHMMZiWnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0qucvVta; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0qucvVta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4859D1F00A3D;
	Fri,  4 Sep 2026 05:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498823;
	bh=BquWT6A5covznMDVXvfi4DDtxOPoGwODJASRWuRDaHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0qucvVtaVVEhVEQ7YhFKY8vPo03CaaoCxema+v8aBtQLBPx0VqFCr/QPu+B9xbo+P
	 RXusgMqc0zip50Iur525heibTvokXVRgXfbSoovYwQCoHz+lzYfjK637h1F8gQ6kaZ
	 G1bFaxzHNBLZODdCuCJ5W0aF3bbP0pLP7H1B3AJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.2 199/713] nfsd: initialize DRC hash table before registering shrinker
Date: Fri,  4 Sep 2026 06:52:47 +0200
Message-ID: <20260904045808.271704035@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


