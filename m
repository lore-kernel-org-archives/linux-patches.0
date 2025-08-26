Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D026A30146A;
	Tue, 26 Aug 2025 13:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216666; cv=none; b=J1j9fOvO1YMIQ4+U+i7IhGNkBHASfok85cMw+ik9pJYzMdCN76u/TTz08KSujWr4kukcm59wD98KK77i53NyvX5+2sMyb7aO2vX7/EUqDHp3yigK4fqetoA8VyjZN26wxon93KV9qV7qcciOZADo9J/cn/jyFCRFSldNK4g2GzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216666; c=relaxed/simple;
	bh=QPm1apT2R44XuOdlqLiu0JEpl7NzQD2tb6fuL2rCzCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KmR73XcLbc1W5SSlWyqL8HI1UaBJLKKS6RpEkgVJt99GXdzMDtLz5QIW99ef+RmtUN/v4T0vgxW2ouez6gljmj7XH3xY/eRjZlHCEMTbfShDDQnypT+ywdoNikCVKDid+sHGX5KIPCB64Cx+VEcGatarhDse2r04It5+I91sUjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q75EQcq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q75EQcq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AEF7C4CEF1;
	Tue, 26 Aug 2025 13:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216666;
	bh=QPm1apT2R44XuOdlqLiu0JEpl7NzQD2tb6fuL2rCzCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q75EQcq4b/x2wSQXYEXrVD+GMsbkaa8+aEAlKMbdeqF3PuoWdIveon0YkRWf6tiPY
	 tCvK7lWl0oHG+nsZrMvdd8Bp993Isfkc856SXyZbUrrj75xnBYgyVytSkYLOgYcL+x
	 MfHQb0PY56CrXz518WF0O4/qcnoJ++dTZnixFDD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Bryan ODonoghue <bod@kernel.org>
Subject: [PATCH 5.15 496/644] media: venus: venc: Clamp param smaller than 1fps and bigger than 240
Date: Tue, 26 Aug 2025 13:09:47 +0200
Message-ID: <20250826110958.785724377@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

commit 417c01b92ec278a1118a05c6ad8a796eaa0c9c52 upstream.

The driver uses "whole" fps in all its calculations (e.g. in
load_per_instance()). Those calculation expect an fps bigger than 1, and
not big enough to overflow.

Clamp the param if the user provides a value that will result in an invalid
fps.

Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
Closes: https://lore.kernel.org/linux-media/f11653a7-bc49-48cd-9cdb-1659147453e4@xs4all.nl/T/#m91cd962ac942834654f94c92206e2f85ff7d97f0
Fixes: aaaa93eda64b ("[media] media: venus: venc: add video encoder files")
Cc: stable@vger.kernel.org
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
[bod: Change "parm" to "param"]
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/venc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -408,11 +408,10 @@ static int venc_s_parm(struct file *file
 	us_per_frame = timeperframe->numerator * (u64)USEC_PER_SEC;
 	do_div(us_per_frame, timeperframe->denominator);
 
-	if (!us_per_frame)
-		return -EINVAL;
-
+	us_per_frame = clamp(us_per_frame, 1, USEC_PER_SEC);
 	fps = (u64)USEC_PER_SEC;
 	do_div(fps, us_per_frame);
+	fps = min(VENUS_MAX_FPS, fps);
 
 	inst->timeperframe = *timeperframe;
 	inst->fps = fps;


