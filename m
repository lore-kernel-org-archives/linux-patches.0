Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3774B411A10;
	Fri,  4 Sep 2026 06:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501830; cv=none; b=s89b6+t1TtffvH3jKaqZS9G2fd1L/hjPuumy5/xsgdXKIShdiT1ydLFSos5JX4kH9w8oih79tJ8+TWATLqf9JCXY0JhEgPu0NfMdohFWsQlDV5KFgyFlUwX0zvgNL5qRxzGNBoXluNPF2Zgfu8EP6QCSoAYaOyWQOrOkcMpi2NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501830; c=relaxed/simple;
	bh=eDhDqRe4P+gihiqPHEDbhVz63ihtiIo4qBDgE7AYmJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q1fXzKxHxn3ZTThCkFX073JLZdg0veKIDpK3ntkSUiGuAkgl2TyGtcGsk6L1sn4rlpCuulYCZNPuRg4KC5o81UfEu4DpEnmDWGt26QT/nQtZ4rZBng4c3pJVN1RQoAaH/G33PEwwjFEipzobAnzfu3WH17aSgcKyYtw0acecbzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZTnhSQih; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZTnhSQih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8666A1F00A3D;
	Fri,  4 Sep 2026 06:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501829;
	bh=+AQ9xgYg9cEv6zHDLQ1/apI9vSet6cOq45Sd4+lAurI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZTnhSQih5zoi6oibIJ5qZnBhBX1MeJKPyPav+CV6jeYUvlcbcF5zoOnphWX/kYCDX
	 y8HruG479imqxTrP4/QslZ0Es6cG7ALXaZ3StrtBGTzvmJP65rp7PfGsX+HO1/jwTA
	 Y1qS/QdaKxgqMGtlR+cVIvrbnQyDbS2/6bYjtkkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh=20 ?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.18 548/552] timekeeping: Check the return value of tk_get_aux_ts64 in __do_adjtimex()
Date: Fri,  4 Sep 2026 07:01:45 +0200
Message-ID: <20260904045803.023353519@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2693,10 +2693,12 @@ static int __do_adjtimex(struct tk_data
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
 


