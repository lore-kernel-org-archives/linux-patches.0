Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33C0381AE4;
	Fri,  7 Aug 2026 15:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115513; cv=none; b=f45TRm9yalaz155Xn/1oN6LEMcbx0inIuLYCPwZThiRLgmJPqTlY1n6AFetx3OTVc5wq3dnkNpekkTIwtQ4YOKCflmbEjddsDQWma0E3GB7Xvf7WZDp+dAuKVXq7lPm4o4xYszjZcrOsUvevXhAbK6ZDMfQdVz/cIUt6JBJ5OUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115513; c=relaxed/simple;
	bh=CCokCFVxMPBkEWJvFRUaU1AXnuDP+FzpeGeT7cR/SCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FzqSQtjhdBPJujruwXTlNtl6vgpyfjv+TSW4DbjjRuoK1ziWZw2f59wfhnGtY5WjrW2JwluIX1V8fomRFK6T38JriVVMl+XHTPN7lsPlLaB9vUGNnLuk/mRxw+J+4LNs0SHQbcOFXlouZMdWg0LavUxXQuUr/mSEbJLTbRkxB5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MD7cLaZY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MD7cLaZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313D21F00A3E;
	Fri,  7 Aug 2026 15:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115505;
	bh=My+oVOLNH3Unmits90eQV6wRkzplw7bwrVgexvuvWZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MD7cLaZYsWrLfihQr8eYtcL7u+Te/xk6aGlGzZMQFpH1iz175jkRbYdiwYXI68yPX
	 g1+uN/kKCj8/ZyV0rAlqsvFsA8JkV426Y9J35cTX39A0SM8OOVCisbZ6w8f3i7e4/D
	 c31yz0W3oG1PQkMuuGLe+GiBLrKUAGlgT6SVEa3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 283/396] net: openvswitch: fix skb leak on flow key update failure during recirculation
Date: Fri,  7 Aug 2026 16:37:23 +0200
Message-ID: <20260807143430.370962606@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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
@@ -1107,6 +1107,10 @@ static int execute_masked_set_action(str
 	return err;
 }
 
+/* When 'last' is true, recirc() should always consume the 'skb'.
+ * Otherwise, recirc() should keep 'skb' intact regardless what
+ * actions are executed on recirculation.
+ */
 static int execute_recirc(struct datapath *dp, struct sk_buff *skb,
 			  struct sw_flow_key *key,
 			  const struct nlattr *a, bool last)
@@ -1117,8 +1121,12 @@ static int execute_recirc(struct datapat
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
 


