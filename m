Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8B144AB62;
	Tue, 21 Jul 2026 22:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671538; cv=none; b=pS0buy5u5gySiJJHG4N92TaQIcJIVk1sCEg5UoJ3uR/03VM9qCPtkyCQBU7mRsQ3/F+PVIDPgdw7QxZ9q8oEhmjg7Rs7FM7X0i/1NJJDVEAaLaVz7v51ct2GipLDbFnVrAVy5HXGhOs722Oy74mzfdbVgpCnOqSFixYTM/xo+VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671538; c=relaxed/simple;
	bh=3E8PW6dGQAKwSOmW9SIpKc7UtT1WBpub/fxnIgWUJvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cP6RDMsRkdR6gXcFUuzBL7HFoHAe/hH6dyw9noXUDsNHB/VC66QKzwFDnOhATwYt50L48DvfSlOO58lCaBEjhJN5Y9pbmK8ydpzJ9xklS3vFtk5+FCzB7MKIO4Ps29slXOOqH2qC02risJbYPYVg2XXWXKLU64myyXDc4UJu1f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TenVSHpj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TenVSHpj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E1CD1F000E9;
	Tue, 21 Jul 2026 22:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671537;
	bh=w+qsOYzDjek+dcRFqjIn7Ei30XEuJSh+4V0DzVBzT+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TenVSHpj74yf2YFEHaejY8w9fOxTp1s/vxElqr8tjhy7b9QX2tzXXt47neczx8gz2
	 Nxx5KOLlrn1Dh/qo7MJICXkMXeSuAv/XsP/uZjS3+x+P65Ljjw+75Gv2Y2rDxaBBCG
	 H5o+u79pTzZ2OsI8p/XmyeETkyh8gjJ/QaIgEYg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Cheng <chencheng@fnnas.com>,
	Xiao Ni <xiao@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 284/843] md/raid10: reset read_slot when reusing r10bio for discard
Date: Tue, 21 Jul 2026 17:18:39 +0200
Message-ID: <20260721152412.417289358@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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
index 225fa6fb183b57..f14d5427a3c46f 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1766,6 +1766,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	r10_bio->mddev = mddev;
 	r10_bio->state = 0;
 	r10_bio->sectors = 0;
+	r10_bio->read_slot = -1;
 	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * geo->raid_disks);
 	wait_blocked_dev(mddev, r10_bio);
 
-- 
2.53.0



