Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4536A2DFF0A;
	Tue, 17 Jun 2025 16:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177290; cv=none; b=jF0fBZkUSIjQRJbsMISH+BpfK/G92xi4XxJew+nsg8tAASCjOQmIV+DcQAi9iXAQh4kCmZKNRZ4C90P0hQy2G58KsVHNA7UzOSNpWCvn0LOSRLgcC+TOUUCwbAugaA4r0xzn8WOD0u6i6tu1GdM3paHcXa6+n+6GGFeaFLsyiSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177290; c=relaxed/simple;
	bh=/rgkL2fgGXxHAnIyGrQjjRD2mPXNCZmJRkKiZ+2VvhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcCgvlCtU6D6AB1Z+4AxyG5ErNRtJF6RKeRjip0vr/NSEAqnv5p3sTeVpbTzAgeJ9+flscS0hW12DYIKjgPFehzjh5qCA3Jz7ChtJR4kSdSaI8Nl6nBQ6bTmXW9AwRTW3m6fDdqUircXoHZ8HC9Zkxi16IUy3dD0uTRFs9yT92k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DHQlILRM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DHQlILRM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C282BC4CEE3;
	Tue, 17 Jun 2025 16:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177290;
	bh=/rgkL2fgGXxHAnIyGrQjjRD2mPXNCZmJRkKiZ+2VvhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DHQlILRMpBgQr0i1rOKYbirWBNhzN6+2skS38myTVmL/QZF/2tZC4gW7viboll23F
	 eVj2aJ71JlrMQLILDQmJpec5GGPRo8M0+TXMxZKbalh3OYaPx/OiNqWhd0EpmK8WX4
	 Xs6+/V/smPtFHFBM2xbcvCmgxxEcmhN1Mi7MTRxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 322/512] serial: Fix potential null-ptr-deref in mlb_usio_probe()
Date: Tue, 17 Jun 2025 17:24:48 +0200
Message-ID: <20250617152432.653814696@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit 86bcae88c9209e334b2f8c252f4cc66beb261886 ]

devm_ioremap() can return NULL on error. Currently, mlb_usio_probe()
does not check for this case, which could result in a NULL pointer
dereference.

Add NULL check after devm_ioremap() to prevent this issue.

Fixes: ba44dc043004 ("serial: Add Milbeaut serial control")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Link: https://lore.kernel.org/r/20250403070339.64990-1-bsdhenrymartin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/milbeaut_usio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/milbeaut_usio.c b/drivers/tty/serial/milbeaut_usio.c
index fb082ee73d5b2..9b54f017f2e8a 100644
--- a/drivers/tty/serial/milbeaut_usio.c
+++ b/drivers/tty/serial/milbeaut_usio.c
@@ -523,7 +523,10 @@ static int mlb_usio_probe(struct platform_device *pdev)
 	}
 	port->membase = devm_ioremap(&pdev->dev, res->start,
 				resource_size(res));
-
+	if (!port->membase) {
+		ret = -ENOMEM;
+		goto failed;
+	}
 	ret = platform_get_irq_byname(pdev, "rx");
 	mlb_usio_irq[index][RX] = ret;
 
-- 
2.39.5



