Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0A348A2C5;
	Mon, 31 Aug 2026 13:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183508; cv=none; b=UWR5iWHwCbWYO94Ye+AGfuSztGKd0eFxftUs4q1bVj3TfEm1FhiZpSWkUYtvsZknVvK0M6zPOXcosEWsVznlJBPR4SPLMgdXP56X0IbZsW4qGf1SGgvGUthM0EjwoY48LMBw+BLYZJSvPHLpnZYNtxeW/BdeiCNwA5Vy0j8PCzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183508; c=relaxed/simple;
	bh=I5k6oZYNED0S9Sr3Fc853uZY28CYHoSUxiqL+72Z7BU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fGG7/O0ZbRG+JYxkKCF/4LjUaE7nzwf2/0rPE0HApM8n2GqfJrFifEEC4kHDtqBKUbsiaBR4l5BowSkh4ZrQqX0i7T7un3wceg6freWPKYbX7UcGQTKVS5Yd6mp4XIiT0S2sASRoW4MMJjemqu5X3o8z0rmq7WVOm6yxtdJKstA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q9vxq5XX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q9vxq5XX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870291F00A3F;
	Mon, 31 Aug 2026 13:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183506;
	bh=7yrf8epqyZ5YYJ+R/+rxw0vvddsOggKjg/K8quce0Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q9vxq5XXb8byQ/uGajYAmCRzJLGQ7ig+IU/0ulWfV3OsUa1S7Ko0Fs7N8To0VRTaN
	 ND8sgziIo/idwEPPPgWwzd0reyk3TiqyV07ghDc883cPxZYSNV6RwOw75j9IA4UksX
	 aEf8vgRXPcuv4jYakjJtbv7t4E5Q13IlD27X/K/sHC4ezk4NS1YFfwowTUm4lCYQe6
	 DuOa/RU0pIRnhOaXkHVcTfpiuMLx+oklzyNOlDVFPw+yneWIR8oi5VSrURDp5UAqAJ
	 0Y7PwNnw/6YQkuHIvpI5tfGxCxBeKsnYU7CA0wUc/9c4fCLD8Ru7dGVyFD7QcvJ+np
	 cGuv4I2/s5IGQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	richardcochran@gmail.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] ptp: ocp: add shutdown callback
Date: Mon, 31 Aug 2026 09:22:45 -0400
Message-ID: <20260831133314.4125787-137-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vadim Fedorenko <vadim.fedorenko@linux.dev>

[ Upstream commit f6f955cbf9d4e02deebe54ca91c118b53be9ffe6 ]

The shutdown callback was never implemented for this driver, but it's
needed because .remove() callback is never called during kexec/reboot
process. That leaves HW with some interrupts enabled and may cause
spurious interrupt while booting into a new kernel during with kexec.
If it happens that I2C interrupt fires during kexec, the whole I2C bus
is disabled leaving TimeCard with no devlink communication. The same
happens if timestampers were enabled, leaving the card without
timestamper interrupts until full reboot cycle.

Implement .shutdown() callback with the same function as remove
callback.

Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20260611190333.787132-1-vadim.fedorenko@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
The `ptp_ocp` driver dates back to commit `a7e1abad13f3f` (“ptp: Add
clock driver for the OpenCompute TimeCard”, Dec 2020) — the missing
`.shutdown` callback has been there since introduction.

**Backport verdict: YES** for this 6.18.44 tree.

On kexec/reboot, `.remove()` is never called; without `.shutdown`,
TimeCard interrupts stay enabled and can break I2C/devlink/timestamper
functionality until a full reboot. The fix is a one-line addition
(`.shutdown = ptp_ocp_remove`), matches common PCI driver practice, and
should apply cleanly here.

 drivers/ptp/ptp_ocp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index a5c3632529862..a064923be9885 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -4866,6 +4866,7 @@ static struct pci_driver ptp_ocp_driver = {
 	.id_table	= ptp_ocp_pcidev_id,
 	.probe		= ptp_ocp_probe,
 	.remove		= ptp_ocp_remove,
+	.shutdown	= ptp_ocp_remove,
 };
 
 static int
-- 
2.53.0

