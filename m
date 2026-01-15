Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444462C028F;
	Thu, 15 Jan 2026 17:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496572; cv=none; b=ownCISmVxBFIEsg7fqfNSr+RXLuEKys7mBfhfWxSpMfsu9N6vQdDsS0psvvEB7lSxFde64sXLbK2HqTwBsiPKan2rMhtrb1UfwcpbM64pv69ymRDOGH0WIEziDidBaPvX1Ot9tojxkNJTF6FcOACIxP4pkBrgN4Vq8lGjXYmNOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496572; c=relaxed/simple;
	bh=O0hSPjNHsmCKczcY7y4Bq+XXQBNtQB00HPMphld2A9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DhYEWE1yE+aBHq1beyR5BSh5KxzqL92Ni5tHWTwyvUBySWYNHA6MlVrgXUqA0nVWa2xCgHgRzNF2aEQwkpgLw4d6mf/ZH1R24ioMsIGZMvF9MGZh9hjbQup7KAT/CVA1+f5LDsrpZZ62yfbzD64HeYJKWmuDvLankFLOkUoL9+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lFXfK8Jx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lFXfK8Jx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C252BC19422;
	Thu, 15 Jan 2026 17:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496572;
	bh=O0hSPjNHsmCKczcY7y4Bq+XXQBNtQB00HPMphld2A9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lFXfK8JxcuPApVcOXq0T9kTonMpsWzAh0xvDxAcpJMguQe6dWy0kDg8j8LgWupl/E
	 V8rlc+rgz8RcSeZ0wesy3nxqIOrcUt+hPR3DGpf0xwemXw6i8dOXCJpmO0rr+EZFzj
	 DqhQ0OAUwv/z6DazgVam3GpFHJtzhl17ihMPaH8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 058/119] netfilter: nft_set_pipapo: fix range overlap detection
Date: Thu, 15 Jan 2026 17:47:53 +0100
Message-ID: <20260115164154.052396498@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 7711f4bb4b360d9c0ff84db1c0ec91e385625047 ]

set->klen has to be used, not sizeof().  The latter only compares a
single register but a full check of the entire key is needed.

Example:
table ip t {
        map s {
                typeof iifname . ip saddr : verdict
                flags interval
        }
}

nft add element t s '{ "lo" . 10.0.0.0/24 : drop }' # no error, expected
nft add element t s '{ "lo" . 10.0.0.0/24 : drop }' # no error, expected
nft add element t s '{ "lo" . 10.0.0.0/8 : drop }' # bug: no error

The 3rd 'add element' should be rejected via -ENOTEMPTY, not -EEXIST,
so userspace / nft can report an error to the user.

The latter is only correct for the 2nd case (re-add of existing element).

As-is, userspace is told that the command was successful, but no elements were
added.

After this patch, 3rd command gives:
Error: Could not process rule: File exists
add element t s { "lo" . 127.0.0.0/8 . "lo"  : drop }
                  ^^^^^^^^^^^^^^^^^^^^^^^^^

Fixes: 0eb4b5ee33f2 ("netfilter: nft_set_pipapo: Separate partial and complete overlap cases on insertion")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_pipapo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 793790d79d138..642152e9c3227 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1303,8 +1303,8 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 		else
 			dup_end = dup_key;
 
-		if (!memcmp(start, dup_key->data, sizeof(*dup_key->data)) &&
-		    !memcmp(end, dup_end->data, sizeof(*dup_end->data))) {
+		if (!memcmp(start, dup_key->data, set->klen) &&
+		    !memcmp(end, dup_end->data, set->klen)) {
 			*elem_priv = &dup->priv;
 			return -EEXIST;
 		}
-- 
2.51.0



