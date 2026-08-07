Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F3438424C;
	Fri,  7 Aug 2026 15:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117687; cv=none; b=VZAvcS8o4/IEwTNi9dVyuEWY7VEz7g1aVCcmeJBgCCbkkVhKkrktFYFmTLClGYkEvgIbsP3x7vQKR1lx8vD9KXhj7aYNqSFoXHVcbgSqgH6+CmLKc6rHddeTDw99Zm950ArqTxCxMAMzaBAibYuLTGr4cjxYFl51Rw9fui4Ir+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117687; c=relaxed/simple;
	bh=5TZXMwXXiMcHGk/WAmo+m1dHyre2er1ghmBtf0W5xsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lh3IrKkDyZa0nbYaSk9vn3f45N/Tl2dQZKVIEqJqOwEfQ7uu/fg5TEhLYHBZ7YxfkSuAQgs4rnL1qAtPVzrT0KBKZCWq2cXgcuquTRScwLUSPYopnAff9XnOnEYDruJjeudeCcsFBMFvC6tKO9QUXmwnK3NPGD094lS+7ydzIbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KtgkJ3Sz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KtgkJ3Sz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0CE1F000E9;
	Fri,  7 Aug 2026 15:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117686;
	bh=KLz9HAZyXew+zJ7RGXV3gBua0Y9PCexu3IAigQ3Tqfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KtgkJ3SzEslAuPFqoq6QvGoEw7+IVeoEdi12VBwTc29wjjIALqe7Nyjmm/VnP1Akn
	 2om7bNLci4i6YXtaU/fFmc0xDPC4vJo3OslbEjYSqb5gwMeVutJrvtQPONagfgXqXx
	 en53oQDvF+GZcr8k9wIVq1S9Kj5yGaAVvxIzTtSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 351/438] net: openvswitch: fix skb leak on flow key update failure during recirculation
Date: Fri,  7 Aug 2026 16:39:07 +0200
Message-ID: <20260807143435.454947113@linuxfoundation.org>
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

From: Ilya Maximets <i.maximets@ovn.org>

commit e1cf066244dad576221b7123a0e5005967f25a20 upstream.

do_execute_actions() returns right away when execute_recirc() fails on
the last action as it assumes this function always takes ownership of
the skb when 'last' is true.  But when the flow key update fails, the
function doesn't free the skb and it ends up leaked.

This is a very unlikely scenario as it requires the packet to become
unparseable by applying a set of actions on a previously parseable skb,
but should be fixed nevertheless.

Reported by Sashiko.

Fixes: 971427f353f3 ("openvswitch: Add recirc and hash action.")
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Link: https://patch.msgid.link/20260727181851.306076-2-i.maximets@ovn.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/actions.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -1108,6 +1108,10 @@ static int execute_masked_set_action(str
 	return err;
 }
 
+/* When 'last' is true, recirc() should always consume the 'skb'.
+ * Otherwise, recirc() should keep 'skb' intact regardless what
+ * actions are executed on recirculation.
+ */
 static int execute_recirc(struct datapath *dp, struct sk_buff *skb,
 			  struct sw_flow_key *key,
 			  const struct nlattr *a, bool last)
@@ -1118,8 +1122,12 @@ static int execute_recirc(struct datapat
 		int err;
 
 		err = ovs_flow_key_update(skb, key);
-		if (err)
+		if (err) {
+			if (last)
+				ovs_kfree_skb_reason(skb,
+						     OVS_DROP_ACTION_ERROR);
 			return err;
+		}
 	}
 	BUG_ON(!is_flow_key_valid(key));
 


