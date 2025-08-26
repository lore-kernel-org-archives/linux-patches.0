Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BB88635D;
	Tue, 26 Aug 2025 13:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213293; cv=none; b=FkadznwBx8onfLE7durpPnhpTLPSRoLnWA78XNotyFlduFcz6KVIKrjHVHCKsAcjPXKsiFN0tnIT3G+8zYYUFg6r4PxdIC9hHhwZ3scHHoaYEFUTNE/F16XoQOePdBp21ABL5N8qd7AIk2m2aqQ8/cR61T5C1G4DoAdXkWoSBf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213293; c=relaxed/simple;
	bh=yUqZFWEzeqbCuqAkh7ZrBg08+KmMV2li5NrP6qxpSHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lamfbjTkzfn/rza1x5Gp7ua34oH0QjZogap3cEIb1LxxgtlT1ph7tYQcGffEdz/dgi7LsXpKVOIOiMvdMgIUW6X7S7obTi4CgZcYJeK+VbqUxeEIM06bv7MVorScg0mgiLXD5u8qE9igCuW68zcvmZoVHkwRWENgr1BgTFHBMzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=19pnd62e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="19pnd62e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42948C4CEF1;
	Tue, 26 Aug 2025 13:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213293;
	bh=yUqZFWEzeqbCuqAkh7ZrBg08+KmMV2li5NrP6qxpSHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=19pnd62e84d18MynuhJjkqvkRjZBdgMDI345fCl9yZbSOjgDXBCTQ9MbrzzZdafKS
	 PB8ruOyvefNqIxBtOW4WTGwxQZ8pe+MEZ1iGGtG85P19OJAcNVATlrXZkFkN/qBX06
	 iYs+qPisIokLH2HQ9i/2ZyVBsSbKqVUgBWOcBCFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Purva Yeshi <purvayeshi550@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 261/587] md: dm-zoned-target: Initialize return variable r to avoid uninitialized use
Date: Tue, 26 Aug 2025 13:06:50 +0200
Message-ID: <20250826110959.569142946@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Purva Yeshi <purvayeshi550@gmail.com>

[ Upstream commit 487767bff572d46f7c37ad846c4078f6d6c9cc55 ]

Fix Smatch-detected error:
drivers/md/dm-zoned-target.c:1073 dmz_iterate_devices()
error: uninitialized symbol 'r'.

Smatch detects a possible use of the uninitialized variable 'r' in
dmz_iterate_devices() because if dmz->nr_ddevs is zero, the loop is
skipped and 'r' is returned without being set, leading to undefined
behavior.

Initialize 'r' to 0 before the loop. This ensures that if there are no
devices to iterate over, the function still returns a defined value.

Signed-off-by: Purva Yeshi <purvayeshi550@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-zoned-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index b487f7acc860..36e55a5bcb0d 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -1062,7 +1062,7 @@ static int dmz_iterate_devices(struct dm_target *ti,
 	struct dmz_target *dmz = ti->private;
 	unsigned int zone_nr_sectors = dmz_zone_nr_sectors(dmz->metadata);
 	sector_t capacity;
-	int i, r;
+	int i, r = 0;
 
 	for (i = 0; i < dmz->nr_ddevs; i++) {
 		capacity = dmz->dev[i].capacity & ~(zone_nr_sectors - 1);
-- 
2.39.5



