Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6EB11C4609;
	Tue, 26 Aug 2025 13:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215196; cv=none; b=VBcGFrdz/v8NABBKKh5oS5FpA2/HCRVDs3Rx+TH2tZ35vh8TssMPRmPiVXUQaZPD5TC2OmFxe+J7PBjDR8IyLhgvo9o8qS9AHtEls1/uWyVJkepLuMApsKFhLPYeFH3TdLQBRgyHUp7Z1AET0TPrTaIbFTX8Zni65TSmCf7Q72A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215196; c=relaxed/simple;
	bh=Ga4aY4RcDLWdpJhlcuvIdo0U9qfWlp8faHQUshF/ZcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQef+a7ByHNeiHBqNAg6xBpPW4bVCSc/DKMjLYA6hJa/Hweuq8VHBGTFRW75bFKjF0In4aMKeNbZmpZc1nw3ypyb4UtFUAy+GbtMsggK1o2tDxzo0lxDRSj1p/iXcGujxufxjoEjxPbW77c1iKd07iyF0WnmzU6yExZfm63c8hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m9TrDRf8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m9TrDRf8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450BFC4CEF1;
	Tue, 26 Aug 2025 13:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215196;
	bh=Ga4aY4RcDLWdpJhlcuvIdo0U9qfWlp8faHQUshF/ZcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m9TrDRf8Qboy2mrw35grBocu1Ile7EOpAz30eqQqenWKkMGdAmpzuPbT45yltzxXU
	 JzevXzohvQsLYzeUV8EnlN9LaY0SdEfLoHq5w5Zd9EQkuEUnpIA9757/wbP4IS/6Pf
	 t6DvcsGjOULfMjsPkvFrK9y3IJpgQKPbUmfSk4cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 383/482] mptcp: reset fallback status gracefully at disconnect() time
Date: Tue, 26 Aug 2025 13:10:36 +0200
Message-ID: <20250826110940.291379712@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Paolo Abeni <pabeni@redhat.com>

commit da9b2fc7b73d147d88abe1922de5ab72d72d7756 upstream.

mptcp_disconnect() clears the fallback bit unconditionally, without
touching the associated flags.

The bit clear is safe, as no fallback operation can race with that --
all subflow are already in TCP_CLOSE status thanks to the previous
FASTCLOSE -- but we need to consistently reset all the fallback related
status.

Also acquire the relevant lock, to avoid fouling static analyzers.

Fixes: b29fcfb54cd7 ("mptcp: full disconnect implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250714-net-mptcp-fallback-races-v1-3-391aff963322@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflicts in protocol.c, because commit ebc1e08f01eb ("mptcp: drop
  last_snd and MPTCP_RESET_SCHEDULER") is not in this version and
  changed the context. The same modification can still be applied at the
  same place. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3204,7 +3204,16 @@ static int mptcp_disconnect(struct sock
 	 */
 	mptcp_destroy_common(msk, MPTCP_CF_FASTCLOSE);
 	msk->last_snd = NULL;
+
+	/* The first subflow is already in TCP_CLOSE status, the following
+	 * can't overlap with a fallback anymore
+	 */
+	spin_lock_bh(&msk->fallback_lock);
+	msk->allow_subflows = true;
+	msk->allow_infinite_fallback = true;
 	WRITE_ONCE(msk->flags, 0);
+	spin_unlock_bh(&msk->fallback_lock);
+
 	msk->cb_flags = 0;
 	msk->recovery = false;
 	msk->can_ack = false;


