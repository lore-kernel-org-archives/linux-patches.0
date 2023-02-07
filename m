Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D7C3212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:12:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC1FC433EF;
	Tue,  7 Feb 2023 13:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775564;
	bh=UZoXbmAiNMVb0C7wIkEF54FHEltGJrek1o93zidJOxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=02dhyqLLhC/azsquAGObon5GDiZ/2zpIvyusw2kmDx6E7B3wZSMXUK14UsvPVjYDD
	 W7+rPGdRtwCehTPulOS0skZm1Dri5kvBfWHYSqk71Nq850hH+mE1aha6Ht/8GPPPJC
	 diIyAFpuddR8GbgIrE6nvY3NIj8gYFaKJ8Z1BCvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 083/120] iio: imu: fxos8700: fix failed initialization ODR mode assignment
Date: Tue,  7 Feb 2023 13:57:34 +0100
Message-Id: <20230207125622.276761489@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Carlos Song <carlos.song@nxp.com>

commit eb6d8f8705bc19141bac81d8161461f9e256948a upstream.

The absence of correct offset leads a failed initialization ODR mode
assignment.

Select MAX ODR mode as the initialization ODR mode by field mask and
FIELD_PREP.

Fixes: 84e5ddd5c46e ("iio: imu: Add support for the FXOS8700 IMU")
Signed-off-by: Carlos Song <carlos.song@nxp.com>
Link: https://lore.kernel.org/r/20230118074227.1665098-3-carlos.song@nxp.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/fxos8700_core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/iio/imu/fxos8700_core.c
+++ b/drivers/iio/imu/fxos8700_core.c
@@ -664,8 +664,10 @@ static int fxos8700_chip_init(struct fxo
 		return ret;
 
 	/* Max ODR (800Hz individual or 400Hz hybrid), active mode */
-	return regmap_write(data->regmap, FXOS8700_CTRL_REG1,
-			   FXOS8700_CTRL_ODR_MAX | FXOS8700_ACTIVE);
+	return regmap_update_bits(data->regmap, FXOS8700_CTRL_REG1,
+				FXOS8700_CTRL_ODR_MSK | FXOS8700_ACTIVE,
+				FIELD_PREP(FXOS8700_CTRL_ODR_MSK, FXOS8700_CTRL_ODR_MAX) |
+				FXOS8700_ACTIVE);
 }
 
 static void fxos8700_chip_uninit(void *data)


