Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EB41779B1;
	Tue,  8 Oct 2024 12:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391187; cv=none; b=G2axsmRArW1c1PmZ3YK8v+eqLXFGqifFhGcNpXHICMLPsOKScmHjEjbfBGhu+J3HhEB3GAm6oNrjzKPBittvSGis971jGNC6qxyIiHKR/GkV68YNMhAnMwkk/OD/p6UVbPCSVOhMajAvS0BK+ufHy2JMVHTkksoi5RGbJF6LNWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391187; c=relaxed/simple;
	bh=65egkYft6cLZBhhwYu00+SyMiDJTGdJkEEcMZ0b1/sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fp5bNcAZNnZXnbzdz6MDg6SriPqemUHBlzyiP/eqKN3bOKXR2YOadc/wiViQNJfHxZqLjFi3KnK4M3s82G6lK3XCVRZyRReYwnGhN3YV61y4ZHzMn5j+K7WyUoIw6ap7K1IgfT2t07t3Ya5EB9QstAQkfIG+44P28tyWQ0SbzdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N24EuVuf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N24EuVuf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D431C4CEC7;
	Tue,  8 Oct 2024 12:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391186;
	bh=65egkYft6cLZBhhwYu00+SyMiDJTGdJkEEcMZ0b1/sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N24EuVufrLBiaT0Yl5S7qMVkuIwEQBtZaFHSe3ZHjlRWenGFjrHmhy/FAEu4kk/D1
	 ISEA6KnvdY3weZU8tSzMpy15kPBlaykiKVK4OxgP8H9orhZqY4HpXwjrwj+rBXGdWt
	 MUmPEBjIg4tZ3JEA0JpCmukVd0p2msHUxkKj9Z94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 033/558] Bluetooth: btmrvl: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Tue,  8 Oct 2024 14:01:03 +0200
Message-ID: <20241008115703.527355639@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 85b7f2bb42598..07cd308f7abf6 100644
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -92,7 +92,7 @@ static int btmrvl_sdio_probe_of(struct device *dev,
 		} else {
 			ret = devm_request_irq(dev, cfg->irq_bt,
 					       btmrvl_wake_irq_bt,
-					       0, "bt_wake", card);
+					       IRQF_NO_AUTOEN, "bt_wake", card);
 			if (ret) {
 				dev_err(dev,
 					"Failed to request irq_bt %d (%d)\n",
@@ -101,7 +101,6 @@ static int btmrvl_sdio_probe_of(struct device *dev,
 
 			/* Configure wakeup (enabled by default) */
 			device_init_wakeup(dev, true);
-			disable_irq(cfg->irq_bt);
 		}
 	}
 
-- 
2.43.0



