Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3FC3176E4;
	Wed,  8 Apr 2026 18:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674695; cv=none; b=E3zndHJZNW8fZLEPDdsE/SXjRNyiNyXKR/xkvwlNX7rQ2U1Ij6QYUyguKcUbKx6kkmv1iLjrakA/HK+k/mn0wL0xHxm4E8p+O84EuSqtyUa4triTqBiGYzYqh2t4XBvQqziA1vnV0QjTKNpGT1Yfp0L9r7DE6YEx8ySRBxIz8Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674695; c=relaxed/simple;
	bh=qBzRRytzt8NtA2cIVWhefgRq5lzId5JcAyKWdYaIKhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TS9EkWEA3bI6F0hU4fxenyYpUxTOQpwUpaPTreYWnJesx730b/ZaPL23eWG0bEk19I3IweRYtowLpZS+Chb9rl2yKbfqRsESeW8X6OGXZyi65+Y7ozpSVmDH8891SjKenr9VsC+od+RWa9a8dwio5rtC93pAyKh3HHPtAALPf24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WHarbBJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WHarbBJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04AA4C19421;
	Wed,  8 Apr 2026 18:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674695;
	bh=qBzRRytzt8NtA2cIVWhefgRq5lzId5JcAyKWdYaIKhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WHarbBJ8gMDxsSkOiyCm4iY/ahx5gApsVhMOxUqPCfNxlTV4ZpuEFOFfgesU7Pjfv
	 S9Eb5IpAT2YHdGi/92ln0OMdHd4FU6i1Ihr3/oJI1yxZT592wLHSoGdipAevojHD/I
	 h6n39og4yTtumZCvY0IpOBIxUoapvlIjLw+HmkMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.19 197/311] iio: adc: ti-ads1119: Reinit completion before wait_for_completion_timeout()
Date: Wed,  8 Apr 2026 20:03:17 +0200
Message-ID: <20260408175946.769080080@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

commit 2f168094177f8553a36046afce139001801ca917 upstream.

The completion is not reinit before wait_for_completion_timeout(),
so wait_for_completion_timeout() will return immediately after
the first successful completion.

Fixes: a9306887eba4 ("iio: adc: ti-ads1119: Add driver")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-ads1119.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iio/adc/ti-ads1119.c
+++ b/drivers/iio/adc/ti-ads1119.c
@@ -280,6 +280,9 @@ static int ads1119_single_conversion(str
 	if (ret)
 		goto pdown;
 
+	if (st->client->irq)
+		reinit_completion(&st->completion);
+
 	ret = i2c_smbus_write_byte(st->client, ADS1119_CMD_START_SYNC);
 	if (ret)
 		goto pdown;


