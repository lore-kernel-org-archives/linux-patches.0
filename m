Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC0C23A6;
	Tue, 10 Sep 2024 10:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965196; cv=none; b=P0VmdDvBYYV5C1zwOf6Oa79u8wqpf5Wd1/WLOLC32dqj38STEvZo/TcPpMIkEpDCTz1Dok2vCC+9QCBCz63/YXDOVB/xDSvYjwm3hPDZEsRQAq1/oV1bx2qUfcX7JMwmywn7nSs5l0wx8q8rIs6E6Egs2HtzomzwogSwha9YgMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965196; c=relaxed/simple;
	bh=5U8HOHp6AB+iYljGIFmVMViw7poxM3X1PiGJXBvVzMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHG5ti8q8DStgD+k8ubjBVrkI9RNNJlskW44Zqgss1fW1tdiO4UlfMnJw3USin/1kqFyyc0so/bJYBc/uMxNAQelT8QGxpUx/49WJ0jvr+VzGt4/08IwODF6hdIwjGYy5RPmIYqTDkT83VGFCiEXmYx+0PdzEacQLYL6ds9td6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PbdrZ4Mo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PbdrZ4Mo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E71BC4CEC3;
	Tue, 10 Sep 2024 10:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965196;
	bh=5U8HOHp6AB+iYljGIFmVMViw7poxM3X1PiGJXBvVzMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PbdrZ4Moo8l4bzYXG8SJhSSmlpeaM6qT2Lq1luKdqXcS85B6Q6i4VJPTlN6fb3RVx
	 UocW2NJUfrMId8l14X+0Z3oOIgZ2mMNJOQTU/DtFCTSLvBQNgwKMTQBOLmF7yhXY7T
	 dFKve6uyJ80oclnm1gHYDc4slNC4G17LBetOee7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacky Bai <ping.bai@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Ye Li <ye.li@nxp.com>,
	Jason Liu <jason.hui.liu@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.10 169/186] clocksource/drivers/imx-tpm: Fix next event not taking effect sometime
Date: Tue, 10 Sep 2024 11:34:24 +0200
Message-ID: <20240910092601.580714296@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacky Bai <ping.bai@nxp.com>

commit 3d5c2f8e75a55cfb11a85086c71996af0354a1fb upstream.

The value written into the TPM CnV can only be updated into the hardware
when the counter increases. Additional writes to the CnV write buffer are
ignored until the register has been updated. Therefore, we need to check
if the CnV has been updated before continuing. This may require waiting for
1 counter cycle in the worst case.

Cc: stable@vger.kernel.org
Fixes: 059ab7b82eec ("clocksource/drivers/imx-tpm: Add imx tpm timer support")
Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Ye Li <ye.li@nxp.com>
Reviewed-by: Jason Liu <jason.hui.liu@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20240725193355.1436005-2-Frank.Li@nxp.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clocksource/timer-imx-tpm.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/clocksource/timer-imx-tpm.c
+++ b/drivers/clocksource/timer-imx-tpm.c
@@ -91,6 +91,14 @@ static int tpm_set_next_event(unsigned l
 	now = tpm_read_counter();
 
 	/*
+	 * Need to wait CNT increase at least 1 cycle to make sure
+	 * the C0V has been updated into HW.
+	 */
+	if ((next & 0xffffffff) != readl(timer_base + TPM_C0V))
+		while (now == tpm_read_counter())
+			;
+
+	/*
 	 * NOTE: We observed in a very small probability, the bus fabric
 	 * contention between GPU and A7 may results a few cycles delay
 	 * of writing CNT registers which may cause the min_delta event got


