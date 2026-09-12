Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6851F1534;
	Sat, 12 Sep 2026 08:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201568; cv=none; b=n6Gakrm+AEfGVLB/MH1gMb63sH3Ec+LUOxipT7Fg8TCRbLXWwZYK5QtjtX0/s1uS8HZqXT9+hNkjnEQXVJnNCWzrsam9w6lSdJskPBJ0gmV05BjYz/9Y74kr6i5V/YijxsGjumlnDx24lQgzR4vs/VJeOOmC02B44OzKBkGufwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201568; c=relaxed/simple;
	bh=KGxBo9CEAsirEZIxeVPbG5z23W128bBYsoxBrH9TyKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oxL9t9EpqTrYqQAggpep80WjqHqP0XodvjyeHZGi1H0TQc81GzWs3S6N2FUGEtUVEdOJyBkS0/Wpiy9PXQoB4ooShGQb91v+OvupcstiBBqyb3R63dMjSFsb9G0mST71wD57iFVOSrp/or/uZmkm3V/FG89L6diRkeHL8bvpZzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XMCRmHOm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMCRmHOm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64741F000FF;
	Sat, 12 Sep 2026 08:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201567;
	bh=19fA/b1Y6pC5+C5h/MKxy4tKd+643oc2Gi+SG6LGerg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XMCRmHOmDi9FsINdBIWZ9WbRRh3nCvzih8rjoo2rV2L2Y8wlxLFZah2M5GYWJKbaj
	 OJt4/CPVRa7HwcrjhaW1Q1/Hp7s9pY+d5V3569jFTRw7KWBJTJcz1wHdFmMKALqSeM
	 nMYuNM7H1GeLuJlw0GlsF+OSTerOYwXt/5cTmfyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Benato <denis.benato@linux.dev>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1005/1815] HID: asus: fix a off-by-one in mcu_parse_version_string() validation
Date: Sat, 12 Sep 2026 08:45:55 +0200
Message-ID: <20260912065712.599524439@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Benato <denis.benato@linux.dev>

[ Upstream commit 2a767bd3e0b7277718a9a604cbe53e42830f025d ]

In mcu_parse_version_string() a size validation for response is stricter
that it needs to be: relax the check by one byte.

The device always answer with a greater byte count so this does
not introduce visible changes.

Fixes: ("hid-asus: check ROG Ally MCU version and warn")
Signed-off-by: Denis Benato <denis.benato@linux.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-asus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index 00c5bbfd706f3..c22c1021ecc38 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -841,7 +841,7 @@ static int mcu_parse_version_string(const u8 *response, size_t response_size)
 			dots++;
 	}
 
-	if (dots != 2 || p >= end || (p + 3) >= end)
+	if (dots != 2 || end - p < 3)
 		return -EINVAL;
 
 	memcpy(buf, p, 3);
-- 
2.53.0



