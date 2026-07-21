Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B24C46D543;
	Tue, 21 Jul 2026 15:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648961; cv=none; b=ovr2Uvq7NkJGYv/NJGNtP2DbUJGVLkoHlW1VPVDfUp+v0Al04ZS/CPUBWVlbnbrj7n8coBttsyPLUwjdKVfrGcbBFo9sx5qnYr1MPplrFl56SAOJ4pIk4V8Pb7OF+vMj/nXeT34lEU5YxtswBeAMc3RneFrHUXOFUA5VWjBJ9rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648961; c=relaxed/simple;
	bh=SuUrhoZUHhX9IZlK2/uW5P8CySXRnllTQlSdouQgKpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ze9pZaNuIa4jFoAwySXUi+lKOUtYp5vb+gc/H6BJLhl5eyzgp17OqYNcPjybuvqQaGOc1SH5nr00rLx5auYEdHUPdayrXSsRereOLH+aFT1Wtswzq9oWPzlPunD/lm3Qh0tiZxShdVctHQxy23RFgeqLItjhpB2tKhMUZJGVCAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YVfxv9z8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YVfxv9z8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6861F00A3A;
	Tue, 21 Jul 2026 15:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648959;
	bh=yMcf/pr8VGi+EFMDlRNPR68RZXApuBJH7X7gAZYKD+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YVfxv9z8ZSm3F5rN3lSXKpeYoUyXIdvwb9cSF81w3MHI//aOS/5MFrK2eoq+8Qs7p
	 GOQlHFNX/VN6Vxgm6eDyEuIY7hlPsd+oh1fdcM8DsapidbpyaFptbUCbdQNotKzzBd
	 MxnI/uqB9qVP502oJTlLZ+ciMtweN+cQbGsu2UYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Cheng <chencheng@fnnas.com>,
	Xiao Ni <xiao@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0396/2077] md/raid10: reset read_slot when reusing r10bio for discard
Date: Tue, 21 Jul 2026 17:01:09 +0200
Message-ID: <20260721152602.054162800@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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
index 39085e7dd6d26d..7dc2a5a127e893 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1727,6 +1727,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	r10_bio->mddev = mddev;
 	r10_bio->state = 0;
 	r10_bio->sectors = 0;
+	r10_bio->read_slot = -1;
 	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * geo->raid_disks);
 	wait_blocked_dev(mddev, r10_bio);
 
-- 
2.53.0



