Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DD314B957;
	Tue,  7 May 2024 21:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715116093; cv=none; b=GNxTxoBYAxQyq2CgEIxVv1dPCD6T397NUWzF7BrLbZPeA7i711Ubh7Au+EPVgv3TW6y8zUwj0KzTml4o8jY6R9LJYQ8LUQuXeYrJq95EkVBH1zn1DSgMU3ucfQY+nmE1b0vEcUzPVXap2WDOI6YwqUV8AhtRNAfR0Ijbv9O9/Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715116093; c=relaxed/simple;
	bh=7IIOVK26N76rgSrHKjrQT7SwQ7fJjZNCfd/ugJsoLdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gz2o7DKQC61vp7Ny1eY/jkQS1gaD59hXKrB5II03GCNgS8Ofau+wiyFr2c6jym3nLaiVG3xlycqpT+BC4qdhQWwZgx8PcHsL634RElErpKAUy0HEOD9RUOlo5jz3sN6Hfwl2yRRS5nYEPlqOsp0TQwVa6Jv7u4LakqKoOtYD/aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BSSswj7H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BSSswj7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB02C4AF67;
	Tue,  7 May 2024 21:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715116093;
	bh=7IIOVK26N76rgSrHKjrQT7SwQ7fJjZNCfd/ugJsoLdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BSSswj7HRYYcYd9Hbir/XBDSOGWszF5G1Moi09rkR32vJlx4ytRwt40ZDDFjO0gRj
	 ap9k/Zzm52/sQgCKgdnnZ+z0uHZHMLIlnDuFIQYM1XzacRbM1pqNAaPjNJhIOR8y6c
	 X6cYN3eIVMa/rJukq4xoI1ag5TGgPlEQRR7vNsG/ogTQtUw57P5H1NQs1WT2w/aRsF
	 BK6G/q5jEeRXftLvCcDg+G4RVST07Ni9TWcl8EHBHBH7Vj4metpDQrCA41yGaAbiy/
	 gB5Mf4R3cHdnB5jykIdINnU0cFCV2aNUzCbPEdvtOBNr+E3m1XxyyYzFFDZtOFBLcv
	 zprDrG5WhkSkA==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Vamshi Gajjela <vamshigajjela@google.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH 04/12] spmi: hisi-spmi-controller: Do not override device identifier
Date: Tue,  7 May 2024 14:07:41 -0700
Message-ID: <20240507210809.3479953-5-sboyd@kernel.org>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
In-Reply-To: <20240507210809.3479953-1-sboyd@kernel.org>
References: <20240507210809.3479953-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Vamshi Gajjela <vamshigajjela@google.com>

'nr' member of struct spmi_controller, which serves as an identifier
for the controller/bus. This value is a dynamic ID assigned in
spmi_controller_alloc, and overriding it from the driver results in an
ida_free error "ida_free called for id=xx which is not allocated".

Signed-off-by: Vamshi Gajjela <vamshigajjela@google.com>
Fixes: 70f59c90c819 ("staging: spmi: add Hikey 970 SPMI controller driver")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240228185116.1269-1-vamshigajjela@google.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/spmi/hisi-spmi-controller.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/spmi/hisi-spmi-controller.c b/drivers/spmi/hisi-spmi-controller.c
index 674a350cc676..fa068b34b040 100644
--- a/drivers/spmi/hisi-spmi-controller.c
+++ b/drivers/spmi/hisi-spmi-controller.c
@@ -300,7 +300,6 @@ static int spmi_controller_probe(struct platform_device *pdev)
 
 	spin_lock_init(&spmi_controller->lock);
 
-	ctrl->nr = spmi_controller->channel;
 	ctrl->dev.parent = pdev->dev.parent;
 	ctrl->dev.of_node = of_node_get(pdev->dev.of_node);
 
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

