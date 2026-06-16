Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4DE44BCBE;
	Tue, 16 Jun 2026 17:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629584; cv=none; b=bW2ON7lJVZXJOyS6WNMxPlSi0OaG5q3J9NiWwJCSDGHEeJ+zRmikaFbU8RZMbeu3YkL7KFFyoc2w80Vs/Ikx+SBAheX2t7/xlKWKD0xqddLNywxH8xi/IlnFtYlE18i0D5BWGnqSQbfBqdOxVmtepTnjVse7+p1dfTiGEMo3Erw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629584; c=relaxed/simple;
	bh=foCmaRrY5v11F91IHkPIpWsMk8unBY1HkeZaUWxrrHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8Ei9v99KrZsUERdZ7YvOazC0+4b8do+7qLJPrnjJHjWJx4JzF/+1Yp4rWKKOSDhLRp5bGm4TUi4xgv1LGYzUyAnWKKcKNFnFzOlJDF/MYtOHj/6NA3y3idnYUIXmxppt0T+2HXRwsH641ipmSbU3Dj0fw/HUuCdwy2JDC9cSA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ug49Yr+F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ug49Yr+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6E91F000E9;
	Tue, 16 Jun 2026 17:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629583;
	bh=SmfUr9p4fa+nlt1qO06gUGBb0xH5l2yyI8aGVWCcCr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ug49Yr+FxAP968ZMSB6D3dkQSFOGKCGPp2+ngivTkK1gMbuzZTC4CpCROggpQE5Sq
	 TFoqlK6Et/BiuAWNfh1XBTVLmx95Dnfcdt+h2VmPlG/oiB73EF5CkUlzFassCE4/RA
	 ywSDxJm7Se4dXT5hdQFRIVVqWqQ41IrkIKY6/P7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 314/452] mptcp: fix retransmission loop when csum is enabled
Date: Tue, 16 Jun 2026 20:29:01 +0530
Message-ID: <20260616145133.999500409@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2751,6 +2751,10 @@ static void __mptcp_retrans(struct sock
 	msk->bytes_retrans += len;
 	dfrag->already_sent = max(dfrag->already_sent, len);
 
+	/* With csum enabled retransmission can send new data. */
+	if (after64(dfrag->already_sent + dfrag->data_seq, msk->snd_nxt))
+		WRITE_ONCE(msk->snd_nxt, dfrag->already_sent + dfrag->data_seq);
+
 reset_timer:
 	mptcp_check_and_set_pending(sk);
 


