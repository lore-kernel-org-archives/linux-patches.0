Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F879475;
	Tue, 21 Jul 2026 18:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658610; cv=none; b=OdILG/9JNE1I4/dmVVaxTjHJmjSAp96EmbaqPCft/6XFLEC0QDDa4A4KBiNsarcEkUKLiCDyS9ZvTk77go+m/5EEU4J8itN4SgX9KD7w5RHYmEac5B4KxcxD04Y2ZGtaPam4NqaLowHPkhZOAGf7liI/0VJSQvAR4QBKOqv34gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658610; c=relaxed/simple;
	bh=2tBXA3BWalKgwSl6Xbbon3VXWJ7BXeQHOPkujNR4zcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nK0c56GgRDo/EpXs15PS55tB2PhrN4soS/p967A27vMdLRzMOQy0qs4Wos0iSXgPNXwXoEJpr9e6D4vM8hjwzRdNV+BdRXyrvVjWnMYtHCFAgDZLyUaCCamOy6X7NBhxI+sxvSnBDLdWNfWCvRI8YF1P9yRCgl1G7Z3mDunQYYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SnomRv4F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SnomRv4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEAC51F000E9;
	Tue, 21 Jul 2026 18:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658609;
	bh=GIBoyGg61dybsLaYdXQOC1LQU0JQ+pgUT2gmBGH7p+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SnomRv4FGxQlxS/t4M+TxU/XZ0ZOGksrVVL7z5x12fdwsDoQVb99VsGnLI/uriqTp
	 PM+F/XyvOfEDOisrlVwfqQYgSJwqL5wqepSn0Sr2sdkeomi7vXhpYQgr+Xq5OKsinA
	 aX3YQCP6itsoFtPEQyfmZLtv3iYAtfYmNYIkuLYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.18 1165/1611] netfilter: nf_conntrack_irc: fix parse_dcc() off-by-one OOB read
Date: Tue, 21 Jul 2026 17:21:21 +0200
Message-ID: <20260721152541.628011464@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -64,7 +64,7 @@ static const char *const dccprotos[] = {
 /* tries to get the ip_addr and port out of a dcc command
  * return value: -1 on failure, 0 on success
  *	data		pointer to first byte of DCC command data
- *	data_end	pointer to last byte of dcc command data
+ *	data_end	one past end of data
  *	ip		returns parsed ip of dcc command
  *	port		returns parsed port of dcc command
  *	ad_beg_p	returns pointer to first byte of addr data
@@ -82,10 +82,10 @@ static int parse_dcc(char *data, const c
 
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


