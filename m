Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A25415F0C;
	Tue, 21 Jul 2026 17:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656264; cv=none; b=oh0gTOFZ6QC+dRlF0WOcgmeHPHw0GbF5ZhH38j40cRmacoujWgTmo3U2L9obdFLQYEyzV14gcAh3nupQhyoVFkz+17ztDdwMtnze6gmNs5qlRtWQ8NwgPbCIgxsl/eiRu2axAVtAhrKPDWOcojCrx0iuII9kq/pibMBRcceJDCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656264; c=relaxed/simple;
	bh=gL4qw7/xOXjE0magUwfotPtqIeQPPgdm7TKsL0IfifA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5ztG9mOfzSd7Lyp5E0LOyd9DQ3Wlhrm5+NDXXmPPfv4niSsiYDlsQfBxnJJcDaPQodEP8m8BIZG0rL5/na6ccJcmyGEsjcfnlHXpFG93nXNOmzC4IcknBzfdNBuN2DgmemJxhpdb6O8RdvUDMXeYoo+pvKH7Pau2O4wjdFtmxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SmPsuac+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SmPsuac+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669471F000E9;
	Tue, 21 Jul 2026 17:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656262;
	bh=LCPx2ljSTgy5HCMitXun7CDscdnjSsLGLvUnpmWRBcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SmPsuac+gsf2gw6o942MM5cYmbh9oZxdFlWNm8j1wpXCS8sEMpRPjLiXKaBG7Wecw
	 xKnHqQdjKhrHAg2rmg0DfKCLcrj8ujJae+GdzdYXLV6KmFbdWJSdzm9EZE66B6JuQi
	 8nIou/87NV0luErf/takaZ4Klaounrz5G+AWcGbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0284/1611] raid1: fix nr_pending leak in REQ_ATOMIC bad-block error path
Date: Tue, 21 Jul 2026 17:06:40 +0200
Message-ID: <20260721152521.445024749@linuxfoundation.org>
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

From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

[ Upstream commit 909d9dc3b5730c8ed7b764c68bc788342df2a07b ]

In raid1_write_request(), each per-mirror loop iteration begins by
incrementing rdev->nr_pending. If a REQ_ATOMIC write encounters a
badblock within the requested range, the code jumps to err_handle
without dropping the reference taken for the current mirror.

err_handle's cleanup loop will only decrements for k < i and
r1_bio->bios[k] is non-NULL. The current slot is therefore skipped,
leaving its nr_pending reference leaked permanently. The reference
prevents the rdev from ever being removed, since raid1_remove_conf()
refuses to remove an rdev with nr_pending > 0.

Fix this by calling rdev_dec_pending() before jumping to err_handle.

Fixes: f2a38abf5f1c ("md/raid1: Atomic write support")
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Link: https://patch.msgid.link/20260530151411.4119-1-abd.masalkhi@gmail.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 84dbf801e9b1b8..df01070eb0c296 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1581,8 +1581,10 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 				 * complexity of supporting that is not worth
 				 * the benefit.
 				 */
-				if (bio->bi_opf & REQ_ATOMIC)
+				if (bio->bi_opf & REQ_ATOMIC) {
+					rdev_dec_pending(rdev, mddev);
 					goto err_handle;
+				}
 
 				good_sectors = first_bad - r1_bio->sector;
 				if (good_sectors < max_sectors)
-- 
2.53.0



