Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624136;
	b=lgW6/kH2z0IBg/iBozr215SY9WiYyHnaFjvwp5ZvN+KMCRdfuHveOMqlQYlzdeSObclc
	 2Vgblwam47rHgh/NOCF1v3JSyus9Eg64NxooRELUiv5ShP7VHmabE+lF6S5weB2C7gV7h
	 syeZAUFY6LU9z/qbpTS5+pZLqgsUeQh3k33AhV23Ki551qFdOXzVPRoInp+AelF03lir/
	 lHYAIAhLDnscspffr+ghB3O+SIOt1SEKg3V3eEO24VW5MlUHfmZhlhzfwCVsb8l88EK4U
	 eHTmt5jfvz+DqE5ugZzYwSmwkIqWd2HWTaGyT5lYDuAfPppq8X3mKHrQftx/wvBRE5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624136;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VaOSfAIVqrIV8d888oOt6Ji/tyob6OF1ueIuvYFpXx4=;
	b=CWRjCYGHPmvZv/pDpksEMDSaQSjAeaL3geuYNFzahXMy5NEQ9tOW8Lsq6K2QUg1fVRU8
	 Ip2xhlz49XXVDkX7s6NtEQC3DQLPFx05GG3hRkgLXfazfVAK0i/BGSnUknO8FjUA6sCYb
	 0ATbjbpjS2y3qbhgIMFWHJYtcf8Nl3l4Z7p9XcTV+uOxa7n8YtnJcTvRWe5tjTROI6Qbt
	 svPYGUBmJnLfBPLTkEgsvgwPdAQZELo8bMvz7gmAiFwsgLOkjB6b5kT+clu3bruvAucXA
	 FcV/aa9DSPTJwRkemZiUxzXWKh9t/eXrX8etrjScb5tMfAhxVWw31Q0PueBimLVmk7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="WcMZdsM/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE01F606A327;
	Wed, 25 Nov 2026 16:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WcMZdsM/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069501F000C4;
	Wed, 25 Nov 2026 16:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624136;
	bh=VaOSfAIVqrIV8d888oOt6Ji/tyob6OF1ueIuvYFpXx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WcMZdsM/c2T2pHF5EiALVWwgSbVviLsYqaFZsn+8sy7E0/lh8GvUm4mlFTpAYPVYw
	 JMZyDFE3VUi4eQ8joHiCl9QSJk02HKFeCNPi5dYf7eVpQD5wNSCWIGwdiItdUAGycN
	 BLjSQmmFs85goawl0Lq2JI5rGSwPYusjVqu4p/Oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Hilliard <james.hilliard1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/816] ptp: vclock: serialize extended samples with counter updates
Date: Wed, 25 Nov 2026 15:27:08 +0100
Message-ID: <20261125143851.073140509@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Hilliard <james.hilliard1@gmail.com>

[ Upstream commit d3fcce5afe3bb62e8f7a2efb29e43da4fe4ae1f3 ]

The extended and cross-timestamp callbacks sample the physical clock
before taking the virtual clock mutex. A concurrent frequency adjustment
can advance the timecounter and change its multiplier in between, so the
older sample is converted using a different frequency than the one in
effect when it was taken.

Take the mutex before sampling and keep it held through the conversion.
Retain timecounter_cyc2time() and its existing conversion window. A PHC
sample need not advance the counter: for example, e1000e explicitly
allows non-monotonic SYSTIM readings. Treating a slightly older sample
as a forward delta would instead advance virtual time by nearly a full
counter wrap.

This race was found by code inspection of the virtual clock sampling
paths.

Fixes: f0067ebfc42b ("ptp: add gettimex64() to virtual clocks.")
Fixes: 21fad63084c2 ("ptp: add getcrosststamp() to virtual clocks.")
Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
Link: https://patch.msgid.link/20261026-ptp-vclock-sampling-v6-4-e705612541f1@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_vclock.c | 32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/ptp/ptp_vclock.c b/drivers/ptp/ptp_vclock.c
index 2016e2481580e..c047a1222ea43 100644
--- a/drivers/ptp/ptp_vclock.c
+++ b/drivers/ptp/ptp_vclock.c
@@ -115,20 +115,18 @@ static int ptp_vclock_gettimex(struct ptp_clock_info *ptp,
 	struct ptp_clock *pptp = vclock->pclock;
 	struct timespec64 pts;
 	int err;
-	u64 ns;
-
-	err = pptp->info->getcyclesx64(pptp->info, &pts, sts);
-	if (err)
-		return err;
 
 	if (mutex_lock_interruptible(&vclock->lock))
 		return -EINTR;
-	ns = timecounter_cyc2time(&vclock->tc, timespec64_to_ns(&pts));
-	mutex_unlock(&vclock->lock);
+	err = pptp->info->getcyclesx64(pptp->info, &pts, sts);
+	if (!err) {
+		u64 ns = timecounter_cyc2time(&vclock->tc, timespec64_to_ns(&pts));
 
-	*ts = ns_to_timespec64(ns);
+		*ts = ns_to_timespec64(ns);
+	}
+	mutex_unlock(&vclock->lock);
 
-	return 0;
+	return err;
 }
 
 static int ptp_vclock_settime(struct ptp_clock_info *ptp,
@@ -154,20 +152,18 @@ static int ptp_vclock_getcrosststamp(struct ptp_clock_info *ptp,
 	struct ptp_vclock *vclock = info_to_vclock(ptp);
 	struct ptp_clock *pptp = vclock->pclock;
 	int err;
-	u64 ns;
-
-	err = pptp->info->getcrosscycles(pptp->info, xtstamp);
-	if (err)
-		return err;
 
 	if (mutex_lock_interruptible(&vclock->lock))
 		return -EINTR;
-	ns = timecounter_cyc2time(&vclock->tc, ktime_to_ns(xtstamp->device));
-	mutex_unlock(&vclock->lock);
+	err = pptp->info->getcrosscycles(pptp->info, xtstamp);
+	if (!err) {
+		u64 ns = timecounter_cyc2time(&vclock->tc, ktime_to_ns(xtstamp->device));
 
-	xtstamp->device = ns_to_ktime(ns);
+		xtstamp->device = ns_to_ktime(ns);
+	}
+	mutex_unlock(&vclock->lock);
 
-	return 0;
+	return err;
 }
 
 static long ptp_vclock_refresh(struct ptp_clock_info *ptp)
-- 
2.53.0



