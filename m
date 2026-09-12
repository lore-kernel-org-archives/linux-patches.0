Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F19C38656D;
	Sat, 12 Sep 2026 18:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239318; cv=none; b=nw8zCEcUgzE9rPMbaclQrQ8liLRQupoMZIS6NG75yRwiPpXaS4RPQkVgMZvgv4zbotsXAiGmkwbrKzM8YfmjstVKwA9hnX/ViRelY/LpVsRRBiPOCpRJDT6uSD+27NeLGufK2g281t5HuAH+5rOiPMsKWVzMGH2uQsS5ln90yK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239318; c=relaxed/simple;
	bh=Lxh457NPu/m7SThH2lQP3xY1Gt9W3OrWHWoosLbUrxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mim3SGfcRySFDSznwuo5WXFzsfrf3eks2+i4o69PJ4UEM2Aafv2f0smiccInzhy0rnxc/bWjeOkuFdpQC9JtOf7ni7XkSQ4p94phKmQkO3AIcbSnrv7/AYmca+ecsHP2GTyz77GtkPqMaKR+JyNVRoJs7+L+cAZjPf1+5rIh/2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DP91D++4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DP91D++4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A36D1F000FF;
	Sat, 12 Sep 2026 18:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239316;
	bh=IeyaNkCqbU7ytOfrcrky8OZejQXDNf+bBlswfgrOgRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DP91D++4X91ws34QO4fONi+heAI2/+ppEDV4UDly5OkwPILb3j/WB/sQxnSd+4Iie
	 UhhkU5Gta476t1sAnjxpQ64qADgmQWvWBvUmVcyqDLDRY5mEYAwXoNmv+m+qO9dQMZ
	 uTGXK/vKnvtWMsdCSGbr+kWpCEZW4nByKfhJjrVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 641/935] i3c: dw: avoid shift-out-of-bounds when DAA assigns no devices
Date: Sat, 12 Sep 2026 09:01:11 +0200
Message-ID: <20260912065541.544075914@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 038cf48b3170af26a70bf2dee4f8c3ac910f5176 ]

On an empty bus ENTDAA assigns nothing, so cmd->rx_len (the count
of addresses left unassigned) equals master->maxdevs.

The GENMASK() index master->maxdevs - cmd->rx_len - 1 then becomes -1,
which trips up UBSAN. This happens every time on boot on a Gigabyte/AMD
server:

    UBSAN: shift-out-of-bounds in drivers/i3c/master/dw-i3c-master.c:905:12
    shift exponent 64 is too large for 64-bit type 'long unsigned int'
    CPU: 7 UID: 0 PID: 963 Comm: (udev-worker) Not tainted 7.0.11-200.fc44.x86_64 #1 PREEMPT(lazy)
    Hardware name: Giga Computing E163-Z34-AAH1-000/MZ33-DC1-000, BIOS R32_F45 04/01/2026
    Call Trace:
     <TASK>
     dump_stack_lvl+0x5d/0x80
     ubsan_epilogue+0x5/0x2b
     __ubsan_handle_shift_out_of_bounds.cold+0xd7/0x1ab
     dw_i3c_master_daa.cold+0x1b/0x96 [dw_i3c_master]
     i3c_master_do_daa_ext.part.0+0x3e/0xf0 [i3c]

Skip the mask when no new device was assigned.

Fixes: 1dd728f5d4d4 ("i3c: master: Add driver for Synopsys DesignWare IP")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260630172904.2662160-1-kuba@kernel.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/dw-i3c-master.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/i3c/master/dw-i3c-master.c b/drivers/i3c/master/dw-i3c-master.c
index 51a8608203de7..11b1cec6398f3 100644
--- a/drivers/i3c/master/dw-i3c-master.c
+++ b/drivers/i3c/master/dw-i3c-master.c
@@ -810,7 +810,15 @@ static int dw_i3c_master_daa(struct i3c_master_controller *m)
 	if (!wait_for_completion_timeout(&xfer->comp, XFER_TIMEOUT))
 		dw_i3c_master_dequeue_xfer(master, xfer);
 
-	newdevs = GENMASK(master->maxdevs - cmd->rx_len - 1, 0);
+	/*
+	 * cmd->rx_len holds the number of addresses ENTDAA left unassigned.
+	 * On an empty bus rx_len == maxdevs, so avoid GENMASK(-1, 0).
+	 */
+	if (cmd->rx_len >= master->maxdevs)
+		newdevs = 0;
+	else
+		newdevs = GENMASK(master->maxdevs - cmd->rx_len - 1, 0);
+
 	newdevs &= ~olddevs;
 
 	for (pos = 0; pos < master->maxdevs; pos++) {
-- 
2.53.0



