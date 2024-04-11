Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8BC14430D;
	Thu, 11 Apr 2024 10:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829829; cv=none; b=BPj0kEOTfaAJugSbh40QwKqeLPhVBGSmXeL64LVi8c3jJxOyL6GE5yFUvks/ExqUPVvdRNx551LfRi2gvX3+82/qXqQ+rCX487e1CaINUj203/XsW2vYkWf5KEBigO8WCLf9zP8jiiABpzKJFWyDZUSI887iA+/+jzpm289w1W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829829; c=relaxed/simple;
	bh=sjgwEe5NUp7wBXLrmtI6kfolBLTtEGjFAv2/XLOazu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YdRpvuH6+wQvBrjRBd6yQqkNZb8/M66VKHx9sd06LdqhDzmQ2oz1z61PGwATO6+gzznNmLCkMNqQus+sZw+lE7UJOkxyPXk5UjpJs/KwC5UyvMpNGTt0Iwb8cMqmPyHQxEzExVOGBUZYbNk8YrstZtf9LsvTJiYI5KqUGJ5qzA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wR4zXapu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wR4zXapu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC55C43394;
	Thu, 11 Apr 2024 10:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829829;
	bh=sjgwEe5NUp7wBXLrmtI6kfolBLTtEGjFAv2/XLOazu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wR4zXapucmvcQIH0SDFkHCoD1Rl0nIAxfHQ10kDtlM6rl/WCIWi3tN8ZsXXO8Cv1E
	 H0wYZNZb1adgK91J2c1TtDRGYoVnefFJHdO/dFPvdKhUJqNKr92YDa6CkNnqRgzJJj
	 fcG/XM9YdLKJEOWCnGzuPMvRI2oaLJaxpsu5QAU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Subject: [PATCH 4.19 118/175] netfilter: nf_tables: disallow timeout for anonymous sets
Date: Thu, 11 Apr 2024 11:55:41 +0200
Message-ID: <20240411095423.119086510@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit e26d3009efda338f19016df4175f354a9bd0a4ab upstream.

Never used from userspace, disallow these parameters.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[Keerthana: code surrounding the patch is different
because nft_set_desc is not present in v4.19-v5.10]
Signed-off-by: Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3607,6 +3607,9 @@ static int nf_tables_newset(struct net *
 		if (!(flags & NFT_SET_TIMEOUT))
 			return -EINVAL;
 
+		if (flags & NFT_SET_ANONYMOUS)
+			return -EOPNOTSUPP;
+
 		err = nf_msecs_to_jiffies64(nla[NFTA_SET_TIMEOUT], &timeout);
 		if (err)
 			return err;
@@ -3615,6 +3618,10 @@ static int nf_tables_newset(struct net *
 	if (nla[NFTA_SET_GC_INTERVAL] != NULL) {
 		if (!(flags & NFT_SET_TIMEOUT))
 			return -EINVAL;
+
+		if (flags & NFT_SET_ANONYMOUS)
+			return -EOPNOTSUPP;
+
 		gc_int = ntohl(nla_get_be32(nla[NFTA_SET_GC_INTERVAL]));
 	}
 


