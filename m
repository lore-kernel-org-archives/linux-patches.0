Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E61C2E0;
	Mon, 23 Jun 2025 21:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714355; cv=none; b=LfJOpveQCoFu5unOWBMBjPX253EUyFhZaFaalUKol3irlYNSkAYQGsJGrpFX1zBVaK3PKSkdtzRyTMXvHgDwJwkZC//O0KdF3CPJjRfpdShHoe8LT8MYnmjuyfvi/nGztNwnkdlwTqip0zd9poJUspyQo9gyTmzF+908ui3w9vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714355; c=relaxed/simple;
	bh=aQwdvirg+2Q0Nut4OUC/TzNUy2RKfMkoApLrRwGoTTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CBRqsYBwkMRQ07Is1eGe/xysoDwRtlNT3VFX/ZhtO3wJdzNWbLMbmOUvwm1S1atNz963whRe02v8Td3fOhwk9Ek5IkC+4sekM4FYZe9cc8ERvOFTN25n5+OXuFXbYFY4IK9AB2QW2UoGFX4KrZPzkxWElmqSxoA5E8lbs3k15X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mW0BYWue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mW0BYWue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD15C4CEEA;
	Mon, 23 Jun 2025 21:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714355;
	bh=aQwdvirg+2Q0Nut4OUC/TzNUy2RKfMkoApLrRwGoTTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mW0BYWueHxpnxn8i3pyVtg9+Na39D2wGBZSWLShk6Zud38FVY1haBpFdk+1rsVSsr
	 EqoHmR7a+X29Wt0oZmab8g6gwHeFHeblLHptxzMk44iwtUJjd1aIF3GQaViHQW3W00
	 OJ8ecB8ZeG9fZZuq8gpeVJdXiFZ82Gkzs/8uM9ZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 201/355] dm-mirror: fix a tiny race condition
Date: Mon, 23 Jun 2025 15:06:42 +0200
Message-ID: <20250623130632.705876780@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 829451beaed6165eb11d7a9fb4e28eb17f489980 upstream.

There's a tiny race condition in dm-mirror. The functions queue_bio and
write_callback grab a spinlock, add a bio to the list, drop the spinlock
and wake up the mirrord thread that processes bios in the list.

It may be possible that the mirrord thread processes the bio just after
spin_unlock_irqrestore is called, before wakeup_mirrord. This spurious
wake-up is normally harmless, however if the device mapper device is
unloaded just after the bio was processed, it may be possible that
wakeup_mirrord(ms) uses invalid "ms" pointer.

Fix this bug by moving wakeup_mirrord inside the spinlock.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-raid1.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -128,10 +128,9 @@ static void queue_bio(struct mirror_set
 	spin_lock_irqsave(&ms->lock, flags);
 	should_wake = !(bl->head);
 	bio_list_add(bl, bio);
-	spin_unlock_irqrestore(&ms->lock, flags);
-
 	if (should_wake)
 		wakeup_mirrord(ms);
+	spin_unlock_irqrestore(&ms->lock, flags);
 }
 
 static void dispatch_bios(void *context, struct bio_list *bio_list)
@@ -638,9 +637,9 @@ static void write_callback(unsigned long
 	if (!ms->failures.head)
 		should_wake = 1;
 	bio_list_add(&ms->failures, bio);
-	spin_unlock_irqrestore(&ms->lock, flags);
 	if (should_wake)
 		wakeup_mirrord(ms);
+	spin_unlock_irqrestore(&ms->lock, flags);
 }
 
 static void do_write(struct mirror_set *ms, struct bio *bio)


