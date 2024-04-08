Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED007CF17;
	Mon,  8 Apr 2024 13:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581894; cv=none; b=WFXv6e626MaKg3f8jtEe+HQOG6o7mLXkRvGfzRdidfVBo6uRVCgf+mHZfB0XSLDwY6jBoAC0FOqn/wv03a8c/1kM3A2h2TkyDrss6G2pdRaQMGz+nPgaoTnDxme5O+EIfuUC5NX7Ec+WrkxBSEMb0gG6ExQ86QkQV0Ex6mXbE3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581894; c=relaxed/simple;
	bh=V3xQqMMz721X7T6Cq+kRzZ1IfXbaTvDCUTWo/2/rdSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smf1AEyD+eP334KAzi4/SviCicsIIC0fCz9EDGmJDyfHKeAVo0qYnN2pL6t+vFV8w6VFcLGGttESc7I0D6yCNGRUWUqV2tAo8l51WoonhqDs7JYQqTzGq+8RiY9EVujgCiCXhUqda8HIX1GWxdKjz+sJz2Kdy5feoaKsM7QVag0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eCgx8QnD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eCgx8QnD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C567C433F1;
	Mon,  8 Apr 2024 13:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581893;
	bh=V3xQqMMz721X7T6Cq+kRzZ1IfXbaTvDCUTWo/2/rdSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eCgx8QnDW3q2bM+uM709HVH1guyX+S1kJUOrnRwD9XyP7q41T7pK5ZObbs8YJw+Ot
	 7uwi+xhGywF3daTerXz5Ja6UXYONfMGaxrJYzONt1yBNyGb73gL/nVxTu53up3Deab
	 xaRcR5EiprOLfNAxp7IvduKQM9Xgx+R1FUn/Xjco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atlas Yu <atlas.yu@canonical.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 060/138] r8169: skip DASH fw status checks when DASH is disabled
Date: Mon,  8 Apr 2024 14:57:54 +0200
Message-ID: <20240408125258.088500262@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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
@@ -1135,17 +1135,40 @@ static void rtl8168ep_stop_cmac(struct r
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
@@ -1159,7 +1182,7 @@ static void rtl8168_driver_start(struct
 static void rtl8168dp_driver_stop(struct rtl8169_private *tp)
 {
 	r8168dp_oob_notify(tp, OOB_CMD_DRIVER_STOP);
-	rtl_loop_wait_low(tp, &rtl_dp_ocp_read_cond, 10000, 10);
+	rtl_dash_loop_wait_low(tp, &rtl_dp_ocp_read_cond, 10000, 10);
 }
 
 static void rtl8168ep_driver_stop(struct rtl8169_private *tp)
@@ -1167,7 +1190,7 @@ static void rtl8168ep_driver_stop(struct
 	rtl8168ep_stop_cmac(tp);
 	r8168ep_ocp_write(tp, 0x01, 0x180, OOB_CMD_DRIVER_STOP);
 	r8168ep_ocp_write(tp, 0x01, 0x30, r8168ep_ocp_read(tp, 0x30) | 0x01);
-	rtl_loop_wait_low(tp, &rtl_ep_ocp_read_cond, 10000, 10);
+	rtl_dash_loop_wait_low(tp, &rtl_ep_ocp_read_cond, 10000, 10);
 }
 
 static void rtl8168_driver_stop(struct rtl8169_private *tp)


