Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D24338F39;
	Wed,  3 Dec 2025 15:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777358; cv=none; b=UIJIdtzwMZVBsqp5AD5dWtznIV3ei2THDErAfJln0XHky44HtdZUoA6mcQJwFvu5WwU4BIfl7qqzHJRTN78LuKye7C92Od92+/TCo2+DZVRS+H83+eXNXrjpWXbojAlzyrHEsqIBxKSgW5mvw6IBuJzKHnduRxDsAmr1m+VLFdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777358; c=relaxed/simple;
	bh=bmAAjUFQRFHyS0RuySDo4lzdUICw4YVmTMPk7cazxvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NN4RI33nya7f8OIWJaOhVheFTG9sJzUK06WlwaFzDLSri9yIFiAEj+pRJCPaZTIVUSC7YDQjpmcjUHPt/etz2lt6hg6VEOlO0l0R5ztp2mOCaWW7WhjOek94OXsCYyoDs6m192R1dcuyWzx1ZlwJxZzIdBsfhsLiMAE4cF3xesw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ECi0TQHC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ECi0TQHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F680C4CEF5;
	Wed,  3 Dec 2025 15:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777357;
	bh=bmAAjUFQRFHyS0RuySDo4lzdUICw4YVmTMPk7cazxvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ECi0TQHCTRe/scM40/qTHM/w9ZqkRyKIjcd82w6r2J6oKzi9DQQsurd8pK4nx1Gsg
	 9wCsZwQpgSknr2fTlspbMZ9XoHA5r+rSIfc7eL/mikxf1wJ1HSoSDdLkpearGb+zBI
	 Zqb+zJu/ePMFyYdmwx7G6zbRNL6zqt1VjzB1KOEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 014/392] mptcp: restore window probe
Date: Wed,  3 Dec 2025 16:22:44 +0100
Message-ID: <20251203152414.629300325@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit a824084b98d8a1dbd6e85d0842a8eb5e73467f59 upstream.

Since commit 72377ab2d671 ("mptcp: more conservative check for zero
probes") the MPTCP-level zero window probe check is always disabled, as
the TCP-level write queue always contains at least the newly allocated
skb.

Refine the relevant check tacking in account that the above condition
and that such skb can have zero length.

Fixes: 72377ab2d671 ("mptcp: more conservative check for zero probes")
Cc: stable@vger.kernel.org
Reported-by: Geliang Tang <geliang@kernel.org>
Closes: https://lore.kernel.org/d0a814c364e744ca6b836ccd5b6e9146882e8d42.camel@kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Tested-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251028-net-mptcp-send-timeout-v1-3-38ffff5a9ec8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1411,7 +1411,12 @@ alloc_skb:
 	if (copy == 0) {
 		u64 snd_una = READ_ONCE(msk->snd_una);
 
-		if (snd_una != msk->snd_nxt || tcp_write_queue_tail(ssk)) {
+		/* No need for zero probe if there are any data pending
+		 * either at the msk or ssk level; skb is the current write
+		 * queue tail and can be empty at this point.
+		 */
+		if (snd_una != msk->snd_nxt || skb->len ||
+		    skb != tcp_send_head(ssk)) {
 			tcp_remove_empty_skb(ssk);
 			return 0;
 		}


