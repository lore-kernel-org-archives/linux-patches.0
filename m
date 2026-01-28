Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FC42F6183;
	Wed, 28 Jan 2026 15:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615200; cv=none; b=QBLaIDLIj5IdSEycQsan9i2meWFvlXpeOp+GfdJXYaBdSFSHo6B7bEoiyLO4UKJoiH5OkCV4xYK76lMSsivbEZHou3H4P5L9i7AehfzaTHG73gdVG3ngA0AOI1FjZH05MDuJ6dPKGv/4mXvW8OeklKKpX8tigrrqv6h5WFfSosE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615200; c=relaxed/simple;
	bh=YfOU81XQkEJKYAVESOB1GR1xUF3GHDc31N69AH0pAEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUsQaUx0E1v0IooNvS18mY60kyL784dYh8ArzqvoHVUegk18EvrsP8yggX8JaOAzUfD8cedi/YQLnLCFA1p/ZDAcvqzrfr2TtpHhnHC34T8VP/7v/5+d9XM6r0pFyp9DP5IgfCATR3fNA0CYdP3vLqFf+RyTYZoR11O6hlbXQec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q9a0dauF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q9a0dauF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7695C4CEF7;
	Wed, 28 Jan 2026 15:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615200;
	bh=YfOU81XQkEJKYAVESOB1GR1xUF3GHDc31N69AH0pAEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q9a0dauFwDUxbc5U+yVCv0YyX9BBq3iRmbghANKnVTyRVmlazr6VOAtRQ6JzH2NMA
	 rYFeeOPx82zqrFakre3pOXM3/+2AN11+DSX81bFxDmbxo1qBX0Y8HOsShrH0bGw9dq
	 RrJNpuT0dHc7bpP4fcD9qCcE9Dwfnh7jaMkSooUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 108/169] iio: adc: pac1934: Fix clamped value in pac1934_reg_snapshot
Date: Wed, 28 Jan 2026 16:23:11 +0100
Message-ID: <20260128145337.894761380@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

commit da934ef0fdff5ba21e82ec3ab3f95fe73137b0c9 upstream.

The local variable 'curr_energy' was never clamped to
PAC_193X_MIN_POWER_ACC or PAC_193X_MAX_POWER_ACC because the return
value of clamp() was not used. Fix this by assigning the clamped value
back to 'curr_energy'.

Cc: stable@vger.kernel.org
Fixes: 0fb528c8255b ("iio: adc: adding support for PAC193x")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/pac1934.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/iio/adc/pac1934.c
+++ b/drivers/iio/adc/pac1934.c
@@ -665,9 +665,9 @@ static int pac1934_reg_snapshot(struct p
 			/* add the power_acc field */
 			curr_energy += inc;
 
-			clamp(curr_energy, PAC_193X_MIN_POWER_ACC, PAC_193X_MAX_POWER_ACC);
-
-			reg_data->energy_sec_acc[cnt] = curr_energy;
+			reg_data->energy_sec_acc[cnt] = clamp(curr_energy,
+							      PAC_193X_MIN_POWER_ACC,
+							      PAC_193X_MAX_POWER_ACC);
 		}
 
 		offset_reg_data_p += PAC1934_VPOWER_ACC_REG_LEN;


