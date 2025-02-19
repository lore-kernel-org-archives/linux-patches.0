Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B94018C011;
	Wed, 19 Feb 2025 08:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953910; cv=none; b=pJzVQB1M3RxeegI2jaoE3LC9KCnj6VgJTe2tWeQhsu/80sL6FiVpsZetAArT4/OBHPLrzDL2F8VaWzOjFo8eDFHzB0PJ/if7kw3AuqwJP4SVPge6afycILSo9iuK08JuBgNEGdO2UiVMM81l5tHg2Bt6A4rbk3MZGl2+AypE6OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953910; c=relaxed/simple;
	bh=HzI0sUiqRXjjPFwmcSJqWBzqqDFX9FrjQ7w83Z9AiLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNleoSgHKoxS480Nbrrv1aNMmgT5YfjDfSo6sNVyH4Hp2VKqYTigssfhzH726QywTpq3pMh1p7ilHIwBEaTZIVOA22oan6BOlMTo49+fOMvfmn65D1XfecrJJ8sbcW/l9m0Y4tlBg7UHBw0An8adnd/qBZzcsl5w/HpUsAUQc9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m2X2Eo+t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m2X2Eo+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9501CC4CED1;
	Wed, 19 Feb 2025 08:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953910;
	bh=HzI0sUiqRXjjPFwmcSJqWBzqqDFX9FrjQ7w83Z9AiLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m2X2Eo+to9ivZJEkh38fUvN3I92zLpCfqYLeqomegFkmH2E+fqge0zrjdYZ2lXnbY
	 cY+rf/0btJYHFmwo4RKAgqd5IR35fIhYmMkU6VKXRHY3EM2I5X+anYsyU2Rii4BqPM
	 TVI/SJxOWO6sn0x0FxdNDjnmvMXlrfu9B+VrSSYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salvatore Bonaccorso <carnil@debian.org>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.13 005/274] nfsd: validate the nfsd_serv pointer before calling svc_wake_up
Date: Wed, 19 Feb 2025 09:24:19 +0100
Message-ID: <20250219082609.746040041@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit b9382e29ca538b879645899ce45d652a304e2ed2 upstream.

nfsd_file_dispose_list_delayed can be called from the filecache
laundrette, which is shut down after the nfsd threads are shut down and
the nfsd_serv pointer is cleared. If nn->nfsd_serv is NULL then there
are no threads to wake.

Ensure that the nn->nfsd_serv pointer is non-NULL before calling
svc_wake_up in nfsd_file_dispose_list_delayed. This is safe since the
svc_serv is not freed until after the filecache laundrette is cancelled.

Reported-by: Salvatore Bonaccorso <carnil@debian.org>
Closes: https://bugs.debian.org/1093734
Fixes: ffb402596147 ("nfsd: Don't leave work of closing files to a work queue")
Cc: stable@vger.kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/filecache.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -445,11 +445,20 @@ nfsd_file_dispose_list_delayed(struct li
 						struct nfsd_file, nf_gc);
 		struct nfsd_net *nn = net_generic(nf->nf_net, nfsd_net_id);
 		struct nfsd_fcache_disposal *l = nn->fcache_disposal;
+		struct svc_serv *serv;
 
 		spin_lock(&l->lock);
 		list_move_tail(&nf->nf_gc, &l->freeme);
 		spin_unlock(&l->lock);
-		svc_wake_up(nn->nfsd_serv);
+
+		/*
+		 * The filecache laundrette is shut down after the
+		 * nn->nfsd_serv pointer is cleared, but before the
+		 * svc_serv is freed.
+		 */
+		serv = nn->nfsd_serv;
+		if (serv)
+			svc_wake_up(serv);
 	}
 }
 


