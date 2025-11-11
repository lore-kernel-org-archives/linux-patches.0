Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A40B2E7BAA;
	Tue, 11 Nov 2025 01:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825364; cv=none; b=O8BG1bzB4rQeBHWo6cLSPuhl5LkV1uIN3h4Lryq/DNuLRcKunysnNLNzo9dxSdtDY0ke4fOUIYUPylNnUKPRNHLdb/WgqanZtzbvJGo5OxbJw0oEvJzZ83T9i+4uzPeb66hj1tw6jheS8zjpghCAZUjUiJxpM3abXeygFCNoiZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825364; c=relaxed/simple;
	bh=azhhdPAvuenIr9fPJKGPcFMuDezyOXCi2+AJlskSyUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dqxLPHM1jkCnYbh3ifr7vNxxPZtZonmZOYMim33TTBd8SMojWPFYPTy9Qbn7p1goQ7pebKyXk/ALpWBBBZ6BofYIvUbDuE8y1g0G1kkzO/E0mJlhZs+RsJLExEsaVmdaBVK53htkTyEwm7ytoKOUwF4f1Krobi7d/1mMp2BPcYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DN3vWcIQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DN3vWcIQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1153FC116B1;
	Tue, 11 Nov 2025 01:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825364;
	bh=azhhdPAvuenIr9fPJKGPcFMuDezyOXCi2+AJlskSyUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DN3vWcIQzxwx4AULf55hFC5PBPKAUZI2VrFyQe3etEQtZHQAazpg3yS3lHvtE1Cl+
	 dGXvuARraJXzyUacod4SgLIkkbgLmSywQMgm56xtWi//fbPwu5MtbyTH8HWIkmBYKv
	 0/T4uK1QKOUObM+bx/v4Nhhy4GTm3Khca3rTAMxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 772/849] net: dsa: b53: stop reading ARL entries if search is done
Date: Tue, 11 Nov 2025 09:45:42 +0900
Message-ID: <20251111004555.094003978@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 0be04b5fa62a82a9929ca261f6c9f64a3d0a28da ]

The switch clears the ARL_SRCH_STDN bit when the search is done, i.e. it
finished traversing the ARL table.

This means that there will be no valid result, so we should not attempt
to read and process any further entries.

We only ever check the validity of the entries for 4 ARL bin chips, and
only after having passed the first entry to the b53_fdb_copy().

This means that we always pass an invalid entry at the end to the
b53_fdb_copy(). b53_fdb_copy() does check the validity though before
passing on the entry, so it never gets passed on.

On < 4 ARL bin chips, we will even continue reading invalid entries
until we reach the result limit.

Fixes: 1da6df85c6fb ("net: dsa: b53: Implement ARL add/del/dump operations")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20251102100758.28352-3-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 58c31049c0e7a..b467500699c70 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2037,7 +2037,7 @@ static int b53_arl_search_wait(struct b53_device *dev)
 	do {
 		b53_read8(dev, B53_ARLIO_PAGE, offset, &reg);
 		if (!(reg & ARL_SRCH_STDN))
-			return 0;
+			return -ENOENT;
 
 		if (reg & ARL_SRCH_VLID)
 			return 0;
-- 
2.51.0



