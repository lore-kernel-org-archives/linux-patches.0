Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C4A1E98E3;
	Sun,  7 Jun 2026 10:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826938; cv=none; b=q4qBebdOqiDqhn+8XtFhGZDGeULjHDYawuuS88N85Ot+JtVQCaWgT2Tz4bf0y1htvIFmdLbyoLIlC9AZLT05S+nNjrZ+avJcl1XaAW2UIEB++gB1k7IvKAfKlv+0ehKdDr565AXEFmRw5Vf/MMJseH/JL0WYUdeut0koPqRu1YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826938; c=relaxed/simple;
	bh=O4TGaDJAjK6LD9vVfHIBlB7uMqcYVJX7Z9LNkFms6Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YhjUf5er/KPN7+MoHcg1sCKYizhyavJJx0LoRRfo2zUkxhtZ9eV/wSOS+Nquh2pm4E4tiiKjyT3C7iDWlAPwdbej9rlBdktu3MCaeHBn1By4lwYOkjUBCFm587IpfJU04hNZ+SGt6sFNusdoTwELoCamDb34HwLXbzqz5XuqWbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DJsOxzlZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DJsOxzlZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B4E1F00893;
	Sun,  7 Jun 2026 10:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826937;
	bh=c5ZqpOUf5tGlEozGyPdkcQSDu23Slo7apMp8XRY5xew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DJsOxzlZ1KOwG+f4CaZrBH09OSPuGtTvV4iQ/OqVu6D//oP/eRssYwA2n07GG/K6x
	 bQ4Pj8EbvdGTube3qpDHgoCQxqHU1Jp+hhsO0fBuycBGdTUVHdGTz+dmHikpd39bu7
	 QDHEkY6HKuCXSgCn+1AttRSwYSrUXgTQjyJgU36I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingzhe Zou <mingzhe.zou@easystack.cn>,
	Coly Li <colyli@fnnas.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 008/307] bcache: fix uninitialized closure object
Date: Sun,  7 Jun 2026 11:56:45 +0200
Message-ID: <20260607095727.944483067@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Mingzhe Zou <mingzhe.zou@easystack.cn>

[ Upstream commit 20a8e451ec1c7e99060b1bbaaad03ce88c39ddb8 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 6e0ac0958c10b5..f969ea43492531 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1378,7 +1378,8 @@ static CLOSURE_CALLBACK(cached_dev_free)
 	 * The sb_bio is embedded in struct cached_dev, so we must
 	 * ensure no I/O is in progress.
 	 */
-	closure_sync(&dc->sb_write);
+	down(&dc->sb_write_mutex);
+	up(&dc->sb_write_mutex);
 
 	if (dc->sb_disk)
 		put_page(virt_to_page(dc->sb_disk));
-- 
2.53.0



