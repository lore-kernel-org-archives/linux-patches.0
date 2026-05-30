Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6FE320CAD;
	Sat, 30 May 2026 17:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163367; cv=none; b=pL+xYv/ZqgmPbDK72WOFSoHJMoophc+eyAIgOHHGMM6E2iixi2llum7klzn6SJWat/gf8XqyNDYHcarLFE0UAcRFv0UqmOzw+oHmMrPdXBSijQ8qvtNxU0nVAGViRakawfAUQZOLbblezQc7tNiX2p1U9bcqgfI2wZdbWyGjgJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163367; c=relaxed/simple;
	bh=ziDOV7zbHUAJk67WpMd0aKwpZHyd3xO85Kd4zawaSvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O4QAF6dCxJ+9iGBAYOm+tKkUn3UyVn2hS0Tn4a5McOPtZcd5kqC9zvq1YUG4Q2mqCZDCMUNlhYIjUU8kyoO8KrJUFNKCNjGqHKza99G9f/7Q1RcEjQer9zz+j43/tqjhatl5Sla4AEzY8Y2GUlBfrcD3BI6wOYLJBkk85LIJEEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ORo7BsVM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ORo7BsVM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A331F0089D;
	Sat, 30 May 2026 17:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163366;
	bh=rUZqIqQVQbv2JSCkAE5+PL5avzLzCG5j0gKOZuWUAmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ORo7BsVMvT95VnPcJLIuUye/806Q14fDJRJIB9tUaq3r687k7YKZlogbQFSiItp5z
	 gG76xtaGPyPEixhQU0TsEKgkLD98est7wWiFDpUOc2qyFG253ReQapCTdLmSUZZBDy
	 undM1ZkzRxqN5Z90U+osvHH5S9zAxibKzEYJ4fBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
	Johan Hovold <johan@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.15 229/776] rtc: ntxec: fix OF node reference imbalance
Date: Sat, 30 May 2026 17:59:03 +0200
Message-ID: <20260530160246.444999608@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 30c4d2f26bb3538c328035cea2e6265c8320539e upstream.

The driver reuses the OF node of the parent multi-function device but
fails to take another reference to balance the one dropped by the
platform bus code when unbinding the MFD and deregistering the child
devices.

Fix this by using the intended helper for reusing OF nodes.

Fixes: 435af89786c6 ("rtc: New driver for RTC in Netronix embedded controller")
Cc: stable@vger.kernel.org	# 5.13
Cc: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260407122717.2676774-1-johan@kernel.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-ntxec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/rtc-ntxec.c
+++ b/drivers/rtc/rtc-ntxec.c
@@ -110,7 +110,7 @@ static int ntxec_rtc_probe(struct platfo
 	struct rtc_device *dev;
 	struct ntxec_rtc *rtc;
 
-	pdev->dev.of_node = pdev->dev.parent->of_node;
+	device_set_of_node_from_dev(&pdev->dev, pdev->dev.parent);
 
 	rtc = devm_kzalloc(&pdev->dev, sizeof(*rtc), GFP_KERNEL);
 	if (!rtc)


