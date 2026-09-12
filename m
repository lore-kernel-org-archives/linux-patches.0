Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0B133A71A;
	Sat, 12 Sep 2026 15:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228359; cv=none; b=R0NXgp61Xh3UiSun4fUyX5SQI4g6rTRMejBjakJa+o9qCkQbB3+dC1oaTX5JsmK4ZQ2dbWG/TBqQyOAoSBdYvFh2OCJREUfPiD8oZ6K5AxdDb6RFRcbqyYnp4AN8EX/RzN7FZ3jjf6CPpXFw0dUGGXHUkNsTO4vtHoiCEny+bco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228359; c=relaxed/simple;
	bh=YibpRzSUEO4TH+sBf9Qgp15+P+tN9GqP4/b1kvLk+i4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oxkex4+vvAJv7szl8rysQfO3VWhNf79DwGeeV+NEdAJG0AZYt3B5zIFCrpnU2O763UFiJCR7OiKE626IlCrCIYUSBN7VmATVx0fKRMD/OVWTCZC/Pg6DtKkkec9zEaODNRuh+lPscTgzMBh2m+1tnJIc9enSZaCKzuiCiNEV7CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EYsMmxfT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EYsMmxfT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BCC61F000FF;
	Sat, 12 Sep 2026 15:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228357;
	bh=CXy6e+4zSk46G4DW2xLOfoxbSJIWKAeGeZjINEdTCYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EYsMmxfTraUb78m3ZdYwIvBX2B127HG6MlYQUPmG3l6Hyzdcq4uMY4heYpxM7WhuN
	 kRrLrNW/hIXRQwCh5FaMfanNexza6jyd4Z+CeG8h8xG01M+rdAjoVjOy3CuF28+ZXa
	 /owf1/kk02MOcunN6cPBJC0s63VeGaasPoEJFFgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 0367/1191] media: cx23885: cancel NetUP CI work before teardown
Date: Sat, 12 Sep 2026 08:51:35 +0200
Message-ID: <20260912065556.471296289@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

commit 4e143d662ca94888b494b2427fc9e34494eb933a upstream.

netup_ci_exit() frees a netup_ci_state while its work item,
netup_read_ci_status(), may still be pending or running on the system
workqueue. The worker obtains the state with container_of() and
dereferences it, so it must not outlive the state.

netup_ci_init() queues the initial status read, and CI GPIO interrupts
subsequently queue the same work from netup_ci_slot_status(). During
remove, cx23885_finidev() calls free_irq() before the CI device is
unregistered. free_irq() prevents further IRQ handlers from running,
but does not drain work queued previously, so the worker can run after
netup_ci_exit() frees the state.

Call cancel_work_sync() before dvb_ca_en50221_release() and kfree().

This issue was found by an in-house static analysis tool.

Fixes: c184dcd28233 ("V4L/DVB (10798): Add CIMax(R) SP2 Common Interface code for NetUP Dual DVB-S2 CI card")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/cx23885/cimax2.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/pci/cx23885/cimax2.c
+++ b/drivers/media/pci/cx23885/cimax2.c
@@ -528,6 +528,7 @@ void netup_ci_exit(struct cx23885_tsport
 	if (NULL == state->ca.data)
 		return;
 
+	cancel_work_sync(&state->work);
 	dvb_ca_en50221_release(&state->ca);
 	kfree(state);
 }


