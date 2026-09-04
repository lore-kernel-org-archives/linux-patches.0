Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6AB3A9629;
	Fri,  4 Sep 2026 05:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500265; cv=none; b=Ha4WtTAwqXncBN+AoVRTcmJKBgR7cEjnIlwZNZef2D/LG06QRwyvSaNbDQT00vko4mMS2jSVV1wlakfk83XZJk4RTK6qiGhhXUB0JuMgU12+0fX0G1H0tNwJDZ0eDH5A+l2t5jE/dqRm7kbdM03ynuHV31GXJfW6nJE83aJq7AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500265; c=relaxed/simple;
	bh=+4G3TlkxR8ozv59hS3VZanrwlx6B1/QcxQ1jnbm+o7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XjBdH+uv78MD8iE4nrObfV85JXu7ml/13ozkKHhnKDF89Or0GzB0oEAtFbHCvvuuu8gXqPA/bGz4J4NutMFeIeg7vrmQlGoVqlUNiBQi0SRW5MgG00Ji2yK6AHugVHPsJbJS8g08DVRN1M0GYujJi8BENo8s6ESu9ZYDADN6aDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=shGrA/tK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="shGrA/tK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0496E1F00A3D;
	Fri,  4 Sep 2026 05:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500264;
	bh=A5WjuemaDbTN8iGt8PgznmjHOelvWFzsI06KUQxBuKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=shGrA/tKr2Vp3eukIf2RqFjc7GVgEYP7o2uljOVSssXDANftHoD7wI65ZqZ4Qr60i
	 6BAD6S6C/N/HewsrcG+HEShGRC1ZTWnHQVgKHiaMMNXA4LNTkoNyB5Jtq2BgxlOAzH
	 cVEMpnFs8cCrldO+Msd2NQ7LysCALwzBD045VJJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh=20 ?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 7.2 708/713] timekeeping: Check the return value of tk_get_aux_ts64 in __do_adjtimex()
Date: Fri,  4 Sep 2026 07:01:16 +0200
Message-ID: <20260904045819.718887599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh (Schneider Electric) <thomas.weissschuh@linutronix.de>

commit 4b61084b11bcecce86d03804ff30f8d7b465593c upstream.

If the auxiliary clock is disabled during tk_get_aux_ts64() but is enabled
before tks->clock_valid is checked, then uninitialized stackdata will be
used in the calculations and indirectly leaked to userspace.

The same race window also exists after this change and also for the core
timekeeper. But in these cases the only effect would be incorrect
adjustments and this is userspace's responsibility to avoid this.

Fixes: 4eca49d0b621 ("timekeeping: Prepare do_adtimex() for auxiliary clocks")
Signed-off-by: Thomas Weißschuh (Schneider Electric) <thomas.weissschuh@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260731-timekeeping-aux-adjtimex-return-v1-1-b7fea4692886@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/timekeeping.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -2943,10 +2943,12 @@ static int __do_adjtimex(struct tk_data
 		return ret;
 	add_device_randomness(txc, sizeof(*txc));
 
-	if (!aux_clock)
+	if (!aux_clock) {
 		ktime_get_real_ts64(&ts);
-	else
-		tk_get_aux_ts64(tkd->timekeeper.id, &ts);
+	} else {
+		if (!tk_get_aux_ts64(tkd->timekeeper.id, &ts))
+			return -ENODEV;
+	}
 
 	add_device_randomness(&ts, sizeof(ts));
 


