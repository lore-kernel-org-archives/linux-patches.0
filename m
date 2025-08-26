Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABBB34A32E;
	Tue, 26 Aug 2025 13:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216439; cv=none; b=fxHrsihJXIieDNYlqArj2qD4uSgaA2+TZL72sENYRY+cGQNlruNu9Fn7NEGlgPA2ynP9kcPk1ZaRKacbYJA8DCWbtgVo/H7933El8WfnpWc1+Q1OSfVlA9MUoC+csz+M5sOQGy7ChdTYdeRp8dbh6h8qUqsz5rosm5yRA8CGe0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216439; c=relaxed/simple;
	bh=Kg+uFIP3JL74zLaZVy61VCAvBKqKzUPNuxFbqXjPa+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlpcOQKf58etOmwsv2B/S9cq2A9hWs/TnJbvzupzLyxS31i3l6ZYLHBnaI4DNOkrH4frru4FsNen9IpxpuVVPTbwE9xCt9QrbcJPbOS1dHKpv03czWpweIPeWtk92DCqnLHbLXTQ35c0i4JFNUfM3M7oWZnKobSwR8PCARdlYyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CgrHdUAu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CgrHdUAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8A5C113CF;
	Tue, 26 Aug 2025 13:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216439;
	bh=Kg+uFIP3JL74zLaZVy61VCAvBKqKzUPNuxFbqXjPa+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CgrHdUAutooMluiUwgWbWmEhcNC23D8x690e5+6TT1pND8vc8NTGRUKfAih2v60V6
	 /QiSR5sfl5iUbIhMGPzrlsYastCgwJ0T3uxytdpiEXMPRm+UbM4SA6fWsFa7g/V65S
	 NaIQ+JCjfWXdVX1BL8tf4iZAUOVX4THULaKE27R8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Purva Yeshi <purvayeshi550@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 412/644] md: dm-zoned-target: Initialize return variable r to avoid uninitialized use
Date: Tue, 26 Aug 2025 13:08:23 +0200
Message-ID: <20250826110956.666495675@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 48b56d6434f7..98c3c8be3bcc 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -1066,7 +1066,7 @@ static int dmz_iterate_devices(struct dm_target *ti,
 	struct dmz_target *dmz = ti->private;
 	unsigned int zone_nr_sectors = dmz_zone_nr_sectors(dmz->metadata);
 	sector_t capacity;
-	int i, r;
+	int i, r = 0;
 
 	for (i = 0; i < dmz->nr_ddevs; i++) {
 		capacity = dmz->dev[i].capacity & ~(zone_nr_sectors - 1);
-- 
2.39.5



