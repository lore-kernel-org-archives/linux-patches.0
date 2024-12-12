Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DC46F2FE;
	Thu, 12 Dec 2024 15:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017787; cv=none; b=bkXWDYPrjqEHLIjPzEK8vRreXJ5FMpEiaNVydTcWXISqrnlQIwenpuf5yKo8Cc70MR7WImIp1+sfpzYg8eoI68juDc/vbOBgVRhTWjCClkbYde6jYavFbQzuiG6KgWvlwvDLTwdW+/Jqy/O2BakaLDTDt5+PkX4kwLqiBWLxXLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017787; c=relaxed/simple;
	bh=fiTVQAeKlA2woxG58y1xWPYxHaaEUpKJOWIN3EwMFno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OU0/cHbmEYJqaCJBQeLpuvB9xp7MSHeN7CsX53T9u8FSrQjR+DqXGVJSwxBNaIhQXAUzZpdA3sRaEEetiPV7LhNO517hnrgEy69wDgntOIZSlDxfuXwM1fPU6LtlWqJ3EBIhi7k65j73BYFZBePwLZrJfvy3e8F+SVcVaNZ19gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvqEadmG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvqEadmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4641BC4CECE;
	Thu, 12 Dec 2024 15:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017787;
	bh=fiTVQAeKlA2woxG58y1xWPYxHaaEUpKJOWIN3EwMFno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jvqEadmGMaYBnfScz1iXZ7gg9yXJ18PbvAFMzPsN6+EU5uBdc3RrD2hmrCYiFJzRj
	 GE2aEAsWUZLyc06dD2ixvJKfs0CNDw3WQgvkjPzg57vhExsOgN5UVvbOAigjEaoOsN
	 n+Z8MreozzRTfwXHAudV0sek7jHMoTcBuxMYgudc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcelo Dalmas <marcelo.dalmas@ge.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.6 093/356] ntp: Remove invalid cast in time offset math
Date: Thu, 12 Dec 2024 15:56:52 +0100
Message-ID: <20241212144248.289600610@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -796,7 +796,7 @@ int __do_adjtimex(struct __kernel_timex
 		txc->offset = shift_right(time_offset * NTP_INTERVAL_FREQ,
 				  NTP_SCALE_SHIFT);
 		if (!(time_status & STA_NANO))
-			txc->offset = (u32)txc->offset / NSEC_PER_USEC;
+			txc->offset = div_s64(txc->offset, NSEC_PER_USEC);
 	}
 
 	result = time_state;	/* mostly `TIME_OK' */


