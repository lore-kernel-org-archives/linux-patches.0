Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A4B42882B;
	Wed, 30 Sep 2026 17:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787750; cv=none; b=m4yEozuRw8IKGepiI4xB+39IzEv03PCZ2KlWCfidGxKH9gtp7YogkFDky4fz3wBs2OO7X0r3bKP9kNe4my7XrgfgD7CBVPRBWRVlqempSjroU1O2bpvHEk9b/HJOgFFunXezEfTJPf555hyflY4MclF05eFcTtl+HOj8mT+b4E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787750; c=relaxed/simple;
	bh=BLVF0snpS9D8BaJu6hCBi+lQqMOdpuTEhzVsLfYYJOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pTsbSxNZL8eOrX1ZVMBgvBXhBi8jLcgj30GXMP91IHUzmAYLC47AkMrkvxgvnQNiE5VOh50qqi9VQr8axcJrBnmMKm9d7AhRs9HQATmqR9Hvs4+qD8oyNFkS+XLzx2857CyWy+JkpHUpyky83NyCyThVrFOEgaX4B1xBMTgWEZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TcDOk53p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TcDOk53p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A401F000FF;
	Wed, 30 Sep 2026 17:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787749;
	bh=bg7OQpE46PoVmd04J2h9Zcf9iMJtPkUl4WZrUa5Bdcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TcDOk53pEEf7vHqiq5cQ98jDh4GgL0rfQ4MKzSDHPcSoPE9o6/nh4/BtJmsnm3YuA
	 tToFaLVfuJLcjRBsHWAikeH+PReT2/RU0szTZV4o4JY16umIFxrY5KRF0VafBq05n8
	 bIFkTXPQuPJKQ1aG9uYqcq8NILckSEU+O6FAGAeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 338/457] net: openvswitch: conntrack: remove add_helper dead code
Date: Wed, 30 Sep 2026 17:27:23 +0200
Message-ID: <20260930152353.310011371@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Maximets <i.maximets@ovn.org>

commit 5e6c14dd42a1c1fe938e573dc6c9098145b2b0c4 upstream.

This variable can only become 'true' when the connection is not
confirmed, but it is only checked when it is confirmed.  So, it can be
treated as being always false and just removed.

Fixes: 3c1860543fcc ("openvswitch: add nf_ct_is_confirmed check before assigning the helper")
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Link: https://patch.msgid.link/20260921145655.3167436-3-i.maximets@ovn.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/conntrack.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -779,8 +779,6 @@ static int __ovs_ct_lookup(struct net *n
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if (ct) {
-		bool add_helper = false;
-
 		/* Packets starting a new connection must be NATted before the
 		 * helper, so that the helper knows about the NAT.  We enforce
 		 * this by delaying both NAT and helper calls for unconfirmed
@@ -812,7 +810,6 @@ static int __ovs_ct_lookup(struct net *n
 							    GFP_ATOMIC);
 			if (err)
 				return err;
-			add_helper = true;
 
 			/* helper installed, add seqadj if NAT is required */
 			if (info->nat && !nfct_seqadj(ct)) {
@@ -822,13 +819,10 @@ static int __ovs_ct_lookup(struct net *n
 		}
 
 		/* Call the helper only if:
-		 * - nf_conntrack_in() was executed above ("!cached") or a
-		 *   helper was just attached ("add_helper") for a confirmed
-		 *   connection, or
+		 * - nf_conntrack_in() was executed above ("!cached"), or
 		 * - When committing an unconfirmed connection.
 		 */
-		if ((nf_ct_is_confirmed(ct) ? !cached || add_helper :
-					      info->commit)) {
+		if ((nf_ct_is_confirmed(ct) ? !cached : info->commit)) {
 			int err = nf_ct_helper(skb, ct, ctinfo, info->family);
 
 			err = verdict_to_errno(err);


