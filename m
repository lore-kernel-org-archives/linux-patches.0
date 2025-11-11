Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E6134C14C;
	Tue, 11 Nov 2025 01:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823871; cv=none; b=PYJvC6zHbI+ho6oEpphOS4mPTWlfzwvgBzYttqG9RGCpMIrYAui+lbZjVjl1OGeiWYfXzZvZ1YDX+FnuANmnIZkE/zmiVbZoLUyRcuIO9Umdg0ZljT5fLZueOuBpotTZ6cmLtuXx94Y3wjXm8qM2wSTAhZtbD86FAkUC1s8oIio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823871; c=relaxed/simple;
	bh=37odurRZJ979Dm84S5YuNMYmsoCC2wn50kk1FbfdBQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BFsLdVyxOiaiY4q6a1yZYxGUmLBY/HTN+TK9K2aEGVoYso9q7AFSQxp9dCkwpE28wNR0/mJLjAltZiF3BnmEBDmNV2bJESK039/H+SLH93n8hopf5Kfc1b/bHpi7CPRq6nziS/N8bqVZYxPUCvA34paWRcLfoeu6wg4kUJuHGh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BDt0tj/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BDt0tj/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF7BC116D0;
	Tue, 11 Nov 2025 01:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823870;
	bh=37odurRZJ979Dm84S5YuNMYmsoCC2wn50kk1FbfdBQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BDt0tj/YXcG4cNfGQ423t5PT2ubar+Rl4Zkyrne+yWGJsSfaHHehkdFzQW/yQYJS5
	 S2FqkSfVPdYp+io2N33xgM1XJGaT8zk6ZeFilgA4nOEIHZsqauzvaGsdgoBqxaBN4A
	 LzXkoWCxlwcGDvdQdDHiIfIADyhw9hxxqp+E2weE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Martin=20T=C5=AFma?= <martin.tuma@digiteqautomotive.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 388/849] media: pci: mgb4: Fix timings comparison in VIDIOC_S_DV_TIMINGS
Date: Tue, 11 Nov 2025 09:39:18 +0900
Message-ID: <20251111004545.813702375@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 989e93f67f75b..42c327bc50e10 100644
--- a/drivers/media/pci/mgb4/mgb4_vin.c
+++ b/drivers/media/pci/mgb4/mgb4_vin.c
@@ -610,8 +610,7 @@ static int vidioc_s_dv_timings(struct file *file, void *fh,
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



