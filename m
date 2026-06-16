Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9B443E4A1;
	Tue, 16 Jun 2026 15:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624057; cv=none; b=L91iNsSxMkKPinEH8ABUTjsJV1o50zWUjhttBqFhudiRsg2xEoz+eCPBPtYv2SEtS0EXOMw8yZCT5jOrZ93pvAHOEvsS+17h6BvNzTMfw1b3Ne3llDUs4AdLzOy7cqCisUqKKcMbi2dnlozWGggDVs4e9i4faudhEJO7v+EI+Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624057; c=relaxed/simple;
	bh=fk0nI++z9zA2W7mrXMuTSf2dYOcVyhFkN6EX/YUcAO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dz1MaodAZgpdR+UeMc5wnMQNfoa6/+iVoUHBk7PHql+VlGxUfPcqa0oBAcfOLQKgagULKHi2Mx/S9gHJRLjuBou/Vg+FhbigU5eIB7igEJsWibAxj6aM9uMj37+ElOYg3BFyamBUn5ynTwyX+boR6nu9jX1F05ivuNoRGo1viIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mz1VXdJ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mz1VXdJ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E65D1F000E9;
	Tue, 16 Jun 2026 15:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624056;
	bh=XBdYSq7UZNe7V4/tBuQfbQLNKSNdO1t2qJosLASfftk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mz1VXdJ5TQEB4ykVLuou73gEVQ1ttTiwm2v7+fW6eA5GYyv0ZyyGw+UBpAf+Vf+vF
	 fkM8js+zl7o25olSHs5pBi4iPJRRxa7bX+tvqfpZMG3kvqDH7ljDtoVk7sHhfrF6S0
	 Llc0wvYQot1pHguGge1yEL7T+Wn345k5K/YdShR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 231/378] mptcp: fix retransmission loop when csum is enabled
Date: Tue, 16 Jun 2026 20:27:42 +0530
Message-ID: <20260616145122.424610934@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

commit d1918b36edcaed0ec4ef6888b2358c6b1ddcff47 upstream.

Sashiko noted that retransmission with csum enabled can actually
transmit new data, but currently the relevant code does not update
accordingly snd_nxt.

The may cause incoming ack drop and an endless retransmission loop.

Address the issue incrementing snd_nxt as needed.

Fixes: 4e14867d5e91 ("mptcp: tune re-injections for csum enabled mode")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260602-net-mptcp-misc-fixes-7-1-rc7-v2-2-856831229976@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2852,6 +2852,10 @@ static void __mptcp_retrans(struct sock
 	msk->bytes_retrans += len;
 	dfrag->already_sent = max(dfrag->already_sent, len);
 
+	/* With csum enabled retransmission can send new data. */
+	if (after64(dfrag->already_sent + dfrag->data_seq, msk->snd_nxt))
+		WRITE_ONCE(msk->snd_nxt, dfrag->already_sent + dfrag->data_seq);
+
 reset_timer:
 	mptcp_check_and_set_pending(sk);
 


