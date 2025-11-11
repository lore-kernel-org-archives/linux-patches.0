Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB263396F7;
	Tue, 11 Nov 2025 01:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824980; cv=none; b=HPOXpxib93GasGG4qOMdLLymugSX5w+1LrEhBQ6sskmExEu9PZwqP2YMethCR8aNAAVbXGRaGCuPaPtAd5YI/5AXF413XTJbTC+7JT2KrDW90BZjKXvI4rxzdpgofjwxJ4cgOSOjj1eCLohbXW649Fegfttn1Cq5tHAFmGtLjAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824980; c=relaxed/simple;
	bh=GOwHvvyU/AHp7VITo75xJU/r+a0uhMpacMfSdy68yTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q5IOu2yL4KXrvoj/RptM5GwBBpCZ2Men6VGOLM6j+U+xVPABe+QtqhpTMXRpklwhNEkUH54bXsI9GO2MI8OKzLO3HteGPmznDnR4jTp7Qi8NBkQEv1RqaHvgEaRiPBow+U6pRECN4z59dQBk9sNl8qv7YvoM1awEtPbZ44ASFB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ePXdEJ7p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ePXdEJ7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3184C116D0;
	Tue, 11 Nov 2025 01:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824980;
	bh=GOwHvvyU/AHp7VITo75xJU/r+a0uhMpacMfSdy68yTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ePXdEJ7p9HtvIJqCTPyJPzHYsiTVbxaUX9neQaGUsUA2U3bilf7ABOQ+zWd4maPaW
	 bUUO7SM93PY8PIYIDT0NrWXGQKWyP9ObLW+0rit/vaPEADnQi7loXs+RWxXf1SwYmu
	 z9x/XC/0Q6kFGhg/3wK/u90Pu7pxComcGIKCeqsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 609/849] ptp_ocp: make ptp_ocp driver compatible with PTP_EXTTS_REQUEST2
Date: Tue, 11 Nov 2025 09:42:59 +0900
Message-ID: <20251111004551.149723722@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vadim Fedorenko <vadim.fedorenko@linux.dev>

[ Upstream commit d3ca2ef0c915d219e0d958e0bdcc4be6c02c210b ]

Originally ptp_ocp driver was not strictly checking flags for external
timestamper and was always activating rising edge timestamping as it's
the only supported mode. Recent changes to ptp made it incompatible with
PTP_EXTTS_REQUEST2 ioctl. Adjust ptp_clock_info to provide supported
mode and be compatible with new infra.

While at here remove explicit check of periodic output flags from the
driver and provide supported flags for ptp core to check.

Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20250918131146.651468-1-vadim.fedorenko@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_ocp.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index f354f2f51a48c..a5c3632529862 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1485,6 +1485,8 @@ static const struct ptp_clock_info ptp_ocp_clock_info = {
 	.pps		= true,
 	.n_ext_ts	= 6,
 	.n_per_out	= 5,
+	.supported_extts_flags = PTP_STRICT_FLAGS | PTP_RISING_EDGE,
+	.supported_perout_flags = PTP_PEROUT_DUTY_CYCLE | PTP_PEROUT_PHASE,
 };
 
 static void
@@ -2095,10 +2097,6 @@ ptp_ocp_signal_from_perout(struct ptp_ocp *bp, int gen,
 {
 	struct ptp_ocp_signal s = { };
 
-	if (req->flags & ~(PTP_PEROUT_DUTY_CYCLE |
-			   PTP_PEROUT_PHASE))
-		return -EOPNOTSUPP;
-
 	s.polarity = bp->signal[gen].polarity;
 	s.period = ktime_set(req->period.sec, req->period.nsec);
 	if (!s.period)
-- 
2.51.0



