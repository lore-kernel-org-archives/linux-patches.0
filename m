Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE663630AE;
	Tue, 13 Oct 2026 12:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895319; cv=none; b=u6LAPEpkBN1Zd0sI2SsJOA30BN3Y0mWdP/WQVp0kL90djbXZR1LxrD05uWt2U+NyCq+Tkl462OTX3tSiWwyDLyjx156JfnfPn80tohY7Qysjn8dAvD1Y1PUuaaFNJfaNw3yVRZ8Wt4dCUKUhIYk+tQpmc4j//R++NkGh4VzKASc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895319; c=relaxed/simple;
	bh=dvJXfTr5WxCjh+O02rXYWxr1cPhehPjZJeXxSIchW2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XY7sP4Bl9fPXW0i5be16gChokpl9ohWhWIzP9WUKf+dvckg8cA3AQwMcKcBJ6zQuWn9SZObTLafG2tj/Shl08yu5DMEZESJ+GHgoKzsFFukcTtPlZXCAGpMWG8o+rOvtDGmDHCE2VAM+UC3PYHn4pML5zyU2pVkpijcT2CjwLHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A58Vczbt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A58Vczbt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945FB1F000FF;
	Tue, 13 Oct 2026 12:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895318;
	bh=I3oSvCM0rgfDEGSzCOTFqyvZ4lWBJK7nREyQTf7oR+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A58VczbtXPci0E4dsZmMmPkuzEL/cyp57UHx6RaK/gOLEVDfXaCZeN6Oeaa8TPdjV
	 bZZID3D+xvVh3JE6JOei+KVjHnqSZHHNWZVXvR+9AMvjFdug9i9PHK4NudwTDhtUKh
	 nicDbuHxJhrhh2MnMVLgVrYM7Q8uLnAjt+gMTmvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 235/497] iio: adc: sun4i-gpadc-iio: clean up on thermal zone registration failure
Date: Tue, 13 Oct 2026 13:36:42 +0200
Message-ID: <20261013112913.474731488@linuxfoundation.org>
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
 


