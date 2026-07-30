Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC3A38BF6A;
	Thu, 30 Jul 2026 16:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427711; cv=none; b=myyJJ42OMDbIv7pLQdp6CzxPOjC/YhMLchLedk4CsJrdClnC9lK+6Rd9HudGpXHTWWPsrtDEDjjaHeeBndMSzkghDgCyZlQE1f+3c13dmaTUjisPW7/Kv4n4ruW5SENib8ExVGBbHhpwFea5TMHe93VrvzfNLUqU55bGbcDfC5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427711; c=relaxed/simple;
	bh=WnCG2hw7bW5iTmDNVvEbOhFpMto8peY8I3LhrzmkYP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AysveuBPK7qU2xnzQNILl2tB5lmVbL42ECv5UHfLLVIwBZDhSVO/NmBBMWjB5birJY+7e7b4izTHUoDx8cLj/dNOjB9Ofp3f0wYJBTGe4B5+MQhwIh5uwBVU6CGwrlwRQmSQcHQcH10AwvE0ZXvn5MCoLVboXWl93N2xm0zAbyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SP1VVMBN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SP1VVMBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D8E1F000E9;
	Thu, 30 Jul 2026 16:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427710;
	bh=/wXeVnxWgQmz+a2J/tn1AibNufrFUMEBS4qbs9Vt3KM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SP1VVMBNWMbhxjqwkyCs/fSe7ZnqaOWT1R0P9b9xO8BB9hCOdC1cNP0jK9xW0whzV
	 JwwQMLLsas/j9FCFFpNXp7IYx0yeLxmZvwD7TXoFkUXw6l50Ji0SiFJtsAqhWCCZNe
	 Ghkhp5EWj4/p5JyGMI36lFhcGp1N5/yovDPd3LoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 265/484] media: vimc: fix reference leak on failed device registration
Date: Thu, 30 Jul 2026 16:12:42 +0200
Message-ID: <20260730141429.250776908@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 33e2b833c66b890a0d71c4fa82d4c97143f7f75f upstream.

When platform_device_register() fails in vimc_init(), the embedded
struct device in vimc_pdev has already been initialized by
device_initialize(), but the failure path returns the error without
dropping the device reference for the current platform device:

  vimc_init()
    -> platform_device_register(&vimc_pdev)
       -> device_initialize(&vimc_pdev.dev)
       -> setup_pdev_dma_masks(&vimc_pdev)
       -> platform_device_add(&vimc_pdev)

This leads to a reference leak when platform_device_register() fails.
Fix this by calling platform_device_put() before returning the error.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fixes: 4babf057c143f ("media: vimc: allocate vimc_device dynamically")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/vimc/vimc-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/test-drivers/vimc/vimc-core.c
+++ b/drivers/media/test-drivers/vimc/vimc-core.c
@@ -424,6 +424,7 @@ static int __init vimc_init(void)
 	if (ret) {
 		dev_err(&vimc_pdev.dev,
 			"platform device registration failed (err=%d)\n", ret);
+		platform_device_put(&vimc_pdev);
 		return ret;
 	}
 


