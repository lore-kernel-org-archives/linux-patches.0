Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB22236D9F7;
	Sat, 28 Feb 2026 17:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301430; cv=none; b=ZD1AobVVF6WmUiJ82E0N+K0ljgvCZbfBEmFLwgVe9ucYkvWu/Abp7ivzhF/KapIdAaICF1bhaICfjYYu8IOIyKH9BpLfTe70WVfFQfZVwHWJV+D/v7TdjgfAaKo724UxAvzFOSYd+Z8UNW9lpl4TuFcsUl30B8fO/6CqJH9UQl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301430; c=relaxed/simple;
	bh=lwidor7yhbMXoDAf9SjUqka3+hhG/IispQy3ahKV/iU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DKpcNRUuFLBP/yStaXZzqZWxe+8kQoqRm1dQyvp+b/NuqyaDlTHMpteM1XTDrHZ+nkkBkfm1dtf7lb/Kk+cdpJJiQaIXIoeDxjOu6fTJtbHb3iHB//XStGJz6S/wpeoqhH2rJ7Vr4FzDmPs0NIyxDlqU7HjEaLh6Gc/QyHa8u+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ikZuikfq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ikZuikfq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE4AC116D0;
	Sat, 28 Feb 2026 17:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301430;
	bh=lwidor7yhbMXoDAf9SjUqka3+hhG/IispQy3ahKV/iU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ikZuikfqOIPNtU3G5bIVjAA9xABBbaX3nk+mr4jxuFdVR9TbQOCj3By/ub4yypHEy
	 79eoKlQEZ/YlTkxu4EVerw94pTlcrYAt9Y5nylI/7CocWTS+zD4al3Hn5r014KIwuN
	 XzI+F/apFz5+Eo0q11EDoweliFYdJA60ko2MgG+ryknDsn+1FPA2xt001ACYPqWJdo
	 0BT7OMBVAqe83nDobbCNsNt/0DmpySUeWYWqOgOQbQtKdaHZEWrineK38v8fc2j8E8
	 CGLE5zs9KenzRli65f4gwwrPEWu5sXQRCj6NONJZUYgzm9KAgvYKK6cc7YuDvEpcz5
	 lXBy2QUYK6OZg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Anthony Iliopoulos <ailiop@suse.com>,
	stable@vger.kernel.org,
	NeilBrown <neil@brown.name>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 621/752] nfsd: fix return error code for nfsd_map_name_to_[ug]id
Date: Sat, 28 Feb 2026 12:45:32 -0500
Message-ID: <20260228174750.1542406-621-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Anthony Iliopoulos <ailiop@suse.com>

[ Upstream commit 404d779466646bf1461f2090ff137e99acaecf42 ]

idmap lookups can time out while the cache is waiting for a userspace
upcall reply. In that case cache_check() returns -ETIMEDOUT to callers.

The nfsd_map_name_to_[ug]id functions currently proceed with attempting
to map the id to a kuid despite a potentially temporary failure to
perform the idmap lookup. This results in the code returning the error
NFSERR_BADOWNER which can cause client operations to return to userspace
with failure.

Fix this by returning the failure status before attempting kuid mapping.

This will return NFSERR_JUKEBOX on idmap lookup timeout so that clients
can retry the operation instead of aborting it.

Fixes: 65e10f6d0ab0 ("nfsd: Convert idmap to use kuids and kgids")
Cc: stable@vger.kernel.org
Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
Reviewed-by: NeilBrown <neil@brown.name>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4idmap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/nfsd/nfs4idmap.c b/fs/nfsd/nfs4idmap.c
index b5b3d45979c9b..c319c31b0f647 100644
--- a/fs/nfsd/nfs4idmap.c
+++ b/fs/nfsd/nfs4idmap.c
@@ -672,6 +672,8 @@ __be32 nfsd_map_name_to_uid(struct svc_rqst *rqstp, const char *name,
 		return nfserr_inval;
 
 	status = do_name_to_id(rqstp, IDMAP_TYPE_USER, name, namelen, &id);
+	if (status)
+		return status;
 	*uid = make_kuid(nfsd_user_namespace(rqstp), id);
 	if (!uid_valid(*uid))
 		status = nfserr_badowner;
@@ -707,6 +709,8 @@ __be32 nfsd_map_name_to_gid(struct svc_rqst *rqstp, const char *name,
 		return nfserr_inval;
 
 	status = do_name_to_id(rqstp, IDMAP_TYPE_GROUP, name, namelen, &id);
+	if (status)
+		return status;
 	*gid = make_kgid(nfsd_user_namespace(rqstp), id);
 	if (!gid_valid(*gid))
 		status = nfserr_badowner;
-- 
2.51.0

