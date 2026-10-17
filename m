Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA506391512;
	Sat, 17 Oct 2026 17:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256584; cv=none; b=tBLkV5HG0jQwxXaqoQinCuYfZWs+UWrTIScGS4IPIkYX441VjhbQ0bwVCGJ4ycb/F0St8CcMeRfZqyE/1SsXtB4XRLcumCEh6oVi66FS1PoF/AHgy2LEszrNtRfCey0kDH+bRH0UT+g97zmLc7wJdtUctDj4XIYFAn6NjFtCkok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256584; c=relaxed/simple;
	bh=EWfsGgX4kewQcKIHGdIz6/qCasF0Y+qQb6ZHZ3Qfbxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ni78LzPF1YJ3niDN3hn43EhtunOactq/lr84UE4R+QFYf3mPBDlySIBQ3WgUolVuEuUPW7N/jrFDss18/urKjG3j41Os2mukIK31xRj0G3a7AuzMwWaUsUs676RzzmCyKNToENoUkBQbWXp9Oy6lw5ccS1IStb4SUjjzPytKda8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hUXuTSmq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hUXuTSmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220401F000C4;
	Sat, 17 Oct 2026 17:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256583;
	bh=t5nTmMtdtU04s0lF6FMQ76QgSQ6iEjWa7RvC6NEmgE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hUXuTSmqgAloy7iHrIvg2doL7Up0ntSWDeUOHC/Tcwa/gOGQPNE+dKm/QNm38RRCA
	 2atpzpK4pXrcksiTKswoiaQeQllMQ6HrK4NfHzFsenYPJAPj7SW0TsQBmx6LGQXVdD
	 2qIjrB2wZVDfmhKn5iyKsyYhutkfPgRvenOw5B9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
Subject: [PATCH 6.6 0283/1674] tty: serial: qcom_geni_serial: Keep console RX functional after deep idle
Date: Sat, 17 Oct 2026 17:42:35 +0200
Message-ID: <20261017160438.377625029@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1304,9 +1304,8 @@ static void qcom_geni_serial_set_termios
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
 


