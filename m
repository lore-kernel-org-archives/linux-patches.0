Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E803403E7;
	Thu, 28 May 2026 19:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998293; cv=none; b=jzfuJedPXJBjc34CbF4dxn8ZnU0REkykz+8Mx8I9jgVOwU0uMD+FlrvjIBbIA7dCYeczw2YGp2lEyed/R9rwKerw1Rbh0Uid1Av2sMr510uQzyccR5wukCNm7wmJXpw+JDspX7IAGnc2rwDaKJkybDd4g6Pprkj9BFapdgTgIH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998293; c=relaxed/simple;
	bh=FFSA8Bs6x7RYytXgjJVGqWtG73BOMNxcic+yGfI+6u8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fl3b0XI/FPcSXYpWgYRdBIErRw3qnElsKv+yCkH3q7vmAoZXjTjWpG4N3xICZh0a+H3uvufilPHtg7GbEgeAxHZhNwe7y8wkgu6BKFPGE9M1cNVgHMSOnowqltE9ffCipzPZcPHttdhaHh3qyEv/asCCCSICgDegsOryKF7TVcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tq/zkKpC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tq/zkKpC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FAEB1F000E9;
	Thu, 28 May 2026 19:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998291;
	bh=V0IQ1onOaFNMQw0pMT7ZdfBj4XID3fMuY4f/FvojmAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tq/zkKpCGSK3HVbAQVmF+ysmjpp+PsKeDpGpHReiIJROZ0sd/w/cZHvIqPy3bqRVG
	 DR7WmEZPCA+63wO4QfZGcsCGNNMbOJsLxLkdNzsnRPlgAnS6osboahKIduNdi4E+OP
	 +85WQ0AuYemvuipW6S+xVLan/b3uCICSC9C37IcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 7.0 115/461] scsi: isci: Fix use-after-free in device removal path
Date: Thu, 28 May 2026 21:44:04 +0200
Message-ID: <20260528194650.302311014@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


