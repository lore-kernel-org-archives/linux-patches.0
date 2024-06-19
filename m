Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C56482495;
	Wed, 19 Jun 2024 13:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803232; cv=none; b=pLa/DFKGX3SlqiRdAJNN2FIWvCJYICoAy44fd95psOVtQYNT2D5GGDU3Y7g0rvLk6MO+o81iGRpDWd2egmDdA2pt92KGz9eRzs5hakPPqYfg6C6Upnb05VbDdkvYpU6zk5ant+4ENAaCy3Rmm3T5PLNubFlntguvkob7nYQFVr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803232; c=relaxed/simple;
	bh=JVHJZ/wy55jIo6YcDxLdjAZOA/NSuWxGv5mwavhig4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYswz1n/+pUj/DclQq1NbvHDV9pschrlR+94GhQ2ix/52n+v1UMgfbUB9O+lV9mCZ1pfmo2dJbwPlQcZTqvZzMDPT8+1DqbDR+JI9vNHLdgbk/PV+KI4A4NQeTXEDleyAH4jfW4wC6sfAv7vV0cJAiBvuQiTg8ugAKp2izSO3NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tR5ubczT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tR5ubczT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1747C2BBFC;
	Wed, 19 Jun 2024 13:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803231;
	bh=JVHJZ/wy55jIo6YcDxLdjAZOA/NSuWxGv5mwavhig4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tR5ubczT2rVS3/V+n3NNXteYFvyJERpNXh9XZ6Yre7KwnoD0rJsvaNEBl/Cp+3XEg
	 8t1fQ2oGn8V8C7WFufVbdd91CrBT40VXC/JuNlVN64/666hUbaYlIQP+ymoG4+Qig+
	 2BI2NJVucfROx1bHT/dX5hdlgnVhfeeruBAOwLLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Rizkalla <ajarizzo@gmail.com>,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Angel Iglesias <ang.iglesiasg@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.9 197/281] iio: pressure: bmp280: Fix BMP580 temperature reading
Date: Wed, 19 Jun 2024 14:55:56 +0200
Message-ID: <20240619125617.531797999@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Rizkalla <ajarizzo@gmail.com>

commit 0f0f6306617cb4b6231fc9d4ec68ab9a56dba7c0 upstream.

Fix overflow issue when storing BMP580 temperature reading and
properly preserve sign of 24-bit data.

Signed-off-by: Adam Rizkalla <ajarizzo@gmail.com>
Tested-By: Vasileios Amoiridis <vassilisamir@gmail.com>
Acked-by: Angel Iglesias <ang.iglesiasg@gmail.com>
Link: https://lore.kernel.org/r/Zin2udkXRD0+GrML@adam-asahi.lan
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/pressure/bmp280-core.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/iio/pressure/bmp280-core.c
+++ b/drivers/iio/pressure/bmp280-core.c
@@ -1394,12 +1394,12 @@ static int bmp580_read_temp(struct bmp28
 
 	/*
 	 * Temperature is returned in Celsius degrees in fractional
-	 * form down 2^16. We rescale by x1000 to return milli Celsius
-	 * to respect IIO ABI.
+	 * form down 2^16. We rescale by x1000 to return millidegrees
+	 * Celsius to respect IIO ABI.
 	 */
-	*val = raw_temp * 1000;
-	*val2 = 16;
-	return IIO_VAL_FRACTIONAL_LOG2;
+	raw_temp = sign_extend32(raw_temp, 23);
+	*val = ((s64)raw_temp * 1000) / (1 << 16);
+	return IIO_VAL_INT;
 }
 
 static int bmp580_read_press(struct bmp280_data *data, int *val, int *val2)


