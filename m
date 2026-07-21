Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971C0347BC6;
	Tue, 21 Jul 2026 22:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674187; cv=none; b=DFPNZHSk70ZDVAFjv2T/OAH96XlP8wQwrlMr+u1kkXzUPW7xp7nGeyKSMLPdbrSd54OrO31Ql+OqwCEX2z8nfUKBftSUWNJw3tqljf6jKVifrA5vwNS4ucd1VTF7QYSdTv5W0F4mw8rqN4Tox5aUeMPjsuPvBRt+8fUgEtVD4eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674187; c=relaxed/simple;
	bh=3rZyBQi4SNh9+CgsNIXxYU6i4zKmA+tqB+nUiUZ0xEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OsFyjaPceeo4Ri7UjMdF7L88/ws884Pa2fm1VHDYdgTF1TrweBjgjKdnbBKOaejL2nJVzcs/eidUUrGtRJKqlVqeMrHU+VTpezJNLQJEhNKiC16qqbajqAC5SF1aUB91xS8GPsdFncLdSr2mL6hfhlTLBYQHn+iL0OlpD0i/lkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3+4/gg2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3+4/gg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 035B81F000E9;
	Tue, 21 Jul 2026 22:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674186;
	bh=fUxz8BCjAT7eIxsKKj8G3LiFSH8xnCBNy874PUj1iHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W3+4/gg2fOf1z7xf+eZda9BvKGgS7PFZ4PvyFZIc34OpmMiH93+lP1pqih07vJypu
	 yrt7QLNyPo8xS3zJ4C7pzjcVLSm3l0c3zV8hArrpc01vvdmteUSAQBh17uL8WzsC+6
	 KbCvDWNsEW1GIsXcgqs6ZH1tR8PXDcg9iiZGbWas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.10 444/699] netfilter: nf_conntrack_irc: fix parse_dcc() off-by-one OOB read
Date: Tue, 21 Jul 2026 17:23:23 +0200
Message-ID: <20260721152405.716440596@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

commit ef6400ca25a13fd6dedbe8ef4a1d0979bbbfe88a upstream.

parse_dcc() treats data_end as an inclusive end pointer, but its only
caller passes data_limit = ib_ptr + datalen, which points one past the
last valid byte.

The newline search loop iterates while tmp <= data_end, so when no
newline is present, *tmp is read at tmp == data_end, one byte beyond
the region filled by skb_header_pointer().

irc_buffer is kmalloc'd as MAX_SEARCH_SIZE + 1 bytes and datalen is
capped at MAX_SEARCH_SIZE, so the stray read does not fault.  The byte
is uninitialized or stale; if it contains an ASCII digit, simple_strtoul
will consume it and produce a wrong DCC IP or port in the conntrack
expectation.  The extra allocation byte is also a fragile guard: if the
cap or allocation size changes, this becomes a real out-of-bounds read.

Change the loop and its post-loop check to use strict less-than,
consistent with the caller's exclusive-end convention.  Update the
function comment accordingly.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_conntrack_irc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -63,7 +63,7 @@ static const char *const dccprotos[] = {
 /* tries to get the ip_addr and port out of a dcc command
  * return value: -1 on failure, 0 on success
  *	data		pointer to first byte of DCC command data
- *	data_end	pointer to last byte of dcc command data
+ *	data_end	one past end of data
  *	ip		returns parsed ip of dcc command
  *	port		returns parsed port of dcc command
  *	ad_beg_p	returns pointer to first byte of addr data
@@ -81,10 +81,10 @@ static int parse_dcc(char *data, const c
 
 	/* Make sure we have a newline character within the packet boundaries
 	 * because simple_strtoul parses until the first invalid character. */
-	for (tmp = data; tmp <= data_end; tmp++)
+	for (tmp = data; tmp < data_end; tmp++)
 		if (*tmp == '\n')
 			break;
-	if (tmp > data_end || *tmp != '\n')
+	if (tmp >= data_end || *tmp != '\n')
 		return -1;
 
 	*ad_beg_p = data;


