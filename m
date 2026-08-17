Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28896441623;
	Mon, 17 Aug 2026 14:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976117; cv=none; b=nv2+IMiYXzZUex7VPxTZnUMqf2I0g5lnrXOAcSA3l58PuS52gxg2ZyBIQlDGzuV69bLFMPaQg8aWcDiQnFrTiwXcuz2rfTWJJXg+W/+SjNWw71RmITbjuqOE3XuldVErPluQ6TvYQ3cPXG/TvUV6XjJlV2GARWRAKK77e5CAyuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976117; c=relaxed/simple;
	bh=S/eg7NGRU/hBvxq6PC3qwCJ6sUJFRePhP6Upv1EfH6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ao7nZTpRGdYNt3pkJZiZoF3rkH5zj5uV22AaI6H9hNcQer0Z8A2YXiC+e4imZyChdtvnHLt4Gj7n0T7cfubRWAgfp9e2auOgnwpCXD+KsfOLQyrbrBeHGrt/IPMEWOdyLwGIphnOB1POKLxKl+T/ONVkpQRunrx86lnldicf7sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oguc28hW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oguc28hW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7E11F00A3A;
	Mon, 17 Aug 2026 14:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976115;
	bh=mCjAc/tEdgbRqm7ABrXac3P0iHRbFcBgFcMpdPNL+LI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oguc28hWOP0+WYsq2mqU+ZwZ9+McNeMqehiYBUWYrGz4g2HfJ/9hPfrVy6hEYbkbo
	 pu1u17nksnkOgxDiucV1gVFMyACbkM7nbE6mrAMfCpOJP70lg6z1WaFkWsMT6CF+Yi
	 ANKqhRp2hrxdqXimpqbwn1fY7UP+ZB0LcWbRSP2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lee <david.lee@trailofbits.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 262/389] netfilter: ipset: do not update comments from kernel-side hash adds
Date: Mon, 17 Aug 2026 15:31:41 +0200
Message-ID: <20260817132549.411648282@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -986,7 +986,7 @@ overwrite_extensions:
 #endif
 	if (SET_WITH_COUNTER(set))
 		ip_set_init_counter(ext_counter(data, set), ext);
-	if (SET_WITH_COMMENT(set))
+	if (SET_WITH_COMMENT(set) && !ext->target)
 		ip_set_init_comment(set, ext_comment(data, set), ext);
 	if (SET_WITH_SKBINFO(set))
 		ip_set_init_skbinfo(ext_skbinfo(data, set), ext);


