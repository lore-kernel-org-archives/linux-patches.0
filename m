Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7B1175A89;
	Wed, 30 Sep 2026 18:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793504; cv=none; b=Vbqqb4jaSgvdo2lnyAEhQqxlCW/mFKAamz7gFktYIzvtDreLVJ/eHoAhRItTugl2gx24/K8oRMNWavc1KZ+49NRGL8ToN9wjcEarcYtZfEfJEuxKQqptmsgvjtzVEIrkyJmpmrg1MGhPlojd6LrEBpPxvoZxB5Ppplldjh7iQxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793504; c=relaxed/simple;
	bh=veeO0Wcj9bCd2synDc0ZDM7EXB+Snr2PYHqUuWwWFbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LT7YmNdtW8Bq16Tlaq140GbgTRbBbWvSRdiobx5ZdRr3hgkDoyMeQSt0p0y9WGxTS+zcGRcCWEIrqxoK5GOdhnysPSFb8W41h5km1oFfctnxviPGsffRnijen6ByGpYBTEhx/A1YlPTyC0QkxTaRqiR8FskBqeSl4BdzEOCupm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P9NxHVzc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P9NxHVzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2ED91F000FF;
	Wed, 30 Sep 2026 18:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793503;
	bh=+t2FHDaiom5nJUWUwg9POcuifxKBYK6lqV1X6V9pFVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P9NxHVzcqzEJKnOhpIZumgfFs3gLQ8zHzpb5zh58ZszyqAYZjxfDvyIb/AMydCF45
	 9Th63svOX93MntniLvGqDulDFPqCNFnfYPSBqoy6mAyIDIaWr0R5VbWpXoam1O6/QC
	 73vl/WcNaDYRetb3FzXNgChcHmF0E0S3Zq6tnVwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 279/395] net: openvswitch: conntrack: remove add_helper dead code
Date: Wed, 30 Sep 2026 17:29:01 +0200
Message-ID: <20260930152346.713312528@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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


