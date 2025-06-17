Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3431A9B48;
	Tue, 17 Jun 2025 16:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176302; cv=none; b=Ya3pBHHoYnSKIXlM9giNmQvmjSnIotFt7DFFhLz259BRF593qZ73dtJqonbzRzRZikIoddnGJpILapGT/y+9SH5wAzgr/Cn8M+f/5SmfBugnXBwU8BoeNmPAdoAAqW3Taq9bIWhhKb28VdWSfuCbOHo16F6Ym5LMEdrukx6+gtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176302; c=relaxed/simple;
	bh=FzTLQOq+1fZ0nsGdCHIXN3/IBeitXhJ/FL/5bsG8eu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hwIpUBozBkik2QaxhfVsoVYIqql7efEGpAh5DrvMZfUAJ6t/xevO+zeT2vqP9qGu6TzupuOal3g40tW8WmgMv4erxQSOAiTmOEdezmZMcJ+TYqr3/HBupUfPdmRZKGmtf7VjUG6af4+ObVPcfWuaYeMZ/VQixFSwLoHxtmfsJzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dj4DXoj3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dj4DXoj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97ECBC4CEE3;
	Tue, 17 Jun 2025 16:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176302;
	bh=FzTLQOq+1fZ0nsGdCHIXN3/IBeitXhJ/FL/5bsG8eu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dj4DXoj3S2yxmHrAuDH6eI0cHcMBYxHosVw8Kx2gke2ZAMdt3eTJSER+rRwxEiSEE
	 1/StYxbaVyqowPoOU/7Kk0BguxM+vHX8QtR+t2MEw8sjI/Tr40u2qNcW1IajBULqmj
	 NFFkUbW2y/sf8/MpP1UtiNm6wipE16k/xCVmjMhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 215/512] net: phy: mscc: Stop clearing the the UDPv4 checksum for L2 frames
Date: Tue, 17 Jun 2025 17:23:01 +0200
Message-ID: <20250617152428.347810514@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit 57a92d14659df3e7e7e0052358c8cc68bbbc3b5e ]

We have noticed that when PHY timestamping is enabled, L2 frames seems
to be modified by changing two 2 bytes with a value of 0. The place were
these 2 bytes seems to be random(or I couldn't find a pattern).  In most
of the cases the userspace can ignore these frames but if for example
those 2 bytes are in the correction field there is nothing to do.  This
seems to happen when configuring the HW for IPv4 even that the flow is
not enabled.
These 2 bytes correspond to the UDPv4 checksum and once we don't enable
clearing the checksum when using L2 frames then the frame doesn't seem
to be changed anymore.

Fixes: 7d272e63e0979d ("net: phy: mscc: timestamping and PHC support")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Link: https://patch.msgid.link/20250523082716.2935895-1-horatiu.vultur@microchip.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mscc/mscc_ptp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/mscc/mscc_ptp.c b/drivers/net/phy/mscc/mscc_ptp.c
index 0173aa3b4ead1..ce49f3ac6939b 100644
--- a/drivers/net/phy/mscc/mscc_ptp.c
+++ b/drivers/net/phy/mscc/mscc_ptp.c
@@ -943,7 +943,9 @@ static int vsc85xx_ip1_conf(struct phy_device *phydev, enum ts_blk blk,
 	/* UDP checksum offset in IPv4 packet
 	 * according to: https://tools.ietf.org/html/rfc768
 	 */
-	val |= IP1_NXT_PROT_UDP_CHKSUM_OFF(26) | IP1_NXT_PROT_UDP_CHKSUM_CLEAR;
+	val |= IP1_NXT_PROT_UDP_CHKSUM_OFF(26);
+	if (enable)
+		val |= IP1_NXT_PROT_UDP_CHKSUM_CLEAR;
 	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_IP1_NXT_PROT_UDP_CHKSUM,
 			     val);
 
-- 
2.39.5



