Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5D0371449
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301481; cv=none; b=ZRqFRY+7RSCRVrMO3VdtuI39A25sdOM5yBB0H7QaqqxIU3oBCMwog75UpCA39dzM6uLKtiW45vcH+lS69MSzEt8x2O9SGMFA2m9RL3qKZxGNhQt3RzM5b38KcA99lo0IPHIBvJhbTa/o6QNSSBSuTcNPyxC9U8mjMEcDLkZp8rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301481; c=relaxed/simple;
	bh=KKRH8BqmA8D24Dq5Sat9mQBwtLCDGlq0H+A/IIvoLjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBIbGyo+q2v3JCvbzb913l7+EqX7AbxSNsmT7D0TwFTdBzWVHMLni7aG9LvQJrXgVB1NAUHWFhKjr66/J6uviB0GvcpqykTs7dZCmf+VshqbRmVeBptsRsWAljxq31K+oIEh4UM7afi9egaO7LHXUaGw+ZupdPuApPlnHV3lHOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DV3+RIDZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DV3+RIDZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1B3C19423;
	Sat, 28 Feb 2026 17:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301481;
	bh=KKRH8BqmA8D24Dq5Sat9mQBwtLCDGlq0H+A/IIvoLjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DV3+RIDZEWT9K8z3ir0C/k2YdD+TTd87399ueK/BupUvY+lv2YMOKCKYdWLwq/SZn
	 p38S2GavSLyjPa5wEFJQMiraIDBgpCTYD5+1nfsoiLME5fw5/hbwo537CDm5pRXt7d
	 J1UUL9/uRmTFAprZIRivZtb+4/Xn1X2eTsYtAl3ZLAuvwaNdB6JomM/n5YquMIsRlB
	 OnxiYhwDdy7NFQR1a1/n1tjsSnS37ruBwzT5nKjo9fBM4hnOdSUfEMQ/SFvCZkxrud
	 iUta3+DJvJi+AOr7spVNycRbJrhQyo+rJThltHdtYNbpSH7lK1FOF5uowjc6z6AMLc
	 oFFPNLfjAUCFw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jisheng Zhang <jszhang@kernel.org>,
	stable <stable@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 666/752] usb: dwc2: fix resume failure if dr_mode is host
Date: Sat, 28 Feb 2026 12:46:17 -0500
Message-ID: <20260228174750.1542406-666-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit a52e4f2dff413b58c7200e89bb6540bd995e1269 ]

commit 13b1f8e25bfd1 ("usb: dwc2: Force mode optimizations") removed the
dwc2_force_mode(hsotg, true) in dwc2_force_dr_mode() if dr_mode is host.

But this brings a bug: the controller fails to resume back as host,
further debugging shows that the controller is resumed as peripheral.
The reason is dwc2_force_dr_mode() missed the host mode forcing, and
when resuming from s2ram, GINTSTS is 0 by default, dwc2_is_device_mode
in dwc2_resume() misreads this as the controller is in peripheral mode.

Fix the resume failure by adding back the dwc2_force_mode(hsotg, true).

Then an obvious question is: why this bug hasn't been observed and fixed
for about six years? There are two resons: most dwc2 platforms set the
dr_mode as otg; Some platforms don't have suspend & resume support yet.

Fixes: 13b1f8e25bfd1 ("usb: dwc2: Force mode optimizations")
Cc: stable <stable@kernel.org>
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Link: https://patch.msgid.link/20260129021534.10411-1-jszhang@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc2/core.c b/drivers/usb/dwc2/core.c
index c3d24312db0fe..f375c5185bfe2 100644
--- a/drivers/usb/dwc2/core.c
+++ b/drivers/usb/dwc2/core.c
@@ -578,6 +578,7 @@ void dwc2_force_dr_mode(struct dwc2_hsotg *hsotg)
 {
 	switch (hsotg->dr_mode) {
 	case USB_DR_MODE_HOST:
+		dwc2_force_mode(hsotg, true);
 		/*
 		 * NOTE: This is required for some rockchip soc based
 		 * platforms on their host-only dwc2.
-- 
2.51.0

