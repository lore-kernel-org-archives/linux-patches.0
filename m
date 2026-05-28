Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C00301472;
	Thu, 28 May 2026 20:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999684; cv=none; b=CdFs/KCceGVVx/4RIFJGuqPp86wCu47jKciS2q5VfS3H9Fy4T5owafSYvklOi1AfbMeZL1/BzxmZ2DKz3JmhLuUJvJ9RW4XItZx2+nN9V/x4D+MOyP1CI3gAojm8aDvjE3SuBzaIvdp3die25T7LE3kcjirLNc18ip5J3anw7og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999684; c=relaxed/simple;
	bh=vGCWAeU2KR/SuGKx4BlNfTsCN5VWb69ZMp30u6HbzEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GdUBbLin+jMAZEv/jM//Zm3xHaLyBVszK+M6kt8m1cuus0NUqKZ6jdtKkxMpJHAxBdfn6x+3wPgWdgsl5Qw0h5ZYJIPhApKCaxkJ0BbVMb17OuxvXYla8/r5Ue7LynDihQc9a+tVPlVhSvpMlpHQW0sfVTipDVEadkCzFiM4gns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tb60VvxU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tb60VvxU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09481F000E9;
	Thu, 28 May 2026 20:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999683;
	bh=lNPyp9ivq8RdbZlVSSwt7mzhrn+WAWp0CKP+OJc/+eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tb60VvxUGjAQQMRP4gP+zNg8jiL+wXIChR1BbUyVizDMIuaJd0saRD5178VtEgJwf
	 6HNquOaZcxjH9FrIA4ing74pPM2U7dQyyUlUnI7p3pwT2iQlVdlZiluQDAhwShj8v3
	 fNzn8VqledDU8ZHbNtjwzP2VAK9YBGUfwcRKHnxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.18 118/377] scsi: isci: Fix use-after-free in device removal path
Date: Thu, 28 May 2026 21:45:56 +0200
Message-ID: <20260528194641.755329818@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


