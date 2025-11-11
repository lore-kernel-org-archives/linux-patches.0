Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C535F342CBB;
	Tue, 11 Nov 2025 01:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823524; cv=none; b=Ms0NynK1IBT1OpLRCF+LRErVZV2yoAXw/sHAB6oe5oQUKdu+cyuW62Pq65Ne9VqoPbbdhmohZTnoCmun1WBAOlZCm2TmyTdjjllWHcBAkWgLUGE5Pvp6wzZMf7cYZQG2X4h9fy8CJn5UR2s8oRnWUizaJcAZG2rzbOhfGg1Q/zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823524; c=relaxed/simple;
	bh=dzW6vPopAHg/ll2QICGA7JIMgw0B4PsUo+Hk3Dkxx2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xuuuon+HZRXbV/QBxyTmrFRM2L4OnRxj2G9xsSuR27HpKp7Riop1afZPQmH2/45qBlDZRu871r4C9rzQG6N5MkMvmH1n0pPmrzCQWdBy7t2+1uQ79U4GYlt9gxnoWSQL3lNXrG/jk+eZ0l8BAstUaUeJca9yRM/i+UXdd4IydQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EpGX9EDh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EpGX9EDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D21C4CEF5;
	Tue, 11 Nov 2025 01:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823524;
	bh=dzW6vPopAHg/ll2QICGA7JIMgw0B4PsUo+Hk3Dkxx2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EpGX9EDhc5sAysxTPKIhQgBQ0Es/r5icvYzdTW927dUZb1EBf+snrT9uIm56O7aDD
	 aJVthDmixK5jLx3sDmS3TQCZwfEva5/e3lcWpxUhD1rdNDBkDUi/GYxXcmopmVguy+
	 F3v22BvywLu6Pjq4nw7qVxyNg/Xblq+//AvEjrKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Martin=20T=C5=AFma?= <martin.tuma@digiteqautomotive.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 263/565] media: pci: mgb4: Fix timings comparison in VIDIOC_S_DV_TIMINGS
Date: Tue, 11 Nov 2025 09:41:59 +0900
Message-ID: <20251111004532.810001784@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Tůma <martin.tuma@digiteqautomotive.com>

[ Upstream commit 0750649b528ff18d1d68aecb45b34ec22d5ab778 ]

Compare the whole v4l2_bt_timings struct, not just the width/height when
setting new timings. Timings with the same resolution and different
pixelclock can now be properly set.

Signed-off-by: Martin Tůma <martin.tuma@digiteqautomotive.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/mgb4/mgb4_vin.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/pci/mgb4/mgb4_vin.c b/drivers/media/pci/mgb4/mgb4_vin.c
index e9332abb31729..cfb6be8a81669 100644
--- a/drivers/media/pci/mgb4/mgb4_vin.c
+++ b/drivers/media/pci/mgb4/mgb4_vin.c
@@ -624,8 +624,7 @@ static int vidioc_s_dv_timings(struct file *file, void *fh,
 	    timings->bt.height < video_timings_cap.bt.min_height ||
 	    timings->bt.height > video_timings_cap.bt.max_height)
 		return -EINVAL;
-	if (timings->bt.width == vindev->timings.bt.width &&
-	    timings->bt.height == vindev->timings.bt.height)
+	if (v4l2_match_dv_timings(timings, &vindev->timings, 0, false))
 		return 0;
 	if (vb2_is_busy(&vindev->queue))
 		return -EBUSY;
-- 
2.51.0



