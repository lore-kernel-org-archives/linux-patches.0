Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381A820AF7D;
	Wed, 19 Mar 2025 14:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395250; cv=none; b=JHpc/b6LH2BcXYf3VPOir8+gHvCOxmZ8P9LldXt/CDPky4HY+l7iZilN1O4WCH/M8wrgPV2/g9toyqp2R40toVuW90aaoK+TrpbPmUXXB72uWbfg9OawIGqgD/wQkA+eOaFzNayHjnIokoJVz1RBosNV841fht9lqoTHzkjUgmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395250; c=relaxed/simple;
	bh=vzDnCcbQ+PGdZ81l4tJgOdwMZByunJNs0Q2Fj6NHqAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HynEOxuKPZgX9XOm2GUAF2MGYSrQueQPTV7Ri12IiEzVaDHmZyDo9HRT6B9ltswZd2a5PnFMXes2agTTRellb0K8suQRz4u2TGsUTO1X/lGbBZCVhZIaU0lgvAq9vLtx4vfnbsnaWSwonA1aZUyLfTpwT0b2YnBce2bjizPhFUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dZk5vIKf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dZk5vIKf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB64C4CEE4;
	Wed, 19 Mar 2025 14:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395250;
	bh=vzDnCcbQ+PGdZ81l4tJgOdwMZByunJNs0Q2Fj6NHqAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dZk5vIKfjVYNP8KbWaSZjb8sgNy8XBwxi3f3jfVoYIiZTmjmnK00vaqpit9t825gW
	 D6AeADTL4rxZ+b+inxMwJvK5y0OAN3k3ocX6NHSjWSvNMHey2oDPK9NMX3plMc5yVN
	 1hfP3nXDDTlFl8QlI+hFi/gX5mn0k9+YClY2fyTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.6 131/166] dm-flakey: Fix memory corruption in optional corrupt_bio_byte feature
Date: Wed, 19 Mar 2025 07:31:42 -0700
Message-ID: <20250319143023.561307966@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kent.overstreet@linux.dev>

commit 57e9417f69839cb10f7ffca684c38acd28ceb57b upstream.

Fix memory corruption due to incorrect parameter being passed to bio_init

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v6.5+
Fixes: 1d9a94389853 ("dm flakey: clone pages on write bio before corrupting them")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-flakey.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 731467d4ed10..b690905ab89f 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -426,7 +426,7 @@ static struct bio *clone_bio(struct dm_target *ti, struct flakey_c *fc, struct b
 	if (!clone)
 		return NULL;
 
-	bio_init(clone, fc->dev->bdev, bio->bi_inline_vecs, nr_iovecs, bio->bi_opf);
+	bio_init(clone, fc->dev->bdev, clone->bi_inline_vecs, nr_iovecs, bio->bi_opf);
 
 	clone->bi_iter.bi_sector = flakey_map_sector(ti, bio->bi_iter.bi_sector);
 	clone->bi_private = bio;
-- 
2.48.1



