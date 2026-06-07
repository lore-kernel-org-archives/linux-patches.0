Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5584071C7;
	Sun,  7 Jun 2026 10:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826774; cv=none; b=NE1vyCtSiRo7ZBXgnlE4Ozzl4tsCf+7dSeoCtvIoK3/oxAttnnrdNgMiusGk2gzLpwpnwt8ERW4hcpvt9A7U1i3G/Mnpt7p4dOttxqJb3jqsxu3tUIxphZfsxn97G7gG0aD0qw4dpkVqzq9s/Dw1vhTIw/zzXvsHCaSB/7cro5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826774; c=relaxed/simple;
	bh=eKCN69UiQGhtjQfrm1rEFn4Jhf/7LR6O9RUYrBy2vQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRjP+q3nCwnEwHahO/nI84Hd4JhQ/n13m7CGygWgDN66RP3pkQ58Cn6bsdQZn+db1oTgvv8peT1KHkHaQoYQyKqckMHY0byhXzcr4PEYW+TZ5XbbSJ7Touu7Jqa3PaNHp6nuBDO97kv+B+jCOYG8E5AFS0okujDhHtPmWoDhaKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f8BRxRSz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f8BRxRSz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0971F00893;
	Sun,  7 Jun 2026 10:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826773;
	bh=0O/DSxirEweSGGS3TY4BpTWDhW4MPxq19ZbJgWH/URI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f8BRxRSzLKqcpiyVGGO0Pfn5BV3Vuoq96HNgYc7hBV+geDd7GLzHw4T/aCFL+Ui20
	 ylETtNH8JK9nP1lMCDUDJmGQt25xMoYXssbMKF6CdRny4bfLO9GBpGkNlFwkM0a4q+
	 xO800XdwvJ75WeLxORche/AdU940qmML2IQeTCWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingzhe Zou <mingzhe.zou@easystack.cn>,
	Coly Li <colyli@fnnas.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 006/332] bcache: fix uninitialized closure object
Date: Sun,  7 Jun 2026 11:56:15 +0200
Message-ID: <20260607095728.262231133@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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
index 6627a381f65ae7..97d9adb0bf96b0 100644
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
 		folio_put(virt_to_folio(dc->sb_disk));
-- 
2.53.0



