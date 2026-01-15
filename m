Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512D53A1E86;
	Thu, 15 Jan 2026 17:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497910; cv=none; b=polOZOKoJAqeCgzmLk0wc+GcgCUAhEpKRRO/9lpmWm6v38F4hSHvDdyyuIlXjhPhxf3CEXIxJKab1ORPjroDne7VL8wsgEwBjrYEtzBcflzNBf/7K09OtG7Ol210WRm7pEo2sR9hYUiv0EW+BDsugZoIUNb6n2RVjXPS8mK81lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497910; c=relaxed/simple;
	bh=9a0mnm6/ZJ2boU2ckJhbeiw5cZ/rgah2fqEjKCWvDUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JslMkf+Gzd8pQWRkpLTDO/ehP9u7fBqUVHz39cN/GIdgHsm2hgrYlDq3AUofsDOPDbG5A089JxpU77rtInnIZEpI1lcZU791R3IBMpm3v0CNpwjpqrxiE6b/twqZzV34DmyOjl7CcLLZju9jVG5Db3BWTiDhs4RXc2XS6F+6sWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cV8HRUG4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cV8HRUG4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C26C116D0;
	Thu, 15 Jan 2026 17:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497910;
	bh=9a0mnm6/ZJ2boU2ckJhbeiw5cZ/rgah2fqEjKCWvDUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cV8HRUG4e+ZcFRgTLGSyZLTr/wF1e8XE99TsZg96fZI12y2N/+vie5oxXhM7PG0Az
	 Ax29m2PfosQj+jxoIKY3DdJ0FeGOdlVSB41ZbHdbSzY3FJ851dPe9TNzxEo1Y6YQ4n
	 aR45KC3UeFKOt5xHswMZY1uHJy6Z8IJTktUDaUVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicklas Bo Jensen <njensen@akamai.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 203/554] netfilter: nf_conncount: garbage collection is not skipped when jiffies wrap around
Date: Thu, 15 Jan 2026 17:44:29 +0100
Message-ID: <20260115164253.603634806@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Nicklas Bo Jensen <njensen@akamai.com>

commit df08c94baafb001de6cf44bb7098bb557f36c335 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_conncount.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -182,7 +182,7 @@ static int __nf_conncount_add(struct net
 		return -EEXIST;
 	}
 
-	if (time_is_after_eq_jiffies((unsigned long)list->last_gc))
+	if ((u32)jiffies == list->last_gc)
 		goto add_new_node;
 
 	/* check the saved connections */
@@ -288,7 +288,7 @@ bool nf_conncount_gc_list(struct net *ne
 	bool ret = false;
 
 	/* don't bother if we just did GC */
-	if (time_is_after_eq_jiffies((unsigned long)READ_ONCE(list->last_gc)))
+	if ((u32)jiffies == READ_ONCE(list->last_gc))
 		return false;
 
 	/* don't bother if other cpu is already doing GC */


