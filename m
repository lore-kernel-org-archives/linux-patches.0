Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3641925AA;
	Thu,  5 Sep 2024 09:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529403; cv=none; b=EJUjUEsXI7t4sAhxXVAUTzBpM8lN9soPu5ouGYd/yKx3AW/wkstforC9n5oANTYB4S7OyXp6hB3MZ3uBu+46g/VqYRmv3XSn2rU8bo8nuwrC6QgVBj5YvSVnZQFxYufaKmIqk+4HG5Pibf1h/hajD83mG3FryMuCKud3pY6IYZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529403; c=relaxed/simple;
	bh=VIEURbEv73xR+hhmeH5v8+k5BDrqzbI1dJYSy0VcA9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=db1tyGJQ1g1R94/KZgmsJ36BT3xqzpuo90CgPlQp235pWQjJUR+8WiJ0KoSkk9fya9q89oxDI02LoAkJGKVP+NBGFKnutmIlBBUv8BCeB09fSX/CNCtk0jes3Je3HShlfY9GgjvPOPPcvMS7rg6HWre9eMBc8DE5+PUT4JByco8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j4wYhvaR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j4wYhvaR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11DBC4CEC6;
	Thu,  5 Sep 2024 09:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529403;
	bh=VIEURbEv73xR+hhmeH5v8+k5BDrqzbI1dJYSy0VcA9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j4wYhvaRy08ccfjki89zktSQbSA59vef7hnRfuGBJSXt0wwqrbDS93xAbR0TfUsnw
	 KAFKWMPR2KmSmgjLYGsGoXkj1OxVYnOXjZ+ZyOWZ3xAjbbUiSRxdIfklyBGWowYT8X
	 zVz1iS3Bc1YqcV92UJr3k9t7rey9F+VeUi3McjQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michel Palleau <michel.palleau@gmail.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 021/184] btrfs: scrub: update last_physical after scrubbing one stripe
Date: Thu,  5 Sep 2024 11:38:54 +0200
Message-ID: <20240905093733.074095654@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 63447b7dd40c6a9ae8d3bb70c11f4c46731823e3 ]

Currently sctx->stat.last_physical only got updated in the following
cases:

- When the last stripe of a non-RAID56 chunk is scrubbed
  This implies a pitfall, if the last stripe is at the chunk boundary,
  and we finished the scrub of the whole chunk, we won't update
  last_physical at all until the next chunk.

- When a P/Q stripe of a RAID56 chunk is scrubbed

This leads the following two problems:

- sctx->stat.last_physical is not updated for a almost full chunk
  This is especially bad, affecting scrub resume, as the resume would
  start from last_physical, causing unnecessary re-scrub.

- "btrfs scrub status" will not report any progress for a long time

Fix the problem by properly updating @last_physical after each stripe is
scrubbed.

And since we're here, for the sake of consistency, use spin lock to
protect the update of @last_physical, just like all the remaining
call sites touching sctx->stat.

Reported-by: Michel Palleau <michel.palleau@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CAMFk-+igFTv2E8svg=cQ6o3e6CrR5QwgQ3Ok9EyRaEvvthpqCQ@mail.gmail.com/
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 9712169593980..731d7d562db1a 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1875,6 +1875,9 @@ static int flush_scrub_stripes(struct scrub_ctx *sctx)
 		stripe = &sctx->stripes[i];
 
 		wait_scrub_stripe_io(stripe);
+		spin_lock(&sctx->stat_lock);
+		sctx->stat.last_physical = stripe->physical + stripe_length(stripe);
+		spin_unlock(&sctx->stat_lock);
 		scrub_reset_stripe(stripe);
 	}
 out:
@@ -2143,7 +2146,9 @@ static int scrub_simple_mirror(struct scrub_ctx *sctx,
 					 cur_physical, &found_logical);
 		if (ret > 0) {
 			/* No more extent, just update the accounting */
+			spin_lock(&sctx->stat_lock);
 			sctx->stat.last_physical = physical + logical_length;
+			spin_unlock(&sctx->stat_lock);
 			ret = 0;
 			break;
 		}
@@ -2340,6 +2345,10 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 			stripe_logical += chunk_logical;
 			ret = scrub_raid56_parity_stripe(sctx, scrub_dev, bg,
 							 map, stripe_logical);
+			spin_lock(&sctx->stat_lock);
+			sctx->stat.last_physical = min(physical + BTRFS_STRIPE_LEN,
+						       physical_end);
+			spin_unlock(&sctx->stat_lock);
 			if (ret)
 				goto out;
 			goto next;
-- 
2.43.0



