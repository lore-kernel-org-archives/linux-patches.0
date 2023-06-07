Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CC3171B9
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:33:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E29C433EF;
	Wed,  7 Jun 2023 20:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170011;
	bh=iZ1Iuai7yOiMu0ROljRsnMO9s4UfD+onOErjGiXt9ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0uI2JrON5a2Yo16Lw8IJ8E1OBuHTic3OO18SBhdzWXV75K/MKKaqGgWiajAKBLUnY
	 EVMY6swkM/STcSc3WH7qmpyVmCGB86Z4mOGwllE1u2zSHsm39KU66O/h54Z4Gsj5Qw
	 4ALXoOuIBtP1TrSxzREUqt/bIcwbY2d4ocQ+VqFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Kapadia <szymon@kapadia.pl>,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 12/88] netrom: fix info-leak in nr_write_internal()
Date: Wed,  7 Jun 2023 22:15:29 +0200
Message-ID: <20230607200858.013895724@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200854.030202132@linuxfoundation.org>
References: <20230607200854.030202132@linuxfoundation.org>
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
index 029c8bb90f4c3..a7d3a265befb9 100644
--- a/net/netrom/nr_subr.c
+++ b/net/netrom/nr_subr.c
@@ -126,7 +126,7 @@ void nr_write_internal(struct sock *sk, int frametype)
 	unsigned char  *dptr;
 	int len, timeout;
 
-	len = NR_NETWORK_LEN + NR_TRANSPORT_LEN;
+	len = NR_TRANSPORT_LEN;
 
 	switch (frametype & 0x0F) {
 	case NR_CONNREQ:
@@ -144,7 +144,8 @@ void nr_write_internal(struct sock *sk, int frametype)
 		return;
 	}
 
-	if ((skb = alloc_skb(len, GFP_ATOMIC)) == NULL)
+	skb = alloc_skb(NR_NETWORK_LEN + len, GFP_ATOMIC);
+	if (!skb)
 		return;
 
 	/*
@@ -152,7 +153,7 @@ void nr_write_internal(struct sock *sk, int frametype)
 	 */
 	skb_reserve(skb, NR_NETWORK_LEN);
 
-	dptr = skb_put(skb, skb_tailroom(skb));
+	dptr = skb_put(skb, len);
 
 	switch (frametype & 0x0F) {
 	case NR_CONNREQ:
-- 
2.39.2



