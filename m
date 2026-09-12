Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B90147277D;
	Sat, 12 Sep 2026 16:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228916; cv=none; b=e7zD38v988F7Rl1NHHIlZJSc38sqQ5W6Z18Iq9h5sRnozW7JkDooVvoOJyLYWa14M9HrrtnvMgfKNRfHOJW2zbb1fDf1FWCJa8S+pUQ4yJ5Wc2U+pPmPfcSvTNiwkk/ltQ8rWZc4kKnZlrMXZXdUTw+PSk68cgoWN5sqlK8LISQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228916; c=relaxed/simple;
	bh=jVoc3wQM0Cv/0emW495RlquOp0/PijpCERabQFCxjv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4KS+c9gYMB8x98PvbHn017ksqYwLN+uZa8mtM1YreD/8OpuyKd05gdU+uTyz4KtNgE+k0CJ4SLlbcbFVuszUuotv+YtIn3yXrqeG3xBRfhHCeEvuNsFjRjkjr52/XjwlrWOgcIYdiwM8ig96yN3HmPlE74gEXTHi0Rch9TKgdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k6YElJRK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k6YElJRK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511261F000FF;
	Sat, 12 Sep 2026 16:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228915;
	bh=tDDGdLWdmj3I/0Dtqf3hV5pcOZ/rB926OBFl6yqqk/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k6YElJRKcv6WjHwCJckOd2gtAQ+OkSy4cX2pV1HWy1JdrKUYzh7Io6bcT5Y2hwtmk
	 2Mef5miv8HFKD1Tth43kTNSAbflinmUqKyQZ2LgYTxKYHDV+rrq7LCHXpwn3c24Gml
	 Mlo1/CQiqKtSfi9xjmO5/Qb617RuNvsvQ8W9viuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Min zhang <zhangmin2026@yeah.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0483/1191] clk: hisilicon: reset: Use devm_kzalloc to initialize hisi_reset_controller
Date: Sat, 12 Sep 2026 08:53:31 +0200
Message-ID: <20260912065559.080245935@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Min zhang <zhangmin2026@yeah.net>

[ Upstream commit a8036f4591542de4b38ec81d3e2ba47bc0b2652b ]

Using devm_kmalloc() does not zero-initialize the allocated structure.
Uninitialized members in struct hisi_reset_controller may contain garbage
data, which can cause reset_controller_register() to fail unexpectedly.

Replace devm_kmalloc() with devm_kzalloc() to ensure all structure fields
are properly zero-initialized.

Fixes: 97b7129cd2afb ("reset: hisilicon: change the definition of hisi_reset_init")
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Min zhang <zhangmin2026@yeah.net>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/hisilicon/reset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/hisilicon/reset.c b/drivers/clk/hisilicon/reset.c
index 93cee17db8b16..c3b7daac93132 100644
--- a/drivers/clk/hisilicon/reset.c
+++ b/drivers/clk/hisilicon/reset.c
@@ -91,7 +91,7 @@ struct hisi_reset_controller *hisi_reset_init(struct platform_device *pdev)
 {
 	struct hisi_reset_controller *rstc;
 
-	rstc = devm_kmalloc(&pdev->dev, sizeof(*rstc), GFP_KERNEL);
+	rstc = devm_kzalloc(&pdev->dev, sizeof(*rstc), GFP_KERNEL);
 	if (!rstc)
 		return NULL;
 
-- 
2.53.0



