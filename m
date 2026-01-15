Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30066394487;
	Thu, 15 Jan 2026 16:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496126; cv=none; b=HXkT0LXohA059GEyyj1tZ259WFHZtP5O7DtJYdSHtEPydAWUh6JC+kq9YwEp80RLsi0TZnOmwr+/KXCHO/nFkRApfz5ikNpjQKRRaoza14/qJgT4x/+pzIgKaYj8PCVFh8c6sIkLlEBo45XhIulTPgHdhBpYil1WkrZlZ2hjefI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496126; c=relaxed/simple;
	bh=KcSCvoDEkV/eA/t2qzRgIFFZRIeShPTP246Aljnz4CM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ccHTI6szX9rCqridPRHYPls4LjgTOS7vEiMCBW11YtNZAwIoc7leF4TK0MIF1oXYKAm12y+B/Ek9/NXiaKu2b3P5Zg9bpNAA5khM1pdckKdh/fxFIt/HqkwV0xxeNY0ujquELBDFCxXN2/nrub+D5F4H+2zRmI5xvANGXHDEDVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iUvPlsZg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iUvPlsZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F540C19421;
	Thu, 15 Jan 2026 16:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496125;
	bh=KcSCvoDEkV/eA/t2qzRgIFFZRIeShPTP246Aljnz4CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iUvPlsZg7Wmol+dv5pFspaFWX5A7ces+zL/uF7rwyZ+ER3dfX2ETz5eHMCowIESXm
	 e0s7IJWCLSbCIxoqzPic5QGBOHFaTJsCNPlxE26DOgf1WafCWkuPjzpKs4liBiWRUf
	 pEPOKYe1M+PvncF7rjwV3o8qG7wzJFZ05aqkvhTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 087/181] netfilter: nft_set_pipapo: fix range overlap detection
Date: Thu, 15 Jan 2026 17:47:04 +0100
Message-ID: <20260115164205.465058565@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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
index 112fe46788b6f..6d77a5f0088ad 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1317,8 +1317,8 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
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



