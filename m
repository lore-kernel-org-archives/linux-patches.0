Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D0F34F492;
	Wed,  3 Dec 2025 16:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780770; cv=none; b=MOSKxDuUIYSgBaNM4nLtFNCAOGzuQ5BEX/vJxWAytGE9JnUlE2rQd69nYh+Fs5YxXCVK5dIdZYn5MkDV7qbbroJ0Ibo/HkWflzqy2V62FGEK1tFxJd6yrmfP4CH+gO4exR37EWnDZJOgJ1SrFK4dQ7r/9BLLv2/Cpb48lh9AHH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780770; c=relaxed/simple;
	bh=ln6o8Q4SguIAz7CK36hZar5UyIzjFdh0m87wKOyvS3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fWe4lRKRJikiBD5JzuKLbYewV1GYwqfGDllVmURwMfAZRFB8m00rnQszlBw00+/YpFatXjeoGlvjpXd4WY8GULBf4kGbQ04O3q4FJJdKlx+S4+OrHL+oCZKPLNVMTVX6jYR57REqZeAQB10PkQKbX8hUoORlaV0fg/zYz6gccXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BswQRcVJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BswQRcVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640F4C4CEF5;
	Wed,  3 Dec 2025 16:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780768;
	bh=ln6o8Q4SguIAz7CK36hZar5UyIzjFdh0m87wKOyvS3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BswQRcVJE/byBkeUmaUL89ysCC6C8w2VkFdLRywAZzqws8u6hr7jCXy4ylFvuAzuh
	 L/0uF/qYyWO1qJcz2KAVU1a3PZVnJVEhfjkXFKhKVZP0mrF+LueXbYntD8Q5ayqQPF
	 6AG0NuQMEAIc3w9N7u6CPq1v2Duj/XdHVFu08e+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filip Pokryvka <fpokryvk@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 084/132] mptcp: clear scheduled subflows on retransmit
Date: Wed,  3 Dec 2025 16:29:23 +0100
Message-ID: <20251203152346.406433891@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 27fd02860164bfa78cec2640dfad630d832e302c upstream.

When __mptcp_retrans() kicks-in, it schedules one or more subflows for
retransmission, but such subflows could be actually left alone if there
is no more data to retransmit and/or in case of concurrent fallback.

Scheduled subflows could be processed much later in time, i.e. when new
data will be transmitted, leading to bad subflow selection.

Explicitly clear all scheduled subflows before leaving the
retransmission function.

Fixes: ee2708aedad0 ("mptcp: use get_retrans wrapper")
Cc: stable@vger.kernel.org
Reported-by: Filip Pokryvka <fpokryvk@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251125-net-mptcp-clear-sched-rtx-v1-1-1cea4ad2165f@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2721,7 +2721,7 @@ static void __mptcp_retrans(struct sock
 		}
 
 		if (!mptcp_send_head(sk))
-			return;
+			goto clear_scheduled;
 
 		goto reset_timer;
 	}
@@ -2752,7 +2752,7 @@ static void __mptcp_retrans(struct sock
 			if (__mptcp_check_fallback(msk)) {
 				spin_unlock_bh(&msk->fallback_lock);
 				release_sock(ssk);
-				return;
+				goto clear_scheduled;
 			}
 
 			while (info.sent < info.limit) {
@@ -2784,6 +2784,15 @@ reset_timer:
 
 	if (!mptcp_rtx_timer_pending(sk))
 		mptcp_reset_rtx_timer(sk);
+
+clear_scheduled:
+	/* If no rtx data was available or in case of fallback, there
+	 * could be left-over scheduled subflows; clear them all
+	 * or later xmit could use bad ones
+	 */
+	mptcp_for_each_subflow(msk, subflow)
+		if (READ_ONCE(subflow->scheduled))
+			mptcp_subflow_set_scheduled(subflow, false);
 }
 
 /* schedule the timeout timer for the relevant event: either close timeout


