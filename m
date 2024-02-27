Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBEC13A26F;
	Tue, 27 Feb 2024 14:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042914; cv=none; b=Xh60C7VzZB6Dv+HgtDxI86xrz7ibaAXrlyfuhPsWtp9McSNvS4Gq76PjKEY0gChUsz1l9qN0ryN52FVREsjfmAoqolA6vMlqB3vfDlledwh/ztoCCZXf2N23qN4GWaaj+0qinuXTi5R4Jv/1AH3zHHwR2dtqi+i/roZAapokG3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042914; c=relaxed/simple;
	bh=S1uWKbeISUfnf+4SbW7d8LpNXukt6pyRU9I4ep4m178=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ID/vXPsO0v3QXn6rskFCa/u4CxsmTYrdgB1N0hrUMMbm6RZ505mVbK+/UWu/+p/MsxfZba6I8IAWsY/lhZy2H+7f2nMf3mT+XZDpIi1hWSuMBvHtVJl9lKAJa6/uTq5KhhXp49GUdSlf4UeSkcFuJ78PYsYQrqtbClzBm1NP+7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fg2Rrqfc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fg2Rrqfc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A92BC433F1;
	Tue, 27 Feb 2024 14:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042914;
	bh=S1uWKbeISUfnf+4SbW7d8LpNXukt6pyRU9I4ep4m178=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fg2RrqfcARt5DXax/1GnAT76xDlmvACLNAcFZRqr+Qf/H1/qLrM/Vu21CwtSSq5z7
	 W19GzriwQ0ICHkCTzXXzaHgmjXEGaJPvgeogu+CRxZyHPoAcmkBBpsUxW2OypmrvXv
	 1nBi9B+eVaSukZWkVLpwU/3+bc4srzK4x5obiJrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Neuwirth <reddunur@online.de>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 167/245] md: fix data corruption for raid456 when reshape restart while grow up
Date: Tue, 27 Feb 2024 14:25:55 +0100
Message-ID: <20240227131620.638926407@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 873f50ece41aad5c4f788a340960c53774b5526e ]

Currently, if reshape is interrupted, echo "reshape" to sync_action will
restart reshape from scratch, for example:

echo frozen > sync_action
echo reshape > sync_action

This will corrupt data before reshape_position if the array is growing,
fix the problem by continue reshape from reshape_position.

Reported-by: Peter Neuwirth <reddunur@online.de>
Link: https://lore.kernel.org/linux-raid/e2f96772-bfbc-f43b-6da1-f520e5164536@online.de/
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230512015610.821290-3-yukuai1@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ff65e5eddfa18..a17f2f725822a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4919,11 +4919,21 @@ action_store(struct mddev *mddev, const char *page, size_t len)
 			return -EINVAL;
 		err = mddev_lock(mddev);
 		if (!err) {
-			if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
+			if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
 				err =  -EBUSY;
-			else {
+			} else if (mddev->reshape_position == MaxSector ||
+				   mddev->pers->check_reshape == NULL ||
+				   mddev->pers->check_reshape(mddev)) {
 				clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 				err = mddev->pers->start_reshape(mddev);
+			} else {
+				/*
+				 * If reshape is still in progress, and
+				 * md_check_recovery() can continue to reshape,
+				 * don't restart reshape because data can be
+				 * corrupted for raid456.
+				 */
+				clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 			}
 			mddev_unlock(mddev);
 		}
-- 
2.43.0



