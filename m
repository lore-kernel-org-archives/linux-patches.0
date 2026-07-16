Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212EE3D7D74;
	Thu, 16 Jul 2026 14:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210835; cv=none; b=pFDRwBLMACS0V2mOeSvM+DgEd9R7nREp68C055zxVkp4EzF6qp/OaT5XRvs+c5e3OPBI3bgfKo6SZ/HpXa0qZpTIF5azpg+AhX8quHqb+CWhhq0cltRfThAUMpUqN5y12HqxXkkmXrfVtupoV8MHfYOJxNLveT1RCYoqHmn0nvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210835; c=relaxed/simple;
	bh=6dsRIyQOpFaHtkG4q4qOBy0/3fvJFQx4wK3mHR5GQjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MyxZoqKlOaRBDMoVzGidqKWG635EtefmxyXOLkwcEyJVJZrwGYDkMS7bGYjL4Or6nfDZxpHXuXqBh6XCYewN/ClVmw3qxGxvVd9KHiYHtWtm5Iw0AKKFCDIEpAzmnnneBS2EKCGd8bGIVRj1ZIuLjpK6qKpZQPCQheGoakHnlGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fzEmo5Gg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fzEmo5Gg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411621F000E9;
	Thu, 16 Jul 2026 14:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210833;
	bh=Tzyf1K1Oa8d9GCGKghZgr/BdyX07akOKI4psf2YXpzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fzEmo5GgBTUXXs6Tn/jWQnUQ/Q2SIQN3KE8jMctjR/kjQf+wsTaqXQyhz5Kq6RKR+
	 TfQfRbr14chK3gYRWSx2HABoBkWwK0TRsVuR34Zfmpt2SH6M/QLSahSk9OwESbAQvU
	 hz16IZEup5zIDjJqz2mJFLgLbwKQC1V67foFYDEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Adrian Bente <adibente@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.18 199/480] netfilter: flowtable: fix offloaded ct timeout never being extended
Date: Thu, 16 Jul 2026 15:29:06 +0200
Message-ID: <20260716133049.033882239@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Adrian Bente <adibente@gmail.com>

commit 53b3e60edb674b442b2b3bbdba484667b0f47a5d upstream.

OpenWrt has recently migrated many platforms to kernel 6.18. On the
MediaTek platform, which supports hardware network offloading, WiFi
connections accelerated via the WED path were observed to drop after
roughly 300 seconds.

After several debugging sessions, assisted by the Claude LLM, the
problem was narrowed down as follows:

nf_flow_table_extend_ct_timeout() extends ct->timeout for offloaded
flows using:

	cmpxchg(&ct->timeout, expires, new_timeout);

'expires' comes from nf_ct_expires(ct) and is a relative value, while
ct->timeout holds an absolute timestamp. The two are never equal, so
the cmpxchg always fails and the timeout is never extended.

This goes unnoticed for most flows, but a long-lived hardware (WED)
offloaded flow on MediaTek MT7986 eventually has ct->timeout decay to
zero, the conntrack entry is reaped and the connection breaks.

Open-code the relative value from a single READ_ONCE(ct->timeout)
snapshot and compare against that same absolute snapshot in the
cmpxchg, so the timeout extension actually takes effect while the
datapath remains authoritative if it updates ct->timeout concurrently.

Fixes: 03428ca5cee9 ("netfilter: conntrack: rework offload nf_conn timeout extension logic")
Cc: stable@vger.kernel.org
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Adrian Bente <adibente@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_flow_table_core.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -500,8 +500,13 @@ static u32 nf_flow_table_tcp_timeout(con
  */
 static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
 {
-	static const u32 min_timeout = 5 * 60 * HZ;
-	u32 expires = nf_ct_expires(ct);
+	static const s32 min_timeout = 5 * 60 * HZ;
+	u32 ct_timeout = READ_ONCE(ct->timeout);
+	s32 expires;
+
+	expires = ct_timeout - nfct_time_stamp;
+	if (expires <= 0) /* already expired */
+		return;
 
 	/* normal case: large enough timeout, nothing to do. */
 	if (likely(expires >= min_timeout))
@@ -519,7 +524,7 @@ static void nf_flow_table_extend_ct_time
 	if (nf_ct_is_confirmed(ct) &&
 	    test_bit(IPS_OFFLOAD_BIT, &ct->status)) {
 		u8 l4proto = nf_ct_protonum(ct);
-		u32 new_timeout = true;
+		u32 new_timeout = 1;
 
 		switch (l4proto) {
 		case IPPROTO_UDP:
@@ -544,7 +549,7 @@ static void nf_flow_table_extend_ct_time
 		 */
 		if (new_timeout) {
 			new_timeout += nfct_time_stamp;
-			cmpxchg(&ct->timeout, expires, new_timeout);
+			cmpxchg(&ct->timeout, ct_timeout, new_timeout);
 		}
 	}
 


