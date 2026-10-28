Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210993;
	b=3LukXHJE0/vUjfoI9epTYTu3mB8hqekLY+ESVR+eMRGqsM+5/ZaHcHK89Z1tOzEuH/HK
	 WK7PtzqJj5BJH82vOa+sQJpA/3fH3WUeC6awRxqN2VZwmZSkfU3eL7T/eLTcyxqTUxtgK
	 EBCdVBmYAxrQv7c3oLni+mQ3X1ga+jtzEiKnTCS/WkyPj2L7wTZHsuY2jIB6/kRCjUXRl
	 hdlqVrZdeCGvGFLV7EFiuZQ2/ccK9K9FlqXNZac++3ioGJBD4f1vx/rW6Kdb8JksKd1d7
	 NtWH0qijR3k51sLlOTUiuoQRrZXJldATXlDMHRcrDGzk4j4dc0dstoayv+eVqaVyUiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210993;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4C2c3VzBAJYouYferdu2xvdDGLKTcQE29upiB/KiseM=;
	b=lmD8jjdwd1hGKCbXKK4IH1K/IA4+MWlKa/uwoHJDKO5jYXsInBXkyDAYzGBOV4OFKTdf
	 21q12q/AgGgO09z9qjzYtDB5sz5pAa/aPYkyET/1gpBnwaASzHsoL8gq4wcVLLmnDUCQC
	 mAvyftMUz4EGDv5WKJEksTJ4HWsa5MFxbMqW5fTH+q+9g1AU6nh4C/IdcWG11fKXSS+CL
	 RF8D+dTapJxpqnMqxMBJyXLFqkhgoaYspiYAqvMihPyM4a673AmdxcdQYCVVDmRjcHNYR
	 pT/Fkqp3DCU9TNj7bDqvyuLiwyx2jj+KpAcf/wg/5pysiWs07xSC81uUutAjo39RPTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SBfAiq5c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FF1606A33F;
	Wed, 28 Oct 2026 18:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SBfAiq5c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763461F031E5;
	Wed, 28 Oct 2026 18:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210993;
	bh=4C2c3VzBAJYouYferdu2xvdDGLKTcQE29upiB/KiseM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SBfAiq5c8hyFOh//DOOHWb8lSXNrg9USf5clav2t7eG+zsRCt0rqCx1Gm5j+D9ChF
	 S8gWtWVevEm5vKH7VlnE/fsYa8WUKrI/zXfvVD1HRbPh2CY+0HbHEul8pHo+2JneFQ
	 pltlvTRoeWJP6ua3UiMc/G0dB0KY2qoQVt8+NEWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
Subject: [PATCH 5.15 219/571] tty: serial: qcom_geni_serial: Keep console RX functional after deep idle
Date: Wed, 28 Oct 2026 17:56:06 +0100
Message-ID: <20261028170013.199055203@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1017,9 +1017,8 @@ static void qcom_geni_serial_set_termios
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
 


