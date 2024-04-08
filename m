Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0854B6A352;
	Mon,  8 Apr 2024 13:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582764; cv=none; b=kuWlowL9es8c41qkwJEkOiqz9nZwTOpv3tbIV2SZmASCpZ2XErUMXEL1JH02BLJHFAQkQl1KIMJa7SFFO9c3b6935M8+bsNQD3bg6H7w/DM6pfg9H9AmNipI+LGqgnxbUw181GDSzd3OaiqmrEder/f4jwrBkGkuf0r/Qe/s8Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582764; c=relaxed/simple;
	bh=L9sM6eSjvmHkquu61uVKlNsTFxylEoJwgZj3ASk5oJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txqbxl3N+J73wjw5gI+H18Ik8iB5LedH+dAnRBbJI+D99Neiz+dx+PSRkzlhtJHr31M+g6KPoTCHP54MsZwzHEgGXxZhV9C/pSCXF3SR6sXORl5ibmV4KNHKFPpC0UNKnXRdFb8Oo+qpmVXh6zUTH3BOSrSmmzA2O+EJQKa9l/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YfLqkneb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YfLqkneb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814E0C433C7;
	Mon,  8 Apr 2024 13:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582763;
	bh=L9sM6eSjvmHkquu61uVKlNsTFxylEoJwgZj3ASk5oJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YfLqknebkPqlT0vkJTSzQomEbFdqpNv5ihjAQKFX9BEjj1BWIl9jbt4PIO58igmpk
	 SM6u7E+Cmt9SYyr6uq6avOU2Td996T15fJA+ztE9rWWkrTf6cT/Rp5Nc6+6Ddlvlrq
	 u56SXDb5q1d83FggK1kgw1/h7nmBRwdE5HSPRoJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atlas Yu <atlas.yu@canonical.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 122/252] r8169: skip DASH fw status checks when DASH is disabled
Date: Mon,  8 Apr 2024 14:57:01 +0200
Message-ID: <20240408125310.412450350@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

From: Atlas Yu <atlas.yu@canonical.com>

commit 5e864d90b20803edf6bd44a99fb9afa7171785f2 upstream.

On devices that support DASH, the current code in the "rtl_loop_wait" function
raises false alarms when DASH is disabled. This occurs because the function
attempts to wait for the DASH firmware to be ready, even though it's not
relevant in this case.

r8169 0000:0c:00.0 eth0: RTL8168ep/8111ep, 38:7c:76:49:08:d9, XID 502, IRQ 86
r8169 0000:0c:00.0 eth0: jumbo features [frames: 9194 bytes, tx checksumming: ko]
r8169 0000:0c:00.0 eth0: DASH disabled
...
r8169 0000:0c:00.0 eth0: rtl_ep_ocp_read_cond == 0 (loop: 30, delay: 10000).

This patch modifies the driver start/stop functions to skip checking the DASH
firmware status when DASH is explicitly disabled. This prevents unnecessary
delays and false alarms.

The patch has been tested on several ThinkStation P8/PX workstations.

Fixes: 0ab0c45d8aae ("r8169: add handling DASH when DASH is disabled")
Signed-off-by: Atlas Yu <atlas.yu@canonical.com>
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/20240328055152.18443-1-atlas.yu@canonical.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |   31 ++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1201,17 +1201,40 @@ static void rtl8168ep_stop_cmac(struct r
 	RTL_W8(tp, IBCR0, RTL_R8(tp, IBCR0) & ~0x01);
 }
 
+static void rtl_dash_loop_wait(struct rtl8169_private *tp,
+			       const struct rtl_cond *c,
+			       unsigned long usecs, int n, bool high)
+{
+	if (!tp->dash_enabled)
+		return;
+	rtl_loop_wait(tp, c, usecs, n, high);
+}
+
+static void rtl_dash_loop_wait_high(struct rtl8169_private *tp,
+				    const struct rtl_cond *c,
+				    unsigned long d, int n)
+{
+	rtl_dash_loop_wait(tp, c, d, n, true);
+}
+
+static void rtl_dash_loop_wait_low(struct rtl8169_private *tp,
+				   const struct rtl_cond *c,
+				   unsigned long d, int n)
+{
+	rtl_dash_loop_wait(tp, c, d, n, false);
+}
+
 static void rtl8168dp_driver_start(struct rtl8169_private *tp)
 {
 	r8168dp_oob_notify(tp, OOB_CMD_DRIVER_START);
-	rtl_loop_wait_high(tp, &rtl_dp_ocp_read_cond, 10000, 10);
+	rtl_dash_loop_wait_high(tp, &rtl_dp_ocp_read_cond, 10000, 10);
 }
 
 static void rtl8168ep_driver_start(struct rtl8169_private *tp)
 {
 	r8168ep_ocp_write(tp, 0x01, 0x180, OOB_CMD_DRIVER_START);
 	r8168ep_ocp_write(tp, 0x01, 0x30, r8168ep_ocp_read(tp, 0x30) | 0x01);
-	rtl_loop_wait_high(tp, &rtl_ep_ocp_read_cond, 10000, 30);
+	rtl_dash_loop_wait_high(tp, &rtl_ep_ocp_read_cond, 10000, 30);
 }
 
 static void rtl8168_driver_start(struct rtl8169_private *tp)
@@ -1225,7 +1248,7 @@ static void rtl8168_driver_start(struct
 static void rtl8168dp_driver_stop(struct rtl8169_private *tp)
 {
 	r8168dp_oob_notify(tp, OOB_CMD_DRIVER_STOP);
-	rtl_loop_wait_low(tp, &rtl_dp_ocp_read_cond, 10000, 10);
+	rtl_dash_loop_wait_low(tp, &rtl_dp_ocp_read_cond, 10000, 10);
 }
 
 static void rtl8168ep_driver_stop(struct rtl8169_private *tp)
@@ -1233,7 +1256,7 @@ static void rtl8168ep_driver_stop(struct
 	rtl8168ep_stop_cmac(tp);
 	r8168ep_ocp_write(tp, 0x01, 0x180, OOB_CMD_DRIVER_STOP);
 	r8168ep_ocp_write(tp, 0x01, 0x30, r8168ep_ocp_read(tp, 0x30) | 0x01);
-	rtl_loop_wait_low(tp, &rtl_ep_ocp_read_cond, 10000, 10);
+	rtl_dash_loop_wait_low(tp, &rtl_ep_ocp_read_cond, 10000, 10);
 }
 
 static void rtl8168_driver_stop(struct rtl8169_private *tp)


