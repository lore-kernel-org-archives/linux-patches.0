Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F73581243;
	Wed,  9 Sep 2026 14:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963847; cv=none; b=rCGYLUGETw+LWrsbRpFWtKEPMTnUQbDcCjErOei4C5ceuE+Kp456t60aoxpGTALnNO7FyYzmveDX58eGCQKAwMQVtlteTRykOTbTP/A5SqYEhJuAAoe88UvGF37by0QCv1t7J7eyiIi8SKhIv3g+IxR+ihYdfH8ZhDUYpQWFPhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963847; c=relaxed/simple;
	bh=jWfbch2CB9TCUkOgp1CzWn6GHQboOykUdafnIjFW+PQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pgv5kA5aSdqBg9L6Cc6cCj+DUF9LH+mGhRdB5r+KpQUr267Zoq3tQtJKNQR5a+jy5Gg+IwCcc5yTMWrKsXpGoEi3iIOxG0/1LBgSNwVDFhU1oj8udlFrUV70rE3xk47R2UuYisWG7r7UjnS0EyIyg3vz9JDTFqrAUbdoBcRReLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ewNx/EAn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ewNx/EAn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A1F1F00A3A;
	Wed,  9 Sep 2026 14:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963846;
	bh=urqtpQS3Pvmizg5S+ObL30RNmZEtvip9MFTk69Y4SVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ewNx/EAncHAOxQ/+ruzEUQ6jFGBPctUtFpxDXAWQYaPNo/WJhUX8ReXKtc/aFYbMy
	 qDduYOdAkuv73gttK2vkLI6QRLUJw7G628M+1HujhkwyrhjdDdDYwfp0Xdq/NNLBAJ
	 x8QxPOagM0/Y9BnqFXQhbIxDQx+PdB2CRKtQv+qY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidhu Sarwal <vidhu.linux@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 217/583] iio: light: ltrf216a: fix runtime PM reference leak in error path
Date: Wed,  9 Sep 2026 15:38:22 +0200
Message-ID: <20260909134245.669564105@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
@@ -248,11 +248,10 @@ static int ltrf216a_get_lux(struct ltrf2
 		return ret;
 
 	greendata = ltrf216a_read_data(data, LTRF216A_ALS_DATA_0);
+	ltrf216a_set_power_state(data, false);
 	if (greendata < 0)
 		return greendata;
 
-	ltrf216a_set_power_state(data, false);
-
 	lux = greendata * data->info->lux_multiplier * LTRF216A_WIN_FAC;
 
 	return lux;


