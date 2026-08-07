Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D6D38947F;
	Fri,  7 Aug 2026 15:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116301; cv=none; b=KnGjJko/1dU4d1GiMQK5v0R1CSt3xtsXtfBDKqHCS79IXdqdC4ijZfwkI6hyuQ2s9xVKSh3/3jOdqcD1JgxAwuzrivfbI9OC0sCRhyZtZ6psGackZVXkYkRObNSRj05npMLCIH3FgyvAGShPp3hEnmf42xcOY9kDSw97pO6c3f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116301; c=relaxed/simple;
	bh=FfBWJbEvmkeu8kJg0f6bCGaOj39NpeHvUEJmUmD1+qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pdyv4Dv5PKM6QVW2/C27K4/E70MHq1fbBZnRSFxDjM+6eb9I9mQqfl8YrdpbFXqKOxH1fglks+D36gYcQ3XLkbCh9qmXHUSzvCzuGaCl0QrEgrYuue9izqZmCniBWygZKhUQjL/V9wQcwQ5kBgsY4nT7otq5b5/6zumjLITjBZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mJicxIl9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mJicxIl9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A651F000E9;
	Fri,  7 Aug 2026 15:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116300;
	bh=rO5Y/XxgJe8tjicw1Uu3r1pqkQqtlDDCkiCFtQxG6/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mJicxIl9wu6g/7m0dgDc/mjjMhL4dFEDGVkBgXarhakRjWyzbqJ/uwFW9AMtR0ff3
	 3fEQnWA/L6BUnNR9pAJFERlYhnc0852KOAiAdnrxpZGuVM+/dwEBaEj4k6q/bbOX38
	 AruQZTxIyzBQay89BY4ZJFuKm+XNWlrf5j9XMJbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Pavel Pisa <pisa@fel.cvut.cz>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 183/261] can: ctucanfd: use self-test mode for PRESUME_ACK
Date: Fri,  7 Aug 2026 16:39:00 +0200
Message-ID: <20260807143419.311805172@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

From: Avi Weiss <thnkslprpt@gmail.com>

commit c31a435933f18be0f874302161333e9f16e200a0 upstream.

Use self-test mode for CAN_CTRLMODE_PRESUME_ACK so transmitted
frames can complete without receiving an ACK.

ACK forbidden mode prevents the controller from acknowledging
received frames and does not implement the presume-ack behavior.

Fixes: 2dcb8e8782d8 ("can: ctucanfd: add support for CTU CAN FD open-source IP core - bus independent part.")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Acked-by: Pavel Pisa <pisa@fel.cvut.cz>
Link: https://patch.msgid.link/20260722192726.230729-1-thnkslprpt@gmail.com
Cc: stable@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/ctucanfd/ctucanfd_base.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/can/ctucanfd/ctucanfd_base.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_base.c
@@ -340,8 +340,8 @@ static void ctucan_set_mode(struct ctuca
 			(mode_reg & ~REG_MODE_FDE);
 
 	mode_reg = (mode->flags & CAN_CTRLMODE_PRESUME_ACK) ?
-			(mode_reg | REG_MODE_ACF) :
-			(mode_reg & ~REG_MODE_ACF);
+			(mode_reg | REG_MODE_STM) :
+			(mode_reg & ~REG_MODE_STM);
 
 	mode_reg = (mode->flags & CAN_CTRLMODE_FD_NON_ISO) ?
 			(mode_reg | REG_MODE_NISOFD) :


