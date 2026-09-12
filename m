Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E1A3E2ADB;
	Sat, 12 Sep 2026 11:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213552; cv=none; b=QHxkrdTvgavZHmYzNewuDz3ig9FEAOV0SD6DJiON8LFDLXbMxeeYlW0jnIZfwZRoRFd/PJbsQ9JjYfpC1FFeo7GD51aY2gi7Xn899vUIpSE/xxUvxKoKG2cECjkblkz24p12CGGlwv4RwbibCzSEii/f3wR5Cbk/zH81ljUiIzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213552; c=relaxed/simple;
	bh=7EcteVO8xhAYLTXbubC2hodMZkTxG6zLZJ1FDUFb42Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/bkvDCR87Kvx/ceiTRwKlP0thoSdApTze/gfk0ABZnJCiWgco13W4TPoA3WOsBbMi8vNEOfhJs7H5MxzW6pwgYjw3E+HLnOQgkCn8evki8tr90/Z03oW8I470DphZxaCohInXhezGPgRUCmqWe7qyaeHXUpPc5YXZ4jaowAqow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hDMofq9x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hDMofq9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4841F000FF;
	Sat, 12 Sep 2026 11:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213550;
	bh=HB//Map6aZmZ5QUgzoyG8A4t/iaw2L1CVsjWW94uqhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hDMofq9xAuIzQETg18OhXjxbv02NCYgpLd6assXYoRo/s7S1L4Xiyxc/L/LwpjQ5v
	 04QmfuYaxO2fOyv9cin1zhn+nO6quC94j7wkQxwC+SURAUPon5EW/O+ISI6c6Ke/ar
	 x6pCUpp6sO7Q5lfyJk3OvlqtM8CQbI7oLSWRAczo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidhu Sarwal <vidhu.linux@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 0146/1376] iio: light: ltrf216a: fix runtime PM reference leak in error path
Date: Sat, 12 Sep 2026 08:42:52 +0200
Message-ID: <20260912065610.807095100@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Vidhu Sarwal <vidhu.linux@gmail.com>

commit c132aef0e757a39036b1d40faf0569f2e343b13e upstream.

ltrf216a_get_lux() acquires a runtime PM reference by calling
ltrf216a_set_power_state(data, true). However, if
ltrf216a_read_data() fails, the function returns immediately without
dropping the reference.

This leaves the runtime PM usage count unbalanced, preventing the device
from autosuspending after a failed read.

Fix this by releasing the runtime PM reference before returning from the
error path.

Fixes: 83f0bcd40d5c ("iio: light: Add support for ltrf216a sensor")
Signed-off-by: Vidhu Sarwal <vidhu.linux@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/ltrf216a.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/iio/light/ltrf216a.c
+++ b/drivers/iio/light/ltrf216a.c
@@ -249,11 +249,10 @@ static int ltrf216a_get_lux(struct ltrf2
 		return ret;
 
 	greendata = ltrf216a_read_data(data, LTRF216A_ALS_DATA_0);
+	ltrf216a_set_power_state(data, false);
 	if (greendata < 0)
 		return greendata;
 
-	ltrf216a_set_power_state(data, false);
-
 	lux = greendata * data->info->lux_multiplier * LTRF216A_WIN_FAC;
 
 	return lux;


