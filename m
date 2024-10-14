Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EED1A76A5;
	Mon, 14 Oct 2024 15:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918663; cv=none; b=Glf092apb8lFws0laaAkSAFC6wg208omgQEIYcFaW9XTEMPXZHoiMKPeF+ZrIMjDfznskqob9/+qbMhw7JfCRz7ntZMp6INOCuzF6oJs9HTMSPjhUryoZrjIOeJ4FM6FZtgkrPGW3O+Kc0saYXRycG7yj1NA4tuHfrr0BSpXKEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918663; c=relaxed/simple;
	bh=l4QolEhdUlzgfuKlbmRFBuxzYVYaObqfazAsQIs78DE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IuYbwEulmLeroyNyp+7wEHzHw8DRh5XjXeFu2P+oLRPWojTcArFKhOnCwnUBVLjqaDgqJgCEwtb6yf43+cp9EUQMh4gbyZLUhxOtmGpJnaO0T24imNRagM1X/jIraB4D2+kyPw+ZKM33pLhFJPAMCcLxyWv+e47g9FQ5Czv3bXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eWzaxlV3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eWzaxlV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F63CC4CEC3;
	Mon, 14 Oct 2024 15:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918663;
	bh=l4QolEhdUlzgfuKlbmRFBuxzYVYaObqfazAsQIs78DE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eWzaxlV3OGGJ1/Iw6n9eJHqgCaQ4IMteUIV3QoKM+PVDIawvDn5E9O45dTVym8OxJ
	 vKhOZRaO7iPo4dEMn6yAfN+GDq9ltIUQQ/6CJyLq8YVJwIsAQ416A7LuSy1dtUxAgI
	 kFDoXOOCA30dcHCeVysrviNCxQnUoC0YFm6VgMh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aakash Menon <aakash.menon@protempis.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 386/798] net: sparx5: Fix invalid timestamps
Date: Mon, 14 Oct 2024 16:15:40 +0200
Message-ID: <20241014141233.113959057@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aakash Menon <aakash.r.menon@gmail.com>

[ Upstream commit 151ac45348afc5b56baa584c7cd4876addf461ff ]

Bit 270-271 are occasionally unexpectedly set by the hardware. This issue
was observed with 10G SFPs causing huge time errors (> 30ms) in PTP. Only
30 bits are needed for the nanosecond part of the timestamp, clear 2 most
significant bits before extracting timestamp from the internal frame
header.

Fixes: 70dfe25cd866 ("net: sparx5: Update extraction/injection for timestamping")
Signed-off-by: Aakash Menon <aakash.menon@protempis.com>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_packet.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
index ac7e1cffbcecf..dcf2e342fc14a 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
@@ -45,8 +45,12 @@ void sparx5_ifh_parse(u32 *ifh, struct frame_info *info)
 	fwd = (fwd >> 5);
 	info->src_port = FIELD_GET(GENMASK(7, 1), fwd);
 
+	/*
+	 * Bit 270-271 are occasionally unexpectedly set by the hardware,
+	 * clear bits before extracting timestamp
+	 */
 	info->timestamp =
-		((u64)xtr_hdr[2] << 24) |
+		((u64)(xtr_hdr[2] & GENMASK(5, 0)) << 24) |
 		((u64)xtr_hdr[3] << 16) |
 		((u64)xtr_hdr[4] <<  8) |
 		((u64)xtr_hdr[5] <<  0);
-- 
2.43.0



