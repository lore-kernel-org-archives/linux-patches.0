Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E11F149DFA;
	Tue, 17 Dec 2024 17:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455593; cv=none; b=gm7/I+o5luvqdiPlIEa+Pn/DjvBVf+Hm0187vu0XK7mSJo2mfnGJBazDefSxp+KpYwglcovkvTCpWfUIhJ/CemtrAHI2z1iTWfXX5MmZrH3X9wU04k2btSdMwhuHV0XAEBk4byAclL87l+H5NF5IMZnGiVm0xtXAJ06QdE3enyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455593; c=relaxed/simple;
	bh=qovqpYFW+EqHjN6M2jD6UFaAC4TPw5L+gzDLReDQylM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r6Qu+R9ORYH7SGLbvckFv8NQCW8+Bpu3AooxMLqZztPI6ZLOqzku0Cp8Mp/8J2VBmE+8Qi8VP3nToAo1dnwEYOFhH9dktW4GmxG+3BYBz/+3+SKXBiFHqUoj3fZ8UcJgXQc+B9Rdc9u+TOAkxxasrvhEFaUMBEjs/CiSlz8cbu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fKFAlD9i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fKFAlD9i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC21FC4CED3;
	Tue, 17 Dec 2024 17:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455593;
	bh=qovqpYFW+EqHjN6M2jD6UFaAC4TPw5L+gzDLReDQylM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fKFAlD9ifjjsPpGkCMJTvElxm91CNNzrrTPLqCv9p1m8zT7hyzgiDOfe3WxooV4v3
	 Wa8acWpM1Htur0Us8YpTCtX7E/+y9bnSqMuJd6EnUBVucPQzfaBqbxZxD/4PjabUs+
	 50IqCYWXxRd9MXOtBoiXv6CO9Ej72I/06Vxi3E6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitalii Mordan <mordan@ispras.ru>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.15 08/51] usb: ehci-hcd: fix call balance of clocks handling routines
Date: Tue, 17 Dec 2024 18:07:01 +0100
Message-ID: <20241217170520.651980437@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.301972474@linuxfoundation.org>
References: <20241217170520.301972474@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitalii Mordan <mordan@ispras.ru>

commit 97264eaaba0122a5b7e8ddd7bf4ff3ac57c2b170 upstream.

If the clocks priv->iclk and priv->fclk were not enabled in ehci_hcd_sh_probe,
they should not be disabled in any path.

Conversely, if they was enabled in ehci_hcd_sh_probe, they must be disabled
in all error paths to ensure proper cleanup.

Found by Linux Verification Center (linuxtesting.org) with Klever.

Fixes: 63c845522263 ("usb: ehci-hcd: Add support for SuperH EHCI.")
Cc: stable@vger.kernel.org # ff30bd6a6618: sh: clk: Fix clk_enable() to return 0 on NULL clk
Signed-off-by: Vitalii Mordan <mordan@ispras.ru>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20241121114700.2100520-1-mordan@ispras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ehci-sh.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/ehci-sh.c
+++ b/drivers/usb/host/ehci-sh.c
@@ -120,8 +120,12 @@ static int ehci_hcd_sh_probe(struct plat
 	if (IS_ERR(priv->iclk))
 		priv->iclk = NULL;
 
-	clk_enable(priv->fclk);
-	clk_enable(priv->iclk);
+	ret = clk_enable(priv->fclk);
+	if (ret)
+		goto fail_request_resource;
+	ret = clk_enable(priv->iclk);
+	if (ret)
+		goto fail_iclk;
 
 	ret = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (ret != 0) {
@@ -137,6 +141,7 @@ static int ehci_hcd_sh_probe(struct plat
 
 fail_add_hcd:
 	clk_disable(priv->iclk);
+fail_iclk:
 	clk_disable(priv->fclk);
 
 fail_request_resource:


