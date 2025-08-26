Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D731DEFF5;
	Tue, 26 Aug 2025 13:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214625; cv=none; b=dmiFlZh5wcFyd9sJqFmwEmmUfyOlvZBzAUNkR+05Ya8nldADoS7G0QO+935ggsdP2puuWTDKAomp/PUuG8F+UV/j0uHuOM2QZOov3n+GKxvVv4CP+aJMP/ZaRdFJeNmZCAfgqYiyQg7j1QJG4mYnDVt/2qPlaxorZH0ijDU97T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214625; c=relaxed/simple;
	bh=goGyV4fxrrOq3Eff3CIkOpydTGUwLC28BecVDjYU7ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1txNJ0TE+cPF+ueGYd3bz7L6MdOwr0G6tasXxAf4MBh4RW6yE0l/quy+h3QrxAxnJjq0Lgo3eaUvNh1WPP0YZRVA065eaEg5ApKnIARTRzk7isPfoYjKKHdvxb3z7OQblIWKKM+3p7IIH5vAVu+agtut3pfSlI1/GGV+Urxltw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Agvb9DQC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Agvb9DQC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045C5C4CEF1;
	Tue, 26 Aug 2025 13:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214625;
	bh=goGyV4fxrrOq3Eff3CIkOpydTGUwLC28BecVDjYU7ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Agvb9DQCqCefEjrhDI2t525zjY8vEUP8OeqV9EBrcsJTuOViUfy8UfJH7TLhkwuR6
	 i8r3HdkmVNzNyUl3bXbltCEMkQi+hjlpwE08p8w2/nxZqm9PBk/u4gTZ4ZBkZtVrCs
	 FAzU56aV8NEzs4t8hD/+EpgZ931D8A6oSiFB6TRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Purva Yeshi <purvayeshi550@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 208/482] md: dm-zoned-target: Initialize return variable r to avoid uninitialized use
Date: Tue, 26 Aug 2025 13:07:41 +0200
Message-ID: <20250826110935.922302972@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4abe1e2f8ad8..cbcfadbdd51d 100644
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



