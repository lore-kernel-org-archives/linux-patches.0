Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCE8196C72;
	Thu,  6 Jun 2024 14:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682931; cv=none; b=iqoAloVAxaaB6ScOv98QjrrNT07v5rlLQRCjrsmGHfqIa21eTQ18FjjPzcgaW7+nbY23q7jsr60hG06YSrgtUuyiSkfnanzvYhrTaDT/7I1fxY2m/roTzKojNqk0jE4pF/QVhVxd/ZCbzo9bBrVnFnnqvDw2+tFIjwMAbcZVy9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682931; c=relaxed/simple;
	bh=Y1JSlawi8Xul543Ka7hDowbg86eMQOzdlJspZfCJg9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHlftyYMkLMUw6T1qRsfmUX4faIZgGi+cJSj7Z0PHQvn6ANixoPXkpDeVyp3VYpefdc23qv4U/2ULb3smk14XA0u2liI9KoSoAiniM9Z2qACGgEB1k52TyusUqU/h2dGmMoc3tmC+NFjDTSAwLaFOBD5u1vfTpjOT+MI5TKnxbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jq7xufWu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jq7xufWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80582C4AF0E;
	Thu,  6 Jun 2024 14:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682930;
	bh=Y1JSlawi8Xul543Ka7hDowbg86eMQOzdlJspZfCJg9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jq7xufWuEQuEA0JsAcvMZKhYhiHTZcfDX+exqPjwuQwHcDzyZTcC8WIZV1uubz9R0
	 2Leir8+bg9940NQBQqrMB7JSoDRNNUj4jMCsHYqC1YIb1Ut9/TQdCuWIw5r/iH0tCG
	 YcRc7NH3E7A8YPDkkquHgfdrLjHExosBTqKFzZBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Marius Cristea <marius.cristea@microchip.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 077/374] iio: adc: PAC1934: fix accessing out of bounds array index
Date: Thu,  6 Jun 2024 16:00:56 +0200
Message-ID: <20240606131654.431057048@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

From: Marius Cristea <marius.cristea@microchip.com>

[ Upstream commit 51fafb3cd7fcf4f4682693b4d2883e2a5bfffe33 ]

Fix accessing out of bounds array index for average
current and voltage measurements. The device itself has
only 4 channels, but in sysfs there are "fake"
channels for the average voltages and currents too.

Fixes: 0fb528c8255b ("iio: adc: adding support for PAC193x")
Reported-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Marius Cristea <marius.cristea@microchip.com>
Closes: https://lore.kernel.org/linux-iio/20240405-embellish-bonnet-ab5f10560d93@wendy/
Tested-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20240425114232.81390-1-marius.cristea@microchip.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/pac1934.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/iio/adc/pac1934.c b/drivers/iio/adc/pac1934.c
index e0c2742da5236..8a0c357422121 100644
--- a/drivers/iio/adc/pac1934.c
+++ b/drivers/iio/adc/pac1934.c
@@ -787,6 +787,15 @@ static int pac1934_read_raw(struct iio_dev *indio_dev,
 	s64 curr_energy;
 	int ret, channel = chan->channel - 1;
 
+	/*
+	 * For AVG the index should be between 5 to 8.
+	 * To calculate PAC1934_CH_VOLTAGE_AVERAGE,
+	 * respectively PAC1934_CH_CURRENT real index, we need
+	 * to remove the added offset (PAC1934_MAX_NUM_CHANNELS).
+	 */
+	if (channel >= PAC1934_MAX_NUM_CHANNELS)
+		channel = channel - PAC1934_MAX_NUM_CHANNELS;
+
 	ret = pac1934_retrieve_data(info, PAC1934_MIN_UPDATE_WAIT_TIME_US);
 	if (ret < 0)
 		return ret;
-- 
2.43.0



