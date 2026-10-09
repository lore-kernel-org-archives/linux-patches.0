Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76AD133A6EB;
	Fri,  9 Oct 2026 14:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555772; cv=none; b=XLcQkKjzT5IsxocBGtoMvpdjqAA6nPAs4b4fuc9NcJKQr21EcXCyQ37Iyqn/HA76Hz8mMcWtgYYXGlwJ+zl/5TpcRS+zNXaumDmWhsLDEHHe44CbSFPfKtzikhT0sSCSLgWWcqgKPmJZNIDh2MHcUZcLfvIk5xCRFCQBfR/sIGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555772; c=relaxed/simple;
	bh=+YHNTvdJQD2ATOulRxpjVQMXW8Ypkc2V2vNzeXeHAog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=riVkdg4h1MSSgbnr8GW/1/+nje/ZGxS0d1u05wB6MEUJyyoYhhWHnjMpIcl2JPoj0Loj6BbwcXwmiwkZJfn7/ozqNu/DGoJGLvzdCKdGjQAkWARg1kpepubPOP7R6kUOyCScgtOy2sZFNrJcSNL91FNPd+Cug0WIHXyOsRVL6Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oml8Pq3E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oml8Pq3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D2D1F000FF;
	Fri,  9 Oct 2026 14:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555771;
	bh=UF7qDeX4K1WIW69H/9Rnxd/2IWBQ7unm7DmFVawrruY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oml8Pq3EvRwWJQC7tPxP3beYsWOMlAtI9O9FAuhOaQKhJK1wVep0Vkr0fRYhr7KnY
	 sG52pocDndSzytov7uJKEzNWmoF5V6afbQOuui8KP2DaVsH/zNc31lYFWVjOetxcPF
	 J12gBTZTgVEdzmuQMNeql9r/5yIYB5KyN6ITSzqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 067/428] iio: light: rohm-bu27034: Fix error return
Date: Fri,  9 Oct 2026 16:06:44 +0200
Message-ID: <20261009140947.620367806@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



