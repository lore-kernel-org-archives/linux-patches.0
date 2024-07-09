Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB746158201;
	Tue,  9 Jul 2024 11:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524049; cv=none; b=nHHqBH4Y+89SGT6kL7zt7YyEb6DM6+I2CAfU2LG8gpwJAC9y47WR8Ede7cEgr1s3HnSN+knKaVFTvZ2Kd4wDebwJR4PcXCvy3ysDw5Db05nYpaqCf8YNH4X5nS8DJ9LAJJanRQOdR9xw1v19Boqft7+HVpIWXw99Bbvf/Y95hC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524049; c=relaxed/simple;
	bh=54w5iC/QLWtXsJrbXC8Ggw+jH6dn43s9ne5OFqODNuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJFnPZee3wQjhqz/ZtmUeWmm1WIuMuI+TKtAr7LfSuimzmfb6Yp7wsKflbVJZC+W1cpVtchpGLRX9roihHFhYbY529Kca16Lt+43EYvg3rdPwiQxkhrKjqAFyghRV6SNXGHXnRC75yOcstns/u3iaUFJLWjPO/Qf51XpAIn28Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bcTg+7cG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bcTg+7cG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BF9C3277B;
	Tue,  9 Jul 2024 11:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524049;
	bh=54w5iC/QLWtXsJrbXC8Ggw+jH6dn43s9ne5OFqODNuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bcTg+7cGUTYM+0r1+poq69uB0OiClTmoL0kx1771k++69rcVYim/GjKJoKmBWe87b
	 537H2da8z2P2RdPdhzFMoV5BNx/EafrDLWkUDRet2Fv4NF8Ylc1MRv5iQEzUwo8XNs
	 2MBWenxT9HH2uBJQuEJMEHJnFf/j+kNXWTTVSZ20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 054/197] media: tc358746: Use the correct div_ function
Date: Tue,  9 Jul 2024 13:08:28 +0200
Message-ID: <20240709110711.054524867@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit d77731382f57b9c18664a13c7e197285060ebf93 ]

fin does not fit in 32 bits in some arches.

Found by cocci:
drivers/media/i2c/tc358746.c:847:2-8: WARNING: do_div() does a 64-by-32 division, please consider using div64_ul instead.

Link: https://lore.kernel.org/linux-media/20240429-fix-cocci-v3-22-3c4865f5a4b0@chromium.org
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/tc358746.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tc358746.c b/drivers/media/i2c/tc358746.c
index d676adc4401bb..edf79107adc51 100644
--- a/drivers/media/i2c/tc358746.c
+++ b/drivers/media/i2c/tc358746.c
@@ -844,8 +844,7 @@ static unsigned long tc358746_find_pll_settings(struct tc358746 *tc358746,
 			continue;
 
 		tmp = fout * postdiv;
-		do_div(tmp, fin);
-		mul = tmp;
+		mul = div64_ul(tmp, fin);
 		if (mul > 511)
 			continue;
 
-- 
2.43.0



