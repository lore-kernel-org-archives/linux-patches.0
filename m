Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195BE2641CA;
	Fri, 21 Nov 2025 13:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732299; cv=none; b=rrhM7TCHGtlU77FpFtGG0VJJEFuO1zjwt3j5K1hopsoPEEhLLWgn5Zj9Uc0aPxa83yljIxQ+Smft7VNnTbcjmQM/tUqF355KGDC6OJ1UVK+iTtMh7z/1TT3EDJDuzikycflJmzG9kaHEmyPOX4s9FtnDetzdb/oHs5UsOW3L5Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732299; c=relaxed/simple;
	bh=u+fF+mlMWpGCCn1xpuQk7X/KqNFekoR7jgRA3DC5mB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFp2XFMyRpIvP6sFL1xYV8v+a0XbzAocrTSS3JhnynCBHVo4wWjkZrvhcKmOTW7D9QqwxX2taVQq/tgqYJa5c+JMi9H6gd3knAVcGmzdjtQ2zv6ALWVnlO5nlvswt9wkXIu1YiyoaFrTKnoZBksE6FpcsrWHoRtRkUMz1IOnz3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hYwqv2yV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hYwqv2yV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F67C4CEF1;
	Fri, 21 Nov 2025 13:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732298;
	bh=u+fF+mlMWpGCCn1xpuQk7X/KqNFekoR7jgRA3DC5mB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hYwqv2yV1+b6QFUnge6mDSwwt/rhbX9ZfPYGy01X2pSExItv4LEEcrICFDQsZ9Nlz
	 fnp2Zqg6qYAzrkmC2Ynxdu3iNWOyOTcGtVJVTa0mWsfElYqHsuWPpHHrKoq7hWfS2M
	 Zq2NwQ3lusX7FrGheUlJtBWyAHT4slDgKJZW12WU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Ruehl <chris.ruehl@gtsys.com.hk>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/529] power: supply: qcom_battmgr: add OOI chemistry
Date: Fri, 21 Nov 2025 14:06:12 +0100
Message-ID: <20251121130233.621851164@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher Ruehl <chris.ruehl@gtsys.com.hk>

[ Upstream commit fee0904441325d83e7578ca457ec65a9d3f21264 ]

The ASUS S15 xElite model report the Li-ion battery with an OOI, hence this
update the detection and return the appropriate type.

Signed-off-by: Christopher Ruehl <chris.ruehl@gtsys.com.hk>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/qcom_battmgr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/qcom_battmgr.c b/drivers/power/supply/qcom_battmgr.c
index 190e8a4cfa97f..c1cb338e54bbc 100644
--- a/drivers/power/supply/qcom_battmgr.c
+++ b/drivers/power/supply/qcom_battmgr.c
@@ -975,7 +975,8 @@ static void qcom_battmgr_sc8280xp_strcpy(char *dest, const char *src)
 
 static unsigned int qcom_battmgr_sc8280xp_parse_technology(const char *chemistry)
 {
-	if (!strncmp(chemistry, "LIO", BATTMGR_CHEMISTRY_LEN))
+	if ((!strncmp(chemistry, "LIO", BATTMGR_CHEMISTRY_LEN)) ||
+	    (!strncmp(chemistry, "OOI", BATTMGR_CHEMISTRY_LEN)))
 		return POWER_SUPPLY_TECHNOLOGY_LION;
 	if (!strncmp(chemistry, "LIP", BATTMGR_CHEMISTRY_LEN))
 		return POWER_SUPPLY_TECHNOLOGY_LIPO;
-- 
2.51.0



