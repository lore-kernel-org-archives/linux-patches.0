Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC9030E0DC;
	Sat, 30 May 2026 17:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163862; cv=none; b=R7a0tz4RNzq7AF9F9eoWZvW3bG34wYZ9a/Xet2Lzr3LEj/tPLqigDKIP7cTJJxbOEYDL6F1c3GUrCbwtACNyFGl45hcGlR8fs1tvbikDPS28ETrldDmD8CGOrVMsKwmUNZyxKRwlmiEOLlbVSowW0azjevVYIpyoAs/Ry+RCrGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163862; c=relaxed/simple;
	bh=LztCx2l3P/J1Mmo/p0uP/1Q5JjCxMA0l1a1V57k+V9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6TL2TjvwnVfdtBEXGKwWXnGfu8B1tRzqRSVjZu/TuT1Vtu5hKWvcrJzvrRLywcoJhQ/yWxTMqIa7wlKjG+nz1DEaS/ATRmlpHa++fAUDwe+IRPzFP8rMy7/uP8x5QozC1EoLA1FAxWMNOmQC+6wmJxLZkSkXthZQPOnh1v2Vag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1InHqGnf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1InHqGnf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1151C1F00893;
	Sat, 30 May 2026 17:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163861;
	bh=AEVQCHLetR8H8cCBpzk2zDuHYI8jBNiKbKRIyEz0R+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1InHqGnfrmTj2mx/i7I117M1h/pz6eH+jrchLdLNtFXHhirjqKJWJe/HCHeOiPxjV
	 MKf/HT5mONtEJo0OgpDHurUDhbsCPfvLGqY20L8GnxCb0ac57ct46P5nbGBfpdTiGN
	 fjytAK4iS8exExJF4oPrhH/hwck6gtse2T8p2ZvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingzhe Zou <mingzhe.zou@easystack.cn>,
	Coly Li <colyli@fnnas.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 384/776] bcache: fix uninitialized closure object
Date: Sat, 30 May 2026 18:01:38 +0200
Message-ID: <20260530160250.434988050@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingzhe Zou <mingzhe.zou@easystack.cn>

commit 20a8e451ec1c7e99060b1bbaaad03ce88c39ddb8 upstream.

In the previous patch ("bcache: fix cached_dev.sb_bio use-after-free and
crash"), we adopted a simple modification suggestion from AI to fix the
use-after-free.

But in actual testing, we found an extreme case where the device is
stopped before calling bch_write_bdev_super().

At this point, struct closure sb_write has not been initialized yet.
For this patch, we ensure that sb_bio has been completed via
sb_write_mutex.

Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
Signed-off-by: Coly Li <colyli@fnnas.com>
Link: https://patch.msgid.link/20260403042135.2221247-1-colyli@fnnas.com
Fixes: fec114a98b87 ("bcache: fix cached_dev.sb_bio use-after-free and crash")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/bcache/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1382,7 +1382,8 @@ static void cached_dev_free(struct closu
 	 * The sb_bio is embedded in struct cached_dev, so we must
 	 * ensure no I/O is in progress.
 	 */
-	closure_sync(&dc->sb_write);
+	down(&dc->sb_write_mutex);
+	up(&dc->sb_write_mutex);
 
 	if (dc->sb_disk)
 		put_page(virt_to_page(dc->sb_disk));


