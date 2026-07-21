Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9544729CE9;
	Tue, 21 Jul 2026 21:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669002; cv=none; b=EDVbp+WtElPJoq1cmbRVkYyadoCnIqtEHJSvcR/TzXiD+R4NWpjc55RJPhER1DVUBILSYQ5zIb5CR06RAZebcmEsOS4Ap0uh2aR5S9pYRHPX7ePDkGKF7cWqFEXnXcoCo/n+Ly59ysusZyrvL3/JOfSSJzDqbTrPcej45OBCRMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669002; c=relaxed/simple;
	bh=00tO5qBLN0ugL0N1cs3nNZe9Wvi42YpxNYbPDCNoOB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iLl25QVjtZindlIxuAQZOKBMuVRw7eHbBtJdPIOTJzTR4DKV7MU3k43fg2deMmpEZNehrp/YWLhRIzESj2RvkT/4eyW/ff8fvTeC4TWoR0NfbzSBedgYGK5vGAFkuculWtWs00H4D6Gb5Qn6RUYke+rzyjJDK3wC12sWvORRNdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EN8oHeBk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EN8oHeBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FFD1F000E9;
	Tue, 21 Jul 2026 21:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668997;
	bh=OG32pdrIf9ywz8c7fDvtfSugh6aymydra5bxzjsLGAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EN8oHeBkqkSS5AZ2zXCalWFNCrRDsB1VCp4b8ZWod+kKJc16MZXzgk5uTOLqiaF6J
	 u087SabTx4x+4q3RrT7eBP3mi5nxdT9IW1ZYVSZOUqY6FWeDjMSe8xwxz6+w1llAhm
	 RHU3n467mkyFNWvXeSJx3vJCxSwd2/e26oLWV2cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0389/1067] wifi: wcn36xx: fix OOB read from firmware count in PRINT_REG_INFO indication
Date: Tue, 21 Jul 2026 17:16:30 +0200
Message-ID: <20260721152433.331540631@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit df2187acfca6c6cca372c5d35f42394d9c270b09 ]

The firmware-controlled rsp->count field is used as the loop bound for
indexing into the flexible rsp->regs[] array without validation against
the message length. A count exceeding the actual data causes out-of-
bounds reads from the heap-allocated message buffer.

Add a check that count fits within the received message.

Fixes: 43efa3c0f241 ("wcn36xx: Implement print_reg indication")
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/20260421135018.352774-3-tristmd@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index bd51abef3a5be7..ad329252a7ceb8 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -2865,6 +2865,12 @@ static int wcn36xx_smd_print_reg_info_ind(struct wcn36xx *wcn,
 		return -EIO;
 	}
 
+	if (rsp->count > (len - sizeof(*rsp)) / sizeof(rsp->regs[0])) {
+		wcn36xx_warn("Truncated print reg info indication: count %u, len %zu\n",
+			     rsp->count, len);
+		return -EIO;
+	}
+
 	wcn36xx_dbg(WCN36XX_DBG_HAL,
 		    "reginfo indication, scenario: 0x%x reason: 0x%x\n",
 		    rsp->scenario, rsp->reason);
-- 
2.53.0



