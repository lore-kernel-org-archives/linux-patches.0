Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D402408617;
	Mon, 17 Aug 2026 14:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976352; cv=none; b=GonG+jsS4RgC8Ags3mncRw0Uq3ACSzzqLCE2qV44HFh+EYyg0GKsksUnapF23iqhUsEmqa5VBCGiILSEh99K5VP6ZyYV0Qeu9bxC1WGKkIu77Dszt0XPxsFAPuk0j0nmG5YNUxTbvALOObuToeeJvTpxrd7SLIP4+tES2WNxaGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976352; c=relaxed/simple;
	bh=HlE2NRO7Lr2WUepWjnRtnoVZIQPMvQlWvQXw8JjigoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDPj/+iZBk6G4iqGSl9AY1nT3oyO20V2KoZkECpFRuQHM1fnC4o84C7AAafnbPpdyNdhalFCdBxqJ7W3e5PVNTIxMRpJhXrex7YGVIlGPMq6dGQO7aZ5W4NuBYVQ6QscNji8X8219RdbV51dSd65Ex3v+C08h+S6eG1Rbc2KJ+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fcbXi9fE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fcbXi9fE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B241F000E9;
	Mon, 17 Aug 2026 14:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976351;
	bh=kl3SQHa0mcFQandxIOQSyAxa9qi22/SPJV44ozXz3B0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fcbXi9fEUtIE0cNMgkZnp9oZBaq3joQFFi4RzdkIXiR8FJeAyQ0YDcKBSVwS6E0b5
	 jbdQ17Jx5pNdSc2w4yCe5FLFFF5NY5dH+N+ncdFp/uuNbYuj5lptbIqM9cxesjh5sn
	 /tjsZMN5/UjVXQsbVM6jBj+Ny/lLt4+PupzhRiy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Wagenaar, C.C.J. (Chris)" <c.c.j.wagenaar@vu.nl>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 343/389] Input: evdev - sanitize event type index when fetching event masks
Date: Mon, 17 Aug 2026 15:33:02 +0200
Message-ID: <20260817132552.204235787@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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


