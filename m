Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5129241C8C;
	Sat, 30 May 2026 18:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164916; cv=none; b=H7TcjwQnCdmr0sc/UFZXlqp+GsjYeXT0ooBK0UtUIfeFjyhuBnJWC0RhaJVoYu4hGBYDvjfx00V3b9JcpMUAjwN8/acO6nkRjO9Kwt1Mffty9lBZeMJJqIeoikp6+OSYwu1MQsiVVR1Gx3MOz+RcSmSOZ0YWjuzUmYofySF2z3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164916; c=relaxed/simple;
	bh=2pRKD7MfPuOP6+hcXVnXs4RuQ7cXGAeEUCciTJjhkhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbr3y9c0DuGkc3xwYwq9x/2eYCRhPpYBZHmklAfVYabsD+JgtUuZVzEOrCxtiCngfeoBVpcH9QZiEk1OlAx2RWOJu7cUyc9b7jdJNidcCkKQ2YSFWjmrOoVslwpHczlC//Z6UV6QUUYMiwVgQvvDAiz9bmhtIY9sLxeIRDKSS3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NKEKDu4v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKEKDu4v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8AB01F00893;
	Sat, 30 May 2026 18:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164915;
	bh=UKtfvryWV6SM4s7lGemhPGqToLR2zamU11pXCAv27Co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NKEKDu4vnZ89kaj1H8W3obGVAqo/3Xy2SCgiKh7YFL0UuW+zGS0ANRyqSEPySb+4T
	 UztnMJmdOuPcot09lihbc2SbGROUMKKqqwRblQFvE97bNVAaGlALpNEhCFrHrx2geo
	 4FxAiDstev2oU0TAJfnx5ebni/uHPPn/8YPKKCCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 697/776] scsi: isci: Fix use-after-free in device removal path
Date: Sat, 30 May 2026 18:06:51 +0200
Message-ID: <20260530160257.843869179@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit b52a8d52c3125ec9a93106ed816582368de34426 upstream.

The ISCI completion tasklet is initialized in isci_host_alloc()
(drivers/scsi/isci/init.c:496) and scheduled from both MSI-X and legacy
interrupt handlers (drivers/scsi/isci/host.c:223,613).

isci_host_deinit() stops the controller and waits for stop completion,
but it never kills completion_tasklet before teardown continues. A
top-of-function tasklet_kill() is not sufficient here: interrupts are
only disabled when isci_host_stop_complete() runs, so until
wait_for_stop() returns the IRQ handlers can still requeue the
tasklet. The tasklet callback also re-enables interrupts after draining
completions, so killing the tasklet before the source is quiesced leaves
the same race open.

Once wait_for_stop() returns, no further IRQ-driven scheduling can
occur. Kill completion_tasklet there so teardown cannot race a queued
tasklet running on a dead ihost. On remove or unload, the stale callback
can otherwise dereference ihost and touch ihost->smu_registers after the
host lifetime ends.

A UML + KASAN analogue reproduced the failure class both with no
tasklet_kill() and with tasklet_kill() placed before source quiesce, and
stayed clean once the kill happened after quiescing the scheduling
source.

This mirrors commit f6ab594672d4 ("scsi: aic94xx: fix use-after-free in
device removal path"), but ISCI needs the kill after wait_for_stop().

Fixes: 6f231dda6808 ("isci: Intel(R) C600 Series Chipset Storage Control Unit Driver")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Assisted-by: Codex:gpt-5-4
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://patch.msgid.link/20260419210420.2134639-1-michael.bommarito@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/isci/host.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -1252,6 +1252,9 @@ void isci_host_deinit(struct isci_host *
 
 	wait_for_stop(ihost);
 
+	/* No further IRQ-driven scheduling can happen past wait_for_stop(). */
+	tasklet_kill(&ihost->completion_tasklet);
+
 	/* phy stop is after controller stop to allow port and device to
 	 * go idle before shutting down the phys, but the expectation is
 	 * that i/o has been shut off well before we reach this


