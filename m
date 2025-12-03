Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7125D332EBC;
	Wed,  3 Dec 2025 15:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777178; cv=none; b=aPDL0tEcbmnBh3la5/8xy8uB481ku7AYavYu0MEwS774j/gQzd4EsOFZ1lGwmrt+99tmtYffPdxEeoka19uY8u8BUpfeHID6NYTRGD4tPlMOZno/x0/cshBcFa2uyuosUlOUqsaWXxL6IW5ADSxCYGFskTrut/3qiQayN1paqNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777178; c=relaxed/simple;
	bh=F2d8My0xbL47StaaeXtRwoFPxzpoze6lJVbRhTv4zTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YgyJYv+w0j574eEX45GjDSbjxLkHmZTeVKv66lkvB5f4twq70duVT93KbwGapqiV1/HP4lupYBoyOacS6VknDHSD7bniZzkzjugyRMf2Kj58YPDcEU+5aUgPpQKHVBpwjMfZZ0Zplh8DjbNubUXzaNhfztTDe2g8DA73OPrtF1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eUYbJcQb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eUYbJcQb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D578DC2BCB1;
	Wed,  3 Dec 2025 15:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777178;
	bh=F2d8My0xbL47StaaeXtRwoFPxzpoze6lJVbRhTv4zTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eUYbJcQb+n1Gml5/J5WsS2APrcI+Se68ZlJZIruuy6ueZUDh3gCJYlE98FDHshAVH
	 D0GnaA8WpsXuCPutsBNxF1YG75J7rwdr7mXCyppwsjzqp6V0eLTuWSNA02/GhqEYyi
	 uZgQIBd5sUlH1pGW06McAUIudrYeIcz/HapFoGI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filip Pokryvka <fpokryvk@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.17 105/146] mptcp: clear scheduled subflows on retransmit
Date: Wed,  3 Dec 2025 16:28:03 +0100
Message-ID: <20251203152350.308854846@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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
@@ -2637,7 +2637,7 @@ static void __mptcp_retrans(struct sock
 		}
 
 		if (!mptcp_send_head(sk))
-			return;
+			goto clear_scheduled;
 
 		goto reset_timer;
 	}
@@ -2668,7 +2668,7 @@ static void __mptcp_retrans(struct sock
 			if (__mptcp_check_fallback(msk)) {
 				spin_unlock_bh(&msk->fallback_lock);
 				release_sock(ssk);
-				return;
+				goto clear_scheduled;
 			}
 
 			while (info.sent < info.limit) {
@@ -2700,6 +2700,15 @@ reset_timer:
 
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


