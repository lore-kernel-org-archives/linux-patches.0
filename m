Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4785E2FC870;
	Tue, 26 Aug 2025 13:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214951; cv=none; b=r51I2JWUCQKZ5wdo03N/DmyGV8D5LlHRuPC6i4zaqrCQo+yQ6UxWfgORxpUEOAyGLQAx7rJRx2UfT5Iv8iBe746d7hMVTFSqYxAMTNibiVsF1U9c1QJvJtI+2ZmH9Dih0pV/aoVv8pT4YRToyHed9suorGQcYP1qqH/EWHVQalE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214951; c=relaxed/simple;
	bh=OWCdj81Jys7XUpE7pDdBjwmEoD2tQ/SXFskSeiQXTOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dz16ojDTL+3MBuY3zOAJhiJz/p03UnLJwX8JpWUgyljvH8SkXMDB1lGsvLi0N7osr1jlx8Kukxb3mecNnhk0HiJ2uxEBYn63wR1rtTQwpgEqKqb7k+KRYzvczDEcTwgIQ1AZFUES8c0PBEo3oY2xSzlcXUKcwxBbNmBy02JRNkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OiyxiNO9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OiyxiNO9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BB1C4CEF1;
	Tue, 26 Aug 2025 13:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214951;
	bh=OWCdj81Jys7XUpE7pDdBjwmEoD2tQ/SXFskSeiQXTOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OiyxiNO95sAv9rGFRxOAuBahv0f7skiViNeJbh/HS1etz+FqUE6qvr4kWz8PXuAg5
	 xGwQiYUG7+QRSnXGVOElFXO8O9lL7UEZw38tsiK8CwUDVeHyrkeNqIVxVLi/fTtHU2
	 tWabd7Wh2UJkIcSBNV8+opiHtw3C9vLeSgl+QJe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Bryan ODonoghue <bod@kernel.org>
Subject: [PATCH 6.1 332/482] media: venus: venc: Clamp param smaller than 1fps and bigger than 240
Date: Tue, 26 Aug 2025 13:09:45 +0200
Message-ID: <20250826110939.023848832@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -406,11 +406,10 @@ static int venc_s_parm(struct file *file
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


