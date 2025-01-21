Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FE91F55E3;
	Tue, 21 Jan 2025 17:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482350; cv=none; b=Rw35XGmuYoVWcgh2ZaNKFWYv60O0NBTg3Fu28pT8sCj75AqdiEj6cbWyMQy0Tj2f6l+kX0kVFOnAL6lrbWe9xmtPhcJqad9gUr4EfUMLektsbMjyrrnkxNk+onDtnq3R2NkXKBcNwLv13lUeICkwnNmJj9pqIh2BYbdGY5M2+fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482350; c=relaxed/simple;
	bh=TyBSZaFJBYUfoXi/N7NQjyLjQjiTChmoXm/69iCWlQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jZpio+AH3nzY7EKN4HL3MVoXfuiyGgSlgcod3aadv8oxGy+gdZp+Za098CbhDLQf4qHyRwjviKfvrI4PoOkVhNK1Lr8m4mp5w6wzgE77AMiaJEtZZDjTL5Rt/QVbF5yTG4sgCOf8vXucAW0qOmQbYSq72MXkd+qJFDs4jCdjD/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q7TlSavO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q7TlSavO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59A2C4CEDF;
	Tue, 21 Jan 2025 17:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482350;
	bh=TyBSZaFJBYUfoXi/N7NQjyLjQjiTChmoXm/69iCWlQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q7TlSavOvBK+Mc2pplcx3FyclTgy4rstApLhuLJZqXyudhPI6huyTjFFV/4UAg6CV
	 azyMiQocHAOombf5OL6T+DfEwkypQIn34oFmkhQMGGTtbHHyIWDxJnGQgMIEDAZNfe
	 uTq/iHu4ToIC2Mt+h60K8gzQfMZcdJ81QCxJozpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 047/122] hwmon: (ltc2991) Fix mixed signed/unsigned in DIV_ROUND_CLOSEST
Date: Tue, 21 Jan 2025 18:51:35 +0100
Message-ID: <20250121174534.796622379@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit e9b24deb84863c5a77dda5be57b6cb5bf4127b85 ]

Fix use of DIV_ROUND_CLOSEST where a possibly negative value is divided
by an unsigned type by casting the unsigned type to the signed type of
the same size (st->r_sense_uohm[channel] has type of u32).

The docs on the DIV_ROUND_CLOSEST macro explain that dividing a negative
value by an unsigned type is undefined behavior. The actual behavior is
that it converts both values to unsigned before doing the division, for
example:

    int ret = DIV_ROUND_CLOSEST(-100, 3U);

results in ret == 1431655732 instead of -33.

Fixes: 2b9ea4262ae9 ("hwmon: Add driver for ltc2991")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://lore.kernel.org/r/20250115-hwmon-ltc2991-fix-div-round-closest-v1-1-b4929667e457@baylibre.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ltc2991.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/ltc2991.c b/drivers/hwmon/ltc2991.c
index 7ca139e4b6aff..6d5d4cb846daf 100644
--- a/drivers/hwmon/ltc2991.c
+++ b/drivers/hwmon/ltc2991.c
@@ -125,7 +125,7 @@ static int ltc2991_get_curr(struct ltc2991_state *st, u32 reg, int channel,
 
 	/* Vx-Vy, 19.075uV/LSB */
 	*val = DIV_ROUND_CLOSEST(sign_extend32(reg_val, 14) * 19075,
-				 st->r_sense_uohm[channel]);
+				 (s32)st->r_sense_uohm[channel]);
 
 	return 0;
 }
-- 
2.39.5



