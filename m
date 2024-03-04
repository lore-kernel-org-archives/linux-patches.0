Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483461EB5A;
	Mon,  4 Mar 2024 21:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588863; cv=none; b=bAVrcIYFjm9nRaK8RhGFK9AcmAUR8oxgaOPnTHhtiTLSH3KYxXdTtnBhYd6t/9AGCWDdo5I31BLRPeDa8kFh+9k6pv/aMJ0XLY6TmUv6kkQZrDk63YC5UezrqXNdTgzK0LKRjazJSXHZ/d+2jLtLKe+l+MgYH42RUi/jvc/ZrlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588863; c=relaxed/simple;
	bh=2qyxo47tr94K9NGAKIxrA0jmpTHC1gnHcvjyKOdPsEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVGUMKuizfKMTTI8NDxcqq/N3JxRmIzJmQzOP6KORUXDytoGKdUYAeFQJ719bLGxL9m1sG1CER6H/viqBaGKbM8/CZeCTOLb9JJHMPjtrflq/WWcKmyBhKyhsEq8DxHvdfSYtfn4uYmUE4exia9Y2UawVBanjjgkR9u4c0Nqtgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iWYwEO4l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iWYwEO4l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50468C433F1;
	Mon,  4 Mar 2024 21:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588863;
	bh=2qyxo47tr94K9NGAKIxrA0jmpTHC1gnHcvjyKOdPsEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iWYwEO4lEIk+adFAfNLWQ87g4PgJSD2rl6lMPRP2sgBRvQ2NtqlPryK7p7884lsol
	 7btpCMFJnch9R2aVzbPFCHaTtcfcsYKw9UZDykFujs9mW+Cw0BvQbJNUopWD13P1pq
	 FLhWAO3pIQEMJisWEJuYkzrQ3JMFfNLph91fxed8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 6.1 100/215] mptcp: continue marking the first subflow as UNCONNECTED
Date: Mon,  4 Mar 2024 21:22:43 +0000
Message-ID: <20240304211600.206386851@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

After the 'Fixes' commit mentioned below, which is a partial backport,
the MPTCP worker was no longer marking the first subflow as "UNCONNECTED"
when the socket was transitioning to TCP_CLOSE state.

As a result, in v6.1, it was no longer possible to reconnect to the just
disconnected socket. Continue to do that like before, only for the first
subflow.

A few refactoring have been done around the 'msk->subflow' in later
versions, and it looks like this is not needed to do that there, but
still needed in v6.1. Without that, the 'disconnect' tests from the
mptcp_connect.sh selftest fail: they repeat the transfer 3 times by
reconnecting to the server each time.

Fixes: 7857e35ef10e ("mptcp: get rid of msk->subflow")
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2440,6 +2440,8 @@ static void __mptcp_close_ssk(struct soc
 	need_push = (flags & MPTCP_CF_PUSH) && __mptcp_retransmit_pending_data(sk);
 	if (!dispose_it) {
 		__mptcp_subflow_disconnect(ssk, subflow, flags);
+		if (msk->subflow && ssk == msk->subflow->sk)
+			msk->subflow->state = SS_UNCONNECTED;
 		release_sock(ssk);
 
 		goto out;


