Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046BF4582D3;
	Fri,  9 Oct 2026 14:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556239; cv=none; b=CyB7uUAIzjHLVVNye1TdRnqQCglgOJ3VBVaqesO0YsTc2fd6KpHaAEs2vaaAkYNTwGpDt6Rzgpd3Hn2zsGUDcAodZWo2IgSDBDZD3yO+li5SvZJ4CetPjzQa9blqd/QKJ5jb/yel9j/B8ppzqEATSiinnLuYZr49Xw1Xad3QHf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556239; c=relaxed/simple;
	bh=2YSa4s5fJ+GSSEgSnGDXdt43w+Y+VPwMaSIfrXymp5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+rix2Wm3AoOWIeMFzi15hLU6i/xBYWmpedcmt1bw0bSoHic5xi3FX22XmqOT1T2/HWd4vomioyYw+vZhJTlEIrr1zHOSgalPFAchzTSLcLTCncfktTHzNm2fHvmm8XECydjrAdv5ddthtW9/nIBDTkJkKqngf84JuCAP59Sgm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SkRZYtiF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SkRZYtiF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621431F000FF;
	Fri,  9 Oct 2026 14:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556237;
	bh=YtsUT3PX4ibj7LDJl71TbqKCtdcOCb0dE/SwwWjw1Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SkRZYtiFY4zA3o9BYCe3Fmdm/9p+00MGq/PUBqnXg23nz8EoTnw03o1LHgBEOaowu
	 OAqtPxvMHtefYf7v+h7G6j+uJYwUi/nJRDdJJLrDixHOl6L44RHHWhQr1HsyPp2wMe
	 kp2sysSrRcAS2P/c9SIoOdkoWcBfYjVdApDJ8xW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
Subject: [PATCH 6.18 196/403] tty: serial: qcom_geni_serial: Keep console RX functional after deep idle
Date: Fri,  9 Oct 2026 16:09:17 +0200
Message-ID: <20261009140956.714605389@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>

commit 63ef71d1474b5417b5b2dec700cd251c44a570d9 upstream.

At baud rates up to 115200, the serial console uses only a 1 kBps keepalive
vote for the GENI_TO_CORE ("qup-core") ICC path. This vote keeps the path
active but does not request a QUP Core 2X clock rate.

When the CPU enters a deeper idle state, the missing Core clock vote can
leave the console RX path unresponsive.

Use the 19.2 MHz Core 2X vote at low baud rates, while retaining the 50 MHz
vote at higher baud rates, so that console RX remains functional after deep
idle transitions.

Fixes: 7cf563b2c846 ("tty: serial: qcom_geni_serial: Add interconnect support")
Cc: stable@kernel.org
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
Link: https://patch.msgid.link/20260915-correct-icc-bandwidth-vote-constants-v2-2-f78eb611204e@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/qcom_geni_serial.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -1303,9 +1303,8 @@ static int geni_serial_set_rate(struct u
 	 * Bump up BW vote on CPU and CORE path as driver supports FIFO mode
 	 * only.
 	 */
-	avg_bw_core = (baud > 115200) ? Bps_to_icc(CORE_2X_50_MHZ)
-						: GENI_DEFAULT_BW;
-	port->se.icc_paths[GENI_TO_CORE].avg_bw = avg_bw_core;
+	avg_bw_core = baud > 115200 ? CORE_2X_50_MHZ : CORE_2X_19_2_MHZ;
+	port->se.icc_paths[GENI_TO_CORE].avg_bw = Bps_to_icc(avg_bw_core);
 	port->se.icc_paths[CPU_TO_GENI].avg_bw = Bps_to_icc(baud);
 	geni_icc_set_bw(&port->se);
 


