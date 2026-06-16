Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBF43A3E78;
	Tue, 16 Jun 2026 17:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631220; cv=none; b=P0PbCn/TLsce54upU4FrF2skxcOrkx9GB5hkhJsR+snTmii6caTI3R2wkGJmqQ/QKN9Pr+GuqNotBHITK9zcxRm4KfVCPmVcg9O+Tr3kVZ9bwKBX4Ku5jvHG9U8axfME/cRQwVQxOaG62FfWL/+lzeXDiewzgDQbz02ceDLahX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631220; c=relaxed/simple;
	bh=EutNSmB8HfoL3V0U7GSLxfnWT0BTY0LnU54psGBocWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tiOsJunk/oT0dWMH1mYwoHVD7+lmGOf6tcdfGb15ltTYDTpXKIFkKRlFpgeP9GEejD3KV+dRDt/ONv9ViPU9THX3HZwSF5sTQb/kfzBBIaT5M8KRPqd7qyQr0Wd8dfgBzLseYk5OWt+Qw/DxekxOeIwqIXWWfDqmDK3sAGbswb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aEpmd2zV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aEpmd2zV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DFDB1F000E9;
	Tue, 16 Jun 2026 17:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631219;
	bh=7oVSvDIo5G/4rGRvkplnTLylwjOX+2wteQ6d1JyU9T0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aEpmd2zV8g4wSs3TZGQD/SlizgX+NYnFuNvCXGN4mJvajjcl94uun5WqTDy8Tv39u
	 psgy4Ct86ZBmo+/qUBpFmCRw7XXzAOBYM2Kpdcby+wYovu2pDMPZlQt8uWDh+JdrV/
	 0BQavr7A1bpgtFR2ZElOBTQlzBohJ4rzPVL6U38M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH 6.1 172/522] serial: zs: Fix swapped RI/DSR modem line transition counting
Date: Tue, 16 Jun 2026 20:25:19 +0530
Message-ID: <20260616145134.197912777@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


