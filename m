Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E251D8DEA;
	Tue, 15 Oct 2024 11:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993451; cv=none; b=dKyLaDEssmXrT68JPakNaLvvVbngBAJFCrfgxlyhdSYijYjSnKudYsFF6NgJoHDFfR8yygK0HzlbjTD1nILunvVlVR5sUxQXUjVloZl/M9Q3LELJpjRunaBAiIzAG5tyuPLTdvRQJRh28K6Ij9mmOcey06k737FD1RtYRrUvnMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993451; c=relaxed/simple;
	bh=phfyauhdDeXYwbtbPGWAPdx6CThHy9n+pypyvuw0mEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgAjShqWvk9L+F9vcTuSskgmvacE5URmf0GvJ4U/q9xaT793KbXVg8GOsOcH3jgk3Qp0TZk7jdnRhWJMZ1p3VLAU6CV7vEjvM9gWJO0zH1d0zEgzkV4JX63mo5w7XBVFvtUBmR8lbiBJgontpojlJUgE4HLGp7cpu4Wo/CCBZAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DB6fEGgw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DB6fEGgw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36042C4CEC6;
	Tue, 15 Oct 2024 11:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993450;
	bh=phfyauhdDeXYwbtbPGWAPdx6CThHy9n+pypyvuw0mEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DB6fEGgwHNixLJl8NiTCvOznW+ShoCieTWFA8LL4eDBDB+cf45UIp5rFdJ28eK/SD
	 nfCX3KkHZIRaplNb/mMjDhbxbfdO8AREIwGNkfQeLJ4rZY6YQeJsBbFdKgdCpc8Zys
	 stJ9SzdjWn3hxHfG+FI1Ip5ePtid7GSCxVvg3Ubk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 384/691] Bluetooth: btmrvl: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Tue, 15 Oct 2024 13:25:32 +0200
Message-ID: <20241015112455.583762855@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 7b1ab460592ca818e7b52f27cd3ec86af79220d1 ]

disable_irq() after request_irq() still has a time gap in which
interrupts can come. request_irq() with IRQF_NO_AUTOEN flag will
disable IRQ auto-enable when request IRQ.

Fixes: bb7f4f0bcee6 ("btmrvl: add platform specific wakeup interrupt support")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmrvl_sdio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btmrvl_sdio.c b/drivers/bluetooth/btmrvl_sdio.c
index 68378b42ea7fd..f71f32d4d4712 100644
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -105,7 +105,7 @@ static int btmrvl_sdio_probe_of(struct device *dev,
 		} else {
 			ret = devm_request_irq(dev, cfg->irq_bt,
 					       btmrvl_wake_irq_bt,
-					       0, "bt_wake", card);
+					       IRQF_NO_AUTOEN, "bt_wake", card);
 			if (ret) {
 				dev_err(dev,
 					"Failed to request irq_bt %d (%d)\n",
@@ -114,7 +114,6 @@ static int btmrvl_sdio_probe_of(struct device *dev,
 
 			/* Configure wakeup (enabled by default) */
 			device_init_wakeup(dev, true);
-			disable_irq(cfg->irq_bt);
 		}
 	}
 
-- 
2.43.0



