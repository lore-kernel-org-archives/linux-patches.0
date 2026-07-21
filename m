Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E2F46D2C7;
	Tue, 21 Jul 2026 17:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654167; cv=none; b=odeV/tIb+7CLtlTVSWYT+AZ2JEWgZpVEJ0RnmJHyjAvZzyTIZFI/Hdm6E4VQPh7/z7UmZOI2QYnd85zmaU01TPX7g7QiczhhFhDdgmHNHjiZArdZaukKIcPw/hAiDzzczGq75iZas33xrbEw/xTCKUXeCs4+YIbLqjyIll1BNmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654167; c=relaxed/simple;
	bh=3x7k9sjAhED8Sajmrh/K9790EVks2Pk2pQuJE04MMbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HVoG1Tqo7A9pq9VWRravfSEpNxsBAIth6Syir7BkJi8E0h3R228pi8/TIZACXmS52tpGN+1MKHiXMuDYQE5dB95r0jnka10mCvfNehhh3aGI9Uh1u6YhrmImmvWeIbAT51IzsUeeqiy4+d55ViWJ7uHZQx5ixtHypqG6ox8Go2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TcSVv/7l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TcSVv/7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39EB1F00A3A;
	Tue, 21 Jul 2026 17:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654166;
	bh=Z8m8SD1mfvvnTLwtOC5kgZa/491EW7EoHp4C9BI6oMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TcSVv/7lmPqZS57konIpIJXeDVOdZUrDvCtvEY4AEjA6kFRqcCEQGvz/K8FeZ/ymB
	 zqF2/hHInoEkFu+Xp6+K/LBuiDhpc2yrMYgKF/k6UGPgT+aKEcf4+tk9V3Pablvq1N
	 ghc+VudFvwgrGGNMy2zaOYmF4jdty+HEbY0pztTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 7.1 1601/2077] netfilter: nf_conntrack_irc: fix parse_dcc() off-by-one OOB read
Date: Tue, 21 Jul 2026 17:21:14 +0200
Message-ID: <20260721152630.532623975@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -59,7 +59,7 @@ static const char *const dccprotos[] = {
 /* tries to get the ip_addr and port out of a dcc command
  * return value: -1 on failure, 0 on success
  *	data		pointer to first byte of DCC command data
- *	data_end	pointer to last byte of dcc command data
+ *	data_end	one past end of data
  *	ip		returns parsed ip of dcc command
  *	port		returns parsed port of dcc command
  *	ad_beg_p	returns pointer to first byte of addr data
@@ -77,10 +77,10 @@ static int parse_dcc(char *data, const c
 
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


