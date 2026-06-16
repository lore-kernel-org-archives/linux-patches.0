Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF2F34FF79;
	Tue, 16 Jun 2026 18:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635862; cv=none; b=qVPzJ8laMt/Pxr/dUJzJpODvGEfBGs649eWOS3INnDTuMcymFi5lS9koVcEVU0Xr2xATZ10+eQ0oGGeZaTbVsyoNMe3CfsZAZlc4GFmX187e9Sr5+hpMvSm/qh7Ta4igquBFoYM0lsIKrcCXyWhrJF+OnC2OB0QyNJXZgRyUW04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635862; c=relaxed/simple;
	bh=AQ2LbnxtIX9OTIh812yHGino+QWTVhB/09zGhF5r50s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UovmRPWsUo/2Vz5QDtvI9FQpk5L6XMZUDaGKKr/P0AgtS5brP2rK9u/5v/JGL5Y15s0AzJ0FbhLo6Vlbbt+mLxsZilIYbPwXu1SvbPt8i7Py3+9e589x9RLAcL07CVIf++v0bS0sO8fmcuDrRUga1janzBCxMfY5OGAU1KHCkDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j5irVjHk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j5irVjHk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F221F000E9;
	Tue, 16 Jun 2026 18:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635861;
	bh=Y+J3yYwS4fVksgcSx4qikq89K39OBpDyahqZALskE0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j5irVjHkiABfYGGHSVqMvbjENNWniSCWpgr+1zoLKe1g50tGe4vvRzjja8vYUT/1W
	 oOSB3koEiOOhZwDfTH3oqy/i4DSPd5/CRibKEc8ozmb7cPG6rXtD/wuEtqlAa3vHiu
	 cb02rMvAPvaNPF2LqIc4g8jskI5w+/L2HImI+VWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 085/342] Input: atmel_mxt_ts - fix boundary check in mxt_prepare_cfg_mem
Date: Tue, 16 Jun 2026 20:26:21 +0530
Message-ID: <20260616145052.207170243@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1400,7 +1400,7 @@ static int mxt_prepare_cfg_mem(struct mx
 			}
 			cfg->raw_pos += offset;
 
-			if (i > mxt_obj_size(object))
+			if (i >= mxt_obj_size(object))
 				continue;
 
 			byte_offset = reg + i - cfg->start_ofs;


