Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D9019F43A;
	Thu,  3 Jul 2025 14:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751553968; cv=none; b=ay2qzZYb6A3Z1bGqtoJWKpZhQDUeM1R1PYav9pa6VHfH5dUprHl5ouLxyxkutb7PQq1Wl7YtB11wuqqvUblWI4lgmXUFDFp7RLxxcO/z79QF5re2TysXBsCZHgF0OkT46ES0F34OCsYRKZyGcFVFxi3bO++99dZ5S7w6H+Sxxk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751553968; c=relaxed/simple;
	bh=2m1z/Ef9hyV9m0Ssll6Dkrv3x9R6ejjVyWrrGOUoSow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5IPVLz3RDdTCDrlUuOdySDwEEQkPamQAh0IYhQkhtRqAETQDSoEE5rzIEWChm5RFQtlGOdWphEWNLhi1IuHPm6s/L/W4uoPDOf+2vEqIc5tvj4Eq5Kn3KKbB3sgEVVDD/b1tX3v4GdnKKAi7TC6zOLqjikqHggUSbNVZGI7VQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eQjL7DYH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eQjL7DYH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2F9C4CEE3;
	Thu,  3 Jul 2025 14:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751553966;
	bh=2m1z/Ef9hyV9m0Ssll6Dkrv3x9R6ejjVyWrrGOUoSow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eQjL7DYH2z6vBnD63ge2VtHlso4y4agrwwnIpw3pRnrR3wrEoCSTwaT7/6bxavKSL
	 tbG2ZQnTvzk2S6Qplbdv8Io+2vWAkfFFD3DYxrH7zV91Iak51kEdo7D6obuFr6O+1S
	 LcLbJz9WT7Uhbr4i3LqEHSK7mrZOLE9QVI6lpe/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Purva Yeshi <purvayeshi550@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 039/218] iio: adc: ad_sigma_delta: Fix use of uninitialized status_pos
Date: Thu,  3 Jul 2025 16:39:47 +0200
Message-ID: <20250703143957.510075706@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

From: Purva Yeshi <purvayeshi550@gmail.com>

[ Upstream commit e5cdb098a3cb165d52282ffc3a6448642953ea13 ]

Fix Smatch-detected issue:
drivers/iio/adc/ad_sigma_delta.c:604 ad_sd_trigger_handler() error:
uninitialized symbol 'status_pos'.

The variable `status_pos` was only initialized in specific switch cases
(1, 2, 3, 4), which could leave it uninitialized if `reg_size` had an
unexpected value.

Fix by adding a default case to the switch block to catch unexpected
values of `reg_size`. Use `dev_err_ratelimited()` for error logging and
`goto irq_handled` instead of returning early.

Signed-off-by: Purva Yeshi <purvayeshi550@gmail.com>
Link: https://patch.msgid.link/20250410170408.8585-1-purvayeshi550@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad_sigma_delta.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/iio/adc/ad_sigma_delta.c b/drivers/iio/adc/ad_sigma_delta.c
index ea4aabd3960a0..3df1d4f6bc959 100644
--- a/drivers/iio/adc/ad_sigma_delta.c
+++ b/drivers/iio/adc/ad_sigma_delta.c
@@ -477,6 +477,10 @@ static irqreturn_t ad_sd_trigger_handler(int irq, void *p)
 		 * byte set to zero. */
 		ad_sd_read_reg_raw(sigma_delta, data_reg, transfer_size, &data[1]);
 		break;
+
+	default:
+		dev_err_ratelimited(&indio_dev->dev, "Unsupported reg_size: %u\n", reg_size);
+		goto irq_handled;
 	}
 
 	/*
-- 
2.39.5



