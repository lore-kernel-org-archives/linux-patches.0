Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CF91DFE33;
	Wed,  6 Nov 2024 13:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898888; cv=none; b=UYggVojl2rEH8HwvP1TaHiFXC2b3a60kg8y7dHvph0/xNMMw3RdHNSdRkd2uUe+taRuSE0hARI4yAyzTUoVChH2UmrfU/bjeYWK4KR3x5y2GrtmhyOaLHZx95aDwK8etFzgwMzNvl4KuYD4UqCXopBcTa8HSyDref2oVRMZaelU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898888; c=relaxed/simple;
	bh=7il54zueROIAmBCDRp8OJ4JZ+kAJlPLNL7mFR45WDN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eB+lR18HRHdjP95Y4rsaAVtLv5f77FKccLteKmbXSlMKNE0vQEUM0LhVAyPrZmWSDt5DL2pSh2wO7p1GyyB6eHap4dkx/1Bq/ib+IlqgAh4gKgROMFr6nY5W7b2ugwK0FBdwMqHu22XEoLR/wq9t7bRVi0B4x8fHkZzWaizJQ/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hO0/BhTa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hO0/BhTa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27F7C4CECD;
	Wed,  6 Nov 2024 13:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898888;
	bh=7il54zueROIAmBCDRp8OJ4JZ+kAJlPLNL7mFR45WDN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hO0/BhTa0+zYKg9uep78W3uJgBLLQOSEpatiwdtjMNfdje2wpzFDqZDGfsV+NJ0KM
	 Ep9a55WZkf7n00P5sdG+2eBq76SoSSXTfSWpNkUdCxXlNlWDd/VgmGhdkvFc1JaE+Y
	 OEZTyM6Z93oQiH4LA7MYIEuaUmB5L2jfc0N/evYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cochran <richardcochran@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 352/462] posix-clock: Fix missing timespec64 check in pc_clock_settime()
Date: Wed,  6 Nov 2024 13:04:05 +0100
Message-ID: <20241106120340.224846036@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit d8794ac20a299b647ba9958f6d657051fc51a540 upstream.

As Andrew pointed out, it will make sense that the PTP core
checked timespec64 struct's tv_sec and tv_nsec range before calling
ptp->info->settime64().

As the man manual of clock_settime() said, if tp.tv_sec is negative or
tp.tv_nsec is outside the range [0..999,999,999], it should return EINVAL,
which include dynamic clocks which handles PTP clock, and the condition is
consistent with timespec64_valid(). As Thomas suggested, timespec64_valid()
only check the timespec is valid, but not ensure that the time is
in a valid range, so check it ahead using timespec64_valid_strict()
in pc_clock_settime() and return -EINVAL if not valid.

There are some drivers that use tp->tv_sec and tp->tv_nsec directly to
write registers without validity checks and assume that the higher layer
has checked it, which is dangerous and will benefit from this, such as
hclge_ptp_settime(), igb_ptp_settime_i210(), _rcar_gen4_ptp_settime(),
and some drivers can remove the checks of itself.

Cc: stable@vger.kernel.org
Fixes: 0606f422b453 ("posix clocks: Introduce dynamic clocks")
Acked-by: Richard Cochran <richardcochran@gmail.com>
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://patch.msgid.link/20241009072302.1754567-2-ruanjinjie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/posix-clock.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/time/posix-clock.c
+++ b/kernel/time/posix-clock.c
@@ -299,6 +299,9 @@ static int pc_clock_settime(clockid_t id
 		goto out;
 	}
 
+	if (!timespec64_valid_strict(ts))
+		return -EINVAL;
+
 	if (cd.clk->ops.clock_settime)
 		err = cd.clk->ops.clock_settime(cd.clk, ts);
 	else


