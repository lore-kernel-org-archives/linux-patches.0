Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2130A174ED0;
	Wed,  3 Jul 2024 10:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003626; cv=none; b=cdxhgPWQLbBV5enb3K1UHeNIT2a7+irK5I4L7TtxekVVnK8cqGiQtTX1cdYQtQ7dcploA9Lbr+6AUCnuhy8a12Ctvj1IaL+ThTPtF2Y0lLNKiNyaCvosaboweD3QAeJp23T6QSErG9ABUxvR21G28XoViQmxo4GLqaWp59gm0jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003626; c=relaxed/simple;
	bh=XLynNpUWW//4JF5Km41PS67nQZyNEnL9c8lzvnzIqQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EypTKZfHg2BbAOiCDNrUSZVUz8iUJAidGtikAg6FI0R5ngcgOiml48qjg5GZoctG9d4zg8lgKnxgL1aD8CecE+JhFQJBA3MOxk0P4gzzI4Eag+6dfaVsJVNr76y4G06LAYk3OdlxrtUtVDoxelqQh8lJQngES7G9D+FaDcI9pUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h0DdSRb2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h0DdSRb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6066AC2BD10;
	Wed,  3 Jul 2024 10:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003625;
	bh=XLynNpUWW//4JF5Km41PS67nQZyNEnL9c8lzvnzIqQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h0DdSRb2IOyUM+1mUdV6N/69TBRWuMq5e5yvDCX65rMTaLpND1WKyUDvWYj9fcoCz
	 b3nGDAY1zN5U+4/qxUfK8fye5PRG1sFPg9sppNLTxub0cwr+5vwtr71Oz16nOh/uTX
	 1mwKAcIH3M/xJHoaSzGTgD8m6vzvxUisalBw2nWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 110/139] media: dvbdev: Initialize sbuf
Date: Wed,  3 Jul 2024 12:40:07 +0200
Message-ID: <20240703102834.594524245@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 17d1316de0d7dc1bdc5d6e3ad4efd30a9bf1a381 ]

Because the size passed to copy_from_user() cannot be known beforehand,
it needs to be checked during runtime with check_object_size. That makes
gcc believe that the content of sbuf can be used before init.

Fix:
./include/linux/thread_info.h:215:17: warning: ‘sbuf’ may be used uninitialized [-Wmaybe-uninitialized]

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-core/dvbdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index f426e1bf16f0a..5124f412c05dc 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -964,7 +964,7 @@ int dvb_usercopy(struct file *file,
 		     int (*func)(struct file *file,
 		     unsigned int cmd, void *arg))
 {
-	char    sbuf[128];
+	char    sbuf[128] = {};
 	void    *mbuf = NULL;
 	void    *parg = NULL;
 	int     err  = -EINVAL;
-- 
2.43.0



