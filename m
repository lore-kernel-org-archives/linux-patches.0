Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BA31D5ABA;
	Wed, 25 Feb 2026 01:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983179; cv=none; b=pT6LHJHk7LYvI4Uytwz3aBd9GEhRcG37mHUEs4bfu/3C1xt9eAmTnCxIr1bls9ckjpLWiiYqZU3201lisGx6uEakDHD+ox7nufML7z1zyx+k0tKWScvCIfWQTotxOhMPQhy1HugCVAkcn+X3ifbnwK6cBb+3gByW9z+HyI1hWPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983179; c=relaxed/simple;
	bh=REO3FOzALaW2l0U776uUpC9YbtrUnW02cPll9+zh+TA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VoNfxJLdSUWdgupufL2Ssh7XUWuTKkrmzrDZjfnP6F/6XiK0wry1/CAHs/ggLat0TWHhIN5VWs8TPNnVOQtsvaGDLNHDBZgs2DsTIhPFuq7s72KHrxa/aqtPdkKkYA4KYgGOnepCGqvhFuXcv71HzxVRJ7q0dN/QdEldNEWHj7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oQVfOQJV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oQVfOQJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63200C116D0;
	Wed, 25 Feb 2026 01:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983179;
	bh=REO3FOzALaW2l0U776uUpC9YbtrUnW02cPll9+zh+TA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oQVfOQJVSTY6ChnSWdpBtu/gukeBuXK63QOkfmIgrmgGRyzNLUoM+vRgzNFnW+Txm
	 n509kePVTEKufQJHquFKTUrvSMCQVS/mwk6rYd+5cHc6EZFsFSF6QujIyJ/ADBtL08
	 IuLkqzuouOBennkt/XMvLoQbsv1RWYs2vI1QU2aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 330/781] dm: fix unlocked test for dm_suspended_md
Date: Tue, 24 Feb 2026 17:17:19 -0800
Message-ID: <20260225012407.797624252@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 24c405fdbe215c45e57bba672cc42859038491ee ]

The function dm_blk_report_zones tests if the device is suspended with
the "dm_suspended_md" call. However, this function is called without
holding any locks, so the device may be suspended just after it.

Move the call to dm_suspended_md after dm_get_live_table, so that the
device can't be suspended after the suspended state was tested.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 37f53a2c60d0 ("dm: fix dm_blk_report_zones")
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-zone.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index c95e417194b33..bc4e45862a220 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -60,11 +60,13 @@ int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
 		 * Zone revalidation during __bind() is in progress, but this
 		 * call is from a different process
 		 */
-		if (dm_suspended_md(md))
-			return -EAGAIN;
-
 		map = dm_get_live_table(md, &srcu_idx);
 		put_table = true;
+
+		if (dm_suspended_md(md)) {
+			ret = -EAGAIN;
+			goto do_put_table;
+		}
 	} else {
 		/* Zone revalidation during __bind() */
 		map = zone_revalidate_map;
@@ -79,6 +81,7 @@ int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
 		ret = dm_blk_do_report_zones(md, map, nr_zones, &dm_args);
 	}
 
+do_put_table:
 	if (put_table)
 		dm_put_live_table(md, srcu_idx);
 
-- 
2.51.0



