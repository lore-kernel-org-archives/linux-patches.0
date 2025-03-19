Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188AD1BD9C6;
	Wed, 19 Mar 2025 14:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394833; cv=none; b=C4gx8EqD6/4JPSfsKJpwyDVKmLprwmkPhPDQYDAPOpvn6AN0rWgbDfKzKA7pSs9aJR+jpVx26DN3MwhYdZoNESyY79OuW+hNeGSB75nrKBB0IMq/fbUFYTjXjQ+4dXaDFQg0UE9m6389s4uWTus0Y0se8U6GNaSeJSjRUuBT2KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394833; c=relaxed/simple;
	bh=i43QjHyRhrG14D6UTegt55yj4wIr6vaRdG2xE/GJsGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LTx68Lr4emsZjWjwuspsQebch0PQI6i6doJInh95tzQNLGSu+bA7gnagGLzNqmYMFqiVozm6JsRS9Yu6yD4y/aBl6N6whTKdrOT5T6wfqg2j9wQAiThrtwU96B+lgiN+HCy3ClMsN7RrxZg4AoV3wDa9O/Ht5j7x9ek2T8DD7Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uyDOdwP7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uyDOdwP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B04FC4CEE4;
	Wed, 19 Mar 2025 14:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394832;
	bh=i43QjHyRhrG14D6UTegt55yj4wIr6vaRdG2xE/GJsGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uyDOdwP72IVzQZmQjdwjh9vJ6J9k9DaC2vQmyQ1qEUbpMkO4MTT0SsGr59N2Znktm
	 KOKvxMHYvtvSgxsxJY+0s/w2kMDRB1xXCMeJDFsmC+kCNHiUgBKCDWYwClYlze+ku6
	 X2S1vcmXMTU5Z9uMKZ08CNLj5k0sxClMT+THwOdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicklas Bo Jensen <njensen@akamai.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 012/241] netfilter: nf_conncount: garbage collection is not skipped when jiffies wrap around
Date: Wed, 19 Mar 2025 07:28:02 -0700
Message-ID: <20250319143028.009538877@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicklas Bo Jensen <njensen@akamai.com>

[ Upstream commit df08c94baafb001de6cf44bb7098bb557f36c335 ]

nf_conncount is supposed to skip garbage collection if it has already
run garbage collection in the same jiffy. Unfortunately, this is broken
when jiffies wrap around which this patch fixes.

The problem is that last_gc in the nf_conncount_list struct is an u32,
but jiffies is an unsigned long which is 8 bytes on my systems. When
those two are compared it only works until last_gc wraps around.

See bug report: https://bugzilla.netfilter.org/show_bug.cgi?id=1778
for more details.

Fixes: d265929930e2 ("netfilter: nf_conncount: reduce unnecessary GC")
Signed-off-by: Nicklas Bo Jensen <njensen@akamai.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conncount.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 4890af4dc263f..ebe38ed2e6f4f 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -132,7 +132,7 @@ static int __nf_conncount_add(struct net *net,
 	struct nf_conn *found_ct;
 	unsigned int collect = 0;
 
-	if (time_is_after_eq_jiffies((unsigned long)list->last_gc))
+	if ((u32)jiffies == list->last_gc)
 		goto add_new_node;
 
 	/* check the saved connections */
@@ -234,7 +234,7 @@ bool nf_conncount_gc_list(struct net *net,
 	bool ret = false;
 
 	/* don't bother if we just did GC */
-	if (time_is_after_eq_jiffies((unsigned long)READ_ONCE(list->last_gc)))
+	if ((u32)jiffies == READ_ONCE(list->last_gc))
 		return false;
 
 	/* don't bother if other cpu is already doing GC */
-- 
2.39.5



