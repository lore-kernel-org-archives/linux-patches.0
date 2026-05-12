Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C5B3C0A1B;
	Tue, 12 May 2026 17:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608520; cv=none; b=e5NnsFzZTZilFE1JcAJUCq7C+8bJrTUB95Yn2NUJjEzWbJHdQoxzFsIwNSHKRFvumxRLjYDMK+hnKAtuLrvZz6Jgh6dVggSSz/wIgwEcmAP3honZGUmAVysURE2jFbRsFYYWCfy7zAI7jxzGdQXmnXRYqSz6xlfrjX6y3+J1UL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608520; c=relaxed/simple;
	bh=6L0jKiE++NKi99nZV6OD5PVdOuWDSZ+PPgzfrZtKc4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jS8AU+nrun9RCQstEfut9a2hOKRs3YVgoAQeATOXGcvvPnaC3Ifc0Qnn848BOrV33Pu52Q4Cbvd5c3IteS6Jkm6ZCgLMJpFlOWsj8tFnrpGx00AgQdTIZMFUh89UmKLJdffvHgST2SMnhuZSpkgDAxq4xRXaWN7ytP74iQWdX/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kZUOxWrW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kZUOxWrW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09CF0C2BCB0;
	Tue, 12 May 2026 17:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608520;
	bh=6L0jKiE++NKi99nZV6OD5PVdOuWDSZ+PPgzfrZtKc4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kZUOxWrWKSSf5aaBIRLm5KERZ61qmGFYTMzwwAsd970Zv4GdQpw1ZFWzygfZM2RUq
	 DDJbuBPH9ZZOLsKJfAlvFI2j86MzxMBaZW782lBFFQB4DFSIuPCXPtUTDdZ0NOqHhl
	 gdtHFkyOnbnpkRG2mH3Y5QlujBMJ3LoCt69+cqJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Johan Hovold <johan@kernel.org>,
	Brian Masney <bmasney@redhat.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.18 110/270] clk: rk808: fix OF node reference imbalance
Date: Tue, 12 May 2026 19:38:31 +0200
Message-ID: <20260512173940.773493521@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit de019f203b0d472c98ead4081ad4f05d92c9b826 upstream.

The driver reuses the OF node of the parent multi-function device but
fails to take another reference to balance the one dropped by the
platform bus code when unbinding the MFD and deregistering the child
devices.

Fix this by using the intended helper for reusing OF nodes.

Fixes: 2dc51ca822e4 ("clk: RK808: Reduce 'struct rk808' usage")
Cc: stable@vger.kernel.org	# 6.5
Cc: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/clk-rk808.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/clk-rk808.c
+++ b/drivers/clk/clk-rk808.c
@@ -153,7 +153,7 @@ static int rk808_clkout_probe(struct pla
 	struct rk808_clkout *rk808_clkout;
 	int ret;
 
-	dev->of_node = pdev->dev.parent->of_node;
+	device_set_of_node_from_dev(dev, dev->parent);
 
 	rk808_clkout = devm_kzalloc(dev,
 				    sizeof(*rk808_clkout), GFP_KERNEL);


