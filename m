Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C60E32B110;
	Thu, 20 Aug 2026 15:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238314; cv=none; b=uIMKNA0VpjzyQpFgZN21CdSYIleDzDXSQjp37kAatF7Yb9nx80brBXKqiOagcDcyllQcEm1VAjLJAArtzcLcdD9mgJABTzET4tvMqKkM49X5hOtisyilr11K9Wx9cGrfc5xa2A6mcWCNMibsFNMvgwuuFbzZaxObqIhHiR5Bxag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238314; c=relaxed/simple;
	bh=spBiFWmDen1ReC4psepYbKJ2Oen4G3RKg5efWXsSB1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XuEEcU0gPD1FAZZ0jzyM5S7GjTh08rXb64Kq5znni8u4Yqr/U/h/matAkUQfMToaOehdmhwI4cfQ1cX4U3p8qoEB8M2e+rGmtuZ+LIYs6QBlK+ZzUtZEqcuORZeDofq+5Nzez8xEOk9Aqj4M0h6K9vs3B8dsZQp2oF89wNAHrao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pd4Q+LuW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pd4Q+LuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0E41F000E9;
	Thu, 20 Aug 2026 15:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238313;
	bh=iF6K9pIBKBwlxuARyN3Emq4wEJjLyR/WsQhkgG3ZHSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pd4Q+LuWTi6HOzB5Ea9Rkcex34DU48Eh73eLXdd9SuMOZUELG3/6ffRGe8HOsY5PJ
	 GyjJ5SD5L8eTsVlTw26qR2XiD8NHYVh/9alJe4jAdJJ7ndqfnF08cNgfywnQEejQ5R
	 xJtbL1ZbQZTUHQEIq63zIV51Ql+02Tgj0FwONsxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Praveen Talari <praveen.talari@oss.qualcomm.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.1 065/228] pmdomain: arm: Fix -EINVAL from scmi_pd_set_perf_state() on state 0
Date: Thu, 20 Aug 2026 16:53:27 +0200
Message-ID: <20260820145246.438870786@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Praveen Talari <praveen.talari@oss.qualcomm.com>

commit 3314c90a2eda3df7da4ab6f4388e667b2758de7f upstream.

Currently, scmi_pd_set_perf_state() treats a performance state of 0 as
invalid and returns -EINVAL. As a result, devices attached to SCMI
performance domains can report failures when relinquishing their
performance vote.

The OPP framework use performance state 0 to indicate that no performance
vote is required. For example, dev_pm_opp_set_rate(dev, 0) is commonly
used (by firmware or linux)  when a device is runtime suspended.

A zero performance state does not require any SCMI performance request
to be sent. Treat it as a no-op and return success instead of reporting
an error.

Signed-off-by: Praveen Talari <praveen.talari@oss.qualcomm.com>
Fixes: 2af23ceb8624 ("pmdomain: arm: Add the SCMI performance domain")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/arm/scmi_perf_domain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pmdomain/arm/scmi_perf_domain.c
+++ b/drivers/pmdomain/arm/scmi_perf_domain.c
@@ -33,7 +33,7 @@ scmi_pd_set_perf_state(struct generic_pm
 		return 0;
 
 	if (!state)
-		return -EINVAL;
+		return 0;
 
 	ret = pd->perf_ops->level_set(pd->ph, pd->domain_id, state, false);
 	if (ret)


