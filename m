Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0132F3B47F6;
	Tue, 21 Jul 2026 20:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665986; cv=none; b=GvaFJ8JVuy3GRE0m4bMnE8a4Dv5a3I0J0kwXmhmeYF483QTjUYhmdmrgTYvZP1XLJ9yZyeRYTCvTkQEpEDPTnfKEf8Mkn45eH7K/cPYSu+1ZNyvlJFzjFZPyxd4HPurusGxUQGGPMj+2dBYT3J1Zu0U6ygW9wyUt4cFSbfUSVPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665986; c=relaxed/simple;
	bh=Ej1GyMPS+e4OcEOGCSzmxQWHHvZFo/cDoRcHliGH1/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IinIISrNQgxdaYHeT7JUBC4yZNwitujbirabPvBkDCm/moOi1kz0Wb6mw49SyqXdcwavpPs4b+so1DOnMPg3RIj+86D1N33mzddP6FKcDcJHwC7jVhIdp+T2idXkCtCi+Q1XehnWruzSJ07jRmULgOj7rKa5sHCmMUoFXvGGXSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UkLZRbX7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UkLZRbX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A841F000E9;
	Tue, 21 Jul 2026 20:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665984;
	bh=jycOxTBhOpVt7/V+yKyguBX+RP3WRUoufpQB1GgMlnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UkLZRbX7Z+25DiP74ea3Kjt3/0PTGRzQrKtUiQlMFDkG1BKqjicAHNOeiYPJ4v7uJ
	 oI5Haj5B6joXV4Nhb4OVGYKNOumHtEocdJdDa60+KJO6E0lftUybsIYsbbbmf7ktpX
	 QC/MtAy7Ng+gTM+Mb0Ux49vPM+9fhVIPeu24aqg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0504/1266] wifi: wcn36xx: fix OOB read from firmware count in PRINT_REG_INFO indication
Date: Tue, 21 Jul 2026 17:15:41 +0200
Message-ID: <20260721152453.124685002@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index daab434b19d581..32a0e41c41ca9a 100644
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



