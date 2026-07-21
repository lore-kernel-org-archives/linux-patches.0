Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1CB43B4A2;
	Tue, 21 Jul 2026 21:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671084; cv=none; b=pBvmlNY1BXSSBq64feklRVGt5XY9izfyUAcdS9j4xyB7LTgKVjrOwrddWOlx6TnvmpzFYHQI6QJ66FviBoHJr3FPEqYPvEp+z5tWZb50UnjpEg2RVAjdNIvDgg4RCAS04ajMNA/TtQ1ZyjQBVkUsQXeb+t7C+hTeK6qPyikD9NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671084; c=relaxed/simple;
	bh=NS8AQWoKjGwNbAgAhRrV0uFhPAkPARc9h9ewTZsip/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZrmeZerEWunRBACC0qJq00Yr4RrTlm6IVCkA1RHZpQG+QR1hBRl2rO1TqTk1Cahg4y1zYNyHVUyBP8h/K+QEwC7AB+bIcquC6npfEQVEOEjMllk3nXE2cFUiJrsuLSW7CrOMcvMJ30Gw3jMVT0+mLd0thboCC1wetKHOPnKLFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qMeKn6Nq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qMeKn6Nq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44161F00A3A;
	Tue, 21 Jul 2026 21:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671082;
	bh=rmJZNJyrN81a37THZpK8rTz2y1a8rHRq2srt2UMehSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qMeKn6NqclBo5qMZKVClNxCKPq6UuMtra4rvrePhduaPXpWMIUTa6Gf1DQ9hcWCup
	 GLESb+F7tbQf4DRYq1ffwjHmqt7e81gnH4E5RNXRkGDltOJMn4m/G6wZ8PPpdAWmUB
	 YeAvxsGpbImCoS6IVuhgxPLiCfwOHJfkmw5N5+F8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.15 111/843] netfilter: ebtables: terminate table name before find_table_lock()
Date: Tue, 21 Jul 2026 17:15:46 +0200
Message-ID: <20260721152408.498334325@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

commit a622d2e9608c9dff47fc2e5759ac7aa3a836b45d upstream.

update_counters() and compat_update_counters() forward a user-supplied
32-byte table name to find_table_lock() without NUL-terminating it. On a
lookup miss, find_inlist_lock() calls try_then_request_module(..., "%s%s",
"ebtable_", name), and vsnprintf() reads past the name field and the
stack object until it hits a zero byte.

  BUG: KASAN: stack-out-of-bounds in string (lib/vsprintf.c:648 lib/vsprintf.c:730)
  Read of size 1 at addr ffff8880119dfb20 by task exploit/147
  Call Trace:
  ...
   string (lib/vsprintf.c:648 lib/vsprintf.c:730)
   vsnprintf (lib/vsprintf.c:2945)
   __request_module (kernel/module/kmod.c:150)
   do_update_counters.isra.0 (net/bridge/netfilter/ebtables.c:371 net/bridge/netfilter/ebtables.c:380)
   update_counters (net/bridge/netfilter/ebtables.c:1440)
   do_ebt_set_ctl (net/bridge/netfilter/ebtables.c:2573)
   nf_setsockopt (net/netfilter/nf_sockopt.c:101)
   ip_setsockopt (net/ipv4/ip_sockglue.c:1424)
   raw_setsockopt (net/ipv4/raw.c:847)
   __sys_setsockopt (net/socket.c:2393)
  ...

compat_do_replace() shares the same unterminated name via
compat_copy_ebt_replace_from_user(); terminate it there too so all
find_table_lock() callers behave alike. The other callers already
terminate the name after the copy.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Fixes: 81e675c227ec ("netfilter: ebtables: add CONFIG_COMPAT support")
Cc: stable@vger.kernel.org
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/netfilter/ebtables.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1432,6 +1432,8 @@ static int update_counters(struct net *n
 	if (copy_from_sockptr(&hlp, arg, sizeof(hlp)))
 		return -EFAULT;
 
+	hlp.name[sizeof(hlp.name) - 1] = '\0';
+
 	if (len != sizeof(hlp) + hlp.num_counters * sizeof(struct ebt_counter))
 		return -EINVAL;
 
@@ -2271,6 +2273,8 @@ static int compat_copy_ebt_replace_from_
 
 	memcpy(repl, &tmp, offsetof(struct ebt_replace, hook_entry));
 
+	repl->name[sizeof(repl->name) - 1] = '\0';
+
 	/* starting with hook_entry, 32 vs. 64 bit structures are different */
 	for (i = 0; i < NF_BR_NUMHOOKS; i++)
 		repl->hook_entry[i] = compat_ptr(tmp.hook_entry[i]);
@@ -2393,6 +2397,8 @@ static int compat_update_counters(struct
 	if (copy_from_sockptr(&hlp, arg, sizeof(hlp)))
 		return -EFAULT;
 
+	hlp.name[sizeof(hlp.name) - 1] = '\0';
+
 	/* try real handler in case userland supplied needed padding */
 	if (len != sizeof(hlp) + hlp.num_counters * sizeof(struct ebt_counter))
 		return update_counters(net, arg, len);


