Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1362315E84
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cqMwQShk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8017BC433C7;
	Mon, 23 Oct 2023 11:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060587;
	bh=rpXrHCOnRjUSY+tT2d0E7yz5PVzEDSPFc5DvEp9somg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cqMwQShkZzjfoKHuQ6RBQOY0aq4xQdE1s3jARcf45l5e70JOd9UX+FjYRKpvUsOmz
	 USqTMeZbE/Shx8MS22QJM8bKXg8vTtXTmvGZhkGrBXX4AInRiUQtA2/pA84nL9x6/T
	 WkVQcveQWOc1NVA2HWMsa69FyeV/U2aLT+wBTXTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lakshmi Yadlapati <lakshmiy@us.ibm.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 026/123] iio: pressure: dps310: Adjust Timeout Settings
Date: Mon, 23 Oct 2023 12:56:24 +0200
Message-ID: <20231023104818.618072632@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104817.691299567@linuxfoundation.org>
References: <20231023104817.691299567@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lakshmi Yadlapati <lakshmiy@us.ibm.com>

commit 901a293fd96fb9bab843ba4cc7be3094a5aa7c94 upstream.

The DPS310 sensor chip has been encountering intermittent errors while
reading the sensor device across various system designs. This issue causes
the chip to become "stuck," preventing the indication of "ready" status
for pressure and temperature measurements in the MEAS_CFG register.

To address this issue, this commit fixes the timeout settings to improve
sensor stability:
- After sending a reset command to the chip, the timeout has been extended
  from 2.5 ms to 15 ms, aligning with the DPS310 specification.
- The read timeout value of the MEAS_CFG register has been adjusted from
  20ms to 30ms to match the specification.

Signed-off-by: Lakshmi Yadlapati <lakshmiy@us.ibm.com>
Fixes: 7b4ab4abcea4 ("iio: pressure: dps310: Reset chip after timeout")
Link: https://lore.kernel.org/r/20230829180222.3431926-2-lakshmiy@us.ibm.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/pressure/dps310.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/iio/pressure/dps310.c
+++ b/drivers/iio/pressure/dps310.c
@@ -57,8 +57,8 @@
 #define  DPS310_RESET_MAGIC	0x09
 #define DPS310_COEF_BASE	0x10
 
-/* Make sure sleep time is <= 20ms for usleep_range */
-#define DPS310_POLL_SLEEP_US(t)		min(20000, (t) / 8)
+/* Make sure sleep time is <= 30ms for usleep_range */
+#define DPS310_POLL_SLEEP_US(t)		min(30000, (t) / 8)
 /* Silently handle error in rate value here */
 #define DPS310_POLL_TIMEOUT_US(rc)	((rc) <= 0 ? 1000000 : 1000000 / (rc))
 
@@ -402,8 +402,8 @@ static int dps310_reset_wait(struct dps3
 	if (rc)
 		return rc;
 
-	/* Wait for device chip access: 2.5ms in specification */
-	usleep_range(2500, 12000);
+	/* Wait for device chip access: 15ms in specification */
+	usleep_range(15000, 55000);
 	return 0;
 }
 


