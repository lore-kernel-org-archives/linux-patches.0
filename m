Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F048A1A3BB6;
	Thu, 15 Aug 2024 14:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730629; cv=none; b=QJB0RKUb2P0RezHJYF1bzQs3JGcSCNXouq17dRytv2EOXT+4id/u9ZoKcV9PEzSxbTh+9UhpxuHtPZoITjiLSbKCLhzV59oj+Hzo16ysDOGy/ju9LOTzMUUD45U7CbhFMTwLZyLYCSWgh5U2DP1UYEP/JzBIDi97kR2+6X6Z5eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730629; c=relaxed/simple;
	bh=79uUR7O/NWjIEcVEcDMP6OVUlh/oZYdFfuoabd2mbms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=URaikBDNrLBFtPl1y+cx1XanRb7ajYmM3VdGcUjVfxlPlUIV8sDs6uofEREPljUTjqCLF1EoyrKMiSp09RTe618K5ABh1DvDHb9QYZuComQv+J6A9+0O/RGOGIGLeaXPqiB8e6/Lkb9sCISNxdPYAE9PSCwy6OA16iUDaml8by4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BmrIMVa4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BmrIMVa4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F9AC32786;
	Thu, 15 Aug 2024 14:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730628;
	bh=79uUR7O/NWjIEcVEcDMP6OVUlh/oZYdFfuoabd2mbms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BmrIMVa4MUd9c8mAtj2vgJ1kM0lYa12RPGEQMYU43YO2yfuWuqYJlOr/1XU2eOsqT
	 YjhEvHMXU9qOQtiBA41qCBM3ISwx8v/Xed+EA2+URFNTMDC2VJgv+clcLu307ohQF+
	 iLa6yM2twg+6uz2yxQ/gBPICJGbQNgHtCL2gZyGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.15 437/484] timekeeping: Fix bogus clock_was_set() invocation in do_adjtimex()
Date: Thu, 15 Aug 2024 15:24:55 +0200
Message-ID: <20240815131958.337805087@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 5916be8a53de6401871bdd953f6c60237b47d6d3 upstream.

The addition of the bases argument to clock_was_set() fixed up all call
sites correctly except for do_adjtimex(). This uses CLOCK_REALTIME
instead of CLOCK_SET_WALL as argument. CLOCK_REALTIME is 0.

As a result the effect of that clock_was_set() notification is incomplete
and might result in timers expiring late because the hrtimer code does
not re-evaluate the affected clock bases.

Use CLOCK_SET_WALL instead of CLOCK_REALTIME to tell the hrtimers code
which clock bases need to be re-evaluated.

Fixes: 17a1b8826b45 ("hrtimer: Add bases argument to clock_was_set()")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/877ccx7igo.ffs@tglx
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/timekeeping.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -2459,7 +2459,7 @@ int do_adjtimex(struct __kernel_timex *t
 		clock_set |= timekeeping_advance(TK_ADV_FREQ);
 
 	if (clock_set)
-		clock_was_set(CLOCK_REALTIME);
+		clock_was_set(CLOCK_SET_WALL);
 
 	ntp_notify_cmos_timer();
 


