Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185C135A2A4;
	Tue, 26 Aug 2025 14:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217892; cv=none; b=Cv2+OHPSIkcDOEjxbmn4tA2dz56FrvyaCwLxTxExanROhJr4TDqnSQV3NXijEHDaJaEZmXIpiemggaXvS1Cn7gPE90L6Ad4zAX0flIAcLoYIBTdcP7EMViexbQfjzsGt8lfGj+EJOqqU5HNew8uDknugKx3VnQIQxllSFg4rnkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217892; c=relaxed/simple;
	bh=KXwcYIBUL74k1EwF0pA2mt7GoP4JLkevD/bx2PNh6xA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3tlsa+LkqX5DP8S0J1idtpkWhBd+XHPxNx6SxZJmaNrpdadmR6Fi0uDaHD/nprKmQm9oxBxqU6b75lDgYEt/f5XoCIFAMZTSWqWV+QxoKeg48uX0Hsn0diCzeSrVp+qitqbCm/KZc/3ilWKoZy/KRKwy7jLEFnDe5KTk4FqgLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kwk3d2LZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kwk3d2LZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E846C4CEF1;
	Tue, 26 Aug 2025 14:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217892;
	bh=KXwcYIBUL74k1EwF0pA2mt7GoP4JLkevD/bx2PNh6xA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kwk3d2LZutyVgqYTmAZ1nYht6MscSEhqtfOSX5iFdeiVz67IZU1qDLrDm1NQ24UIM
	 +pVRo9QGG4XlxuW3kUAFMRaCHHfXASTpCugD3wyLqvRAZEs1QCDfvV22AU0Rl3F2CI
	 yxacPxvca62Q0ld2b3+P407mxZRxPUVG3WoPwhdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Purva Yeshi <purvayeshi550@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 315/523] md: dm-zoned-target: Initialize return variable r to avoid uninitialized use
Date: Tue, 26 Aug 2025 13:08:45 +0200
Message-ID: <20250826110932.232654296@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 48fc723f1ac8..e5f61a9080e4 100644
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



