Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53917334692;
	Tue, 13 Oct 2026 12:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895633; cv=none; b=p+VVA7pKqrsJ+Xc1ZdFbIYUcBKdWxUpQ0rMqXNQ73H3MsxbF6zo7kWh8VVgnRlqLnOhSCIom5uMwzmKhiZGs37LOQGiv8mq6uXLxO3sNCm/junhGeH8vUlc30l7vj7A76LqRsDMLMos//X6UBVIy5YbzaGXWrEz2/uea0kUoGgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895633; c=relaxed/simple;
	bh=t+evDcMKgeTs3NVKby2Xki3Yj4RHHDGuoUUSU1oxKgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CyI6kFt8JpNsgiMfE1joITaKadaj9U6nnCE6PQrhySSW3bBSMXICzkvQS4yb/Bfg99dIeYJNxpp3urSXz0CZNn4d0K2pWC9u4EJgxk1ckj/tpJcd5ofV6748lLllPZTdbE6K7F1sYraMqXyZQS42Vu44NvzPJYBfrmawISjR9hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KDr8GfnT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KDr8GfnT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F211F000FF;
	Tue, 13 Oct 2026 12:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895632;
	bh=jjVPqT54/DoLDSFEmWCjXra0eogMESmIFaaszXtj2Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KDr8GfnTfkjfYj5gflRhLtLHxC43MPhav7RJEsOeQWi/2/CJYcdUgZoIK11O88cLb
	 kOt0CSkzy6DDp/J9qm90c9azNGALapWRHPlUtcBwOf3dpmHi0oFkq0t0k3ZLi15Wv6
	 5BkAanuoTw6kkCw0GJNGmEPY9lTLU4cWt64lAETE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 340/497] iio: light: rohm-bu27034: Fix error return
Date: Tue, 13 Oct 2026 13:38:27 +0200
Message-ID: <20261013112915.974059025@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 439815c3c15dd..0e90d3633b7b5 100644
--- a/drivers/iio/light/rohm-bu27034.c
+++ b/drivers/iio/light/rohm-bu27034.c
@@ -420,7 +420,7 @@ static int bu27034_try_set_int_time(struct bu27034_data *data, int time_us)
 	for (i = 0; i < numg; i++) {
 		ret = bu27034_get_gain(data, gains[i].chan, &gains[i].old_gain);
 		if (ret)
-			return 0;
+			return ret;
 
 		ret = iio_gts_find_new_gain_by_old_gain_time(&data->gts,
 							     gains[i].old_gain,
-- 
2.53.0



