Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205F131A04F;
	Mon, 18 Aug 2025 12:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521672; cv=none; b=jSCC90L/ZRTEv5MTd/JivzLyJZ6o5E1gvfvcjOjFWwe7M/D3VYszgJh2QM+WlYwDphUcmBPuREmaz6l4ZeeCkVLROZ2yKBNk/7C230+fWe88DGMpXS1qP2SH+P79+WYU6U78Hee42I7O8SJyX7izrECieci0+wsmHxy46QkSe4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521672; c=relaxed/simple;
	bh=AxgdvljR/BqxouG0EsB02x/waAk5QINpo/PktoOou5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IcoUCVQsqFH7+jIE2H2uACl+43cN4elka+8Id9/0OuhoS2HFTw82eg2Ip4LrSnYTJNGD2s82i2q7xqZnCvuaceJw5eeapEmapxF0toe1vliMBZbkx/ujbBZSFBFmIqlJOYmzWNbwWoAyKCeks5RQ+0Q/YsShru7mEeud+e3gWbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vKMUc6v5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vKMUc6v5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854E4C4CEEB;
	Mon, 18 Aug 2025 12:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521672;
	bh=AxgdvljR/BqxouG0EsB02x/waAk5QINpo/PktoOou5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vKMUc6v5nfz5joplOx1mvTdeXDCmOr/juxFWqGxMUqoIDTJVjsyzrvsExZtGKRzgx
	 bP3sPQ8wlXyLDPGPJNbsGbEibKZTmTdPU/SgdEjzvybEcGNb1sFsgZPbb2V+MjybFv
	 kP42CrbrFnnZUlqR/StX0FrCAg1f427nfid/f9xY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Xiao Ni <xni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 089/444] md: Dont clear MD_CLOSING until mddev is freed
Date: Mon, 18 Aug 2025 14:41:55 +0200
Message-ID: <20250818124452.283798260@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Xiao Ni <xni@redhat.com>

[ Upstream commit 5f286f33553d600e6c2fb5a23dd6afcf99b3ebac ]

UNTIL_STOP is used to avoid mddev is freed on the last close before adding
disks to mddev. And it should be cleared when stopping an array which is
mentioned in commit efeb53c0e572 ("md: Allow md devices to be created by
name."). So reset ->hold_active to 0 in md_clean.

And MD_CLOSING should be kept until mddev is freed to avoid reopen.

Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
Link: https://lore.kernel.org/linux-raid/20250611073108.25463-3-xni@redhat.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 91cece996250..6b5b69a7a3f0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6380,15 +6380,10 @@ static void md_clean(struct mddev *mddev)
 	mddev->persistent = 0;
 	mddev->level = LEVEL_NONE;
 	mddev->clevel[0] = 0;
-	/*
-	 * Don't clear MD_CLOSING, or mddev can be opened again.
-	 * 'hold_active != 0' means mddev is still in the creation
-	 * process and will be used later.
-	 */
-	if (mddev->hold_active)
-		mddev->flags = 0;
-	else
-		mddev->flags &= BIT_ULL_MASK(MD_CLOSING);
+	/* if UNTIL_STOP is set, it's cleared here */
+	mddev->hold_active = 0;
+	/* Don't clear MD_CLOSING, or mddev can be opened again. */
+	mddev->flags &= BIT_ULL_MASK(MD_CLOSING);
 	mddev->sb_flags = 0;
 	mddev->ro = MD_RDWR;
 	mddev->metadata_type[0] = 0;
@@ -6615,9 +6610,6 @@ static int do_md_stop(struct mddev *mddev, int mode)
 		export_array(mddev);
 		md_clean(mddev);
 		set_bit(MD_DELETED, &mddev->flags);
-
-		if (mddev->hold_active == UNTIL_STOP)
-			mddev->hold_active = 0;
 	}
 	md_new_event();
 	sysfs_notify_dirent_safe(mddev->sysfs_state);
-- 
2.39.5



