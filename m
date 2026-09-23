Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72EC23D9029;
	Wed, 23 Sep 2026 14:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175363; cv=none; b=U+AwjP9vSE4XgbLvEeZMetD2SZGMF+gL2vstUh+HmqWVoo03j/WeUasWFOrGMwQ533uWWFfgY3EYmxGRoBGgvTkwoymCdGYE22HmL1eXGS8CSVOKHqBtrdSOHEVLnG5/i15NSLNDeVhiMbr4kmFM2a98iEJsMUCTzJF23RbDNuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175363; c=relaxed/simple;
	bh=ME9Fx8RqHLdDpyTmdEY4Jppfdf/EUYBFq9A78WP38HM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R5Qvv6XZ2BbhbKjT5tLy7Is1VA4z7mDlz8tbChqyJvOogDJYA//HGs/bF5qyCBaJYynwgh7JpMxDpjnkCZizyYLDdgscybwLk+fjN4Ko80MLNjpdt/EIYxigHH7XJrwULXccqlqEZJHA57oexC3CuAORb7tlWZFUKBJg/LwowIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ynGCNmiC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ynGCNmiC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0411F00893;
	Wed, 23 Sep 2026 14:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175362;
	bh=AEzWU9Nk9U34Q1DAHz9FG68+b+sSnhLELQFm1Z2ffwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ynGCNmiC6WWXbUAzm9BWkwpgljj3Ur9iLZSpoXvrwMrsYjBynL2cKGVt+bIFVHn/H
	 6luRINMYssXFEyg1XPVEmJzhRVUncX9jqd7rG7XtDSVhGD+37t3yyxAK99U/zzRF25
	 mn/yrcyFvcYo1KmgWn3gHkJEdielOWQpjUglVJB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.18 392/398] time/namespace: Export init_time_ns and do_timens_ktime_to_host()
Date: Wed, 23 Sep 2026 16:07:46 +0200
Message-ID: <20260923140653.634413539@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit 766e828b011ca5f971554001611b4acab7c244c1 upstream.

timens_ktime_to_host() in compares the current time namespace against
init_time_ns for the fast path. It calls do_timens_ktime_to_host() for the
offset case. Both symbols are needed at link time by any caller of the
inline.

All current callers are builtin, but ntsync can be built as module, which
prevents it from using it.

Export both with EXPORT_SYMBOL_GPL.

Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260528063311.3300393-2-maoyixie.tju@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/namespace.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/time/namespace.c
+++ b/kernel/time/namespace.c
@@ -57,6 +57,7 @@ ktime_t do_timens_ktime_to_host(clockid_
 
 	return tim;
 }
+EXPORT_SYMBOL_GPL(do_timens_ktime_to_host);
 
 static struct ucounts *inc_time_namespaces(struct user_namespace *ns)
 {
@@ -364,6 +365,7 @@ struct time_namespace init_time_ns = {
 	.ns.ops		= &timens_operations,
 	.frozen_offsets	= true,
 };
+EXPORT_SYMBOL_GPL(init_time_ns);
 
 void __init time_ns_init(void)
 {


