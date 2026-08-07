Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B27A46C4B0;
	Fri,  7 Aug 2026 15:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117331; cv=none; b=BnN9l0ZnZSlXsm6RbL5hNpzWnbW84atH5TXqo1GeB3Gq2NqYGNi6LhsIB+C2pDo32G+SpZBGo6W7aJHN5nrs7yzFxlE43nI6SIabLXgiD1pc0IyAXS+TpggYMR1nB4cB7vKPVDJtux3CiQ8T5qecOaPFi6dN6r1KXmCAQ9WE6XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117331; c=relaxed/simple;
	bh=pxlAhZPVBmPAZJ9nBxTgtL8LxgPLF61uvyTevjA/g5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CjEgQEekH+MO8ghx2YoC8sZy6UFdaFuAiXXIUlsAJA9It8l8u7To68Zl5udlmsTp1OYYs82AGffSHjQY39BGc/hSsTj08ZC+1etb1Toag3BAme8MLSBYPipo21VTVEcWMv9PzWm/+bUhROI4oa/mUAE60m6JozWB7G+FplKoz5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IB7jpOpQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IB7jpOpQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D581F000E9;
	Fri,  7 Aug 2026 15:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117330;
	bh=5Spn4YkNnuPUCdbdcoVLEXvKyY4KW8xds11bZ8qcEVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IB7jpOpQen+h+FJdczg9iLFn/Yscehaj54rZWb5Tj9A2wP/WcvRNri0vtffbDP/wP
	 yMafBnC/6jbJtkNHak0PGiMfGZHHVHwf5ZB5ujDV8UF+Plp9bFuCcbumNnNYZ1Xec/
	 MhCTA9JbtLN+ZGxZa8VDJKBkH5JLUNp9bsMd1UeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lee <david.lee@trailofbits.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7.1 281/438] netfilter: ipset: do not update comments from kernel-side hash adds
Date: Fri,  7 Aug 2026 16:37:57 +0200
Message-ID: <20260807143433.969754893@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lee <david.lee@trailofbits.com>

commit f30415929be8aeb002d557c8d3f7ab2d2188003a upstream.

mtype_resize() copies comment pointers with memcpy(), not the comment
objects themselves. During the window after an entry has been copied but
before the table swap and backlog replay, the old table is still
published for packet-side updates while the replacement-table entry
already holds the same ip_set_comment_rcu pointer.

If xt_SET --add-set ... --exist hits that old entry in this window,
mtype_add() calls ip_set_init_comment() even though packet-side adds
carry no comment payload. That call frees the shared comment through the
old entry, so the replacement-table entry now holds a stale pointer.
When the queued add is replayed on the new table, mtype_add() calls
ip_set_init_comment() again and strlen() dereferences the stale pointer.

Fix this in mtype_add() by skipping ip_set_init_comment() when
ext->target marks a packet-side add. Userspace adds still update
comments, while packet-side adds can no longer free comment storage
shared with a resize copy.

Fixes: f66ee0410b1c ("netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" reports")
Cc: stable@vger.kernel.org
Signed-off-by: David Lee <david.lee@trailofbits.com>
Assisted-by: Codex:gpt-5.5
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -984,7 +984,7 @@ overwrite_extensions:
 #endif
 	if (SET_WITH_COUNTER(set))
 		ip_set_init_counter(ext_counter(data, set), ext);
-	if (SET_WITH_COMMENT(set))
+	if (SET_WITH_COMMENT(set) && !ext->target)
 		ip_set_init_comment(set, ext_comment(data, set), ext);
 	if (SET_WITH_SKBINFO(set))
 		ip_set_init_skbinfo(ext_skbinfo(data, set), ext);


