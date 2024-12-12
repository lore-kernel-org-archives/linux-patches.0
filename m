Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7A6215764;
	Thu, 12 Dec 2024 15:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015887; cv=none; b=Jgtih2TVV12AVAga/N+ObBMK6i88tjfJWoEPQjUsPDNaOArnuiA8ldJu7nnHUG9Wl3pEy3k2+5MxvS+VE29ktPPUv/Eb+917JWP/GInSMDu5778ZieczbyiYWh4qksT8+8bvc+l/Ex8Yim1FH1YtEcixBm/OL1zPd1p/lZ19xcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015887; c=relaxed/simple;
	bh=O6Nf3W/WgNKBibPilFe2YHF4BLGWgr5WLPNPg5w+jP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCBxxb+JHE528i66UdtMezbA+3Fik5LjDZVgQY4b+dqipGz6xUZ9z7axXr1PQ82Jpt/m/TPI+IPE85s756m6qVzNw8G0ERo8lA6zVbwZlvuQXSoeJNhwVs0NBnglxFxIJoc/wRS6/9Ckh7IxLaQMKzl+dZ6oDB/FY3TzghNsZMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iNOcXhZ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iNOcXhZ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4049C4CED0;
	Thu, 12 Dec 2024 15:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015887;
	bh=O6Nf3W/WgNKBibPilFe2YHF4BLGWgr5WLPNPg5w+jP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iNOcXhZ9mTf/HHZEzYMh/g/lDOsc0IFsHgUNKJ4iuxZsAlC8Knpo3rEkPca4MGDqi
	 z8JyO+OibBvhD5p/ArTC6UI3XEpXWkhdmHl3pHhMSHLfOHInIoLgNITu3qoLFOlbS6
	 IZtt6hGOdhKSyHU8zsq8A6HMTvKCFsNrwcmMoxWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcelo Dalmas <marcelo.dalmas@ge.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.12 072/466] ntp: Remove invalid cast in time offset math
Date: Thu, 12 Dec 2024 15:54:01 +0100
Message-ID: <20241212144309.659595760@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Dalmas <marcelo.dalmas@ge.com>

commit f5807b0606da7ac7c1b74a386b22134ec7702d05 upstream.

Due to an unsigned cast, adjtimex() returns the wrong offest when using
ADJ_MICRO and the offset is negative. In this case a small negative offset
returns approximately 4.29 seconds (~ 2^32/1000 milliseconds) due to the
unsigned cast of the negative offset.

This cast was added when the kernel internal struct timex was changed to
use type long long for the time offset value to address the problem of a
64bit/32bit division on 32bit systems.

The correct cast would have been (s32), which is correct as time_offset can
only be in the range of [INT_MIN..INT_MAX] because the shift constant used
for calculating it is 32. But that's non-obvious.

Remove the cast and use div_s64() to cure the issue.

[ tglx: Fix white space damage, use div_s64() and amend the change log ]

Fixes: ead25417f82e ("timex: use __kernel_timex internally")
Signed-off-by: Marcelo Dalmas <marcelo.dalmas@ge.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/SJ0P101MB03687BF7D5A10FD3C49C51E5F42E2@SJ0P101MB0368.NAMP101.PROD.OUTLOOK.COM
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/ntp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -804,7 +804,7 @@ int __do_adjtimex(struct __kernel_timex
 		txc->offset = shift_right(time_offset * NTP_INTERVAL_FREQ,
 				  NTP_SCALE_SHIFT);
 		if (!(time_status & STA_NANO))
-			txc->offset = (u32)txc->offset / NSEC_PER_USEC;
+			txc->offset = div_s64(txc->offset, NSEC_PER_USEC);
 	}
 
 	result = time_state;	/* mostly `TIME_OK' */


