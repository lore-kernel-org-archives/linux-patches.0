Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0921DE3AE;
	Tue,  8 Oct 2024 12:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390581; cv=none; b=l7DUR2GHirBUiGhUVxlOAerT2Cuo69R7cq7w6e6IDZrqays8SGuivnVGRsIGJYlT4O4N/EOPZtSpLhrryVxcXO36OgMShFSL+eINCinUh9TOTQkQmyDJGzu/7RCTROnWxew9us02yeRbLKIpUlelOeWcvN5/3JhKgWNk1ZL6Gcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390581; c=relaxed/simple;
	bh=XGh4kDSfvedlWOLqo8PVtiXhAIXQ6fU5tMLKMvZXQKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+VNYa0K/jj/MuCoHghiKBeIgQsswsfcMC8p+f2WRfibVscv3U6Dsx5kFr53WeW9CX7k01fTNLFY9bx+YouqJz3GtgNnOyolICCn5vWessv5ft5TWzD24XCPXY7z6JzVaLZ5txqvvsBMz1XDDJxF/OUkBmmtwonc/tvYUYfRiwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TY+zwMHN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TY+zwMHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C5CC4CECD;
	Tue,  8 Oct 2024 12:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390581;
	bh=XGh4kDSfvedlWOLqo8PVtiXhAIXQ6fU5tMLKMvZXQKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TY+zwMHN0ULwfbS4XBuQcQuRrh7WAx6zHfS57R8M1oThezsoHcuDTAlJpNirxWoTC
	 AoumbGVHMaQFTnDnnW957REgUmeyCj9FW4sQTc4yfOIZBCLAebUBVaCtovtyDx/muN
	 y61t4A/hJJhXOzDshRxvEXCXxkSMCnZ2b4px1ttA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.10 297/482] i2c: xiic: Fix pm_runtime_set_suspended() with runtime pm enabled
Date: Tue,  8 Oct 2024 14:06:00 +0200
Message-ID: <20241008115659.970174825@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit 0c8d604dea437b69a861479b413d629bc9b3da70 upstream.

It is not valid to call pm_runtime_set_suspended() for devices
with runtime PM enabled because it returns -EAGAIN if it is enabled
already and working. So, call pm_runtime_disable() before to fix it.

Fixes: 36ecbcab84d0 ("i2c: xiic: Implement power management")
Cc: <stable@vger.kernel.org> # v4.6+
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-xiic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -1337,8 +1337,8 @@ static int xiic_i2c_probe(struct platfor
 	return 0;
 
 err_pm_disable:
-	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
 
 	return ret;
 }


