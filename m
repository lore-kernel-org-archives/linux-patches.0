Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F7732D42B;
	Sat, 30 May 2026 16:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160114; cv=none; b=cVkJwwI5pQSVwx/U04no7yq7AL2INZIHds2fM14zPGvCFY6ub4UxcSmG2kATZuZMrR7BgRqvaA72rjvd5aW0oWkSdC2o6juDnXK+867Zj0kNNpgKkoQ9P3FpRInvrwlOhl6t9uBRKonlalDDr2glSYJ5v5DZvwtDWuJBRRN9WCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160114; c=relaxed/simple;
	bh=FavHy8x1gvBCkLu35kolt/2daztjYw7GoRP74YuKPMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dnrc9zvq3c2JzXARhd6SxVSuXQE3qCBOU98AiT+A8MyXUUtzzSNuDsYvOhpssnyGDkZ9wAMQtjLH02qGVqthLo7sF9pZ3ghewB9nwUDY7VaiRJIIHNlO11b/KNBN+DcGbEd6yh5HSOteVMENftFgqg37OGdS/tIR6xDusa8PUoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CEmZfSy4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CEmZfSy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EFDB1F00893;
	Sat, 30 May 2026 16:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160113;
	bh=HjCzXAiVZHzD0epoQ3qoJbsFe9wuaegbl4hrhZiXqao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CEmZfSy48e6+QKeK0BwRKUt0JTlgXCBUy4gQaWAziNXRep7EzVWTZZJaZoPHvgXh0
	 7obJ2PXoN7z9XWFIpmRzZ/6rtJhNrKBhgbOOijMnjbK7ed4i4cjB+GMotx5G5xLwme
	 ie83HhHN/HondMM3rWtZKO+BO+JERRQM4JMNOfsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FengWei Shih <dannyshih@synology.com>,
	Chia-Ming Chang <chiamingc@synology.com>,
	Yu Kuai <yukuai@fnnas.com>
Subject: [PATCH 6.1 248/969] md/raid5: fix soft lockup in retry_aligned_read()
Date: Sat, 30 May 2026 17:56:12 +0200
Message-ID: <20260530160307.316343861@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chia-Ming Chang <chiamingc@synology.com>

commit 7f9f7c697474268d9ef9479df3ddfe7cdcfbbffc upstream.

When retry_aligned_read() encounters an overlapped stripe, it releases
the stripe via raid5_release_stripe() which puts it on the lockless
released_stripes llist. In the next raid5d loop iteration,
release_stripe_list() drains the stripe onto handle_list (since
STRIPE_HANDLE is set by the original IO), but retry_aligned_read()
runs before handle_active_stripes() and removes the stripe from
handle_list via find_get_stripe() -> list_del_init(). This prevents
handle_stripe() from ever processing the stripe to resolve the
overlap, causing an infinite loop and soft lockup.

Fix this by using __release_stripe() with temp_inactive_list instead
of raid5_release_stripe() in the failure path, so the stripe does not
go through the released_stripes llist. This allows raid5d to break out
of its loop, and the overlap will be resolved when the stripe is
eventually processed by handle_stripe().

Fixes: 773ca82fa1ee ("raid5: make release_stripe lockless")
Cc: stable@vger.kernel.org
Signed-off-by: FengWei Shih <dannyshih@synology.com>
Signed-off-by: Chia-Ming Chang <chiamingc@synology.com>
Link: https://lore.kernel.org/linux-raid/20260402061406.455755-1-chiamingc@synology.com/
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid5.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6664,7 +6664,13 @@ static int  retry_aligned_read(struct r5
 		}
 
 		if (!add_stripe_bio(sh, raid_bio, dd_idx, 0, 0)) {
-			raid5_release_stripe(sh);
+			int hash;
+
+			spin_lock_irq(&conf->device_lock);
+			hash = sh->hash_lock_index;
+			__release_stripe(conf, sh,
+					 &conf->temp_inactive_list[hash]);
+			spin_unlock_irq(&conf->device_lock);
 			conf->retry_read_aligned = raid_bio;
 			conf->retry_read_offset = scnt;
 			return handled;


