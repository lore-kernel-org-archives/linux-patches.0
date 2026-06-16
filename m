Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC674779B0;
	Tue, 16 Jun 2026 16:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627612; cv=none; b=uWkgFdDb7jO3Viq6hxMF3sGA+u3TR4oaewkRh9veG12CpJwv1ICNW14d9WirPxZkyFXRsFcpweYOKdgZFU275qwmzD09x9nOvpjVuiTUdyn6BXWaF0SgMUUxnGtV5R0Gofyttf7LcnI/0EbSA1YNMciCv3Kc+0bsegiAfe4UU+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627612; c=relaxed/simple;
	bh=7AMSz26Y42kF5Kgqf+lCcXBYFZdg7KSxkYHsp6wwQeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSPVAs8lV/yJHiSWJdTcutTEJo1sWZABbzO2L11/Sk/ky5W8lIqB7V4cMvNZkRjHYtkK/AKC52Qdg1nSA2Hp2iB+Y5VJLiSxsJzKGL+5bjLVMJtB1gbaEQF6dTKoeh2OeFaAvBWUD4a3YBP1agSQOF/2d+3W8V9a+ogiZ5rmcPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=msHsv0sh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="msHsv0sh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B431F00A3A;
	Tue, 16 Jun 2026 16:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627611;
	bh=20B4jh9kT1UXCKxjWhUwZm0TYanlwY7d+6TzwG6txJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=msHsv0sh31cUzjtSbOjaZp0NuGIlNovgkacY3ofJ6LzuwR3mQttnSG2casAXF1lxc
	 4ZFOBPKBSt5R5fmOf7dsuanZkP1nb+63QaADkFO7u0/Wrd7qwJ69llVGvFScf5NGTh
	 LLDP48ut41OgQ3CZEE9pDHDAqOp5f3nbrhXczfW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Lai <justinlai0215@realtek.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 198/261] rtase: Avoid sleeping in get_stats64()
Date: Tue, 16 Jun 2026 20:30:36 +0530
Message-ID: <20260616145054.233121376@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Lai <justinlai0215@realtek.com>

commit 9fc237f8d49f06d05f0f8e80361047b718894e81 upstream.

The .ndo_get_stats64 callback must not sleep because it can be
called when reading /proc/net/dev.

rtase_get_stats64() calls rtase_dump_tally_counter(), which polls
the tally counter dump bit with read_poll_timeout(). This may
sleep while waiting for the hardware counter dump to complete.

Use read_poll_timeout_atomic() instead to avoid sleeping in the
get_stats64() path.

Fixes: 079600489960 ("rtase: Implement net_device_ops")
Cc: stable@vger.kernel.org
Signed-off-by: Justin Lai <justinlai0215@realtek.com>
Link: https://patch.msgid.link/20260603061816.31356-1-justinlai0215@realtek.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/rtase/rtase_main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/realtek/rtase/rtase_main.c
+++ b/drivers/net/ethernet/realtek/rtase/rtase_main.c
@@ -1548,8 +1548,9 @@ static void rtase_dump_tally_counter(con
 	rtase_w32(tp, RTASE_DTCCR0, cmd);
 	rtase_w32(tp, RTASE_DTCCR0, cmd | RTASE_COUNTER_DUMP);
 
-	err = read_poll_timeout(rtase_r32, val, !(val & RTASE_COUNTER_DUMP),
-				10, 250, false, tp, RTASE_DTCCR0);
+	err = read_poll_timeout_atomic(rtase_r32, val,
+				       !(val & RTASE_COUNTER_DUMP),
+				       10, 250, false, tp, RTASE_DTCCR0);
 
 	if (err == -ETIMEDOUT)
 		netdev_err(tp->dev, "error occurred in dump tally counter\n");


