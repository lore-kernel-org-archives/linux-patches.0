Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C6F75801;
	Mon,  4 May 2026 14:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903560; cv=none; b=HU47P6x6p9conaRjwhaCht5JTTxWxx8NGssAwhQFJ9KhRZObwTHcp5A/2SGCw/Tz6IRx1M2KMaamPYq7g6MrVUuWZgVPH22BdgcJ9gRtWLOIsmk/bh8CvKUwIdKZm/a5GIYpLKW/UQe0lEehczOFuab9Tfnpw47i70lsph0tbnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903560; c=relaxed/simple;
	bh=+6XGAi2p4JKg468bt62g/TucLpsrVqyUwDW274/1cP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2yBnAmmizcXmTqaAAyS1N/cLQD939+eD3H6nt35L39KQNxFmjOkZITV8u43ritCxz58IA6skhUc+PY09r2BgzGXeDw7PqKgXVG98GwAvR/5eluMfhf3kNDv0yGI8gF3DnbLK3O/W5PKPTh2SB+FV5W7ErZXxd5MLhb7AIh/JzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sbgh9L+e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sbgh9L+e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E70C2BCB8;
	Mon,  4 May 2026 14:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903560;
	bh=+6XGAi2p4JKg468bt62g/TucLpsrVqyUwDW274/1cP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sbgh9L+eYVSJCeeQ+HM9Whj5ts5uv8O6jbMmiiph3Y5o/oe+Fdh+fkQ9LWi95q43C
	 kN/fN4D8kj0hsxJVju9GeitSrfc7KoY4g6XFPRR7J68KvO0bi/l17rh+tm1m4IzvjR
	 Py0uRI6HRgSToxYgBbxpHqbOK+Gf/5H6XH7EYUBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FengWei Shih <dannyshih@synology.com>,
	Chia-Ming Chang <chiamingc@synology.com>,
	Yu Kuai <yukuai@fnnas.com>
Subject: [PATCH 7.0 239/307] md/raid5: fix soft lockup in retry_aligned_read()
Date: Mon,  4 May 2026 15:52:04 +0200
Message-ID: <20260504135151.831628852@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6641,7 +6641,13 @@ static int  retry_aligned_read(struct r5
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


