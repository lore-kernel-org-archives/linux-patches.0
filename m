Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782403DC857;
	Mon, 17 Aug 2026 14:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975766; cv=none; b=W85rub8/Myo5QmGzbLfISubeddU1dA9kzQ0RQ3FGJZuwlmN5sW2IUkvkPoCAvKm5DyxloedUsi1u30AelE/mnMxK0VCaJ+aTsVvtJGwqNWQh/Cxh/Y6NXArusetYkA37gs0bKOzzGod0TwBT9jjFEyuppVCWHRQgd5iicwD1IBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975766; c=relaxed/simple;
	bh=xOc2Xx9uM1HQ4M3iVxMN390a9MAbxauZtqFq1a98ris=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/h+ZDemFXv1Ii0ciBEqUJ2vMsHi+SgEy0mFLdD+XAdSCUaD88aLorXa9ZMhAJ1igAE9iB/3PEE1eQ+yyLzV4gsjahCQl/9mM141++9jRFXkq8s/4FVyMQAtPRaiSJI9LF1k5d+F8dqHtqG6tN9Le1WwMXnl6rO0YFVYwt+r95c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rivLoPru; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rivLoPru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF0551F000E9;
	Mon, 17 Aug 2026 14:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975765;
	bh=17CglJfLNUOPCLgTU9VpAhcTrqBue3Eb+67kHDhpo/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rivLoPruvKXEInZqbq+c7XG5BNBgbope1fZjILlPWvwu6LfgHXJ+/z/7WDCgVWCjm
	 ajnbL1U/QCT0gcfOta/hmbqZZyvRVpJSpnyeFPYnhuWiiwM4zA8SOBBbceA2ks/RP3
	 DKfeaH3cxUSKws+l/8m+IfV7nvP1VZtNBEBc0IDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 140/389] media: vimc: fix reference leak on failed device registration
Date: Mon, 17 Aug 2026 15:29:39 +0200
Message-ID: <20260817132544.617991538@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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
@@ -350,6 +350,7 @@ static int __init vimc_init(void)
 	if (ret) {
 		dev_err(&vimc_pdev.dev,
 			"platform device registration failed (err=%d)\n", ret);
+		platform_device_put(&vimc_pdev);
 		return ret;
 	}
 


