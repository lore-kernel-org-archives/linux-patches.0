Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC839346A0C;
	Tue, 21 Jul 2026 20:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665871; cv=none; b=fZsRED4dShjYzabDdPpKbBQfo2zyp3KEIFOaxbfEGo9Utz95OtUXHZ7vSTUbSFZsTrLAEp1XVw6noZgeFswbnr3HxhOaj/4IknKLHiamk9La/UcbYpTyZZzvY0M3nAn1LKhgm8DoyL36lkQD38y+J7Z8pWX3Q1Tcfs3QiNMxnWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665871; c=relaxed/simple;
	bh=ThiUx+BPHdO0KZohkxVndnswyLz+CHifXkxtT1bQFB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LT23Wd6BrMCYs9j+jgD1MvaoIjD8s8i5QuEmaHWtW+QEwxEJQpn3puNvb2sf/0q032BbMd6eyvoyWMdpnDKbHbGexrP4mZiLl0zaK7BNeBB2nkW8plo00bcUrtaj+GN66u8lJ8kK5V1iC02ffMZZKO062Qsq+XrmqOtEqd6l6Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rRkvXLaT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rRkvXLaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054FD1F000E9;
	Tue, 21 Jul 2026 20:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665869;
	bh=opFd4kyzguKHwS0jm6B1X1/0m9EZuVbRVBfZtT5IiaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rRkvXLaTJFr/mF2tiHBeckdiPq+kHG0i6gTgeqtmRHARDryF4BEpBT3j2OC6+NsKr
	 q8F822h1YiEDaWL5A7XgmcVIsC+oIqXGIUGbuLiTKtewmG1CDce/mDubkidPtv4b9H
	 crSMmKN38z6DBxCsaAhxmV7s7G+7lz0WsedPsi9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Cheng <chencheng@fnnas.com>,
	Xiao Ni <xiao@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0468/1266] md/raid10: reset read_slot when reusing r10bio for discard
Date: Tue, 21 Jul 2026 17:15:05 +0200
Message-ID: <20260721152452.307447247@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Cheng <chencheng@fnnas.com>

[ Upstream commit 6b8a26af065ddc93de2aa5c9f0df98dce9723442 ]

put_all_bios() always drops devs[i].bio, but it only drops
devs[i].repl_bio when r10_bio->read_slot < 0. If discard reuses an
r10bio that was previously used for a read, read_slot can still be
non-negative, and discard cleanup can skip bio_put() on repl_bio.

Reset read_slot to -1 when preparing an r10bio for discard so the
replacement bio is always released correctly.

Fixes: d30588b2731f ("md/raid10: improve raid10 discard request")
Signed-off-by: Chen Cheng <chencheng@fnnas.com>
Reviewed-by: Xiao Ni <xiao@kernel.org>
Link: https://patch.msgid.link/20260515093019.3436882-1-chencheng@fnnas.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index fd03c01bcf2571..ca9ae89c6d1dc2 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1744,6 +1744,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	r10_bio->mddev = mddev;
 	r10_bio->state = 0;
 	r10_bio->sectors = 0;
+	r10_bio->read_slot = -1;
 	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * geo->raid_disks);
 	wait_blocked_dev(mddev, r10_bio);
 
-- 
2.53.0



