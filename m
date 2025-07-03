Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCC62E62CD;
	Thu,  3 Jul 2025 14:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554701; cv=none; b=cTHBLt/xc7oaDdYonJCJWA+uL+wpgfmQC3zBwneQKXgbrasYA+W8ITK9iTTEzXo7FUVmCmLMDsTvpnkcfkUy5z51XuuMUFvkPOspEZT9Osj10GROJp0G7MiNay4WKvOfOv6As1fK5J9zZvxLR39Sy2TIURwwQBPyF1V+aIXtKno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554701; c=relaxed/simple;
	bh=JTixKZ5Qsi0slff/BV+DUrt5GmwiNY1O05q7gls8OHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QI+SPtY+3cXoOz1vbQO10J5IOPJTPtc2l3XG2JQCJmLn4ARfaXly91sNShyxDJywIKlfSeIX4pDuo4vuu5cbyfPjBfyDBn1O5Qflx/KZ6JTFHynHqatr4ZdPAYJyRbgdxPuQpj1CwGI/hjypcU4eiBtfyzGaVN6zUFjVYvhmyoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C6fp1ClJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C6fp1ClJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02FDCC4CEE3;
	Thu,  3 Jul 2025 14:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554701;
	bh=JTixKZ5Qsi0slff/BV+DUrt5GmwiNY1O05q7gls8OHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C6fp1ClJ9AXW2mDyFryNskMl/pyCvp+gNi+lIbgyf4d8AxnfKuViwP2ZgxDo1kgY3
	 PqkEGLDX0pDPdIHZ+41th2zdThp64b2ko7D9Q58KCeTUuVNvRvUSL25+A1lba1h+jr
	 p4V0m4zxPh/2vsqc9V5RvTqdnVgS6plmtkpoIHd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Purva Yeshi <purvayeshi550@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 051/263] iio: adc: ad_sigma_delta: Fix use of uninitialized status_pos
Date: Thu,  3 Jul 2025 16:39:31 +0200
Message-ID: <20250703144006.348123671@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6c37f8e21120b..4c5f8d29a559f 100644
--- a/drivers/iio/adc/ad_sigma_delta.c
+++ b/drivers/iio/adc/ad_sigma_delta.c
@@ -587,6 +587,10 @@ static irqreturn_t ad_sd_trigger_handler(int irq, void *p)
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



