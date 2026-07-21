Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1412F35C699;
	Tue, 21 Jul 2026 21:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670949; cv=none; b=N7n/a0d6CzLTurv+CT9enWN69YODmfRv/mhVofnHb2VFpSCtxYLo3MBG7oOWpvQxRbPYTXhKaP3HsfORS/xKExPekMgLsAIjz4HAfM6MFaLqm7G+BsNP6CpUpPPxClegfhj310iWE8c9SdKOWPj2drsUwvvKEN1eH9FB6Q5VdR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670949; c=relaxed/simple;
	bh=qKKqGmsQCSRi276IRM1WrGMkwY/Zono0kkVXj874F10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=leZHR4fxtPqyToIrePbwofUbHCdKl3nxHcXjOSl5YcuN137Za9+PFB/rvr4Ly5QZ/TOjOpa9/9ZIF1QtbeCBQ3QguwediLvuyCiFwt43UDy1YK0/zeyhpMQiiS4ALzdPKAF6TgoU2SspNWyKmEWqLEPX/bHko2K1zFoAiGByh1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JgdqpM2l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JgdqpM2l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798ED1F000E9;
	Tue, 21 Jul 2026 21:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670948;
	bh=O4qh7aKruXY5kz2UUsPH1Oimht57phyh6+JngqhLBP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JgdqpM2lk8q3kJ1XXkYcYv835uMg0oTU8Skmujj1p9re0SfpH5qpIeRXuqFs2POV3
	 anXMb6+6FCNsxNpGqRLXAotT1fu5z1hVlnun5yRBtL99NyKuUeC8a8WUSDzrO4oUgl
	 hyaipv9OHMTl0pgxfV7BHGCWpjV0z93wFWA/eu7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 5.15 061/843] iio: light: opt3001: fix missing state reset on timeout
Date: Tue, 21 Jul 2026 17:14:56 +0200
Message-ID: <20260721152407.360619432@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Crofts <joshua.crofts1@gmail.com>

commit c123ca6ee26ad98f70a866ff428b08145c5a24fe upstream.

Currently in the function opt3001_get_processed(), there is a check
that directly returns -ETIMEDOUT if the conversion IRQ times out,
completely bypassing the err label, leaving ok_to_ignore_lock
permanently true, potentially breaking the device's falling threshold
interrupt detection.

Assign -ETIMEDOUT to the return variable and jump to the error label
to ensure ok_to_ignore_lock is properly reset.

Fixes: 26d90b559057 ("iio: light: opt3001: Fixed timeout error when 0 lux")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260525-opt3001-cleanup-v4-0-65b36a174f78%40gmail.com?part=1
Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/opt3001.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/iio/light/opt3001.c
+++ b/drivers/iio/light/opt3001.c
@@ -280,8 +280,10 @@ static int opt3001_get_lux(struct opt300
 		ret = wait_event_timeout(opt->result_ready_queue,
 				opt->result_ready,
 				msecs_to_jiffies(OPT3001_RESULT_READY_LONG));
-		if (ret == 0)
-			return -ETIMEDOUT;
+		if (ret == 0) {
+			ret = -ETIMEDOUT;
+			goto err;
+		}
 	} else {
 		/* Sleep for result ready time */
 		timeout = (opt->int_time == OPT3001_INT_TIME_SHORT) ?


