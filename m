Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51212E7BD6;
	Mon, 17 Aug 2026 15:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980173; cv=none; b=bD1oaLrX9647oRijNVaUHQPwQhAxY0JAb+HfcFLpAMlPDR/aDhOvIG52/TCsBEKFD6hgj0V4iO6KTTblSIdvr8+Pg6rq/PfO+G6VrXcoEwEqMIHamoxggmFN6JTtP3EFijHT8nOeiWgZD6fqWOMuwMJhPGMzD8bAOZbWsLqlSdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980173; c=relaxed/simple;
	bh=VoTkgzH6BXPFm4V6jOcS08jXlNereq/KevP6eTxto1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gySspWZ8M4QOkFmnIZ+OT4XQT2aLvyOX7FL3CoA7LKNfUisP2Ha+miNe4+XTzXXesJvKYQoe7qch5N26/v0thBESryse9d3by9ytiQawKGCS/JHr58ieYTjJFCxCPkT/kiSKJVSOxC09AdROjywQSOWwrn3uvmfXH6xPdA95/Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LwQydTWJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LwQydTWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09BCB1F000E9;
	Mon, 17 Aug 2026 15:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980172;
	bh=x/4aIYiCPtZIN+HOAVNrxBiTauZVPRZ+s2h72nzs3B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LwQydTWJEUrlFeI6mR1eDEC+mfIV7c9cXFurDqEFXMum2EeX9XDa1Vk7Myg3ftiTP
	 fWrR0ImsCOxiSAdyIJaH++lJH3KaBjtFWsfpBa7UMc9+8WKHJXeY/LNrjr3Y/nrYJZ
	 otB5eCmJDB2kq5IO+BBf9dgpQd57fHhp4QSHd/G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 480/609] net: openvswitch: fix skb leak on flow key update failure during recirculation
Date: Mon, 17 Aug 2026 15:32:56 +0200
Message-ID: <20260817132600.004921111@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Maximets <i.maximets@ovn.org>

[ Upstream commit e1cf066244dad576221b7123a0e5005967f25a20 ]

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
[OVS drop reasons are not available in 6.1, hence plain kfree_skb()]
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/actions.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index db4b6929d5bc5..679409953ac50 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -1107,6 +1107,10 @@ static int execute_masked_set_action(struct sk_buff *skb,
 	return err;
 }
 
+/* When 'last' is true, recirc() should always consume the 'skb'.
+ * Otherwise, recirc() should keep 'skb' intact regardless what
+ * actions are executed on recirculation.
+ */
 static int execute_recirc(struct datapath *dp, struct sk_buff *skb,
 			  struct sw_flow_key *key,
 			  const struct nlattr *a, bool last)
@@ -1117,8 +1121,11 @@ static int execute_recirc(struct datapath *dp, struct sk_buff *skb,
 		int err;
 
 		err = ovs_flow_key_update(skb, key);
-		if (err)
+		if (err) {
+			if (last)
+				kfree_skb(skb);
 			return err;
+		}
 	}
 	BUG_ON(!is_flow_key_valid(key));
 
-- 
2.53.0



