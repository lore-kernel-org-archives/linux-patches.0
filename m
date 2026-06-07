Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8736F32FA3C;
	Sun,  7 Jun 2026 10:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829758; cv=none; b=NrkytENeVdySHxTZfrtZQhXkg6dta+1FR3Y9bf4Nuok18Zw7lUDyQ55aCeNllKQJ0mBuyrWL0a2TC51WTnAJs6m5b6/ga7FeWu0P6awumBrnJUs4rRPJnQGeiNGleHv7eu24MILloTk9Kewe/uZktEFHkDPJrfkHGf2psKUbHKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829758; c=relaxed/simple;
	bh=GFRLUA503+NyWwogCvM7TXayGDUvpq44vFF1dwADX2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OdeyrkwN624DkEo6af8P5tDdaE1aDimribYhB0TECBjrMwXqdoEunNO8TdRlBF/nCqQDXDlCuom1NtAJa6hA9Vlxzzp3dOFkmXNmccVVFT5Wku3k/+DNAA4Bhco2fpYRHFgX6yPxiyXtTHgTgBwzlvKrffCbpY1c1zpsJwefAfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B6x6uRvE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B6x6uRvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC0B1F00893;
	Sun,  7 Jun 2026 10:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829757;
	bh=ereFox/kxTHoh0pGkz+OrPZUCJVOitW1WF73WfHyDQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B6x6uRvEA/OMhZ62YLji0AODZC8x60Cdz4Nm3Pg+SUhUpzeRaKvudCEk9L5hHboMt
	 famTyMj6wun234edHznTnFUCi224k4zQxYNxfyiqK0kHc0yWH0qPMyEf2NcSPTzIjb
	 B9cLJz0yVW7Pi0RUHns5LCQ5idO9Cmo68K0MbeR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH 6.12 251/307] serial: zs: Fix swapped RI/DSR modem line transition counting
Date: Sun,  7 Jun 2026 12:00:48 +0200
Message-ID: <20260607095736.912006871@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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
@@ -680,9 +680,9 @@ static void zs_status_handle(struct zs_p
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


