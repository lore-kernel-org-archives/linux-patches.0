Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CA6169AD2;
	Tue, 16 Jun 2026 16:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629043; cv=none; b=FDZcd11x3dba0/BnsKSDeqKn22c6p5FRDSq7L1nu9Lia7sDOweHnyOFfDB/Jsjrkr5diWVyRgw/AckH+rRnL8xsCVzWdr+z6CcN4emevG+mKxx/PY9qjZEb6wwU7487SFvU6l3lqZ/2UYttN2a1UqYksqiS+ynGLsUe4oKBjSpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629043; c=relaxed/simple;
	bh=oOGaKVd23Z7NDJVFW5OmUTSmNQK7CIapb/EbN9mqGE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l8vl09bwYV8lTSM8iA3HxJD0pJbJFepC8zF/EhgXX/GPHgkTsMR/QGxY+0hanRn21F9rPRDCqF7qMUHUL8UTB+n0cFzc82X/etsncQCWT3u0V/fAKRsk9241NeJnR7jKDs39FShfhrlWgBPazlJvfuAwM9ShYyBYyO/bEmtHycU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P/7/kjjn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P/7/kjjn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859DF1F000E9;
	Tue, 16 Jun 2026 16:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629042;
	bh=Vdm0LgSDcAMiqRcz8jmdF3/60w4QVDDNSIQkj2EbSlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P/7/kjjnscqRliShtmem6lV/Cxs1daGpsQFXRg76nU9neJKHM7n5tuQPxeZFdC/sr
	 MQh+lXfL3ePtsixTxkU/EGQQCZ8zi3i1CcnGf6tl4ZHw/ShlSU2UM//+0teXJFdEc0
	 Xry2Ads/sOfCTSvEZ12+OTJhp2Yecq6iGn9jn4Fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH 6.6 183/452] serial: zs: Fix swapped RI/DSR modem line transition counting
Date: Tue, 16 Jun 2026 20:26:50 +0530
Message-ID: <20260616145127.458203960@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit d15cd40cb1858f75846eaafa9a6bca841b790a92 upstream.

Fix a thinko in the status interrupt handler that has caused counters
for the RI and DSR modem line transitions to be used for the other line
each.

Fixes: 8b4a40809e53 ("zs: move to the serial subsystem")
Cc: stable <stable@kernel.org>
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Link: https://patch.msgid.link/alpine.DEB.2.21.2604101747110.29980@angie.orcam.me.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/zs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/zs.c
+++ b/drivers/tty/serial/zs.c
@@ -679,9 +679,9 @@ static void zs_status_handle(struct zs_p
 			uart_handle_dcd_change(uport,
 					       zport->mctrl & TIOCM_CAR);
 		if (delta & TIOCM_RNG)
-			uport->icount.dsr++;
-		if (delta & TIOCM_DSR)
 			uport->icount.rng++;
+		if (delta & TIOCM_DSR)
+			uport->icount.dsr++;
 
 		if (delta)
 			wake_up_interruptible(&uport->state->port.delta_msr_wait);


