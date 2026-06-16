Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E5D3CEBBD;
	Tue, 16 Jun 2026 18:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633559; cv=none; b=hS+xFWrh5ZT36FjpVvmSMPi7jcSgx1H+yVIVQ15Q5pgJBlY827YSmqYWBerUXleZu4xPsZO8QFFJOWVLpRMgvUUef3gLA0HS47B3I0ZLMCd3iRKamWVZ2YF20CQicGbQZNV9e3ap6UAtuny1bCQGfeXjCu5tgb90m5V5fNdg0cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633559; c=relaxed/simple;
	bh=wx9sl04iFDtw+UoCbDd+T6xD2SwUOWYZE7X/ygT6Xrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ajiqV9WDbli5XLaqf6Zy4hdDIWITw6I9AC1m8HPCfDYr7heRop9CtQMkLyNp4rTrHwX2fjHw3m7NCYjUnL9vgreySN0LpVlTtloLv7g/KvnkzudSAGjuUdVSCnC3oOPShE7qq/T+yQGyhPjO5lEIk9mfFLr/+1/ER6PBumaImgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/CVlfEQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/CVlfEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1D71F000E9;
	Tue, 16 Jun 2026 18:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633558;
	bh=9MN96T7dX2/LiCBBR6cxi2sObem3K71qTpeMOfC0BAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i/CVlfEQ8yt+CZo9v6bu9EyhzLz90hY9yA17mJvoe6UvMf1Ux3abJ7zCm1vi4yaCX
	 UgAO/l7rqO47Au/CnCW0Le7dm9o/lKwO1tYZQ0KNClaFnrf/u7txhUHnhNROqt1xav
	 T2X09435toYjuOd3L7Q4IMeizPR/x3v+TvIQWvCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 102/411] Input: atmel_mxt_ts - fix boundary check in mxt_prepare_cfg_mem
Date: Tue, 16 Jun 2026 20:25:40 +0530
Message-ID: <20260616145105.662628128@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit baa0210fb6a9dc3882509a9411b6d284d88fe30e upstream.

When a configuration file provides an object size that is larger than the
driver's known mxt_obj_size(object), the driver intends to discard the
extra bytes.

The loop iterates using for (i = 0; i < size; i++). Inside the loop, the
condition to skip processing extra bytes is:

    if (i > mxt_obj_size(object))
        continue;

Since i is a 0-based index, the valid indices for the object are 0 through
mxt_obj_size(object) - 1.

When i == mxt_obj_size(object), the condition evaluates to false, and the
code processes the byte instead of discarding it.

This causes the code to calculate byte_offset = reg + i - cfg->start_ofs
and writes the byte there, overwriting exactly one byte of the adjacent
instance or object.

Update the boundary check to skip extra bytes correctly by using >=.

Fixes: 50a77c658b80 ("Input: atmel_mxt_ts - download device config using firmware loader")
Cc: stable@vger.kernel.org
Assisted-by: Gemini:gemini-3.1-pro
Reviewed-by: Ricardo Ribalda <ribalda@chromium.org>
Link: https://patch.msgid.link/20260504185448.4055973-1-dmitry.torokhov@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1443,7 +1443,7 @@ static int mxt_prepare_cfg_mem(struct mx
 			}
 			cfg->raw_pos += offset;
 
-			if (i > mxt_obj_size(object))
+			if (i >= mxt_obj_size(object))
 				continue;
 
 			byte_offset = reg + i - cfg->start_ofs;


