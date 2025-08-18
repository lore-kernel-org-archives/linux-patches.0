Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094E4322525;
	Mon, 18 Aug 2025 13:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524179; cv=none; b=VlTva3ZnVOSv6uCaOqd6+CE8Qs80iSToXxaEISiiqGhloqEensifrJ+a4b33J9ablIQ/7vmtXbgnVodANwkuj4ZqQAGEyEEdPVOurFqihfcX7h2Ior8G9ZLb+xVKip9QVhDqpCfN78iN5GHC7nQedST0ZQbenb7ljUW//c4uqGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524179; c=relaxed/simple;
	bh=3HmXGMQZGprrm3/vk9w4Q7t4Da+Hr1tGdJtSb72gxd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u9/6T6aURZKTmIoD3P916LFPUMlVweVfke6VwkOrLIc0N8qVpIJwOorzez3/3BhCMp+vwTncYdDQasm8SfTZ3uyIgeQMHvJYTNfBMyjXmkY+GYFB+a+M74H3Bglr7mcW7FYMTpBi8RWfKA3zG0BnzoCXku5X7GOwy09i9yHTlrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oxoshe67; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oxoshe67"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D804C19423;
	Mon, 18 Aug 2025 13:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524178;
	bh=3HmXGMQZGprrm3/vk9w4Q7t4Da+Hr1tGdJtSb72gxd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oxoshe67cB8Sfz52931Z6/HmhsfRbOsdgwzV4sF5Axx4sfpwuL7Nz+L+QrzSbGxrc
	 hV7sAVCyymwXbZzBsqWBXxHezvDw+Ox8ER/QSXA7qd6KPnXLn/zRkl4ZKYN6ohVXA7
	 ups0AxPWyEfMSYQ+NVfrc45Rc8MEyVReNaIVc71Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Purva Yeshi <purvayeshi550@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 390/515] md: dm-zoned-target: Initialize return variable r to avoid uninitialized use
Date: Mon, 18 Aug 2025 14:46:16 +0200
Message-ID: <20250818124513.429697465@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6141fc25d842..c38bd6e4c273 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -1061,7 +1061,7 @@ static int dmz_iterate_devices(struct dm_target *ti,
 	struct dmz_target *dmz = ti->private;
 	unsigned int zone_nr_sectors = dmz_zone_nr_sectors(dmz->metadata);
 	sector_t capacity;
-	int i, r;
+	int i, r = 0;
 
 	for (i = 0; i < dmz->nr_ddevs; i++) {
 		capacity = dmz->dev[i].capacity & ~(zone_nr_sectors - 1);
-- 
2.39.5



