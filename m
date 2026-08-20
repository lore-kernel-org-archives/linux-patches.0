Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D19377016;
	Thu, 20 Aug 2026 15:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238500; cv=none; b=mjarXL7AgVmpT3z4Im6HPgztUdGMNLh3BWo2C4FulxYSUqaVdm1aIeuK8oR926UEAtgEN8CvZNqsxLHJeSOaFrjvBwIDOK0X91LElHH2U+uoo1ghnyu9594ivtm5K6P1CV5W9peLofYNuxB9T4Xgby5KdDYf+4JS8I//zCdIfK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238500; c=relaxed/simple;
	bh=FuXe8Jw+czQsoh0mbHEtIbibF6g/bLoJ1mItn4ejawA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NgP70+tuYGrtgUBT8w5B6SeDNUNRy40TzYqDMwGAOqz6e1boP+ben5/mhebj6ipck6Npu6vWB+jnbtgAOZrACJ985jUc4mUM3N2Wc0Z4xtre+crEJSOcu1X6KfMPTNbvSyQEhLBJGt1JyKGUh7em+hee2V9/fDy/LXQ/Ghm1Kfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QAmLEGyj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QAmLEGyj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34081F000E9;
	Thu, 20 Aug 2026 15:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238499;
	bh=Q0T6jskRKlNDQ6SWerifTVr6L4/aZISPuGzTp+UdzK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QAmLEGyjNEz+fFuEqWE37psd7tWgfsDron5DO7gw4r9Se3Z4OCSjIBtwBmj3TCnnb
	 kfOMqyrEN0oaln5yLWBg7ON32eAFB/oepHsMXBVRmrNvko8jYkAhOT9o5oqdcSo615
	 73Qius3oNp6/mCQibSr04U3JMHOGk1I8tgibcudg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 169/228] rhashtable: fix false-positive lockdep splat on rhltable destruction
Date: Thu, 20 Aug 2026 16:55:11 +0200
Message-ID: <20260820145249.824485710@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 1132c38927886259c694f77cd74fc577c2216eeb ]

Blamed commit removed ht->mutex usage during destruction but forgot to
switch rhashtable_free_one() to rcu_dereference_raw(), this triggers a
lockdep splat when an rhltable gets zapped.

Fixes: 09ae540e1d5c ("rhashtable: drop ht->mutex in rhashtable_free_and_destroy()")
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/rhashtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 208cb3558f8c2..bd3168ca4ae23 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -1159,7 +1159,7 @@ static void rhashtable_free_one(struct rhashtable *ht, struct rhash_head *obj,
 	list = container_of(obj, struct rhlist_head, rhead);
 	do {
 		obj = &list->rhead;
-		list = rht_dereference(list->next, ht);
+		list = rcu_dereference_raw(list->next);
 		free_fn(rht_obj(ht, obj), arg);
 	} while (list);
 }
-- 
2.53.0



