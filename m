Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3742D3D1CB9;
	Thu, 15 Jan 2026 17:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499303; cv=none; b=FSfq1c3lB1pf8aqHhU5VcnI4SDw96boQb3n2ZWmYKPA+6E3Z5v0OsP75pxaQ8+ibTi0OoH0z0gk2c2Oa3Qid5QF1b+/2fAYFLzoxj32IWCJdwKKxL/Wl19zA3j4TiunT+ptUOBBsy7PlL0uVAwzSoi/6/6s0egA0znCVMa9caqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499303; c=relaxed/simple;
	bh=A6cYIgB0S724l5YtpaC0KRbImLEFNTP1BZ2jjOXQnB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qlroSeANHgk/BOZxaa9AH8fm+4/z3zax9jl6eI+rylY53mdnFxt5jYl3O38uWA4pyaVxBJWtjX7fe8pgHGKds4teqsWlY86YxiwA8bIH2Ir5CgCFQbpBGGmE4JksuHdvIInaXKdFu6HQHvq7GcsC8WbTF8lfehJAvT+Xe/WcwVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=To7eY4a2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="To7eY4a2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7192FC2BC86;
	Thu, 15 Jan 2026 17:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499302;
	bh=A6cYIgB0S724l5YtpaC0KRbImLEFNTP1BZ2jjOXQnB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=To7eY4a22VZSEvPZ9YMtpga0Pn7GN7ZOtYQqnDDMp9Od2N+LhLIFMeE/6XgrayUiU
	 76/zBJ9G2x2zMleC2E4YNVGivI/cmX1Ua3NQXzY5TuNvPWxsoODtfc+YeJfohtoWEA
	 P0gu4mQeXffKnFw2x06jDitESNY+eSq6/l4b8gnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 179/451] nfc: pn533: Fix error code in pn533_acr122_poweron_rdr()
Date: Thu, 15 Jan 2026 17:46:20 +0100
Message-ID: <20260115164237.380932519@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 68eb1253f888f..77ada0a5c7396 100644
--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -411,7 +411,7 @@ static int pn533_acr122_poweron_rdr(struct pn533_usb_phy *phy)
 	if (rc || (transferred != sizeof(cmd))) {
 		nfc_err(&phy->udev->dev,
 			"Reader power on cmd error %d\n", rc);
-		return rc;
+		return rc ?: -EINVAL;
 	}
 
 	rc =  usb_submit_urb(phy->in_urb, GFP_KERNEL);
-- 
2.51.0



