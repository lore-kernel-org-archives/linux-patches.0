Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2439470428;
	Tue, 21 Jul 2026 17:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656235; cv=none; b=Xlu8UVvD00zs/cigqr2W8T4zI68MDBbssdHZvW6g/K3agsu0kis7w3IQEJq+gz8yXk3NL+bFZOfnifNIZaaasnlqPlWTYKz99dKveDs14Bf93+gmL2oqzCIAFVYEHbQ8GBMD1imwN16CgxZD12CFPbMHv2MGlz1imL+ou/vCUsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656235; c=relaxed/simple;
	bh=INaywhpv1bQ7fwebFUAZGz7rEDQqGqWdYA8euG18SVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sKCLbVOVjxLxbdXKj7DoVUyvKm3+QwNxoASGaTI+AbNks2Qu5H/3HG4llGzuhVMHHED49R5ZfJbmxmP89brTtHN8udEAen46G/AB6uPdWFxzSNBbaaRLVHvgEcyMzAjOi6+ZZwx0o3OT2vbvi6zHeMzXPMK/OZXYnU8nMwXt8Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sBjQQplg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sBjQQplg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366451F00A3A;
	Tue, 21 Jul 2026 17:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656233;
	bh=eBdtkpdH0/JonvwxveURm6YJskgdv1zxG5jQ3MLkhko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sBjQQplgu00hIqqB4jG4wNWr38DhLZuhxiN37fgsgNlqsuuKMr4UQaWBtSi8YS1eY
	 5VlVYDbqTbNMg40Pn3ZL/XGaAqoE5ACRmK98jopya2jpNlsypuJBt0mGBD7yosYzh2
	 mQweygyeOT2ReJ8k/phu/P1xv9LB2bJ/szKcxIto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Cheng <chencheng@fnnas.com>,
	Xiao Ni <xiao@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0283/1611] md/raid10: reset read_slot when reusing r10bio for discard
Date: Tue, 21 Jul 2026 17:06:39 +0200
Message-ID: <20260721152521.422404590@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 2815c05d1c9f0b..4a8814fd75cd0e 100644
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



