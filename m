Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D013290D1;
	Sat, 12 Sep 2026 16:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231122; cv=none; b=kEIKiZA7+pSYUFPUB9FhajaPLGWLl56WdYZ0W7iakkvgkNSqkzakwl67ZSdsWuzF2EHIJz6wzFhBSbxm21HqgF8Aaawu/5p9qdjBX7XlJ7fgd1edU6gRDZ6imjGxb9cv7wNxWMBmBWKa7MeuPK6P80EEE/6+urwp1Li8Z1S7XPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231122; c=relaxed/simple;
	bh=KSUaxF8AMg95eEjnP3IMR0kWlmWHxplXqczCHFOmKLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DAZ4xHLeUGmRglFu+jGzurX8ajbmLZ6SHEWIZ1bd9yRmunGAFi2MHwZZWBbycPt7XI5iJ7GCAkC1VdIXoYxcmU4eCyGwue20UiVgkb4tPW+paJiZZMUBqBMirsWBBmwnz12oNkI39yZ7F2G58YBbJKlHZJ+VxrcAMVWPoARTqo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rf+YOjRA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rf+YOjRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1911F000FF;
	Sat, 12 Sep 2026 16:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231121;
	bh=yqC5SGu/HsoWnzsghG43vg9STFLQjqobnmhAt84ihAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rf+YOjRAjSrGFQb8UmG96yl7JcRODHVrtkjbvBcQ+Y8sOOL+6t8pT+4Dnt7DjKzi4
	 kdmdmrjG9YjO1Jd0aKNAotW1P1YM6ZvSE/H+g4pd4PhNstsVH09CMkZASgF/4269Uh
	 aLhGnXRJ7gHMVB+oQDZses7D0MW3T2NexyMACytk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gautam <nikhilgtr@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0935/1191] iio: light: gp2ap002: re-enable irq if runtime suspend fails
Date: Sat, 12 Sep 2026 09:01:03 +0200
Message-ID: <20260912065609.229007719@linuxfoundation.org>
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

From: Nikhil Gautam <nikhilgtr@gmail.com>

[ Upstream commit 5d89e7cbac40057f5241a0832a86ce0fe97e4818 ]

gp2ap002_runtime_suspend() disables the irq before writing OPMOD. If
the write fails, the callback returns an error with the irq still
disabled while the PM core marks the device active again.

re-enable the irq before returning the error so the irq state matches
the active state the PM core restores.

Fixes: 97d642e23037c ("iio: light: Add a driver for Sharp GP2AP002x00F")
Signed-off-by: Nikhil Gautam <nikhilgtr@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/gp2ap002.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/light/gp2ap002.c b/drivers/iio/light/gp2ap002.c
index dca2ddd9a7639..2157a4fbb1f6e 100644
--- a/drivers/iio/light/gp2ap002.c
+++ b/drivers/iio/light/gp2ap002.c
@@ -652,6 +652,7 @@ static int gp2ap002_runtime_suspend(struct device *dev)
 	/* Disable chip and IRQ, everything off */
 	ret = regmap_write(gp2ap002->map, GP2AP002_OPMOD, 0x00);
 	if (ret) {
+		enable_irq(gp2ap002->irq);
 		dev_err(gp2ap002->dev, "error setting up operation mode\n");
 		return ret;
 	}
-- 
2.53.0



