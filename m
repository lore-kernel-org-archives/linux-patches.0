Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113CB2222B2;
	Mon, 23 Jun 2025 22:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717644; cv=none; b=BW62i14X9hKo5d9hJecYgT6LFNk2xQdkZXQZIMnapXTUOYLcl7/xA5qNbAr4FidbzsM3jIhAHGWTVSo1dKziXcw7hMxrGCgbLyj80QAUmV7MPHpIe5Ksqa8leN4d9Opif0BXNK3F1Li2cUxpdVXzuZ0BhGfKlceWRIZNXH3HI/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717644; c=relaxed/simple;
	bh=DMvegwdKA8XfNcY3qHhRvBC+fy/7kTSbsJTc5Uhpq4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cMLwmps2c4T4Q7bLT2tS7g/n61n0Slikrm1IeDvgs+lp9dMR2fyfqJVu9vwfayHXZxKaZiHqOZzrhRM/CC3MV5xZGD/OICy1Mg+hP2b2Hvrs/qfn100zJbrb6OS3uZ/vRKF2dZR0Q4wKTiugfvbGOZ3kJIVEvnJ6M9Y3FvvbBqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fRjic8R6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fRjic8R6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E484C4CEEA;
	Mon, 23 Jun 2025 22:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717643;
	bh=DMvegwdKA8XfNcY3qHhRvBC+fy/7kTSbsJTc5Uhpq4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fRjic8R6A1isKEjBaLTztQZK7wNkQTFEJ5Saf13H4T7jmpfmGbUoXC71kPUKhovq6
	 OMhBch0v/REeJLJ5Fetuq0MsZfVvFC+8B/BLyg1BzQQ0rZ/QYqeGXO2oVIj8SlfYWp
	 ppMnOll9yqsFDngYmidsZ3DzjafpW+kFL/Em6eU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rengarajan S <rengarajan.s@microchip.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 487/508] net: microchip: lan743x: Reduce PTP timeout on HW failure
Date: Mon, 23 Jun 2025 15:08:52 +0200
Message-ID: <20250623130657.031455133@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rengarajan S <rengarajan.s@microchip.com>

[ Upstream commit b1de3c0df7abc41dc41862c0b08386411f2799d7 ]

The PTP_CMD_CTL is a self clearing register which controls the PTP clock
values. In the current implementation driver waits for a duration of 20
sec in case of HW failure to clear the PTP_CMD_CTL register bit. This
timeout of 20 sec is very long to recognize a HW failure, as it is
typically cleared in one clock(<16ns). Hence reducing the timeout to 1 sec
would be sufficient to conclude if there is any HW failure observed. The
usleep_range will sleep somewhere between 1 msec to 20 msec for each
iteration. By setting the PTP_CMD_CTL_TIMEOUT_CNT to 50 the max timeout
is extended to 1 sec.

Signed-off-by: Rengarajan S <rengarajan.s@microchip.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240502050300.38689-1-rengarajan.s@microchip.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: e353b0854d3a ("net: lan743x: fix potential out-of-bounds write in lan743x_ptp_io_event_clock_get()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan743x_ptp.c | 2 +-
 drivers/net/ethernet/microchip/lan743x_ptp.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_ptp.c b/drivers/net/ethernet/microchip/lan743x_ptp.c
index da3ea905adbb8..7ace578551a09 100644
--- a/drivers/net/ethernet/microchip/lan743x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan743x_ptp.c
@@ -58,7 +58,7 @@ int lan743x_gpio_init(struct lan743x_adapter *adapter)
 static void lan743x_ptp_wait_till_cmd_done(struct lan743x_adapter *adapter,
 					   u32 bit_mask)
 {
-	int timeout = 1000;
+	int timeout = PTP_CMD_CTL_TIMEOUT_CNT;
 	u32 data = 0;
 
 	while (timeout &&
diff --git a/drivers/net/ethernet/microchip/lan743x_ptp.h b/drivers/net/ethernet/microchip/lan743x_ptp.h
index e26d4eff71336..0d29914cd4606 100644
--- a/drivers/net/ethernet/microchip/lan743x_ptp.h
+++ b/drivers/net/ethernet/microchip/lan743x_ptp.h
@@ -21,6 +21,7 @@
 #define LAN743X_PTP_N_EXTTS		4
 #define LAN743X_PTP_N_PPS		0
 #define PCI11X1X_PTP_IO_MAX_CHANNELS	8
+#define PTP_CMD_CTL_TIMEOUT_CNT		50
 
 struct lan743x_adapter;
 
-- 
2.39.5



