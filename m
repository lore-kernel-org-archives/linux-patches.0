Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFBD1BD9D0;
	Wed, 20 May 2026 16:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295591; cv=none; b=NltGoHqq1E+wfuKTiv/p59NRtY4CmySRe17LdxFA0VizgFSKC5RFiqj9BC+7R+JhMYE+rqX7g0F/+Fc+gLo+qGpPAWax1hyrKrsWQWpglYBK281qCsxinZCNyjtbonarkk7tLDQnfNjM71JCrtIYZ8GGs4XHu5qtUZSP+Jl446I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295591; c=relaxed/simple;
	bh=AqidraC83xNTXbib9cWyCfGTkge4lCs+Rwux8m06rPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mya1ioQEC1cCi/hduK9G8ap4OWCiOYfmBDChk7U4TaGVp1wqe2NXueI9FbeLjm08gkmjDKMyNuIfWKMYDR+E9tXHE6khcFMH7KIzuSqXm7+G9Kl5VXI3c+QC49/GALX1420jDD5La8/m061CbPmxW2r7PxxEJ1bOgAjcolW0f1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cm0GCQ+N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cm0GCQ+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57FB71F000E9;
	Wed, 20 May 2026 16:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295589;
	bh=xZZkADcHy9Q0CeEkda4T+NYB53tB2rDOaPej7Qq/1dA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cm0GCQ+N+tXlQ6iGEvc47Wkta+T125Hjc8uSuPh7ug6lY9pTR3lZbovDPu5zHxWN3
	 riUeKoC8tg5Jg6UauOq2ASdkQz4O4tMhxB8p9C/77enuv9pT7eodo1fAsCYlyp99MW
	 TKgysEo+xmGTx52PrQ5+R41cdJIJzPzcf6MZvsDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0436/1146] dm cache: fix missing return in invalidate_committeds error path
Date: Wed, 20 May 2026 18:11:26 +0200
Message-ID: <20260520162158.066273816@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming-Hung Tsai <mtsai@redhat.com>

[ Upstream commit 8c0ee19db81f0fa1ff25fd75b22b17c0cc2acde3 ]

In passthrough mode, dm-cache defers write submission until after
metadata commit completes via the invalidate_committed() continuation.
On commit error, invalidate_committed() calls invalidate_complete() to
end the bio and free the migration struct, after which it should return
immediately.

The patch 4ca8b8bd952d ("dm cache: fix write hang in passthrough mode")
omitted this early return, causing execution to fall through into the
success path on error. This results in use-after-free on the migration
struct in the subsequent calls.

Fix by adding the missing return after the invalidate_complete() call.

Fixes: 4ca8b8bd952d ("dm cache: fix write hang in passthrough mode")
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/dm-devel/adjMq6T5RRjv_uxM@stanley.mountain/
Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-cache-target.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index e479ac22b97cc..af7a2571988b4 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1521,8 +1521,10 @@ static void invalidate_committed(struct work_struct *ws)
 	struct bio *bio = mg->overwrite_bio;
 	struct per_bio_data *pb = get_per_bio_data(bio);
 
-	if (mg->k.input)
+	if (mg->k.input) {
 		invalidate_complete(mg, false);
+		return;
+	}
 
 	init_continuation(&mg->k, invalidate_completed);
 	remap_to_origin_clear_discard(cache, bio, mg->invalidate_oblock);
-- 
2.53.0



