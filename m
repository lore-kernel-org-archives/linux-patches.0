Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DBD6A354;
	Tue, 23 Jan 2024 02:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975384; cv=none; b=n2ngteINJsxuOaGf9hGcZw7rbnUFgwQDZhPxA+qwTfw3NqHjerDqwlJkXoiSx5wcKry/x+lw0SOpoE9oA+aIHRw2Y81/+//L03osr5LQI92reJZb/UvBOeMwRQaQPNwTMVTUR6We0IH1+Ty6wH54aM0qrXL+hfzLVMWYzVmluoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975384; c=relaxed/simple;
	bh=a5Kr+nS51dggcsddD3THaeiCO8DI1TcCAOCJpu2asG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o8+myr+dMUbTX1uOlzki043M1UWO39TqGHtcJa0HXOhmW+eCGvK+XxFimG42Qlhh1aE0Q8ElwV09J8P0d174AsS/7GDJhNPIyxDmJJdYlPleUUZQi6ivLHg1d9FZwczBucaPcKQmNXtvKcio7E2Oi4i3jL4rr7oD3XVmqSjd7K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rcd08tfn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rcd08tfn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55627C43390;
	Tue, 23 Jan 2024 02:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975384;
	bh=a5Kr+nS51dggcsddD3THaeiCO8DI1TcCAOCJpu2asG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rcd08tfnY66xbQ2laoPg25sLVmzFQ164Wt/CdIxRqutnJgYcpaP4Zp4g0thmuDktR
	 z7LaN/O6E6QDs6FQQl9oxf7LtFdCle2RGIHQN+B/bx17MjCveBQqoohv2UxX/a+Nmj
	 yD+BEpSXGErXsjvWKdLiOmiphi7pAvZFCkw6dkq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Xu <pengfei.xu@intel.com>,
	David Howells <dhowells@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Petr Vorel <pvorel@suse.cz>
Subject: [PATCH 6.6 345/583] keys, dns: Fix size check of V1 server-list header
Date: Mon, 22 Jan 2024 15:56:36 -0800
Message-ID: <20240122235822.583517952@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: David Howells <dhowells@redhat.com>

commit acc657692aed438e9931438f8c923b2b107aebf9 upstream.

Fix the size check added to dns_resolver_preparse() for the V1 server-list
header so that it doesn't give EINVAL if the size supplied is the same as
the size of the header struct (which should be valid).

This can be tested with:

        echo -n -e '\0\0\01\xff\0\0' | keyctl padd dns_resolver desc @p

which will give "add_key: Invalid argument" without this fix.

Fixes: 1997b3cb4217 ("keys, dns: Fix missing size check of V1 server-list header")
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Link: https://lore.kernel.org/r/ZZ4fyY4r3rqgZL+4@xpf.sh.intel.com/
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dns_resolver/dns_key.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/dns_resolver/dns_key.c
+++ b/net/dns_resolver/dns_key.c
@@ -104,7 +104,7 @@ dns_resolver_preparse(struct key_prepars
 		const struct dns_server_list_v1_header *v1;
 
 		/* It may be a server list. */
-		if (datalen <= sizeof(*v1))
+		if (datalen < sizeof(*v1))
 			return -EINVAL;
 
 		v1 = (const struct dns_server_list_v1_header *)data;


