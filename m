Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5351519AA;
	Wed,  5 Feb 2025 14:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764987; cv=none; b=mv1rAptijgNYz9TqTYY14CvLXpIjxnfoqm9PiAyjfyRv7auOMBzxrCGwQ7+54IaSit54bw+reeiZ3oylNItMdaROeOdMyevqDQzIDIcenIXw0W5ylGMMju7I3yhtfI3D66JXy5r+caH5gaXV9ldt3DQrLCOYYEvaulwisPj5DDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764987; c=relaxed/simple;
	bh=mQ+0ReDtVF9zHANBiexpvGI5EMiO7Zik2zf2sVWHoug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4PKHBqAPDq5OjFnZqr1lwTvHHGwEVu4Eq0TIUv81bXoJqjks9peMi+iKZT0WErdw0ukNPEGpBSt31+0dtHIqidNVKMX/6BoGEqb6+H69QPd/EtkjtxYoKcwkFOsRnMlW8UFsWK0bN0OEbD+SGN74/sl+1ECjIVMaIm2qiQYzyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lvhxf+CC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lvhxf+CC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE496C4CED1;
	Wed,  5 Feb 2025 14:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764986;
	bh=mQ+0ReDtVF9zHANBiexpvGI5EMiO7Zik2zf2sVWHoug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lvhxf+CC3qKLnMkYAHHFXI5YnQPddijNs31WnTxliJLUG9n/pe+9DnNjHrzYnE/mF
	 QY7BW80qfcvfI33Ni8mhWqdbqjojZBm1NpYbpa+uX894T45khJ9PCpS0kZHLNyk4Y+
	 E/Bjv0NA1Kb8YB6zpjt0BhOjLhua6RwX35/KPpM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xueqin Luo <luoxueqin@kylinos.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 179/590] wifi: mt76: mt7996: fix overflows seen when writing limit attributes
Date: Wed,  5 Feb 2025 14:38:54 +0100
Message-ID: <20250205134502.129213139@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: xueqin Luo <luoxueqin@kylinos.cn>

[ Upstream commit 5adbc8ce5bbe7e311e2600b7d7d998a958873e98 ]

DIV_ROUND_CLOSEST() after kstrtoul() results in an overflow if a large
number such as 18446744073709551615 is provided by the user.
Fix it by reordering clamp_val() and DIV_ROUND_CLOSEST() operations.
This commit was inspired by commit: 57ee12b6c514.

Fixes: 6879b2e94172 ("wifi: mt76: mt7996: add thermal sensor device support")
Signed-off-by: xueqin Luo <luoxueqin@kylinos.cn>
Link: https://patch.msgid.link/20241202031917.23741-2-luoxueqin@kylinos.cn
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index efa7b0697a406..d5f53abc4dcb4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -82,7 +82,7 @@ static ssize_t mt7996_thermal_temp_store(struct device *dev,
 		return ret;
 
 	mutex_lock(&phy->dev->mt76.mutex);
-	val = clamp_val(DIV_ROUND_CLOSEST(val, 1000), 40, 130);
+	val = DIV_ROUND_CLOSEST(clamp_val(val, 40 * 1000, 130 * 1000), 1000);
 
 	/* add a safety margin ~10 */
 	if ((i - 1 == MT7996_CRIT_TEMP_IDX &&
-- 
2.39.5



