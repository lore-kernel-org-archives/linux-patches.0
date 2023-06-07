Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B7E3922F
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 479C3C433D2;
	Wed,  7 Jun 2023 20:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171505;
	bh=wXSSdQyJmNc1+zAqIpCgTXO4z+1cRBkB4VzOjiIEOew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zEPR03uBRfg4alXcJfy1iGyz/b3If4SHvo+rog2BjCgkU39MWSGSurkkUMzAUDP3a
	 zyPt12KNc7Ikx0vmwb5ATnqS6PDO2fWp1TZCnkCUS47uyR+YSZcWvYMwa5LmAI4s9A
	 jVTy61a99LPf1M6NdKPBekdU0QGy3EzVJcgekz5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Kapadia <szymon@kapadia.pl>,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/159] netrom: fix info-leak in nr_write_internal()
Date: Wed,  7 Jun 2023 22:15:19 +0200
Message-ID: <20230607200904.204604215@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>
References: <20230607200903.652580797@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 31642e7089df8fd3f54ca7843f7ee2952978cad1 ]

Simon Kapadia reported the following issue:

<quote>

The Online Amateur Radio Community (OARC) has recently been experimenting
with building a nationwide packet network in the UK.
As part of our experimentation, we have been testing out packet on 300bps HF,
and playing with net/rom.  For HF packet at this baud rate you really need
to make sure that your MTU is relatively low; AX.25 suggests a PACLEN of 60,
and a net/rom PACLEN of 40 to go with that.
However the Linux net/rom support didn't work with a low PACLEN;
the mkiss module would truncate packets if you set the PACLEN below about 200 or so, e.g.:

Apr 19 14:00:51 radio kernel: [12985.747310] mkiss: ax1: truncating oversized transmit packet!

This didn't make any sense to me (if the packets are smaller why would they
be truncated?) so I started investigating.
I looked at the packets using ethereal, and found that many were just huge
compared to what I would expect.
A simple net/rom connection request packet had the request and then a bunch
of what appeared to be random data following it:

</quote>

Simon provided a patch that I slightly revised:
Not only we must not use skb_tailroom(), we also do
not want to count NR_NETWORK_LEN twice.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Co-Developed-by: Simon Kapadia <szymon@kapadia.pl>
Signed-off-by: Simon Kapadia <szymon@kapadia.pl>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Tested-by: Simon Kapadia <szymon@kapadia.pl>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230524141456.1045467-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netrom/nr_subr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netrom/nr_subr.c b/net/netrom/nr_subr.c
index 3f99b432ea707..e2d2af924cff4 100644
--- a/net/netrom/nr_subr.c
+++ b/net/netrom/nr_subr.c
@@ -123,7 +123,7 @@ void nr_write_internal(struct sock *sk, int frametype)
 	unsigned char  *dptr;
 	int len, timeout;
 
-	len = NR_NETWORK_LEN + NR_TRANSPORT_LEN;
+	len = NR_TRANSPORT_LEN;
 
 	switch (frametype & 0x0F) {
 	case NR_CONNREQ:
@@ -141,7 +141,8 @@ void nr_write_internal(struct sock *sk, int frametype)
 		return;
 	}
 
-	if ((skb = alloc_skb(len, GFP_ATOMIC)) == NULL)
+	skb = alloc_skb(NR_NETWORK_LEN + len, GFP_ATOMIC);
+	if (!skb)
 		return;
 
 	/*
@@ -149,7 +150,7 @@ void nr_write_internal(struct sock *sk, int frametype)
 	 */
 	skb_reserve(skb, NR_NETWORK_LEN);
 
-	dptr = skb_put(skb, skb_tailroom(skb));
+	dptr = skb_put(skb, len);
 
 	switch (frametype & 0x0F) {
 	case NR_CONNREQ:
-- 
2.39.2



