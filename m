Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1901DE4CC;
	Tue,  8 Oct 2024 13:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392962; cv=none; b=rPNLTVh2jQnRhkujqgxfBnEBY8FZ56VhltYak7ApOXJwrWg6nOB9KVAfi6PgUPWYpr91pNE33sGGKXfkQm+yjEkyjfBTZJk9WsKNZzdWDkV3C7FQKxSNrPqyOFhiaYKEkRE3zCywcWzhWl7EIZUctvL57hIlRWzX+AX7VgUJ/Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392962; c=relaxed/simple;
	bh=kQYuGlX+gz1cjOu1fR4nN/lt46QVBpu8nxCViLTxwqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZdKOqPIMLejlORHcKaDrXJbcIuo5CkOx8LoVLjyYN/iLvc8smFtdeS8rZBIuSgqktxwL8Mr1ClE2WE3kXcg/sgi8G3ka5tPuSSQhi7C6y2Kt0/gQRsyWIt/mufU92//qzkoM5McvX62+1GAuOD4yQVIsWkgWPLfTmyzck/A058=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NLmDw2hy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NLmDw2hy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CDEDC4CEC7;
	Tue,  8 Oct 2024 13:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392961;
	bh=kQYuGlX+gz1cjOu1fR4nN/lt46QVBpu8nxCViLTxwqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NLmDw2hyvG+WNZZFpAnLI6rKKl6FDJKo+659+YGEEQRmU9vS+WEcpKKEszknFxA7k
	 rBLwmawmRCBhyVin3kbuRk5hhbVYs3pirMph/XiwAdlsGsfvQHItdFECgQ9WOT548N
	 a23cQNiROZo/rCrDNcNZozs2f2sYl8gF1XAqU/I8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aakash Menon <aakash.menon@protempis.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/386] net: sparx5: Fix invalid timestamps
Date: Tue,  8 Oct 2024 14:04:17 +0200
Message-ID: <20241008115629.804302121@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



