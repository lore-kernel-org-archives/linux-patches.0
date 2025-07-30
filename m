Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE34F1E25E1;
	Wed, 30 Jul 2025 09:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868903; cv=none; b=Hc83+EjvmQ737BtTWKTZn4/EMQtyXS+87Io2oMJD38P4z/Ha03t8HVq3Y61/GoM9iVD7wM11hYIAJomDmn4MZZvyk6rfIGJk2NNs2RReTaXsnind/fKKdlw3J4CpFFcen8yAHlupQVxwHOMVNKJtjz1R9X9k6waPl07qfp/ilwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868903; c=relaxed/simple;
	bh=ouAfiu1+CiqXe3/yrb2QRj5iXPyrwd97oe+iC1NQrPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWMVpnyk6dwTIjvizEP6fgCHKAwKHTzH+3SLgoDZ7dE1NV7t7w+ZYmP3/oke71OX+XQCk8qmNrTBSNEE5mq0vfLt/DXH7st8XPF3M0t1MHw45VR4L4rybtCyxC/ZHXXv+8FTgekhjVPkm0PWxNM6rQBEQoIR+LiO1YgP1LckA1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j0Ea93f8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j0Ea93f8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB2A5C4CEF5;
	Wed, 30 Jul 2025 09:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868903;
	bh=ouAfiu1+CiqXe3/yrb2QRj5iXPyrwd97oe+iC1NQrPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j0Ea93f8kkFTMWA6o2ArAuLQhzADgN43H9H/GmaXS/MYC8Zo9QQTfUxL0fB+26b9t
	 nAC5Q6BNgiyjzaXNvZw5/Kj5QxxmWXcM4GOaWfDBFC+y4YW+Tq8jG4SDIaMp6vJnhg
	 YBAoSSQ2RdpM8Ezxhay0Atonwx2BenjiT57V4AKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Lixu <lixu.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 106/117] iio: hid-sensor-prox: Fix incorrect OFFSET calculation
Date: Wed, 30 Jul 2025 11:36:15 +0200
Message-ID: <20250730093237.933652513@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -102,8 +102,7 @@ static int prox_read_raw(struct iio_dev
 		ret_type = prox_state->scale_precision;
 		break;
 	case IIO_CHAN_INFO_OFFSET:
-		*val = hid_sensor_convert_exponent(
-				prox_state->prox_attr.unit_expo);
+		*val = 0;
 		ret_type = IIO_VAL_INT;
 		break;
 	case IIO_CHAN_INFO_SAMP_FREQ:


