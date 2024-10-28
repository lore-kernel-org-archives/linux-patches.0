Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0939018E05D;
	Mon, 28 Oct 2024 06:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097907; cv=none; b=nS8imKPP1/Wnsy5lcEs44l2bCEyA1Mjs28W4LbjxIvW/sn+KHWU5ii44RKIJtSG4de4E4kNOGO6Cj14Q5hx8T8gzqodcwcqjLy5JwgKflKzNd7JtWZiIZJorN8bsiMMvCY05kL4MqJxW5+RU3qv6X3vskus7/7FKbUZQJ6/7HWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097907; c=relaxed/simple;
	bh=R77nVmgTCCXDlAKWoAtx0e4H/UhpwOJ02zQ3JNuCZGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNRngTL+zE5vZZzROOKdSKSaPCPAThay0MIyvCCNjrsn+ALy26eoI+ibmNOpsfnXXXf7svrM2TziIUFidHsTJH463NogJ2P2clqiSlpNrVwpVYO8qHrVOa3bXbqorrjPMUFx1lyeUWaB6cAzOBlyYSDivfe2Fio4fu3I+hN66h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g0yHpGmv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g0yHpGmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E57FC4CEC3;
	Mon, 28 Oct 2024 06:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097906;
	bh=R77nVmgTCCXDlAKWoAtx0e4H/UhpwOJ02zQ3JNuCZGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g0yHpGmvZW59yYNVTkXLI9QRtGbpAtNcROTgMN2hZ2uGV0ZDHKS4JnP0DUGUoN2nu
	 GHst+vh8s3ypB61W5HUbx/kx0N9Z4ww6brqiOIX+D6rxPSTwEHDNNdZf/dWouRPSKI
	 spajYS/nJfLI8ryUlTZ8gEH3WzUFyag6Kf1ZMDBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lai, Yi" <yi1.lai@linux.intel.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.6 200/208] ata: libata: Set DID_TIME_OUT for commands that actually timed out
Date: Mon, 28 Oct 2024 07:26:20 +0100
Message-ID: <20241028062311.565887495@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Niklas Cassel <cassel@kernel.org>

commit 8e59a2a5459fd9840dbe2cbde85fe154b11e1727 upstream.

When ata_qc_complete() schedules a command for EH using
ata_qc_schedule_eh(), blk_abort_request() will be called, which leads to
req->q->mq_ops->timeout() / scsi_timeout() being called.

scsi_timeout(), if the LLDD has no abort handler (libata has no abort
handler), will set host byte to DID_TIME_OUT, and then call
scsi_eh_scmd_add() to add the command to EH.

Thus, when commands first enter libata's EH strategy_handler, all the
commands that have been added to EH will have DID_TIME_OUT set.

Commit e5dd410acb34 ("ata: libata: Clear DID_TIME_OUT for ATA PT commands
with sense data") clears this bogus DID_TIME_OUT flag for all commands
that reached libata's EH strategy_handler.

libata has its own flag (AC_ERR_TIMEOUT), that it sets for commands that
have not received a completion at the time of entering EH.

ata_eh_worth_retry() has no special handling for AC_ERR_TIMEOUT, so by
default timed out commands will get flag ATA_QCFLAG_RETRY set, and will be
retried after the port has been reset (ata_eh_link_autopsy() always
triggers a port reset if any command has AC_ERR_TIMEOUT set).

For a command that has ATA_QCFLAG_RETRY set, while also having an error
flag set (e.g. AC_ERR_TIMEOUT), ata_eh_finish() will not increment
scmd->allowed, so the command will at most be retried scmd->allowed number
of times (which by default is set to 3).

However, scsi_eh_flush_done_q() will only retry commands for which
scsi_noretry_cmd() returns false.

For a command that has DID_TIME_OUT set, while also having either the
FAILFAST flag set, or the command being a passthrough command,
scsi_noretry_cmd() will return true. Thus, such a command will never be
retried.

Thus, make sure that libata sets SCSI's DID_TIME_OUT flag for commands that
actually timed out (libata's AC_ERR_TIMEOUT flag), such that timed out
commands will once again not be retried if they are also a FAILFAST or
passthrough command.

Cc: stable@vger.kernel.org
Fixes: e5dd410acb34 ("ata: libata: Clear DID_TIME_OUT for ATA PT commands with sense data")
Reported-by: Lai, Yi <yi1.lai@linux.intel.com>
Closes: https://lore.kernel.org/linux-ide/ZxYz871I3Blsi30F@ly-workstation/
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20241023105540.1070012-2-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-eh.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -636,6 +636,7 @@ void ata_scsi_cmd_error_handler(struct S
 			/* the scmd has an associated qc */
 			if (!(qc->flags & ATA_QCFLAG_EH)) {
 				/* which hasn't failed yet, timeout */
+				set_host_byte(scmd, DID_TIME_OUT);
 				qc->err_mask |= AC_ERR_TIMEOUT;
 				qc->flags |= ATA_QCFLAG_EH;
 				nr_timedout++;


