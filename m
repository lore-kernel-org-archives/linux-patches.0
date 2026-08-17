Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CC03033E7;
	Mon, 17 Aug 2026 13:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974627; cv=none; b=HTZin4+CrZCaFOtMIiOA9h4FM3GRzNBhoa6xFXCH9b3o+/IvDQb6OOBT5gpFJlg1riTywtbyfYc6wgG9RQ5h/PAUmVP44qmvLhH+rQMV/ewrj923sRj9ZBMYYiBqfhAzD33w8xXTItTMdVKPLPuMslSfzN2ABZjG50fO8ZdpDyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974627; c=relaxed/simple;
	bh=1now9qXBa50ISGPV8dV9o40+jLu9yop0YTZOLoSHiyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwc6zEOXE91I6NRoVGlnimp7ulpRDmQ/Hg0bRUitM65TFqSWWco/sro1KgwtMRp51WsYjtEeokoHSioE2Ui9vfBqPgCBubsBtd4O2C3Z+w+kfTUM7c+DjFFhRK1g2xGDq9OtVK3oOgO0Hb91htbr4uUGFXM4vz4cSu4rYoCF8k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EFkNT5Bg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EFkNT5Bg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCAD1F000E9;
	Mon, 17 Aug 2026 13:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974620;
	bh=Tt5NCO0vwAE5nHyugEotIVAE23EzwErjr5HztomOtnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EFkNT5BgfosYTQQt5o9bBx5R1QAqwjO0x9WJPmVElIejfLl+PXSXtzugW3JZvTzvF
	 tG88LLKENP7TFupUZ4RZsyP/M95mJAaAVdRH1R5V6jLloN2ELhXcrpk7kwb4A7rAqj
	 NTf8GYxK6CPtxYq3lB0o8LTrIr+SB6KdCmyAJo44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 268/271] sctp: fix use-after-free of cached ASCONF chunk
Date: Mon, 17 Aug 2026 15:33:13 +0200
Message-ID: <20260817132547.733293711@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

From: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>

commit 8c283e7b56adce00193837f3311b06662466fb21 upstream.

addip_last_asconf caches the outstanding outbound ASCONF chunk. The normal
ASCONF-ACK completion path releases the chunk and clears the pointer.

However, sctp_asconf_queue_teardown() releases the cached chunk without
clearing addip_last_asconf. During peer restart handling,
sctp_sf_do_dupcook_a() queues SCTP_CMD_PURGE_ASCONF_QUEUE, which invokes
sctp_asconf_queue_teardown() while the association remains alive and leaves
the pointer dangling.

A delayed authenticated ASCONF-ACK can then reach sctp_sf_do_asconf_ack(),
which accesses the stale chunk and passes it to sctp_process_asconf_ack(),
causing a use-after-free and a second release.

Clearing the pointer exposes a race with T4 expiry. Peer restart handling
queues the timer stop before the purge, but SCTP_CMD_TIMER_STOP uses
timer_delete(), which does not wait for a callback already running on
another CPU. Such a callback can reach sctp_sf_t4_timer_expire() after
the purge and dereference NULL.

Clear addip_last_asconf after releasing the cached chunk, and make
sctp_sf_t4_timer_expire() consume a stale T4 expiry if no outstanding
ASCONF remains.

Fixes: a000c01e60e4 ("sctp: stop pending timers and purge queues when peer restart asoc")
Cc: stable@vger.kernel.org
Suggested-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260809043806.2768302-1-yangyx22@mails.tsinghua.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/associola.c    |    4 +++-
 net/sctp/sm_statefuns.c |    6 +++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1713,6 +1713,8 @@ void sctp_asconf_queue_teardown(struct s
 	sctp_assoc_free_asconf_queue(asoc);
 
 	/* Free any cached ASCONF chunk. */
-	if (asoc->addip_last_asconf)
+	if (asoc->addip_last_asconf) {
 		sctp_chunk_free(asoc->addip_last_asconf);
+		asoc->addip_last_asconf = NULL;
+	}
 }
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -6145,8 +6145,12 @@ enum sctp_disposition sctp_sf_t4_timer_e
 					struct sctp_cmd_seq *commands)
 {
 	struct sctp_chunk *chunk = asoc->addip_last_asconf;
-	struct sctp_transport *transport = chunk->transport;
+	struct sctp_transport *transport;
 
+	if (!chunk)
+		return SCTP_DISPOSITION_CONSUME;
+
+	transport = chunk->transport;
 	SCTP_INC_STATS(net, SCTP_MIB_T4_RTO_EXPIREDS);
 
 	/* ADDIP 4.1 B1) Increment the error counters and perform path failure


