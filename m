Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF103304BCB;
	Sat, 30 May 2026 17:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163393; cv=none; b=BfXBUgDauh4UZyho8EBosoflCGTgOree3vGm+oqGuyDF5bbMT4w8WGbk8rHWw2Pq2W1mPqJYAivgl4Rq23vo+cfO0B/Gft/D/02qlub9dhk+uXabFYt2tOd3egv1VdKeQ4txgoioF8XnoiyV8snj3ADQ2J1oY6wxRbGlgErhWZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163393; c=relaxed/simple;
	bh=mphZkJ58edDFFDAz5NXPAqUFnvDbjXle0HGAMTr6qaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JuIVGfRFmm8cahSoc8RQ5xCw/Y6bI5wKB4kzhnrCxIdzISTSzqCfq+cHVEaE9RnqrVeG5nmPFX58vFJv8Fm9LuczCt4e7QgqOKt2e6HFQjK8Bbb1I3Ar+O3PM5XIUt1/Xh4gvH17b7dStO5TwF6/xbh6+vo83D2pquS1j3yPkSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R6bmIgM/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R6bmIgM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0110F1F00893;
	Sat, 30 May 2026 17:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163392;
	bh=cqCfrPo4krykqJzF/cuAExk6H2FFi/ZdG1agyk4nY4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R6bmIgM/AqigXYiIkjaBBRdYOGlkyLMNXsLxnJbyV0ZbjsWOYLUc1usloTwVpPL2Q
	 T/flNSAT7+K0XeEAZf2j4SvClZG5jUSr0iDPGfMa+pla9ZuRMnJvoq/IgSuEQZy4FA
	 /XdGX+lKGTA5aP6rx0Om2CP+Yd59GJxYEjO/vRjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FengWei Shih <dannyshih@synology.com>,
	Chia-Ming Chang <chiamingc@synology.com>,
	Yu Kuai <yukuai@fnnas.com>
Subject: [PATCH 5.15 245/776] md/raid5: fix soft lockup in retry_aligned_read()
Date: Sat, 30 May 2026 17:59:19 +0200
Message-ID: <20260530160246.865354332@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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
@@ -6351,7 +6351,13 @@ static int  retry_aligned_read(struct r5
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


