Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4528566C5B;
	Wed,  9 Sep 2026 14:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962405; cv=none; b=IGjDKjLvS5TCNPj7ATBkOPFn4ZSDq98mjftGuuyxLhxKhPKGBwhGSXo7femVhMFupRaMdc23ge9lGF03DSVMjqNrhGGh99WhQDtak/0FhKLKo0QyURiTMtslkc9wr6D9F4mBjT7mn0LEjlTlqA1vcGD8uDJwcL4jJrPU4kjBZl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962405; c=relaxed/simple;
	bh=gx/aXFoIcSAjRcR7Rs3AY9/ISVHUDlS/5YttNA/Id0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDg8alkIEdM945ojRc5CDDeMXekHuP0caUIZQcWyti+nQ27am+m6E6f1pHVwjsWGXaL7xhiisfbUctBw1sNPktmOvndERc4L/2Z+pX2V8mly8cc5E44a/cAcmLweqin5X4UIrhKJkC0cTPZ9agZG1zxn4kYt/4UjMiVlplZTPvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gxzdMXk3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gxzdMXk3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C701F00A3A;
	Wed,  9 Sep 2026 14:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962404;
	bh=zLnzrBhKq1GiPgFoUa7D42nIN/vXBmBbdserZh9YzBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gxzdMXk3Iw09BkZ//JQr46A+hfPOsoyXUjvmPHR81ktz+YXZ2yCpgjTbcbnm17Z3e
	 CiEThWsf9E+fijNHggtAMwkfjmHlf8Ni9qTyR2y7Ys7Kz8g7R4ehghb0B1ipkrXGWj
	 Z1prJYKiPzWosDx9INSUy+Yk9IIvaBv5l4qXL3K0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidhu Sarwal <vidhu.linux@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 279/556] iio: light: ltrf216a: fix runtime PM reference leak in error path
Date: Wed,  9 Sep 2026 15:39:19 +0200
Message-ID: <20260909134240.451579036@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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
@@ -247,11 +247,10 @@ static int ltrf216a_get_lux(struct ltrf2
 		return ret;
 
 	greendata = ltrf216a_read_data(data, LTRF216A_ALS_DATA_0);
+	ltrf216a_set_power_state(data, false);
 	if (greendata < 0)
 		return greendata;
 
-	ltrf216a_set_power_state(data, false);
-
 	lux = greendata * data->info->lux_multiplier * LTRF216A_WIN_FAC;
 
 	return lux;


