Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB3F306754;
	Fri,  7 Aug 2026 15:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117608; cv=none; b=qEuaj15rZHZalB8fcTBYW0iOcXdnvhzv13xvfXTEQxy92kLKW8ZZ5tmCcHWupQEq5BBtVj1bAEgVjXmKlBb9PxtkyMB0/i4e706Ck4l2Ibzj36JS1tUEM1FxonbyoZ/JVQVxUeOv9rO6vN2V/+wGsdzH6kNdAMqEiiQ+Kw1CmvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117608; c=relaxed/simple;
	bh=MHGyuUTn9mmbaPutAfcP4Dwo60jOHeolz44X+NGA1DQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KpZA9hk4HyBqlHVXSLaiGGoaSO40I6ZXVl/Rdxt6FFIv6JRJymk207jWVLqiqibjov//IsS5FK8sFwG8Z81L5VMiUAAKCVpWXfgTrjvA9lBjyBZSjrDGWHaOFWdELxahHFcgVflLHlVl1R/ZDZQUaa0ZZSvIcNwICmvZuQaBxbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vtT5oWdF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vtT5oWdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4131F000E9;
	Fri,  7 Aug 2026 15:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117606;
	bh=Ly80bfjr0CzsdoAmkntEzQVeQ//s4NRjSbLMbGq5YtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vtT5oWdFlnwP/SxHbcUJDNHQI+bG1hXD8lsFcsiTExNntkTcO3EkR3zBoLBW6Yle4
	 WMZuTbnVr39sctz3UUwB9F79NwFVi5U7AW4IH/mJOORAAfkNhoPbZzX9YdvfjSyYSR
	 IK1vPos5nElTK2Wx+pFT/xIDVmtVmz18vCm/mfOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Pavel Pisa <pisa@fel.cvut.cz>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 7.1 378/438] can: ctucanfd: use self-test mode for PRESUME_ACK
Date: Fri,  7 Aug 2026 16:39:34 +0200
Message-ID: <20260807143436.026174610@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


