Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46097368276;
	Fri,  7 Aug 2026 14:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114389; cv=none; b=heOPhBv3xzSwjKUqrm/1sJFEPuTqv2ZkJadk643ctQZXlwl2fUTtZi6inifHTguf6vE1bPVrKdqBQol1hgY56tiNBfEDFBPzLiKdJxjPo9G06gIekHGnBKQPu+Rb47rZEcxylmd41lRR7E/2fEggN8AkISBqE1wH36qui0xqTHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114389; c=relaxed/simple;
	bh=B4a8BpEPEz4ghi3ddCd6B6UXNQYk1H/KwXJfH1nOM7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uoKzgFs0TDG5eMQDowuxtBJffEE43xK4ylFicRLFrT858iQvbC5q5kqEIT33zj+WUZF54UC3onnvitXFNbHXxsdP8lqwwWpFuYPinPMoW0b2GoZMoI+XWZA3IaLpP4knz7O1oSH4dl4DwVxpw/ybsub4kNlWGL0zO2ldpwhalz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mBuU+Bgf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mBuU+Bgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17AE1F000E9;
	Fri,  7 Aug 2026 14:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114388;
	bh=lYPvrFrwzAzcOvfjnUJGr9+4vWv2NSwxCXJeGt6CTNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mBuU+BgfiHPtJKGU9kmal0TRG0inUFQLL6DU5qPPl20Ldg8Hi50NxjPG8EuaXR/ov
	 nJanAhsaQC1fGye2Kxteu7Tr3WhfNTg+B5kdugnjKz4QMKFMx657sY4NbXbFfZ+zqV
	 7OcmXRyuk5Nj9iIefSj5lxgQMc/hXRyDH6PSkFNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 219/337] net: openvswitch: fix skb leak on flow key update failure during recirculation
Date: Fri,  7 Aug 2026 16:37:02 +0200
Message-ID: <20260807143423.302163438@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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
@@ -1146,6 +1146,10 @@ static int execute_masked_set_action(str
 	return err;
 }
 
+/* When 'last' is true, recirc() should always consume the 'skb'.
+ * Otherwise, recirc() should keep 'skb' intact regardless what
+ * actions are executed on recirculation.
+ */
 static int execute_recirc(struct datapath *dp, struct sk_buff *skb,
 			  struct sw_flow_key *key,
 			  const struct nlattr *a, bool last)
@@ -1156,8 +1160,12 @@ static int execute_recirc(struct datapat
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
 


