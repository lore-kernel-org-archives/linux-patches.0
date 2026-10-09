Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1CA4CEE73;
	Fri,  9 Oct 2026 14:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555446; cv=none; b=ds/6XEB+T3RAwQdpJI0T7ZrtxGRNQkUsTqqXEjHvVGsYL2n37UDczynczoC+aNj/71PpxzFj+dcoSetzo4XmJowUCEEU3LeQeb0/Z34SF0vbiP+TBAiNkJC9qFqxG8tOgJ9PwIyyRTblb0KmNcXplYXhvMkABtqTYRl7biyxglM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555446; c=relaxed/simple;
	bh=hR2+GIYoPM8wxpKuJo9WVIirfwJk9FpxYLt9R33+6Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/PA8sV9q5bmImTlDkQLP8R9zoV5njQnJ1kx5Is3HdGVSi60Unha+s5cX/iB1+XMiUw32wHafFUJMXoeP9yGFhZebCh7Tq7b7uKWxOzAdL0OgXVRrwoWI2qtiqqx97jhEwRz7EuExpnQfT7VczTP2xpLUBnLgcP1UC12nOXJ1Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXVPUAWH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXVPUAWH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8121F00893;
	Fri,  9 Oct 2026 14:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555441;
	bh=svppk4yXNCAdgC7KOIaT7CXYC+aLBc4ThacIlKJI8qY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RXVPUAWHMlSSNeKl4UiFhw+4+7KoT1XWYDb+Pb1GRlFiu7D5ztPLL3M8ZMRF/jpmt
	 QvU2u9MKOd5Pg7eiNKFukz+udd5ljI+843hr/4IlcCvsutmLnixw5wpCmAQjtfnU8C
	 gakllPNsT3DlRrOUVlhCn2RGlvsLoaSa2Oov5MDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 058/403] iio: light: rohm-bu27034: Fix error return
Date: Fri,  9 Oct 2026 16:06:59 +0200
Message-ID: <20261009140953.457614185@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit 4e5b0b7c5d95814b6d76911a91572a0691925ca7 ]

When BU27034 fails to read gain value at integration-time setting, it
returns 0. This leaves caller unaware of the fact that setting the
integration time failed.

Fix this by returning the relevant error instead of zero.

Fixes: 439c2cef8157 ("iio: bu27034: simplify using guard(mutex)")
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/rohm-bu27034.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/light/rohm-bu27034.c b/drivers/iio/light/rohm-bu27034.c
index 28d111ac8c0a7..f9a4216184063 100644
--- a/drivers/iio/light/rohm-bu27034.c
+++ b/drivers/iio/light/rohm-bu27034.c
@@ -415,7 +415,7 @@ static int bu27034_try_set_int_time(struct bu27034_data *data, int time_us)
 	for (i = 0; i < numg; i++) {
 		ret = bu27034_get_gain(data, gains[i].chan, &gains[i].old_gain);
 		if (ret)
-			return 0;
+			return ret;
 
 		ret = iio_gts_find_new_gain_by_old_gain_time(&data->gts,
 							     gains[i].old_gain,
-- 
2.53.0



