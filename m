Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C992D979C;
	Tue, 11 Nov 2025 01:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823583; cv=none; b=DwbllSBoa/4oLVjXM/9aE3ij1qfoGFDgmohjOlxfb2ll81dNE4Ivjs3dW/F10jGCMzb4MhBtib26uhcFazIvv2/5F/pH3geFX5BZ4ZtVo4XDndUI8PMPbmgd5/F+1uCYFLXBp6UAJGVCGyumzSvzUdIvvNolPMt5YW+IaSYwIk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823583; c=relaxed/simple;
	bh=TXWRpJZsAcN1z0/NAAAGRUWZzdiiGNFp8iQFbZIYN5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cdN6X0UnX9daBwlmh2jafIf2zORWNKaWG+qpgcxu3xtUjcNEi5eBxxm9Q4lLDLGiNDQefAxE9Ajfu2E1I010xxpcx09e8a7iENFM/xt4ERKdAiz4+2U1NZuZwk4NR+54f559J87qzilKR+JQj/t+8NiB8vglrCVDqPGOlooAg2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mIJh1vgt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mIJh1vgt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E5F9C4CEF5;
	Tue, 11 Nov 2025 01:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823583;
	bh=TXWRpJZsAcN1z0/NAAAGRUWZzdiiGNFp8iQFbZIYN5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mIJh1vgt9W66w3xkSacPhu7359v7bVI+JKjus6iVghAr3+XaMDPRGa1I92YTfkV3I
	 PGM7goPTKIRCgsC53DwPv7lbldyAsjpkmrsFPZRf6cZslHtoxtHBOiQMd6mCbIILdb
	 vkaMLAByaVeGwObqL84iS8eY7fFDioxFGD5sf7So=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miroslav Lichvar <mlichvar@redhat.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	John Stultz <jstultz@google.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 280/565] ptp: Limit time setting of PTP clocks
Date: Tue, 11 Nov 2025 09:42:16 +0900
Message-ID: <20251111004533.179997626@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miroslav Lichvar <mlichvar@redhat.com>

[ Upstream commit 5a8c02a6bf52b1cf9cfb7868a8330f7c3c6aebe9 ]

Networking drivers implementing PTP clocks and kernel socket code
handling hardware timestamps use the 64-bit signed ktime_t type counting
nanoseconds. When a PTP clock reaches the maximum value in year 2262,
the timestamps returned to applications will overflow into year 1667.
The same thing happens when injecting a large offset with
clock_adjtime(ADJ_SETOFFSET).

The commit 7a8e61f84786 ("timekeeping: Force upper bound for setting
CLOCK_REALTIME") limited the maximum accepted value setting the system
clock to 30 years before the maximum representable value (i.e. year
2232) to avoid the overflow, assuming the system will not run for more
than 30 years.

Enforce the same limit for PTP clocks. Don't allow negative values and
values closer than 30 years to the maximum value. Drivers may implement
an even lower limit if the hardware registers cannot represent the whole
interval between years 1970 and 2262 in the required resolution.

Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <jstultz@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20250828103300.1387025-1-mlichvar@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_clock.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 642a540861d43..03c17b1db7aac 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -100,6 +100,9 @@ static int ptp_clock_settime(struct posix_clock *pc, const struct timespec64 *tp
 		return -EBUSY;
 	}
 
+	if (!timespec64_valid_settod(tp))
+		return -EINVAL;
+
 	return  ptp->info->settime64(ptp->info, tp);
 }
 
@@ -130,7 +133,7 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
 	ops = ptp->info;
 
 	if (tx->modes & ADJ_SETOFFSET) {
-		struct timespec64 ts;
+		struct timespec64 ts, ts2;
 		ktime_t kt;
 		s64 delta;
 
@@ -143,6 +146,14 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
 		if ((unsigned long) ts.tv_nsec >= NSEC_PER_SEC)
 			return -EINVAL;
 
+		/* Make sure the offset is valid */
+		err = ptp_clock_gettime(pc, &ts2);
+		if (err)
+			return err;
+		ts2 = timespec64_add(ts2, ts);
+		if (!timespec64_valid_settod(&ts2))
+			return -EINVAL;
+
 		kt = timespec64_to_ktime(ts);
 		delta = ktime_to_ns(kt);
 		err = ops->adjtime(ops, delta);
-- 
2.51.0



