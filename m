Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FDE2DC783;
	Mon, 17 Aug 2026 14:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977760; cv=none; b=dCgstEQ/ZbGW8lch/uDhjrHxaY9jQBFPHlbDg7DJLQuv7sRLyX+ybn2lw1cebGAEFHd/HwC9vX/SRpPRdBJiPZ3W02SBt4Yq4UViMKLQet7ACrxQojUFpTR5jxQTQVe4Idk8DZ/ir8CSqkTq3TJR0aG1T5ME8u9VXRkbYCeXzoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977760; c=relaxed/simple;
	bh=EDlEL8QXuVd5pkL9ypqWw0dmz8MyPqIFX9dAs9etxKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4XleC0LL6aFh51osGzbZB3ievW/av5doP00zBIbs1kJIYJVyo0nPpLiz/uPUW+hAqJw9KP3jXdynUZ6m7gnLldBE8AbTrRfFU2c6286iuJxK9GuLSZXLopez0u2n8F+zeIQUvwS1zjUZ6/SXKOkFYqkhXZ4MXt2o8Akic5GtAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qYZCF4Gq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qYZCF4Gq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7C01F000E9;
	Mon, 17 Aug 2026 14:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977759;
	bh=l+eDUMKqwNIfwy+hRKszxxcNnmzetWb3jVWUK13E1JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qYZCF4Gq+gNTf54OnTp4q2i+dcOS91NULwFU2sKMW6F3YKhQXt57rA8HQnUxxS6FA
	 C2/H2NLe1u/syTKDIcn7RnA9h24j2cDsVPK1Ly4Lfb1nieEZrctGx3u0t87PrwJLBK
	 oMPvrm+lcD79Eq+7GCtNe2ImfTqaZXMDnOh+eg88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Wagenaar, C.C.J. (Chris)" <c.c.j.wagenaar@vu.nl>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 400/456] Input: evdev - sanitize event type index when fetching event masks
Date: Mon, 17 Aug 2026 15:33:10 +0200
Message-ID: <20260817132554.980305958@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

commit 3abd29c61d2ef37c4102cf755b18be53bb9dbea6 upstream.

The user-supplied event type index passed to EVIOCGMASK / EVIOCSMASK
ioctls is used to index the static counts array in evdev_get_mask_cnt()
and client evmasks array in evdev_get_mask().

While the event type is architecturally bounded by EV_CNT, speculative
execution may mispredict bounds checks and perform out-of-bounds loads.

Sanitize the event type index in evdev_get_mask_cnt() branchlessly using
array_index_mask_nospec(). This clamps the index to 0 for safe array
access and forces the returned count to 0 speculatively when the index
is out of bounds.

We do not need additional array_index_nospec() calls in evdev_get_mask()
because evdev_get_mask_cnt() speculatively forces the count (and
resulting xfer_size) to 0 for out-of-bounds types, preventing any
speculative memory access to client evmasks array.

Reported-by: "Wagenaar, C.C.J. (Chris)" <c.c.j.wagenaar@vu.nl>
Cc: stable@vger.kernel.org
Assisted-by: Antigravity:gemini-3.6-flash
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/anFCAfvxwXB5eJF1@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/evdev.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -21,6 +21,7 @@
 #include <linux/init.h>
 #include <linux/input/mt.h>
 #include <linux/major.h>
+#include <linux/nospec.h>
 #include <linux/device.h>
 #include <linux/cdev.h>
 #include "input-compat.h"
@@ -67,8 +68,10 @@ static size_t evdev_get_mask_cnt(unsigne
 		[EV_SND]	= SND_CNT,
 		[EV_FF]		= FF_CNT,
 	};
+	unsigned long mask = array_index_mask_nospec(type, EV_CNT);
 
-	return (type < EV_CNT) ? counts[type] : 0;
+	/* Returns 0 for out-of-bounds types, including speculatively */
+	return counts[type & mask] & mask;
 }
 
 /* requires the buffer lock to be held */


