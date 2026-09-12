Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F19F47B439;
	Sat, 12 Sep 2026 12:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217525; cv=none; b=fG4xAgfe/Dv8PbJn4vEASkHRoO5cEDrTQ2HscTw4zczIZO6++Cw+zHY2+xP9qboxQt/r4ZxwwnEAMcRgCW5s+QAuXStEqX90oCNko3TEX7GReQE8B8g8YoEFS1x+AbS/x7kJDfhdE5NITmzXaQUkAxjW9QBVz4lxuLTKuszy7r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217525; c=relaxed/simple;
	bh=2qlyE7d/UhI5+Cevk8W0n7upPkvEERzuOLj4qw55BVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HeeE2ZOSfCUcm9LCVH1hAkUaXuy2NuyHsq6aLhRHrg4x720rVC0nREF013CbjtRIZb41rtqhimpNGxm6EjPcgH6oleBF76YarvDxNcpVPV8s1+JRbu/GJJu/ie1obb2MYR5nvhHPQuBRuloVrUr9J7t2ARh90vAxJFeP9ZTL2Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Coc4z/rY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Coc4z/rY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0688B1F000FF;
	Sat, 12 Sep 2026 12:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217522;
	bh=YaRFF8zLP9fg7xVh/o5DctQpkYPs30A7dDGOc5XXB5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Coc4z/rY9gRAmiV8Tx4xE4zlLn50G++Jg3oLDCqabEL7F/ZRXbpUPDrCYmWiPWIHb
	 7TiYqTJ/l3LCDDnnTTK6u7qxZ3R4N/fLy1ZoFdHtUYpLifZcXrG0BXnDnFFKINrW3Y
	 wP41T1Sa5OxTkJFuHTD1atLCxlKHJuZoqk0ICyrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bruce Johnston <bjohnsto@redhat.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0957/1376] md/raid1: dont set array_frozen in raid1_takeover()
Date: Sat, 12 Sep 2026 08:56:23 +0200
Message-ID: <20260912065628.889664108@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Bruce Johnston <bjohnsto@redhat.com>

[ Upstream commit dc386aa0ac0a3ec06c9a3ea9b064b073fb72a916 ]

raid1_takeover() sets conf->array_frozen = 1 on the newly-allocated
r1conf and nothing ever clears it, so every I/O to the array stalls
permanently once _wait_barrier() sees it stuck at 1.

This used to be harmless: level_store() called mddev_resume() right
after pers->run(), which called raid1_quiesce(mddev, 0) and cleared
array_frozen back to 0 regardless of what raid1_takeover() set. Commit
b39f35ebe86d ("md: don't quiesce in mddev_suspend()") removed that
quiesce(mddev, 0) call, so the pre-set now sticks.

setup_conf() already zero-initializes the new r1conf via kzalloc, so
just don't set array_frozen here.

Same class of bug as commit 892da88d1cd9 ("md/raid10: fix a
'conf->barrier' leakage in raid10_takeover()"), also triggered by
b39f35ebe86d.

Fixes: b39f35ebe86d ("md: don't quiesce in mddev_suspend()")
Link: https://issues.redhat.com/browse/RHEL-191802
Signed-off-by: Bruce Johnston <bjohnsto@redhat.com>
Link: https://patch.msgid.link/20260803180240.1177104-1-bjohnsto@redhat.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index c6ad1f97cdace..32b2eb2a169c3 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3482,8 +3482,6 @@ static void *raid1_takeover(struct mddev *mddev)
 		mddev->new_chunk_sectors = 0;
 		conf = setup_conf(mddev);
 		if (!IS_ERR(conf)) {
-			/* Array must appear to be quiesced */
-			conf->array_frozen = 1;
 			mddev_clear_unsupported_flags(mddev,
 				UNSUPPORTED_MDDEV_FLAGS);
 		}
-- 
2.53.0



