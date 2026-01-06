Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C713E33C1BF;
	Tue,  6 Jan 2026 17:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719852; cv=none; b=twqCHrA39kM+9bNjzcPhdiX9UfCc+y0zi+hoUZ8DFbJlPtcYtwR6S2rklnUHu+nHXaBW4KftuwXdbb6AXEh7l2UUUqaXRVjp2p+PAR//YqltDNjR7F3jYGvmNiWAQESNL+8Atmt+HgIIFVeT7cEIw3rbGCOQs8O5KHroEeuX+9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719852; c=relaxed/simple;
	bh=V0TXU0xCUcZ1M4y3x+WMZjcRqjSsGSfCBNUk84+jASI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=krl14hVyRFUZGpjZmoA+XHx5T0fAsGs2iToG5tHtgDehpy2LFNo3FNBZdBPMxD80dvALUwI7m+hrA2MiWnjP4VoIk/ZgFvfqxiEUma8mK9p7rwICk/Yd6D3WfgffTGLQYQlMIQhE4NQCKG2RGlZgsYcFwPsVzVUTCq7ejnB9MTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WFVm7p6d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WFVm7p6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939B3C116C6;
	Tue,  6 Jan 2026 17:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719852;
	bh=V0TXU0xCUcZ1M4y3x+WMZjcRqjSsGSfCBNUk84+jASI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WFVm7p6d4u46iLG8ago1S214abMxFYrWoZJ1G2ETAo4L0wNAI5fcKBKFzUR1HhJN/
	 SfUqOZkIdUDaGr7o7Iw5FxNQXGLb9QmWYVEaAg49F/nXBs1+DNAAaTXWfqIGn0jwLr
	 8S3T6sRB9gIrpRYDtbz/zLy7V2HjMyagbGJDcI+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 059/567] nfc: pn533: Fix error code in pn533_acr122_poweron_rdr()
Date: Tue,  6 Jan 2026 17:57:21 +0100
Message-ID: <20260106170453.520671953@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 885bebac9909994050bbbeed0829c727e42bd1b7 ]

Set the error code if "transferred != sizeof(cmd)" instead of
returning success.

Fixes: dbafc28955fa ("NFC: pn533: don't send USB data off of the stack")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/aTfIJ9tZPmeUF4W1@stanley.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/pn533/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
index ffd7367ce1194..018a80674f06e 100644
--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -406,7 +406,7 @@ static int pn533_acr122_poweron_rdr(struct pn533_usb_phy *phy)
 	if (rc || (transferred != sizeof(cmd))) {
 		nfc_err(&phy->udev->dev,
 			"Reader power on cmd error %d\n", rc);
-		return rc;
+		return rc ?: -EINVAL;
 	}
 
 	rc =  usb_submit_urb(phy->in_urb, GFP_KERNEL);
-- 
2.51.0



