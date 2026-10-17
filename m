Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC3C2E8DEB;
	Sat, 17 Oct 2026 17:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256752; cv=none; b=AsIQyFTUs+Aob/ItMFkfF5WYPgIHPRw6t7AEfddVB4BsAbISPtplfnA5BkdjNiF64TEFRMJnaWiOyW7KwSH8dBq9J1St1ot+0+R0rA3EYjn98qSl7z73P4nPaQtlpu0iINpNSGIpTzlhpMli4mkpsxbeDCCw8f5x8Ad3u3GLjoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256752; c=relaxed/simple;
	bh=wKiIvnhvxrgfoz6eMZs7/kCji0cTappUraHfYFJofuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZaUY6GvzPNJzj08/1fLnFYzg6Bh32yyCHg80r1jYGIulynpZ6EPD7aaeHN+ysneOd9Pt/9vWc7KkmJNhYArUe+AmhY43rucjFVaCl+P/Xod386H70GbaBHSkx/hpA279Gwbji+OF/51AHskohVbGh/hU2nTZ/5X1gp5JrTQZec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QBSjSRBb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QBSjSRBb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6491F000C4;
	Sat, 17 Oct 2026 17:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256751;
	bh=ODHmCTPMWe90MSc7PpMw1zDnGChKJXs/FXO6oy5cIpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QBSjSRBbQ3CDVkxVobbwWTwexnoR7Fq0oIIasSetuMuSOJEHJuBp96pgQ8RTkKKiO
	 AQW21flxe3eOqWWX6z8i16x3Gp470rQOulPTAAilM35VIcxMilTSEckexGwozTpbLe
	 CJabJ4KnfkCS2QeJU47LU0UeMt3q239RnfQmfVSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.6 0338/1674] iio: adc: sun4i-gpadc-iio: clean up on thermal zone registration failure
Date: Sat, 17 Oct 2026 17:43:30 +0200
Message-ID: <20261017160439.801094973@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

commit 2cdc7ef31827db4fbc6283750420639569e1f0e9 upstream.

If devm_thermal_of_zone_register() fails, probe returns without
unregistering the IIO map array or disabling runtime PM.

Jump to err_map to release them.

Fixes: b0a242894f11 ("iio: adc: sun4i-gpadc-iio: register in the thermal after registering in pm")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/sun4i-gpadc-iio.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/iio/adc/sun4i-gpadc-iio.c
+++ b/drivers/iio/adc/sun4i-gpadc-iio.c
@@ -644,10 +644,10 @@ static int sun4i_gpadc_probe(struct plat
 		 * thermal because no thermal DT node is found.
 		 */
 		if (IS_ERR(info->tzd) && PTR_ERR(info->tzd) != -ENODEV) {
-			dev_err(&pdev->dev,
-				"could not register thermal sensor: %ld\n",
-				PTR_ERR(info->tzd));
-			return PTR_ERR(info->tzd);
+			ret = dev_err_probe(&pdev->dev,
+					    PTR_ERR(info->tzd),
+					    "could not register thermal sensor\n");
+			goto err_map;
 		}
 	}
 


