Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E13B2FF64C;
	Tue, 26 Aug 2025 14:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218162; cv=none; b=Vt5Lop9k5WduTcOIOnJJr4tV+0zsE9ZZ2/orfnZarrVUA8Vlc96xuC2pl5rwyfnlg+CHiQkNredP0Z6ZO7g6R2Rh0qHclwWwOxaJpRXPVww7IMK2eKM/b3dmwCOxbZakOYJnEHHy92PysQhyz7lVPongWMQDorycIFugvG20OjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218162; c=relaxed/simple;
	bh=3L5LtoWEwaBIombD1AASC/fPMobhtaNphtJuTghT5Dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/DXvoe2+CtZdhNDCtyyzgNr6Ftnloh5ofL/iy0+mZ8vNfqBMXh/zp0j0B+HIeyuFkA7JY2660Y4ufvKTZikO8qKOOWuhsARyn1PqxUu6uoxG24jNNny5DNlewWUeDZDdx918EnFeB076Kd5bbtbsycdPfavxA7CsvY9HxJrLKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EBSSPr3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EBSSPr3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C5BC4CEF1;
	Tue, 26 Aug 2025 14:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218161;
	bh=3L5LtoWEwaBIombD1AASC/fPMobhtaNphtJuTghT5Dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EBSSPr3u+Tjqnr4AlLsdGstkL7mW2kYLBDNG1It6eDbj++4fE9wfw6tOlLobK9O0O
	 Bv7YY7+7XEiwkXjYGOCKjT2xrPaT49OvrawrAm04Ict/DGC+KFKAN+1u1lyiE9yR09
	 d4giJuIup+8cbZHkfeBUz/dLuuOr0PpILx7iImsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Lixu <lixu.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 417/523] iio: hid-sensor-prox: Fix incorrect OFFSET calculation
Date: Tue, 26 Aug 2025 13:10:27 +0200
Message-ID: <20250826110934.741272833@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Lixu <lixu.zhang@intel.com>

[ Upstream commit 79dabbd505210e41c88060806c92c052496dd61c ]

The OFFSET calculation in the prox_read_raw() was incorrectly using the
unit exponent, which is intended for SCALE calculations.

Remove the incorrect OFFSET calculation and set it to a fixed value of 0.

Cc: stable@vger.kernel.org
Fixes: 39a3a0138f61 ("iio: hid-sensors: Added Proximity Sensor Driver")
Signed-off-by: Zhang Lixu <lixu.zhang@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20250331055022.1149736-4-lixu.zhang@intel.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[ adapted prox_attr array access to single structure member access ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/hid-sensor-prox.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/iio/light/hid-sensor-prox.c
+++ b/drivers/iio/light/hid-sensor-prox.c
@@ -101,8 +101,7 @@ static int prox_read_raw(struct iio_dev
 		ret_type = prox_state->scale_precision;
 		break;
 	case IIO_CHAN_INFO_OFFSET:
-		*val = hid_sensor_convert_exponent(
-				prox_state->prox_attr.unit_expo);
+		*val = 0;
 		ret_type = IIO_VAL_INT;
 		break;
 	case IIO_CHAN_INFO_SAMP_FREQ:


