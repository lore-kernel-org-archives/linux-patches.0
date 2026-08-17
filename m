Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E9C429803;
	Mon, 17 Aug 2026 14:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978026; cv=none; b=cDwhAUIDrfwG47y4lkB6wCb1InRUQPhCQvqb8/B2APBkC+UUmEWfc0k7N2jFDBhTgr4ULkbDmXfdfJJYu3Jw8O7GMAwqlAScTahKla7l6jdxYk2tfBucmECoAPxQKfwFR1FXlUSD0ImEq3EQHU2qHCXtXqx6Kv7sgh4cc2SPN80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978026; c=relaxed/simple;
	bh=NVAMkVg7gu8Ta04WMOCn53JD/2LO/BctrFwB/xvCy40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpOXhj/vfBO7HDvOKD7DgA9O2q5Zhz7lpGbUKu+0lznxPzDQnP8CuQlDqr/iZ0JG/4cmqvqlYpAdFJ0BTPzh5V4seQV45LgVvTKIjdeEXS0+8cA/uD1p1uUG8bEr5goJAHP3DLVEYb7TkykEXBXbuRsAph4yXrZ8jggzv2yXuhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gh3mB7Oz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gh3mB7Oz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DEC1F000E9;
	Mon, 17 Aug 2026 14:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978024;
	bh=LoZS3P81WQ8GMrqqFDFCfg6Sy6WNJoIMQl2Fz7Nk+6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gh3mB7OzunabZzv+Kky5mjMSCd1f6Bmspqv8S2BbU7zeAZeSzaLUyA9YSMzaVYa2u
	 OgOluJ17pRLrlobcG2uz6DX6JVPGB0mQHFykjBjjcoZxZa8JcNYWFdInFoWCW+d4qm
	 vMuoFoJ3+c91hnFBx38wVbjDLP39ovBFa7dkIcns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Wagenaar, C.C.J. (Chris)" <c.c.j.wagenaar@vu.nl>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 074/181] Input: evdev - sanitize event type index when fetching event masks
Date: Mon, 17 Aug 2026 15:32:48 +0200
Message-ID: <20260817132538.359383453@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


