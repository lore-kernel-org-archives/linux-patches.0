Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196DB1D5141;
	Wed, 25 Feb 2026 01:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983480; cv=none; b=HnLfKawFAeNxtXU2CrHodyRAHcA/+6S1UKBjzyqzmpEU5aN+vjsk1YD1CbqSbtbxeiDmmBH1az+H4zJds+T7KezU3oI7yqMepRXx63Aq0nlIpVE5LINyaVn2BvG8irPr1xV+aM2yviCpJyJ9ROVxifTguJq5LwOjZkgkux46ukk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983480; c=relaxed/simple;
	bh=0AMItDpuyvpODM0mtGdLyzbzSK/+Lu11ObU9aicywSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gChtQllnXogLPsKmaJrPWpdxC/QVFXWgNiY9FMeCaa59R1KJ7oMhJkqfWR1ywLlFJdP6YP2pFvjjWWRpfroc+apDpSVKLbqCdjndk+AOc95VmzueMMPNiRuHHwI3eGOprzjpGCTuhUAMQ75ZI3SZsrMIcicTuciJn44u8l7Ta8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CQ7K1tSL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CQ7K1tSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0327C116D0;
	Wed, 25 Feb 2026 01:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983480;
	bh=0AMItDpuyvpODM0mtGdLyzbzSK/+Lu11ObU9aicywSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CQ7K1tSLy+iKBoxKUHYCMcuScGob9nI2l9oPSpTkGlZykFMGHm3FJQ9aEpeQbsvRd
	 VHZqq2oJLAcY6uTca+fT5kxt+OJIjzmvxLvWhHSWesNHtDiUCDN7Bqq8oC3hSc04WE
	 HiSUzK8lDw3bPiAOVBLdhk7Xo5zFXsKVNjOj+4Ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 593/781] usb: bdc: fix sleep during atomic
Date: Tue, 24 Feb 2026 17:21:42 -0800
Message-ID: <20260225012414.342166899@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Chen <justin.chen@broadcom.com>

[ Upstream commit f1195ca3b4bbd001d3f1264dce91f83dec7777f5 ]

bdc_run() can be ran during atomic context leading to a sleep during
atomic warning. Fix this by replacing read_poll_timeout() with
read_poll_timeout_atomic().

Fixes: 75ae051efc9b ("usb: gadget: bdc: use readl_poll_timeout() to simplify code")
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260120200754.2488765-1-justin.chen@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/bdc/bdc_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/udc/bdc/bdc_core.c b/drivers/usb/gadget/udc/bdc/bdc_core.c
index 5c3d8b64c0e76..f47aac078f6be 100644
--- a/drivers/usb/gadget/udc/bdc/bdc_core.c
+++ b/drivers/usb/gadget/udc/bdc/bdc_core.c
@@ -35,8 +35,8 @@ static int poll_oip(struct bdc *bdc, u32 usec)
 	u32 status;
 	int ret;
 
-	ret = readl_poll_timeout(bdc->regs + BDC_BDCSC, status,
-				 (BDC_CSTS(status) != BDC_OIP), 10, usec);
+	ret = readl_poll_timeout_atomic(bdc->regs + BDC_BDCSC, status,
+					(BDC_CSTS(status) != BDC_OIP), 10, usec);
 	if (ret)
 		dev_err(bdc->dev, "operation timedout BDCSC: 0x%08x\n", status);
 	else
-- 
2.51.0



