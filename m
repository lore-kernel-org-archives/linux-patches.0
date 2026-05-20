Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4480312825;
	Wed, 20 May 2026 17:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298242; cv=none; b=S3+AAafYc/kTRDl7SYM5UfU1oun8+1N145SiMIffh+ZSf9gWPLi/ARPrLFEjyOKiZDwH4zmAhdy/lfsmAB0e2/k5oI+fs/MYWgg2K0uift97piENZPb9pSNyrJnKIGf5q+1mehjspDw+kAwVrDW8dn6QAXBdNke0zDMHXv1G4F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298242; c=relaxed/simple;
	bh=uLm0ASMj5VwvdAklJD84KjjdtBBst7sNRxkh4bk00BQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AIvEgKp9ozs/03g17EcGVT4sPxO6q+I8by1alwfo9tc7oKM/XHKO30u0wTYt3LTw8U5IvSkXNtpFAPoJEhVK/sL5s1Hdey7ckXMCKB5W2kQiEvnWMdYMklDS9ruF/0LTHd9zO7mTAuvoq6xqGOLHizICL4jLME7wOmgVBMiHNfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xTs4ABx5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xTs4ABx5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0281F00893;
	Wed, 20 May 2026 17:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298241;
	bh=0og89KdK9je2YXuetatqQGgcEeg9oYEkWuJvYDuDyhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xTs4ABx555kEo/pG5NqsZ2FgFp1nQfk27CgEtuPdie6BrjK4RQawYFVhay5Sazqg8
	 f9DSupJx3CXBY/E0pYVr/QMgwzSjjXqI93RGjRZYblRyHwUAtM/68AhMTKSsspntMZ
	 iiPPgrh0yaq9lVRyabaN2kruOexDiLxw7MCaHYMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 335/957] dm cache: fix missing return in invalidate_committeds error path
Date: Wed, 20 May 2026 18:13:38 +0200
Message-ID: <20260520162141.796112867@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index 9c64fe56ecb6c..bb0b484d4d687 100644
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



