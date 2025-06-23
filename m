Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFDB221734;
	Mon, 23 Jun 2025 21:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714708; cv=none; b=qHppWgkUo6GUiIAyTsVSN0RPI2OQ/NlBP7GYkbH/Jjhx0M7j4Yff2r03hmHicbYQ51+6BQJbbiwcsCvGf9u5Ec0lHQ6zs/VUEdSCK+2uDXn7Vs3Wh0xEb7F72BBjq+6luXbktgYqI7gvE95nYbXZaJLDQh+brjVTMRb7g1kppn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714708; c=relaxed/simple;
	bh=3d2Zla+22i8wMJvYnmtM5nKmZNmNEI/hJGThJmrRzXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3Ifq12jTx+DLjbGicX4sf+lcerzyAQDcNfIZ5cG+W/pOLlbnHdWXXW+7Ent+z7uYcPvqApJdDfecwZwSoicN7X64YIrOJVSzAez7TRlmDw9j11iiQYAIzVH6f6d+xAoXL65kzMmaESiNlE49J+jjsGjGAfoCHVcx1msDlV4jTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VVXqgJnI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VVXqgJnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B28C4CEEA;
	Mon, 23 Jun 2025 21:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714708;
	bh=3d2Zla+22i8wMJvYnmtM5nKmZNmNEI/hJGThJmrRzXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VVXqgJnIJ7y6cMGp7GI4E/2+zuwajNmZnuhn+1a0xY4yZG1S5z9y27XFEHslYG/61
	 gA79R0pwfVtACrG6taDEUrswiBgYSGME7GOIYVTwq9obuis2aB9JtGSoEMxPCgjv3u
	 HFPuM5m2Z2ceyJIEJ3sB/+DQSuI3KLDlCfDDdB2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 125/414] dm-mirror: fix a tiny race condition
Date: Mon, 23 Jun 2025 15:04:22 +0200
Message-ID: <20250623130645.188621588@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -133,10 +133,9 @@ static void queue_bio(struct mirror_set
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
@@ -646,9 +645,9 @@ static void write_callback(unsigned long
 	if (!ms->failures.head)
 		should_wake = 1;
 	bio_list_add(&ms->failures, bio);
-	spin_unlock_irqrestore(&ms->lock, flags);
 	if (should_wake)
 		wakeup_mirrord(ms);
+	spin_unlock_irqrestore(&ms->lock, flags);
 }
 
 static void do_write(struct mirror_set *ms, struct bio *bio)


