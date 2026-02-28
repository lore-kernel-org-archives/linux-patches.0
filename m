Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB65421A16
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301149; cv=none; b=BsoIe3jpdX8CcL0tsOfzYShJ+XV+6HSDB5FwHif/SArndztzOgTSNlpQ+MLtO4sxKbVyCWg6PSO3ySZvyX6b5Vb4OWnWu9USlv96siGwlSUlg6phyQwKvZYJ1zhgKzDRRMEtsbaQ101bjOKvwLyV01OI78tvFSFcctYH+ovsGb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301149; c=relaxed/simple;
	bh=p0/zZUD++Cy59dQpIM9ZPgWXbqQmfQZVC5X+V6bLGmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oo3mUzRXG2bzmXskMwMhgmpC1uhbI+wnZGszkx6RueVs58J/tid7ZocqBgkeUrW+MAgyVwOslQ6wTLFL1lIrWbGgcRDJhUdrnvO3WZlGC1bW3wQxzt/NpsjvfaRf1KIYHJJJUqGVCB8J4OVEHir0XJOYC/lZOOnRyWsdRJxgqJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eRLFic+3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eRLFic+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F70C116D0;
	Sat, 28 Feb 2026 17:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301149;
	bh=p0/zZUD++Cy59dQpIM9ZPgWXbqQmfQZVC5X+V6bLGmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eRLFic+318amKeaNyjqbO0Ts521Sb7ekNfMR9TFSKK1JcewWMe6pEOvTsIoqmbCu8
	 qPTuoOtnZAI2Z21mQDD1ldzz/5potqo9OLECSg2QPhke5I8GmU0XsC6vOoqKRgDHOB
	 HQI/sbl7Av7K+rVC5RJQd2tSprrEtMg7Kn4uzM5ux9LS6TCtEBvfc48Y2dtc5O+edO
	 28hq6sxvEk5PkhZXsqZYb2oxQmhnPc3YJs4EPiR4WvmeOvMohVE0l3x3LnRerJHhU+
	 ap9L8lsRHU13PiiovkLYreABG+SfIIKWwSZWhIwshqFg6rjkxdxl2EuW/zQqGKmTuK
	 TK7YXpWaapaEQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Mark Brown <broonie@kernel.org>,
	Aishwarya TCV <Aishwarya.TCV@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 311/752] mailbox: pcc: Remove spurious IRQF_ONESHOT usage
Date: Sat, 28 Feb 2026 12:40:22 -0500
Message-ID: <20260228174750.1542406-311-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 673327028cd61db68a1e0c708be2e302c082adf9 ]

The PCC code currently specifies IRQF_ONESHOT if the interrupt could
potentially be shared but doesn't actually use request_threaded_irq() and
the interrupt handler does not use IRQ_WAKE_THREAD so IRQF_ONESHOT is
never relevant. Since commit aef30c8d569c ("genirq: Warn about using
IRQF_ONESHOT without a threaded handler") specifying it has resulted in a
WARN_ON(), fix this by removing IRQF_ONESHOT.

Reported-by: Aishwarya TCV <Aishwarya.TCV@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/pcc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/pcc.c b/drivers/mailbox/pcc.c
index 0e0a66359d4c3..713022aed2e2f 100644
--- a/drivers/mailbox/pcc.c
+++ b/drivers/mailbox/pcc.c
@@ -459,7 +459,7 @@ static int pcc_startup(struct mbox_chan *chan)
 
 	if (pchan->plat_irq > 0) {
 		irqflags = pcc_chan_plat_irq_can_be_shared(pchan) ?
-						IRQF_SHARED | IRQF_ONESHOT : 0;
+						IRQF_SHARED : 0;
 		rc = devm_request_irq(chan->mbox->dev, pchan->plat_irq, pcc_mbox_irq,
 				      irqflags, MBOX_IRQ_NAME, chan);
 		if (unlikely(rc)) {
-- 
2.51.0

