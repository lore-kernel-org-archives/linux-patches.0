Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1869C425CEE;
	Tue, 16 Jun 2026 16:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627325; cv=none; b=iPJmdAuUwjv2xS5BVDrWDhu7oZVTekyy+NFUxhNg3qZKORODgyMKqMP4L/rl+/TPWn1F7WLU6w8JpFvMpzOqBFP68mV+zyaXSiFe3dtcb9MIN5mZW4Uh3A1d6bNecyfaJ2gnJBwMqbjomNViz4oZOzf7zMuLcKkC95Hp4W3dTls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627325; c=relaxed/simple;
	bh=XM2l4vO85xolr6Hq+XMNdgfFXxBYMchn8xoEl/RRuns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsPqFn55WZK8tGYixLf5+GEEwRAEQq3n5UDF7uSxDVxHNH1PLkwXHZsEPbFvewc5nKla4QOOYQNo4KrXBpytdNxG2QNHVbc5jD4LwN9FRnfVCybuDdCdREKDFvReI19Q30SBONJQin982a3p9kD8L2hAUtD0fzMu36869GouoYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lFt9yiwL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lFt9yiwL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40541F000E9;
	Tue, 16 Jun 2026 16:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627323;
	bh=gSlshGAov9h22XXYcjMRm8S8M3pyonFAQXZv+WzAg5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lFt9yiwL3aI+BzUntLQeD4iDvvZluuKlVtU9sspXv34V/lnecTd1aGMj7ILIxCWY0
	 I6nqQtYO9dmPvtDzq6brHnI5jVTYekzqoLnMTX5UJ/XksCzHjtQFwHTpWAV84tFSfz
	 FQ5xD8ONIlBKAVlU8ZvF9+8pjrErpP6GQiTC/FTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 156/261] mptcp: fix retransmission loop when csum is enabled
Date: Tue, 16 Jun 2026 20:29:54 +0530
Message-ID: <20260616145052.308608554@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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
@@ -2810,6 +2810,10 @@ static void __mptcp_retrans(struct sock
 	msk->bytes_retrans += len;
 	dfrag->already_sent = max(dfrag->already_sent, len);
 
+	/* With csum enabled retransmission can send new data. */
+	if (after64(dfrag->already_sent + dfrag->data_seq, msk->snd_nxt))
+		WRITE_ONCE(msk->snd_nxt, dfrag->already_sent + dfrag->data_seq);
+
 reset_timer:
 	mptcp_check_and_set_pending(sk);
 


