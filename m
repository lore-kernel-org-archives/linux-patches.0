Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F29415B9D;
	Sat, 12 Sep 2026 08:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202556; cv=none; b=jK6Z2vVs3mt4oZ2S29dWPhWSO/lOxlDztOnSOimQ6jaDhR5H/RKh3B+Pgmh0XPdvqRLGEfGST4tEyLW6BHiLEZGtRh1/fD1NN3bkwcwQeEzwaXSyZF7ALWTmsUegvmCeN6jblg4Ez303imgZVJkLCwsgI6TO90GaKjBFbk7aA7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202556; c=relaxed/simple;
	bh=dB7Zkto3zZ3niTeYPXGbGiEdzJkIoYGFXmj64Yar3EE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0mpGK+L3vuR7jQeBqbd8+T6TB357XaI7ZbaTVMu3Hoh87P/P+LNT03QjQ58nidc82ZSrJl0mf2me58hjWQYpbp7d1EiOJrFX6mSSgdMWXm0RYru7zlu3Y5GI6Rcx0rcsTw8RWE3SfXgx58nWir2UjN/4BCfjqnjmelKjKjS7hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EIUYmJLc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EIUYmJLc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12481F00893;
	Sat, 12 Sep 2026 08:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202555;
	bh=XQUbSyEvImHniBKUpIzyW028bfTUp5fJVgHOM5hLBYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EIUYmJLcyYElpUBJj1yNWmFZc0dlXBAbAGohncsuwvfEp3EuSBbs2q63NPqabcsjT
	 2lI77Z6/wfu9u7IBwTLT9+ZM6fPE1eYWRS1hMfUATA3lXeCxho5n0NKZBjXoRehjU1
	 rwCYEGayS2aE6Ej9CA0uwXQQ79Dk8bS4caFQstR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykola Marzhan <mykola@meshstor.io>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1190/1815] md: avoid stale clone I/O accounting timestamps
Date: Sat, 12 Sep 2026 08:49:00 +0200
Message-ID: <20260912065716.946880342@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Yu Kuai <yukuai@fygo.io>

[ Upstream commit 45102fc8330525d35675b1c193242bba101df5ee ]

md_clone_bio() always allocates the clone from mddev->io_clone_set, even
when queue I/O stats are disabled. In that case it does not call
bio_start_io_acct(), but it also left md_io_clone->start_time untouched.

The clone private data comes from a mempool and can contain data from a
previous user. md_end_clone_io() checks start_time to decide whether it
needs to call bio_end_io_acct(), so a stale non-zero value can make the
completion path end accounting that was never started for this bio.

Set start_time to 0 in the no-stats branch. This keeps the end path tied
to whether bio_start_io_acct() actually ran.

Fixes: c687297b8845 ("md: also clone new io if io accounting is disabled")
Tested-by: Mykola Marzhan <mykola@meshstor.io>
Link: https://patch.msgid.link/20260802195038.164272-8-yukuai@kernel.org
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1603856c644b3..b9aef7ba11515 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9439,6 +9439,8 @@ static void md_clone_bio(struct mddev *mddev, struct bio **bio)
 	md_io_clone->mddev = mddev;
 	if (blk_queue_io_stat(bdev->bd_disk->queue))
 		md_io_clone->start_time = bio_start_io_acct(*bio);
+	else
+		md_io_clone->start_time = 0;
 
 	if (bio_data_dir(*bio) == WRITE && md_bitmap_enabled(mddev, false)) {
 		md_io_clone->offset = (*bio)->bi_iter.bi_sector;
-- 
2.53.0



