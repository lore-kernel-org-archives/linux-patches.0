Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1CD29ACCD;
	Fri, 21 Nov 2025 13:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732598; cv=none; b=kljSNIc5H9nV9WqLWZnoDl7Ncqqj3vsYKNdNS/3mPwXyFzTxcGNvCm4TyGNPSLr6gZwPbxq9UUan/3UwdyAj3zJNovL9R/aZ3piroSTx0lv4FOEojaB6z/esnj2GVPSEZcr6xIS/z5TaUfoA8fCBJBYRc+oG4n8ASVMDxXIS1c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732598; c=relaxed/simple;
	bh=eh3PeZICS8AwlEyMHPFKZGuSqnGx/OBDk/rqSQ4ZLTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/hpiBr334DrN0sMSnYFjy1EJVoRsefTX2Zm+SJYLr5nL1XG32Pu+yrNbNbPfvzz9u6acRLaWOOdicR0m+2MCT9pTr7o7tZnMK//JNy1M8dF+PhrstPuVvAd/QoPV7CetPIr/qqkBeSVl3bELXw4nSkPJizsW5SnTu9y9KjvL20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gx5OODcc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gx5OODcc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51805C4CEF1;
	Fri, 21 Nov 2025 13:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732598;
	bh=eh3PeZICS8AwlEyMHPFKZGuSqnGx/OBDk/rqSQ4ZLTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gx5OODccKASPR+5Jucr4Gd2VUurAg9h5Gqxd/6bODiYwumRw/FMQBz5kH++m9FgiY
	 t6I7862vheZVlnyTPAGG5IASh3ikH4WXKKKbNdhnv064Dq6qwl3aacb9ERU5SToRT2
	 /Qv1VAVXdhacL8yJORa5qCrWzfVggMYglBjKzQOA=
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
Subject: [PATCH 6.6 178/529] ptp: Limit time setting of PTP clocks
Date: Fri, 21 Nov 2025 14:07:57 +0100
Message-ID: <20251121130237.351296129@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0682bb340221a..d252d018bfe77 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -83,6 +83,9 @@ static int ptp_clock_settime(struct posix_clock *pc, const struct timespec64 *tp
 		return -EBUSY;
 	}
 
+	if (!timespec64_valid_settod(tp))
+		return -EINVAL;
+
 	return  ptp->info->settime64(ptp->info, tp);
 }
 
@@ -113,7 +116,7 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
 	ops = ptp->info;
 
 	if (tx->modes & ADJ_SETOFFSET) {
-		struct timespec64 ts;
+		struct timespec64 ts, ts2;
 		ktime_t kt;
 		s64 delta;
 
@@ -126,6 +129,14 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
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



