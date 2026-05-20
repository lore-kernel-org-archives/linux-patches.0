Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B192F3F871A;
	Wed, 20 May 2026 18:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300636; cv=none; b=JwMRvu09u3niCn5VeqWAykA6W45onKtDlBrfHmkrcrr47XmkDNvpJQoXFe6is0oW9mkVe3ohwjuF3j9XOU3HBOx/XHl8ip9jLO5HeuMkcYv+I3gc9y9FlA9jE1WAON/usAbB4pgsTDY0Gxz/rHWHZhARplda98LjnIbLz08IAj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300636; c=relaxed/simple;
	bh=sktgp9MnaaI4rVuBaLhCJhyjI3yVATM9i5nq8F96HWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=usgjwvpFf+TyqwoK6WndUjB1c/vSE35Mh5ggzLxaW97USSnLH1IC99NAf4DX1OL3yT60TLEj2vHDtLKpkFVaHgye+wPu1buM2yak3PKRwyMEpCsZ+NK0OUMS9Wg503eztykfuLxVaLP2Iox6/IwRK0mmyOGLZkwqjY8JQDQPMWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vqRyxc+T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vqRyxc+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F411F000E9;
	Wed, 20 May 2026 18:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300635;
	bh=eAvCd5D7SVvBEk4s3k6wIQ9+nN6RGlbJwadeW7MLT04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vqRyxc+TjcU9IP84mDML2mfBRca/nFYh71G2e0eubAcxfLjkrl3+e26BMHtM04KWa
	 KqHJYyeRcq0cMQEl3gKR3cKiwjk0W3iiElE/SOgHQhHQcfHZNQEk1VzlduoBUalf88
	 ROZBkZr/q8KjJRbLPzF3uHV3WHZgv0ow9ZRQMEjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 248/666] dm cache: fix missing return in invalidate_committeds error path
Date: Wed, 20 May 2026 18:17:39 +0200
Message-ID: <20260520162116.591726794@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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
index 68751841e124f..3a7881c0a5b13 100644
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



