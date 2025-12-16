Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FD13446BB;
	Tue, 16 Dec 2025 11:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885495; cv=none; b=sF4t1PGmsg2Q+4U/nmaxnhLxvR4RVsN4IZI5mHOJ5kqYY+7NeCQWqwNacTt0C/lfoX/I7IHfN4AlrHqsRzZb7KFMB/AHqk5v4SmWCAxWdfNecSJmnFEfyd7lnYeAntbdgIDY/C/tgul7oKk+OhmFcIZdXlRlVMclLYhb3Yq351U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885495; c=relaxed/simple;
	bh=mNJ+LgjUL035u0tOaxNzwhGrBRYWB6LaSIHq36VM6WE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPoAHtwU6JLxheRxnzXmGPxJr8RH72TYk/LCihNA/rm5xVDeQHUmehVpXvF5L79VpIJBWemJe7qGAHCqNF9XW/rySqio5omR6B5Yn5eZ9R+bIxjpddf7BpYZeGtHzx9EYvyhX9PmcdzGuJZ6FTMM0kMRBKj0FtRQJ33anD0pCy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TguWhxPF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TguWhxPF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CDAEC4CEF1;
	Tue, 16 Dec 2025 11:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885495;
	bh=mNJ+LgjUL035u0tOaxNzwhGrBRYWB6LaSIHq36VM6WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TguWhxPFYPLcZI84NAjNf82UUYRjs6SqiFBcO/7d0lUBvp8Ogd73Mxy5dVHxYS/J3
	 9HJLXzh7GJangC/nNr6EhS9W7A9J/HyiBVb9tDdeVkdkVjD6RtTai28ZZjf/IHev0l
	 4jJrkFqBXSHie+GFflYHTvC2LDRPnZE3ax0KhHoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 156/507] power: supply: rt9467: Prevent using uninitialized local variable in rt9467_set_value_from_ranges()
Date: Tue, 16 Dec 2025 12:09:57 +0100
Message-ID: <20251216111351.176004868@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Murad Masimov <m.masimov@mt-integration.ru>

[ Upstream commit 15aca30cc6c69806054b896a2ccf7577239cb878 ]

There is a typo in rt9467_set_value_from_ranges() that can cause leaving local
variable sel with an undefined value which is then used in regmap_field_write().

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 6f7f70e3a8dd ("power: supply: rt9467: Add Richtek RT9467 charger driver")
Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>
Link: https://patch.msgid.link/20251009145308.1830893-1-m.masimov@mt-integration.ru
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/rt9467-charger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/rt9467-charger.c b/drivers/power/supply/rt9467-charger.c
index 5f3efcac4a1bb..3beb8a763a923 100644
--- a/drivers/power/supply/rt9467-charger.c
+++ b/drivers/power/supply/rt9467-charger.c
@@ -376,7 +376,7 @@ static int rt9467_set_value_from_ranges(struct rt9467_chg_data *data,
 	if (rsel == RT9467_RANGE_VMIVR) {
 		ret = linear_range_get_selector_high(range, value, &sel, &found);
 		if (ret)
-			value = range->max_sel;
+			sel = range->max_sel;
 	} else {
 		linear_range_get_selector_within(range, value, &sel);
 	}
-- 
2.51.0



