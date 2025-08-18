Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5264331B107;
	Mon, 18 Aug 2025 14:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525977; cv=none; b=aIQom3xyTd9z8TfR/hmbLBkoj4Zoh59SYNUdc55gIoE+oW3plxERdc79d0O3CMrZn25JH5yvt1FyMqzo9u0aVadqzsPbY8mDREskDTK//0gsR/Z+DDvAKuAHnCKK1y2CBFrGNUcdI1zB018PKjCxl6ImE4Mb9OQVt/PnyccKB5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525977; c=relaxed/simple;
	bh=roszR7h4eLmbKTSx8QRTZzJZq15IS4IsyyIKYMFWrIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBowrVZ6wovC2HCJoRBSr6b5EV2diupjrFvOVhNbqULOlJsR9IA3XJQ3t3KZSz7RlObrWF6SWLr+1Ue76Huh3z+2gUfhOrADWkEhvnP80+8IIcCsSXyMQzJrbeKGf4dK9jJCE9L28qe+KXbehR1JcIaFuPuOBCYdgayDEkfrUyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1DHZ8OKK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1DHZ8OKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7AEC4CEEB;
	Mon, 18 Aug 2025 14:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525977;
	bh=roszR7h4eLmbKTSx8QRTZzJZq15IS4IsyyIKYMFWrIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1DHZ8OKKl2/cfXv8XOeVaiLECMck4QBkUWoOcALyNOYtIbkYcLuGLXwSXtxIxIyEq
	 SKIEA8iH5Pk5jgEfJ8TtHbN20zJUU3e3KLYoJ1ykYGW8HaQRzfMcPYiC+h0rFsZMmq
	 tJKyvz1jE0GHyBNAuf+IaIMj8y+x3T5F8WevpvkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Purva Yeshi <purvayeshi550@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 423/570] md: dm-zoned-target: Initialize return variable r to avoid uninitialized use
Date: Mon, 18 Aug 2025 14:46:50 +0200
Message-ID: <20250818124522.132393011@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 5da3db06da10..9da329078ea4 100644
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



