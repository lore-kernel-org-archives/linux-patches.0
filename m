Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE2022258C;
	Thu,  3 Jul 2025 15:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555936; cv=none; b=lz5//vwNS0tN43K2okQtKxFVsbBmTDKyBcxtbH4BA29ODomOKmY4MXxWNhiZ74UrBGhTYFDSnLlP6wGYdPnLi5wSd+4uF0LjQ5YQFJmWxlsOWCy8uCtQefAB+PO8aDG/96YAmkCDnDftM+sAZY3YZ+P76J0JLXNBg4QdYSqTa0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555936; c=relaxed/simple;
	bh=5YGjLGxDvaNPZWfWNwduBr7JQZifbakclCNLKzM+iAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qtkcM5MHp6JYVidtfhLRoZjyzqhiA52ltbwc1KIo0GMLVzAuO6S5Q4B0QS6XQFOkFLhC1PWyolMXRXFuZ0y6Zf4rZSlxwWuRDUkEuSMJiojK8qhg66vc5VOizJQ8FL0xR+V6MGweWprP7CQc2s+LaYj7JDDzZCdq/JLkNa3iEZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TTgPIkiz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TTgPIkiz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D327C4CEE3;
	Thu,  3 Jul 2025 15:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555935;
	bh=5YGjLGxDvaNPZWfWNwduBr7JQZifbakclCNLKzM+iAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TTgPIkizbKxR1omwqWDiXf7DmhMhM0GFNoA18g0WEmqGvJLnXQoF/+UtGwcJC6awv
	 j473gbcfga/36taLk6HXn2mdh3wJyHuBf18QwzsibwZbfPsjKTn0WSNnALRLajRUQE
	 kNBdPizQgQSVBTHMLsIBs/BaqeClcghpam4Pu8Ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Purva Yeshi <purvayeshi550@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/132] iio: adc: ad_sigma_delta: Fix use of uninitialized status_pos
Date: Thu,  3 Jul 2025 16:41:52 +0200
Message-ID: <20250703143940.310212395@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7e21928707437..533667eefe419 100644
--- a/drivers/iio/adc/ad_sigma_delta.c
+++ b/drivers/iio/adc/ad_sigma_delta.c
@@ -476,6 +476,10 @@ static irqreturn_t ad_sd_trigger_handler(int irq, void *p)
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



